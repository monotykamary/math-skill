import Base

# An unbounded inductive model. Core executable arithmetic uses binary
# digits. The verified reference magnitude routine also traverses this
# unary model; see README.md for its numeric-size performance limit.
type Number is Data:
  Z{}
  S{pred: Number}

def add(a: Number, b: Number) -> Number:
  match a:
    case Z{}:
      b
    case S{p}:
      S{add(p, b)}

def mul(a: Number, +b: Number) -> Number:
  match a:
    case Z{}:
      Z{}
    case S{p}:
      add(b, mul(p, b))

law add_zero:
  for a: Number
  {add(a, Z{}) == a : Number}
def add_zero(a):
  match a:
    case Z{}:
      {==}
    case S{p}:
      %add_zero(p) : {S{add(p, Z{})} == S{_} : Number}
      {==}

law add_succ:
  for a: Number
  for b: Number
  {add(a, S{b}) == S{add(a, b)} : Number}
def add_succ(a, b):
  match a:
    case Z{}:
      {==}
    case S{p}:
      %add_succ(p, b) : {S{add(p, S{b})} == S{_} : Number}
      {==}

law add_comm:
  for +a: Number
  for +b: Number
  {add(a, b) == add(b, a) : Number}
def add_comm(a, b):
  match a:
    case Z{}:
      Equal.sym(Number, add(b, Z{}), b, add_zero(b))
    case S{p}:
      Equal.trans(Number, S{add(p, b)}, S{add(b, p)}, add(b, S{p}),
        Equal.cong(Number, Number, x => S{x}, add(p, b), add(b, p), add_comm(p, b)),
        Equal.sym(Number, add(b, S{p}), S{add(b, p)}, add_succ(b, p)))

law add_assoc:
  for a: Number
  for b: Number
  for c: Number
  {add(add(a, b), c) == add(a, add(b, c)) : Number}
def add_assoc(a, b, c):
  match a:
    case Z{}:
      {==}
    case S{p}:
      %add_assoc(p, b, c) : {S{add(add(p, b), c)} == S{_} : Number}
      {==}

law mul_zero:
  for a: Number
  {mul(a, Z{}) == Z{} : Number}
def mul_zero(a):
  match a:
    case Z{}:
      {==}
    case S{p}:
      mul_zero(p)

law add_swap:
  for +a: Number
  for +b: Number
  for +c: Number
  {add(a, add(b, c)) == add(b, add(a, c)) : Number}
def add_swap(a, b, c):
  %add_assoc(b, a, c) : {add(a, add(b, c)) == _ : Number}
  %add_comm(a, b) : {add(a, add(b, c)) == add(_, c) : Number}
  %add_assoc(a, b, c) : {_ == add(add(a, b), c) : Number}
  {==}

law mul_succ:
  for +a: Number
  for +b: Number
  {mul(a, S{b}) == add(a, mul(a, b)) : Number}
def mul_succ(a, b):
  match a:
    case Z{}:
      {==}
    case S{p}:
      %add_swap(b, p, mul(p, b)) : {S{add(b, mul(p, S{b}))} == S{_} : Number}
      %mul_succ(p, b) : {S{add(b, mul(p, S{b}))} == S{add(b, _)} : Number}
      {==}

law mul_comm:
  for +a: Number
  for +b: Number
  {mul(a, b) == mul(b, a) : Number}
def mul_comm(a, b):
  match a:
    case Z{}:
      Equal.sym(Number, mul(b, Z{}), Z{}, mul_zero(b))
    case S{p}:
      Equal.trans(Number, add(b, mul(p, b)), add(b, mul(b, p)), mul(b, S{p}),
        Equal.cong(Number, Number, x => add(b, x), mul(p, b), mul(b, p), mul_comm(p, b)),
        Equal.sym(Number, mul(b, S{p}), add(b, mul(b, p)), mul_succ(b, p)))

law mul_add:
  for +a: Number
  for +b: Number
  for +c: Number
  {mul(add(a, b), c) == add(mul(a, c), mul(b, c)) : Number}
def mul_add(a, b, c):
  match a:
    case Z{}:
      {==}
    case S{p}:
      Equal.trans(Number, add(c, mul(add(p, b), c)), add(c, add(mul(p, c), mul(b, c))), add(add(c, mul(p, c)), mul(b, c)),
        Equal.cong(Number, Number, x => add(c, x), mul(add(p, b), c), add(mul(p, c), mul(b, c)), mul_add(p, b, c)),
        Equal.sym(Number, add(add(c, mul(p, c)), mul(b, c)), add(c, add(mul(p, c), mul(b, c))), add_assoc(c, mul(p, c), mul(b, c))))

law add_mul:
  for +a: Number
  for +b: Number
  for +c: Number
  {mul(a, add(b, c)) == add(mul(a, b), mul(a, c)) : Number}
def add_mul(a, b, c):
  %mul_comm(c, a) : {mul(a, add(b, c)) == add(mul(a, b), _) : Number}
  %mul_comm(b, a) : {mul(a, add(b, c)) == add(_, mul(c, a)) : Number}
  %mul_add(b, c, a) : {mul(a, add(b, c)) == _ : Number}
  %mul_comm(add(b, c), a) : {_ == mul(add(b, c), a) : Number}
  {==}

law mul_one:
  for +a: Number
  {mul(a, S{Z{}}) == a : Number}
def mul_one(a):
  %add_zero(a) : {mul(a, S{Z{}}) == _ : Number}
  %mul_zero(a) : {mul(a, S{Z{}}) == add(a, _) : Number}
  %mul_succ(a, Z{}) : {mul(a, S{Z{}}) == _ : Number}
  {==}

law mul_assoc:
  for +a: Number
  for +b: Number
  for +c: Number
  {mul(mul(a, b), c) == mul(a, mul(b, c)) : Number}
def mul_assoc(a, b, c):
  match a:
    case Z{}:
      {==}
    case S{p}:
      %mul_assoc(p, b, c) : {mul(add(b, mul(p, b)), c) == add(mul(b, c), _) : Number}
      %mul_add(b, mul(p, b), c) : {mul(add(b, mul(p, b)), c) == _ : Number}
      {==}

law mul_swap:
  for +a: Number
  for +b: Number
  for +c: Number
  {mul(a, mul(b, c)) == mul(b, mul(a, c)) : Number}
def mul_swap(a, b, c):
  %mul_assoc(b, a, c) : {mul(a, mul(b, c)) == _ : Number}
  %mul_comm(a, b) : {mul(a, mul(b, c)) == mul(_, c) : Number}
  %mul_assoc(a, b, c) : {_ == mul(mul(a, b), c) : Number}
  {==}

law add_one:
  for +a: Number
  {add(a, S{Z{}}) == S{a} : Number}
def add_one(a):
  %add_zero(a) : {add(a, S{Z{}}) == S{_} : Number}
  add_succ(a, Z{})

law add_interchange:
  for +a: Number
  for +b: Number
  for +c: Number
  for +d: Number
  {add(add(a, b), add(c, d)) == add(add(a, c), add(b, d)) : Number}
def add_interchange(a, b, c, d):
  Equal.trans(Number, add(add(a, b), add(c, d)), add(a, add(b, add(c, d))), add(add(a, c), add(b, d)),
    add_assoc(a, b, add(c, d)),
    Equal.trans(Number, add(a, add(b, add(c, d))), add(a, add(c, add(b, d))), add(add(a, c), add(b, d)),
      Equal.cong(Number, Number, x => add(a, x), add(b, add(c, d)), add(c, add(b, d)), add_swap(b, c, d)),
      Equal.sym(Number, add(add(a, c), add(b, d)), add(a, add(c, add(b, d))), add_assoc(a, c, add(b, d)))))
