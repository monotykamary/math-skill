import Base
import ./Natural.bend as N
import ./Binary.bend as B

# Signed binary subtraction: the gap between a and b and which side is
# larger, in one pass over the bits. It runs in time linear in the bit
# length; compare_correct relates it to the unary model.
type Gap is Data:
  Same{}
  Above{gap: B.Positive}
  Below{gap: B.Positive}

# 2q - 1, which is positive for every positive q.
def pred_double(q: B.Positive) -> B.Positive:
  match q:
    case B.One{}:
      B.One{}
    case B.Bit0{r}:
      B.Bit1{pred_double(r)}
    case B.Bit1{r}:
      B.Bit1{B.Bit0{r}}

# 2p against 2q.
def double_gap(r: Gap) -> Gap:
  match r:
    case Same{}:
      Same{}
    case Above{g}:
      Above{B.Bit0{g}}
    case Below{g}:
      Below{B.Bit0{g}}

# 2p + 1 against 2q.
def up_gap(r: Gap) -> Gap:
  match r:
    case Same{}:
      Above{B.One{}}
    case Above{g}:
      Above{B.Bit1{g}}
    case Below{g}:
      Below{pred_double(g)}

# 2p against 2q + 1.
def down_gap(r: Gap) -> Gap:
  match r:
    case Same{}:
      Below{B.One{}}
    case Above{g}:
      Above{pred_double(g)}
    case Below{g}:
      Below{B.Bit1{g}}

def positive_compare(a: B.Positive, b: B.Positive) -> Gap:
  match a b:
    case B.One{} B.One{}:
      Same{}
    case B.One{} B.Bit0{q}:
      Below{pred_double(q)}
    case B.One{} B.Bit1{q}:
      Below{B.Bit0{q}}
    case B.Bit0{p} B.One{}:
      Above{pred_double(p)}
    case B.Bit1{p} B.One{}:
      Above{B.Bit0{p}}
    case B.Bit0{p} B.Bit0{q}:
      double_gap(positive_compare(p, q))
    case B.Bit1{p} B.Bit1{q}:
      double_gap(positive_compare(p, q))
    case B.Bit0{p} B.Bit1{q}:
      down_gap(positive_compare(p, q))
    case B.Bit1{p} B.Bit0{q}:
      up_gap(positive_compare(p, q))

def compare(a: B.Whole, b: B.Whole) -> Gap:
  match a b:
    case B.Zero{} B.Zero{}:
      Same{}
    case B.Zero{} B.Pos{q}:
      Below{q}
    case B.Pos{p} B.Zero{}:
      Above{p}
    case B.Pos{p} B.Pos{q}:
      positive_compare(p, q)

# What a gap asserts about the unary values of its two operands.
def Holds(+a: N.Number, +b: N.Number, r: Gap) -> Type:
  match r:
    case Same{}:
      {a == b : N.Number}
    case Above{g}:
      {a == N.add(b, B.positive_value(g)) : N.Number}
    case Below{g}:
      {b == N.add(a, B.positive_value(g)) : N.Number}

law pred_double_correct:
  for +q: B.Positive
  {N.S{B.positive_value(pred_double(q))} == N.add(B.positive_value(q), B.positive_value(q)) : N.Number}
def pred_double_correct(q):
  match q:
    case B.One{}:
      {==}
    case B.Bit0{r}:
      +x = B.positive_value(pred_double(r))
      %pred_double_correct(r) : {N.S{N.S{N.add(x, x)}} == N.add(_, _) : N.Number}
      Equal.cong(N.Number, N.Number, y => N.S{y}, N.S{N.add(x, x)}, N.add(x, N.S{x}),
        Equal.sym(N.Number, N.add(x, N.S{x}), N.S{N.add(x, x)}, N.add_succ(x, x)))
    case B.Bit1{r}:
      +d = N.add(B.positive_value(r), B.positive_value(r))
      Equal.cong(N.Number, N.Number, y => N.S{y}, N.S{N.add(d, d)}, N.add(d, N.S{d}),
        Equal.sym(N.Number, N.add(d, N.S{d}), N.S{N.add(d, d)}, N.add_succ(d, d)))

# Doubling a gap: p = q + g gives 2p = 2q + 2g.
law double_split:
  for +p: N.Number
  for +q: N.Number
  for +g: N.Number
  for h: {p == N.add(q, g) : N.Number}
  {N.add(p, p) == N.add(N.add(q, q), N.add(g, g)) : N.Number}
def double_split(p, q, g, h):
  %Equal.sym(N.Number, p, N.add(q, g), h) : {N.add(_, _) == N.add(N.add(q, q), N.add(g, g)) : N.Number}
  N.add_interchange(q, g, q, g)

law odd_split:
  for +p: N.Number
  for +q: N.Number
  for +g: N.Number
  for h: {p == N.add(q, g) : N.Number}
  {N.S{N.add(p, p)} == N.add(N.add(q, q), N.S{N.add(g, g)}) : N.Number}
def odd_split(p, q, g, h):
  +qq = N.add(q, q)
  +gg = N.add(g, g)
  Equal.trans(N.Number, N.S{N.add(p, p)}, N.S{N.add(qq, gg)}, N.add(qq, N.S{gg}),
    Equal.cong(N.Number, N.Number, y => N.S{y}, N.add(p, p), N.add(qq, gg), double_split(p, q, g, h)),
    Equal.sym(N.Number, N.add(qq, N.S{gg}), N.S{N.add(qq, gg)}, N.add_succ(qq, gg)))

# 2p - 2q - 1 = 2g - 1 when p = q + g.
law pred_split:
  for +p: N.Number
  for +q: N.Number
  for +g: N.Number
  for +x: N.Number
  for h: {p == N.add(q, g) : N.Number}
  for k: {N.S{x} == N.add(g, g) : N.Number}
  {N.add(p, p) == N.S{N.add(N.add(q, q), x)} : N.Number}
def pred_split(p, q, g, x, h, k):
  +qq = N.add(q, q)
  Equal.trans(N.Number, N.add(p, p), N.add(qq, N.add(g, g)), N.S{N.add(qq, x)}, double_split(p, q, g, h),
    Equal.trans(N.Number, N.add(qq, N.add(g, g)), N.add(qq, N.S{x}), N.S{N.add(qq, x)},
      Equal.cong(N.Number, N.Number, y => N.add(qq, y), N.add(g, g), N.S{x}, Equal.sym(N.Number, N.S{x}, N.add(g, g), k)),
      N.add_succ(qq, x)))

law odd_same:
  for +p: N.Number
  for +q: N.Number
  for h: {p == q : N.Number}
  {N.S{N.add(p, p)} == N.add(N.add(q, q), N.S{N.Z{}}) : N.Number}
def odd_same(p, q, h):
  Equal.trans(N.Number, N.S{N.add(p, p)}, N.S{N.add(q, q)}, N.add(N.add(q, q), N.S{N.Z{}}),
    Equal.cong(N.Number, N.Number, +y => N.S{N.add(y, y)}, p, q, h),
    Equal.sym(N.Number, N.add(N.add(q, q), N.S{N.Z{}}), N.S{N.add(q, q)}, N.add_one(N.add(q, q))))

law double_holds:
  for +p: N.Number
  for +q: N.Number
  for r: Gap
  for h: Holds(p, q, r)
  Holds(N.add(p, p), N.add(q, q), double_gap(r))
def double_holds(p, q, r, h):
  match r:
    case Same{}:
      Equal.cong(N.Number, N.Number, +y => N.add(y, y), p, q, h)
    case Above{g}:
      double_split(p, q, B.positive_value(g), h)
    case Below{g}:
      double_split(q, p, B.positive_value(g), h)

law up_holds:
  for +p: N.Number
  for +q: N.Number
  for r: Gap
  for h: Holds(p, q, r)
  Holds(N.S{N.add(p, p)}, N.add(q, q), up_gap(r))
def up_holds(p, q, r, h):
  match r:
    case Same{}:
      odd_same(p, q, h)
    case Above{g}:
      odd_split(p, q, B.positive_value(g), h)
    case Below{+g}:
      pred_split(q, p, B.positive_value(g), B.positive_value(pred_double(g)), h, pred_double_correct(g))

law down_holds:
  for +p: N.Number
  for +q: N.Number
  for r: Gap
  for h: Holds(p, q, r)
  Holds(N.add(p, p), N.S{N.add(q, q)}, down_gap(r))
def down_holds(p, q, r, h):
  match r:
    case Same{}:
      odd_same(q, p, Equal.sym(N.Number, p, q, h))
    case Above{+g}:
      pred_split(p, q, B.positive_value(g), B.positive_value(pred_double(g)), h, pred_double_correct(g))
    case Below{g}:
      odd_split(q, p, B.positive_value(g), h)

law succ_holds:
  for +p: N.Number
  for +q: N.Number
  for r: Gap
  for h: Holds(p, q, r)
  Holds(N.S{p}, N.S{q}, r)
def succ_holds(p, q, r, h):
  match r:
    case Same{}:
      Equal.cong(N.Number, N.Number, y => N.S{y}, p, q, h)
    case Above{g}:
      Equal.cong(N.Number, N.Number, y => N.S{y}, p, N.add(q, B.positive_value(g)), h)
    case Below{g}:
      Equal.cong(N.Number, N.Number, y => N.S{y}, q, N.add(p, B.positive_value(g)), h)

law positive_compare_correct:
  for +a: B.Positive
  for +b: B.Positive
  Holds(B.positive_value(a), B.positive_value(b), positive_compare(a, b))
def positive_compare_correct(a, b):
  match a b:
    case B.One{} B.One{}:
      {==}
    case B.One{} B.Bit0{q}:
      Equal.sym(N.Number, N.S{B.positive_value(pred_double(q))}, N.add(B.positive_value(q), B.positive_value(q)), pred_double_correct(q))
    case B.One{} B.Bit1{q}:
      {==}
    case B.Bit0{p} B.One{}:
      Equal.sym(N.Number, N.S{B.positive_value(pred_double(p))}, N.add(B.positive_value(p), B.positive_value(p)), pred_double_correct(p))
    case B.Bit1{p} B.One{}:
      {==}
    case B.Bit0{p} B.Bit0{q}:
      double_holds(B.positive_value(p), B.positive_value(q), positive_compare(p, q), positive_compare_correct(p, q))
    case B.Bit1{p} B.Bit1{q}:
      +pv = B.positive_value(p)
      +qv = B.positive_value(q)
      succ_holds(N.add(pv, pv), N.add(qv, qv), double_gap(positive_compare(p, q)),
        double_holds(pv, qv, positive_compare(p, q), positive_compare_correct(p, q)))
    case B.Bit0{p} B.Bit1{q}:
      down_holds(B.positive_value(p), B.positive_value(q), positive_compare(p, q), positive_compare_correct(p, q))
    case B.Bit1{p} B.Bit0{q}:
      up_holds(B.positive_value(p), B.positive_value(q), positive_compare(p, q), positive_compare_correct(p, q))

law compare_correct:
  for +a: B.Whole
  for +b: B.Whole
  Holds(B.value(a), B.value(b), compare(a, b))
def compare_correct(a, b):
  match a b:
    case B.Zero{} B.Zero{}:
      {==}
    case B.Zero{} B.Pos{q}:
      {==}
    case B.Pos{p} B.Zero{}:
      {==}
    case B.Pos{p} B.Pos{q}:
      positive_compare_correct(p, q)
