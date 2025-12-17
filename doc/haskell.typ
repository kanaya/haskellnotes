#let block(x) = { 
  // set text(gray)
  set text(font: ("Helvetica", "Toppan Bunkyu Gothic"), size: 10pt)
  $penta.filled$
  h(1em)
  x}

// Parameter.
#let parameter(x) = x
#let longparameter(x) = math.serif(x)
#let first = longparameter("first")
#let otherwise = longparameter("otherwise")

// Function.
#let longfunction(x) = math.serif(x)
#let id = longfunction("id")
#let read = longfunction("read")

// Type parameter.
#let typeparameter(x) = math.bold(x)

// Type name.
#let typename(x) = math.bold(x)
#let Bool = typename("Bool")
#let Char = typename("Char")
#let Double = typename("Double")
#let Int = typename("Int")
#let Unit = typename(math.paren.l.stroked+math.paren.r.stroked)

// Type class.
#let typeclass(x) = math.frak(x)
#let Num = typeclass("Num")

// Action.
#let action(x) = math.sans(x)
#let main = action("main")
#let print = action("print")
#let getLine = action("getLine")

// Binary operator.
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

// Constructor.
#let constructor(x) = math.serif(x)
#let Nothing = constructor("Nothing")
#let True = constructor("True")
#let False = constructor("False")

// Constructor with one argument.
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


