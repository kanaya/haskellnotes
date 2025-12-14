#let block(x) = { 
  set text(gray)
  set text(font: ("Helvetica", "Toppan Bunkyu Gothic"), size: 10pt)
  $penta.filled$
  h(1em)
  x}

#let constant(x) = x
#let parameter(x) = x

#let keyword(x) = math.mono(x)

#let typeparameter(x) = math.bold(x)

#let longfunction(x) = x
#let read = longfunction("read")

#let action(x) = math.sans(x)
#let main = action("main")
#let print = action("print")
#let getLine = action("getLine")

#let lambda = math.backslash
#let lambdaarrow = math.arrow.r.bar
#let anonymousparameter = math.lozenge

#let list(x) = {
  let xx = x
  $xx_"s"$
}
#let maybe(x) = {
  let xx = x
  $xx_?$
}
#let ctxt(x) = {
  let xx = x
  $xx_*$
}
#let monadic(x) = {
  let xx = x
  $xx^dagger$
}

#let typename(x) = math.bold(x)
#let Int = typename("Int")
#let Double = typename("Double")
#let Bool = typename("Bool")

#let typeclass(x) = math.frak(x)
#let Num = typeclass("Num")

#let constructor(x) = math.serif(x)
#let True = constructor("True")
#let False = constructor("False")

#let compose = math.bullet.op
#let apply = math.class("binary", math.section)

#let map = math.star.op
#let fmap = math.ast.op
#let amap = math.ast.op.o
#let bind = math.class("binary", math.suit.heart.stroked)

#let leteq = math.equiv

#let kwlet = keyword("let")
#let kwin = keyword("in")
#let kwwhere = keyword("where")