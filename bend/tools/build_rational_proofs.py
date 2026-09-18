"""Generate exact rational ring certificates from binary correctness lemmas."""
from dataclasses import dataclass
from pathlib import Path
import semiring
from semiring import Z, ONE, atom, proof, Expr, DagRenderer

EXPANSIONS = {}

@dataclass(frozen=True)
class Binary:
    text: str
    positive: bool = False

    def val(self):
        return atom(f'B.{"positive_value" if self.positive else "value"}({self.text})')

    def whole(self):
        if not self.positive:
            return self
        b = Binary(f'B.Pos{{{self.text}}}')
        EXPANSIONS[b.val()] = (self.val(), '{==}')
        return b

    def __add__(self, other):
        a, b = self.whole(), other.whole()
        c = Binary(f'B.add({a.text}, {b.text})')
        EXPANSIONS[c.val()] = (a.val() + b.val(), f'BP.add_correct({a.text}, {b.text})')
        return c

    def __mul__(self, other):
        if self.positive and other.positive:
            c = Binary(f'B.positive_mul({self.text}, {other.text})', True)
            EXPANSIONS[c.val()] = (self.val() * other.val(), f'BP.positive_mul_correct({self.text}, {other.text})')
            return c
        a, b = self.whole(), other.whole()
        c = Binary(f'B.mul({a.text}, {b.text})')
        EXPANSIONS[c.val()] = (a.val() * b.val(), f'BP.mul_correct({a.text}, {b.text})')
        return c

BZ, BO = Binary('B.Zero{}'), Binary('B.One{}', True)
EXPANSIONS[BZ.val()] = (Z, '{==}')
EXPANSIONS[BO.val()] = (ONE, '{==}')

@dataclass(frozen=True)
class Rational:
    text: str
    p: Binary
    n: Binary
    d: Binary

    def __add__(self, b):
        return Rational(f'Q.add({self.text}, {b.text})', self.p * b.d + b.p * self.d, self.n * b.d + b.n * self.d, self.d * b.d)

    def __neg__(self):
        return Rational(f'Q.neg({self.text})', self.n, self.p, self.d)

    def __sub__(self, b):
        c = self + (-b)
        return Rational(f'Q.sub({self.text}, {b.text})', c.p, c.n, c.d)

    def __mul__(self, b):
        return Rational(f'Q.mul({self.text}, {b.text})', self.p * b.p + self.n * b.n, self.p * b.n + self.n * b.p, self.d * b.d)

ZERO = Rational('Q.zero()', BZ, BZ, BO)
UNIT = Rational('Q.one()', BO.whole(), BZ, BO)

def variable(name):
    return Rational(name, Binary(name+'p'), Binary(name+'n'), Binary(name+'d', True))

def expand_first(e):
    if e in EXPANSIONS:
        return e, EXPANSIONS[e]
    if e.op in ('add', 'mul'):
        for x in e.args:
            found = expand_first(x)
            if found:
                return found
    return None

def replace(e, old, new):
    if e == old:
        return new
    if e.op in ('add', 'mul'):
        return Expr(e.op, tuple(replace(x, old, new) for x in e.args))
    return e

def certificate(a, b, indent='      ', finish=None):
    left = a.p.val() * b.d.val() + b.n.val() * a.d.val()
    right = b.p.val() * a.d.val() + a.n.val() * b.d.val()
    lines = []
    for side in (0, 1):
        expr = left if side == 0 else right
        while (step := expand_first(expr)):
            old, (new, evidence) = step
            context = replace(expr, old, atom('_')).render()
            lhs, rhs = (context, right.render()) if side == 0 else (left.render(), context)
            lines.append(f'{indent}%Equal.sym(N.Number, {old.render()}, {new.render()}, {evidence}) : {{{lhs} == {rhs} : N.Number}}\n')
            expr = replace(expr, old, new)
        if side == 0:
            left = expr
        else:
            right = expr
    lines.append(finish(left, right) if finish else proof(left, right, indent))
    return f'{indent}Q.Witness{{(\n' + ''.join(lines) + f'{indent})}}\n'

def theorem(name, params, lhs, rhs):
    s = f'\nlaw {name}:\n'
    for p in params:
        s += f'  for +{p}: Q.Number\n'
    s += f'  Q.Eq({lhs.text}, {rhs.text})\ndef {name}(' + ', '.join(params) + '):\n'
    if params:
        s += '  match ' + ' '.join(params) + ':\n    case ' + ' '.join(f'Q.Fraction{{{p}p, {p}n, {p}d}}' for p in params) + ':\n'
    renderer = DagRenderer()
    semiring.RENDERER = renderer
    try:
        body = certificate(lhs, rhs)
    finally:
        semiring.RENDERER = None
    return s + "".join(renderer.lines) + body

if __name__ == '__main__':
    a, b, c = map(variable, ('a','b','c'))
    specs = [
        ('refl', ['a'], a, a),
        ('add_zero', ['a'], a + ZERO, a),
        ('add_comm', ['a','b'], a + b, b + a),
        ('add_assoc', ['a','b','c'], (a + b) + c, a + (b + c)),
        ('neg_neg', ['a'], -(-a), a),
        ('neg_zero', [], -ZERO, ZERO),
        ('neg_add_distrib', ['a','b'], -(a + b), (-a) + (-b)),
        ('neg_mul_left', ['a','b'], (-a) * b, -(a * b)),
        ('neg_mul_right', ['a','b'], a * (-b), -(a * b)),
        ('add_cancel_pair', ['a','b'], a + ((-a) + b), b),
        ('neg_square', ['a'], (-a) * (-a), a * a),
        ('add_neg', ['a'], a + (-a), ZERO),
        ('mul_zero', ['a'], a * ZERO, ZERO),
        ('mul_one', ['a'], a * UNIT, a),
        ('mul_comm', ['a','b'], a * b, b * a),
        ('mul_assoc', ['a','b','c'], (a * b) * c, a * (b * c)),
        ('mul_add', ['a','b','c'], a * (b + c), (a * b) + (a * c)),
        ('mul_sub', ['a','b','c'], a * (b - c), (a * b) - (a * c)),
        ('cool_contracts_deficit', ['a','b','c'], (a * b) - (a * c), a * (b - c)),
        ('chebyshev_two', ['a'], (UNIT + UNIT) * (a * a) - UNIT, ((UNIT + UNIT) * a) * a - UNIT),
        ('heat_step_algebra', ['a','b','c'], ((UNIT - b) * a) + (b * (a * (UNIT - c))), a * (UNIT - (b * c))),
        ('geom_step_algebra', ['a','b'], (UNIT - b) + ((UNIT - a) * b), UNIT - (a * b)),
        ('sub_add', ['a','b'], (a - b) + b, a),
        ('add_shuffle', ['a','b','c'], (a + b) + c, (a + c) + b),
        ('weighted_split', ['a','b','c'], (a + b) * c, (a * c) + (b * c)),
        ('markov_split', ['a','b','c'], a * (b + c), (b * a) + (a * c)),
        ('heat_increment_algebra', ['a','b','c'], (a * (UNIT - (b * c))) - (a * (UNIT - c)), (a * (UNIT - b)) * c),
    ]
    content = '# Generated by tools/build_rational_proofs.py; checked by Bend.\nimport Base\nimport ./Natural.bend as N\nimport ./Binary.bend as B\nimport ./BinaryProof.bend as BP\nimport ./Rational.bend as Q\n'
    content += ''.join(theorem(*spec) for spec in specs)
    out = Path(__file__).resolve().parents[1] / 'Exact' / 'RationalProof.bend'
    out.write_text(content)
    print(f'{out.name}: {len(specs)} laws, {len(content.splitlines())} lines, {len(content)} bytes')
