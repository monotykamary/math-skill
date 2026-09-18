"""Untrusted rational-ring proof-term generator, using checked ring laws."""
from dataclasses import dataclass

@dataclass(frozen=True)
class Expr:
    op: str
    args: tuple = ()
    def __add__(self,b): return Expr('add',(self,b))
    def __mul__(self,b): return Expr('mul',(self,b))
    def __neg__(self): return Expr('neg',(self,))
    def __sub__(self,b): return self + (-b)
    def raw(self):
        if self.op=='atom': return self.args[0]
        return 'Q.'+self.op+'('+', '.join(x.raw() for x in self.args)+')'

ZERO,ONE=Expr('zero'),Expr('one')
def atom(name): return Expr('atom',(name,))
def key(e):
    return (e.args[0].raw(),1) if e.op=='neg' else (e.raw(),0)

class Generator:
    def __init__(self):
        self.names={}
        self.lines=[]
        self.counter=0
    def term(self,e):
        if e.op=='atom': return e.args[0]
        if e.op in ('zero','one'): return e.raw()
        if e not in self.names:
            text='Q.'+e.op+'('+', '.join(self.term(x) for x in e.args)+')'
            name=f'v{len(self.names)}'
            self.names[e]=name
            self.lines.append(f'  +{name} = {text}\n')
        return self.names[e]
    def call(self,lemma,*args):
        return lemma+'('+', '.join(self.term(a) for a in args)+')'
    def rule(self,e):
        if e.op=='neg':
            a=e.args[0]
            if a==ZERO: return ZERO,'R.neg_zero()'
            if a.op=='neg': return a.args[0],self.call('R.neg_neg',a.args[0])
            if a.op=='add': return -a.args[0]+(-a.args[1]),self.call('R.neg_add_distrib',*a.args)
        if e.op not in ('add','mul'): return None
        a,b=e.args
        if e.op=='add':
            if a==ZERO: return b,self.call('O.zero_add',b)
            if b==ZERO: return a,self.call('R.add_zero',a)
            if b==-a: return ZERO,self.call('R.add_neg',a)
            if a.op=='add': return a.args[0]+(a.args[1]+b),self.call('R.add_assoc',*a.args,b)
            if b.op=='add':
                x,y=b.args
                if x==-a: return y,self.call('R.add_cancel_pair',a,y)
                if key(a)>key(x): return x+(a+y),self.call('add_swap',a,x,y)
            elif key(a)>key(b): return b+a,self.call('R.add_comm',a,b)
        else:
            if a==ZERO: return ZERO,self.call('O.zero_mul',b)
            if b==ZERO: return ZERO,self.call('R.mul_zero',a)
            if a==ONE: return b,self.call('C.one_mul',b)
            if b==ONE: return a,self.call('R.mul_one',a)
            if a.op=='add': return a.args[0]*b+a.args[1]*b,self.call('R.weighted_split',*a.args,b)
            if b.op=='add': return a*b.args[0]+a*b.args[1],self.call('R.mul_add',a,*b.args)
            if a.op=='neg': return -(a.args[0]*b),self.call('R.neg_mul_left',a.args[0],b)
            if b.op=='neg': return -(a*b.args[0]),self.call('R.neg_mul_right',a,b.args[0])
            if a.op=='mul': return a.args[0]*(a.args[1]*b),self.call('R.mul_assoc',*a.args,b)
            if b.op=='mul':
                x,y=b.args
                if key(a)>key(x): return x*(a*y),self.call('mul_swap',a,x,y)
            elif key(a)>key(b): return b*a,self.call('R.mul_comm',a,b)
        return None
    def step(self,e):
        if e.op in ('add','mul','neg'):
            for i,a in enumerate(e.args):
                step=self.step(a)
                if step:
                    new,ev=step
                    args=list(e.args);args[i]=new
                    if e.op=='neg':
                        ev=f'C.neg_congr({self.term(a)}, {self.term(new)}, {ev})'
                    else:
                        lemma=('E.add_congr' if i==0 else 'C.add_right') if e.op=='add' else ('E.mul_congr' if i==0 else 'C.mul_right')
                        ev=f'{lemma}({self.term(a)}, {self.term(new)}, {self.term(e.args[1-i])}, {ev})'
                    return Expr(e.op,tuple(args)),ev
        return self.rule(e)
    def normalize(self,original):
        e=original
        evidence=self.call('R.refl',original)
        for _ in range(20000):
            step=self.step(e)
            if not step: return e,evidence
            new,ev=step
            name=f'e{self.counter}'; self.counter+=1
            self.lines.append(f'  {name} = E.trans({self.term(original)}, {self.term(e)}, {self.term(new)}, {evidence}, {ev})\n')
            evidence=name;e=new
        raise RuntimeError('ring normalization limit')
    def prove(self,l,r):
        ln,le=self.normalize(l)
        rn,re=self.normalize(r)
        if ln!=rn: raise ValueError(f'Not a ring identity: {ln.raw()} != {rn.raw()}')
        result=f'  E.trans({self.term(l)}, {self.term(ln)}, {self.term(r)}, {le}, E.sym({self.term(r)}, {self.term(rn)}, {re}))\n'
        return ''.join(self.lines)+result

def theorem(name,names,l,r):
    return '\nlaw '+name+':\n'+''.join(f'  for +{n}: Q.Number\n' for n in names)+f'  Q.Eq({l.raw()}, {r.raw()})\ndef {name}('+', '.join(names)+'):\n'+Generator().prove(l,r)

HEADER='''import Base
import ./Rational.bend as Q
import ./RationalProof.bend as R
import ./RationalEquality.bend as E
import ./Reasoning.bend as C
import ./Order.bend as O

law add_swap:
  for +a: Q.Number
  for +b: Q.Number
  for +c: Q.Number
  Q.Eq(Q.add(a, Q.add(b, c)), Q.add(b, Q.add(a, c)))
def add_swap(a, b, c):
  E.trans(Q.add(a, Q.add(b, c)), Q.add(Q.add(a, b), c), Q.add(b, Q.add(a, c)),
    E.sym(Q.add(Q.add(a, b), c), Q.add(a, Q.add(b, c)), R.add_assoc(a, b, c)),
    E.trans(Q.add(Q.add(a, b), c), Q.add(Q.add(b, a), c), Q.add(b, Q.add(a, c)),
      E.add_congr(Q.add(a, b), Q.add(b, a), c, R.add_comm(a, b)), R.add_assoc(b, a, c)))

law mul_swap:
  for +a: Q.Number
  for +b: Q.Number
  for +c: Q.Number
  Q.Eq(Q.mul(a, Q.mul(b, c)), Q.mul(b, Q.mul(a, c)))
def mul_swap(a, b, c):
  E.trans(Q.mul(a, Q.mul(b, c)), Q.mul(Q.mul(a, b), c), Q.mul(b, Q.mul(a, c)),
    E.sym(Q.mul(Q.mul(a, b), c), Q.mul(a, Q.mul(b, c)), R.mul_assoc(a, b, c)),
    E.trans(Q.mul(Q.mul(a, b), c), Q.mul(Q.mul(b, a), c), Q.mul(b, Q.mul(a, c)),
      E.mul_congr(Q.mul(a, b), Q.mul(b, a), c, R.mul_comm(a, b)), R.mul_assoc(b, a, c)))
'''
