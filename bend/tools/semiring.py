"""Untrusted proof-term generator. Bend checks every emitted equality.

This is a development helper, never an axiom or part of the proof gate.
Expressions are polynomials over the proved Natural semiring.
"""
from dataclasses import dataclass

RENDERER = None

def has_hole(e):
    if e.op == 'atom':
        return e.args[0] == '_'
    return e.op in ('add', 'mul') and any(has_hole(x) for x in e.args)

class DagRenderer:
    """Share repeated natural expressions without adding any trusted rewrite."""
    def __init__(self):
        self.names = {}
        self.lines = []

    def __call__(self, e):
        if e.op == 'atom' and (e.args[0] == '_' or e.args[0].isidentifier()):
            return e.args[0]
        if e.op in ('zero', 'one'):
            return e.raw()
        if e in self.names:
            return self.names[e]
        if e.op == 'atom':
            text = e.args[0]
        else:
            text = f'N.{e.op}({self(e.args[0])}, {self(e.args[1])})'
        if has_hole(e):
            return text
        name = f'v{len(self.names)}'
        self.names[e] = name
        self.lines.append(f'      +{name} = {text}\n')
        return name

@dataclass(frozen=True)
class Expr:
    op: str
    args: tuple = ()

    def render(self):
        return RENDERER(self) if RENDERER else self.raw()

    def raw(self):
        if self.op == 'atom':
            return self.args[0]
        if self.op == 'zero':
            return 'N.Z{}'
        if self.op == 'one':
            return 'N.S{N.Z{}}'
        return f'N.{self.op}({self.args[0].raw()}, {self.args[1].raw()})'

    def __add__(self, other):
        return Expr('add', (self, other))

    def __mul__(self, other):
        return Expr('mul', (self, other))

Z = Expr('zero')
ONE = Expr('one')

def atom(name):
    return Expr('atom', (name,))

def key(e):
    return e.raw()

def call(name, *args):
    return f'N.{name}(' + ', '.join(a.render() for a in args) + ')'

def rule(e):
    if e.op not in ('add', 'mul'):
        return None
    a, b = e.args
    if e.op == 'add':
        if a == Z:
            return b, '{==}'
        if b == Z:
            return a, call('add_zero', a)
        if a.op == 'add':
            x, y = a.args
            return x + (y + b), call('add_assoc', x, y, b)
        if b.op == 'add':
            x, y = b.args
            if key(a) > key(x):
                return x + (a + y), call('add_swap', a, x, y)
        elif key(a) > key(b):
            return b + a, call('add_comm', a, b)
    else:
        if a == Z:
            return Z, '{==}'
        if b == Z:
            return Z, call('mul_zero', a)
        if a == ONE:
            return b, call('add_zero', b)
        if b == ONE:
            return a, call('mul_one', a)
        if a.op == 'add':
            x, y = a.args
            return (x * b) + (y * b), call('mul_add', x, y, b)
        if b.op == 'add':
            x, y = b.args
            return (a * x) + (a * y), call('add_mul', a, x, y)
        if a.op == 'mul':
            x, y = a.args
            return x * (y * b), call('mul_assoc', x, y, b)
        if b.op == 'mul':
            x, y = b.args
            if key(a) > key(x):
                return x * (a * y), call('mul_swap', a, x, y)
        elif key(a) > key(b):
            return b * a, call('mul_comm', a, b)
    return None

def first_step(e, path=()):
    if e.op in ('add', 'mul'):
        for i, a in enumerate(e.args):
            step = first_step(a, path + (i,))
            if step:
                return step
    r = rule(e)
    return (path, e, *r) if r else None

def replace(e, path, new):
    if not path:
        return new
    args = list(e.args)
    args[path[0]] = replace(args[path[0]], path[1:], new)
    return Expr(e.op, tuple(args))

def proof(left, right, indent='  '):
    lines = []
    for side in (0, 1):
        expr = left if side == 0 else right
        for _ in range(20000):
            step = first_step(expr)
            if step is None:
                break
            path, before, after, evidence = step
            context = replace(expr, path, atom('_')).render()
            lhs, rhs = (context, right.render()) if side == 0 else (left.render(), context)
            lines.append(f'{indent}%Equal.sym(N.Number, {before.render()}, {after.render()}, {evidence}) : {{{lhs} == {rhs} : N.Number}}')
            expr = replace(expr, path, after)
        else:
            raise RuntimeError('normalization step limit')
        if side == 0:
            left = expr
        else:
            right = expr
    if left != right:
        raise ValueError(f'Not an identity:\n{left.render()}\n{right.render()}')
    return '\n'.join(lines + [indent + '{==}']) + '\n'
