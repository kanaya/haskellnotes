#let block(x) = { 
  // set text(gray)
  set text(font: ("Helvetica", "Toppan Bunkyu Gothic"), size: 10pt)
  $penta.filled$
  h(1em)
  x}

// Keyword.
#let keyword(x) = math.mono(x)
#let kwcase = keyword("case")
#let kwclass = keyword("class")
#let kwdata = keyword("data")
#let kwdo = keyword("do")
#let kwelse = keyword("else")
#let kwif = keyword("if")
#let kwin = keyword("in")
#let instance = keyword("instance")
#let kwlet = keyword("let")
#let kwof = keyword("of")
#let kwthen = keyword("then")
#let kwtype = keyword("type")
#let kwwhere = keyword("where")

// Constant.

#let constantstring(x) = { "\"" + math.mono(x) + "\"" }

// Parameter.
#let parameter(x) = x
#let longparameter(x) = math.serif(x)
#let first = longparameter("first")
#let otherwise = longparameter("otherwise")

// Function.
#let longfunction(x) = math.serif(x)
#let curry = longfunction("curry")
#let even = longfunction("even")
#let fact = longfunction("fact")
#let filter = longfunction("filter")
#let first = longfunction("first")
#let fib = longfunction("fib")
#let head = longfunction("head")
#let fromIntegral = longfunction("fromIntegral")
#let lines = longfunction("lines")
#let norm = longfunction("norm")
#let null = longfunction("null")
#let pred = longfunction("pred")
#let quicksort = longfunction("quicksort")
#let read = longfunction("read")
#let readDouble = longfunction("readDouble")
#let rest = longfunction("rest")
#let sqrt = longfunction("sqrt")
#let succ = longfunction("succ")
#let take = longfunction("take")
#let tail = longfunction("tail")
#let uncurry = longfunction("uncurry")
#let words = longfunction("words")

// Type parameter.
#let typeparameter(x) = math.bold(x)

// Type name.
#let typename(x) = math.bold(x)
#let Bool = typename("Bool")
#let Char = typename("Char")
#let Double = typename("Double")
#let Float = typename("Float")
#let Int = typename("Int")
#let Integer = typename("Integer")
#let IO = typename("IO")
#let List = typename("[]")
#let String = typename("String")
#let Unit = typename(math.paren.l.stroked+math.paren.r.stroked)

// Type constructor.
#let typeconstructor(x) = math.bold(x)

#let Either = typeconstructor("Either")
#let Maybe = typeconstructor("Maybe")

#let typeconstructor1(x, y) = {
  let xx = x
  let yy = y
  $xx_yy$
}

#let typeconstructor2(x, y, z) = {
  let xx = x
  let yy = y
  let zz = z
  $xx_(yy zz)$
}

#let EitherType(x, y) = typeconstructor2(Either, x, y)
#let MaybeType(x) = typeconstructor1(Maybe, x)

// Type class.
#let typeclass(x) = math.sans(x)
#let Applicative = typeclass("Applicative")
#let Enum = typeclass("Enum")
#let Eq = typeclass("Eq")
#let Functor = typeclass("Functor")
#let Integral = typeclass("Integral")
#let Num = typeclass("Num")
#let Ord = typeclass("Ord")
#let Real = typeclass("Real")

// Action.
#let action(x) = math.bold(x)
#let main = action("main")
#let getContents = action("getContents")
#let getLine = action("getLine")
#let print = action("print")
#let printEach = action("printEach")

// Unary operator

#let flat = math.class("unary", math.flat)

// Binary operator.
#let anyop = math.class("binary", math.circle.dotted)
#let at = math.class("binary", math.at)
#let bangbang = math.class("binary", math.excl.double)
#let compose = math.bullet.op
#let apply = math.class("binary", math.dollar)
#let amap = math.ast.square
#let mapM = math.class("binary", math.ast.triple)
#let bind = math.class("binary", math.suit.heart.stroked)
#let leteq = math.equiv

// Big operator
#let fold = math.union.big
#let foldright = math.union.sq.big

// Container.
#let ctxt(x) = {
  let xx = x
  $xx_*$
}
#let monadic(x) = x

// Value constructor.
#let constructor(x) = math.serif(x)
#let False = constructor("False")
#let Nothing = constructor("Nothing")
#let True = constructor("True")

// Value constructor with one argument.
#let constructor1(x, y) = {
  let xx = x
  let yy = y
  $xx_yy$
}

#let Left(x) = constructor1("Left", x)
#let Just(x) = constructor1("Just", x)
#let Right(x) = constructor1("Right", x)

// Type constructor with one argument.
#let typename1(x, y) = {
  let xx = typename(x)
  let yy = typename(y)
  $xx_yy$
}

// Infix.
#let infix(x) = {
  let xx = x
  $class("binary", quote.l.single xx quote.r.single)$
}

// Unit type.
#let unittype = $class("normal", bold(paren.l.closed paren.r.closed))$

// Kind
#let kind(x) = math.frak(x)
#let Type = kind("Type")
#let kk = kind("K")

// Shortcut.

#let a = $typename(a)$
#let b = $typename(b)$
#let c = $typename(c)$
#let d = $typename(d)$
#let e = $typename(e)$
#let f = $typename(f)$
#let g = $typename(g)$
#let h = $typename(h)$
#let i = $typename(i)$
#let j = $typename(j)$
#let k = $typename(k)$
#let l = $typename(l)$
#let m = $typename(m)$
#let n = $typename(n)$
#let o = $typename(o)$
#let p = $typename(p)$
#let q = $typename(q)$
#let r = $typename(r)$
#let s = $typename(s)$
#let t = $typename(t)$
#let u = $typename(u)$
#let v = $typename(v)$
#let w = $typename(w)$
#let x = $typename(x)$
#let y = $typename(y)$
#let z = $typename(z)$

#let fa = $typeconstructor1(typename(f), typename(a))$
#let fb = $typeconstructor1(typename(f), typename(b))$
#let fc = $typeconstructor1(typename(f), typename(c))$



