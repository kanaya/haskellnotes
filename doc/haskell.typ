#let block(x) = { 
  // set text(gray)
  set text(font: ("Helvetica", "Toppan Bunkyu Gothic"), size: 10pt)
  $penta.filled$
  h(1em)
  x}

// Constant.

#let constantstring(x) = { "\"" + math.mono(x) + "\"" }

// Parameter.
#let parameter(x) = x
#let longparameter(x) = math.serif(x)
#let first = longparameter("first")
#let otherwise = longparameter("otherwise")

// Function.
#let longfunction(x) = math.serif(x)
#let even = longfunction("even")
#let fib = longfunction("fib")
#let id = longfunction("id")
#let lines = longfunction("lines")
#let norm = longfunction("norm")
#let read = longfunction("read")
#let readDouble = longfunction("readDouble")
#let sqrt = longfunction("sqrt")
#let words = longfunction("words")

// Type parameter.
#let typeparameter(x) = math.bold(x)

// Type name.
#let typename(x) = math.bold(x)
#let Bool = typename("Bool")
#let Char = typename("Char")
#let Double = typename("Double")
#let Int = typename("Int")
#let String = typename("String")
#let Unit = typename(math.paren.l.stroked+math.paren.r.stroked)

// Type constructor.
#let typeconstructor(x) = math.bold(x)

#let Maybe = typeconstructor("Maybe")

#let typeconstructor1(x, y) = {
  let xx = x
  let yy = y
  $xx_yy$
}

#let MaybeType(x) = typeconstructor1(Maybe, x)

// Type class.
#let typeclass(x) = math.frak(x)
#let Functor = typeclass("Functor")
#let Num = typeclass("Num")

// Action.
#let action(x) = math.sans(x)
#let main = action("main")
#let getContents = action("getContents")
#let getLine = action("getLine")
#let print = action("print")
#let printEach = action("printEach")

// Binary operator.
#let anonymousoperator = math.class("binary",math.square.stroked)
#let compose = math.bullet.op
#let apply = math.class("binary", math.dollar)
#let map = math.ast
#let fmap = math.ast.op.o
#let amap = math.ast.square
#let mapM = math.class("binary", math.ast.triple)
#let bind = math.class("binary", math.suit.heart.stroked)
#let leteq = math.equiv

// Keyword.
#let keyword(x) = math.mono(x)
#let kwcase = keyword("case")
#let kwelse = keyword("else")
#let kwif = keyword("if")
#let kwin = keyword("in")
#let kwlet = keyword("let")
#let kwof = keyword("of")
#let kwthen = keyword("then")
#let kwtype = keyword("type")
#let kwwhere = keyword("where")

// Container.
#let list(x) = {
  let xx = x
  $xx_"s"$
}
#let listlist(x) = {
  let xx = x
  $xx_"ss"$
}
#let maybe(x) = {
  let xx = x
  $xx_?$
}
#let ctxt(x) = {
  let xx = x
  $xx_*$
}
#let monadic(x) = x

// Value constructor.
#let constructor(x) = math.serif(x)
#let Nothing = constructor("Nothing")
#let True = constructor("True")
#let False = constructor("False")

// Value constructor with one argument.
#let constructor1(x, y) = {
  let xx = x
  let yy = y
  $xx_yy$
}
#let Just(x) = constructor1("Just", x)
#let pure(x) = {
  let xx = x
  $shell.l xx shell.r$
}

// Type constructor with one argument.
#let typename1(x, y) = {
  let xx = typename(x)
  let yy = typename(y)
  $xx_yy$
}

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

#let xs = $list(x)$
#let xss = $listlist(x)$
#let ys = $list(y)$
#let zs = $list(z)$
#let xm = $maybe(x)$
#let ym = $maybe(y)$
#let zm = $maybe(z)$
#let xc = $ctxt(x)$
#let yc = $ctxt(y)$
#let zc = $ctxt(z)$
