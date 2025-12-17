// Typst
#import "@preview/in-dexter:0.7.2": *
#import "@preview/codelst:2.0.2": sourcecode

#set text(lang:"ja")
#set math.equation(numbering: "(1)")

#set page(
  paper: "a4",
  header: align(right, context document.title),
  numbering: "1",
)

#set par(justify: true, first-line-indent: (all: true, amount: 1em))

#set heading(numbering: "1.1")

#set document(title: [Haskell Notes])

#set text(font: ("Times", "Toppan Bunkyu Mincho"))

#let heading_font(body) = {
    set text(font: ("Helvetica", "Toppan Bunkyu Midashi Gothic"), navy)
    body
}
#show heading: heading_font

#let strong_font(body) = {
  set text(font: ("Helvetica", "Toppan Bunkyu Gothic"), weight: "bold")
  body
}
#show strong: strong_font

#let highlight_font(body) = {
  set text(font: ("Helvetica", "Toppan Bunkyu Gothic"), weight: "bold")
  body
}
#show highlight: highlight_font

#let tk = [ #emoji.ast.box *TK* ]
#let keyword(x) = [#highlight[#x]]

#import "haskell.typ"

#title[Haskell Notes]

#outline()
#pagebreak()

= 凡例

#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: center,
  table.header([*種類*], [*字体・表記法*], [*例*]),
  [変数・関数], [イタリック（1文字）], $x, f$,
  [有名な変数・関数・定数], [ローマン・大文字], $haskell.first, haskell.id, haskell.otherwise$,
  [リスト変数], [変数名にsをつける], $haskell.list(x)$,
  [Maybe変数], [変数名に $?$ をつける], $haskell.maybe(x)$,
  [一般のコンテナ変数], [変数名に $*$ をつける], $haskell.ctxt(x)$,
  // [コンテナに入れる関数], [関数名に $dagger$ をつける], $haskell.monadic(f)$,
  [定数値コンストラクタ], [ローマン・大文字], $haskell.True, haskell.Nothing$,
  [値コンストラクタ], [ローマン・大文字], $haskell.Just(x)$,
  [有名な定数値コンストラクタ], [数学記号], $emptyset, emptyset.rev$,
  [有名な値コンストラクタ], [特別なカッコで包む], $[x], haskell.pure(y)$,
  [アクション], [ギリシア文字（1文字）], $alpha, mu$,
  [有名なアクション], [サンセリフ], $haskell.main, haskell.print$,
  [型（引数なし）], [ボールドイタリック（1文字）], $haskell.typename(a)$,
  [型（引数あり）], [ボールドイタリック（1文字）], $haskell.typename1(m, a)$,
  [有名な型（引数なし）], [ボールド・大文字], $haskell.Int$,
  [有名な型（引数あり）], [特別なカッコで包む], $[haskell.typename(a)], [haskell.Int]$,
  [型クラス], [フラクチュール], $haskell.Num$,
  [キーワード], [固定幅], $haskell.kwlet$,
  [無名パラメタ], [ひし形（白）], $lozenge.stroked.medium$,
  [無名型パラメタ], [ひし形（黒）], $lozenge.filled.filled.medium$,
  [集合（数学）], [ブラックボード（1文字）], $ZZ$,
  [関手（数学）], [スクリプト（1文字）], $scr(F)$,
  [圏（数学）], [カリグラフィ（1文字）], $cal(C)$
)

= Haskellについて

本書はプログラミング言語Haskellの入門書である．それと同時に，本書はプログラミング言語を用いた代数構造の入門書でもある．プログラミングと代数構造の間には密接な関係があるが，とくに#keyword[関数型プログラミング]を実践する時にはその関係を意識する必要が出てくる．本書はその両者を同時に解説することを試みる．

== Haskellという森

これからのプログラマにとってHaskellを無視することはできない．Haskellの「欠点をあげつらうことも，攻撃することもできるが，無視することだけはできない」のだ．それはHaskellがプログラミングの本質に深く関わっているからである．

Haskellというプログラミング言語を知ろうとすると，従来のプログラミング言語の知識が邪魔をする．モダンで，人気があって，Haskellから影響を受けた言語，たとえばRubyやSwiftの知識さえ，Haskellを学ぶ障害になり得る．ではどのようにしてHaskellの深みに到達すればいいのだろうか．

その答えは，一見遠回りに見えるが，一度抽象数学の高みに登ることである．

と言っても，あわてる必要はない．

近代的なプログラミング言語を知っていれば，すでにある程度抽象数学に足を踏み入れているからである．そこで，本書では近代的なプログラマを対象に，プログラミング言語を登山口に抽象数学の山を登り，その高みからHaskellという森を見下ろすことにする．

さて，登山口にどのプログラミング言語を選ぶのが適当であろうか．TIOBE Index 2023年2月版によると「ビッグ5」としてPython，C，C++，Java，C\#が挙げられている．#footnote[https://www.tiobe.com/tiobe-index/]順位の変動はあるが，他の調査でもビッグ5は過去何年も変動していないので，当座は妥当な統計であろう．このうちCは「多くのプログラマが読める」以外にメリットが無く，その唯一のメリットさえ最近は怪しくなっているため，登山口候補から外す．残るはJava，C\#グループとPythonということになるが，シンプルであり，かつHaskellと対極にある言語であるPythonを登山口に選ぶことにした．

本書ではPythonコードはこのように登場する．
#sourcecode[```python
print("Hello, world.")
```]

本書に示すコードは擬似コードではなく，すべて実行可能な本物のコードである．

一部の章でどうしても型に触れないといけない部分がある．Pythonは動的型付け言語であり，型の説明には不適切であるため，この部分だけ理解の助けとしてC++によるコードを例示した．この部分はコードを読まなくても先に進める．

ところで，プログラムのソースコードは現代でもASCII文字セットの範囲で書くことが標準的である．Unicodeを利用したり，まして文字にカラーを指定したり，書体や装飾を指定することは一般的ではない．たとえば変数 `a` のことを $a$ と書いたり $bold(a)$ と書いたり $tilde(a)$ と書いたりして区別することはない．

Haskellプログラマもまた，多くの異なる概念を同じ貧弱な文字セットで表現しなければならない．これは，はじめてHaskellコードを読むときに大きな問題になりえる．たとえばHaskellでは `[a]` という表記をよく扱う．この `[a]` は `a` という変数1要素からなるリストのこともあるし，`a` 型という仮の型から作ったリスト型の場合もあるが，字面からでは判断できない．もし変数はイタリック体，型はボールド体と決まっていれば，それぞれ $[a]$ および $[haskell.typeparameter(a)]$ と区別できたところである．

本書は，異なる性質のものには異なる書体を割り当てるようにしている．ただし，どの表現もいつでもHaskellに翻訳できるように配慮している．実際，本書執筆の最大の困難点は，数学的に妥当で，かつHaskellの記法とも矛盾しない記法を見つけることであった．

== 関数型プログラミング

プログラマはなぜHaskellを習得しなければならないのだろう．それはHaskellと#keyword[関数型プログラミング]の間に密接な関係があるからである．

関数型プログラミングとはプログラミングにおける一種のスローガンのようなもので，どの言語を用いたから関数型でどの言語を用いたから関数型ではない，というものではない．しかし，関数型プログラミングを強くサポートする言語と，そうでない言語とがある．ここら辺の事情はオブジェクト指向プログラミングとプログラミング言語の関係と似ている．Haskellは関数型プログラミングを強くサポートし，Pythonはほとんどサポートしない．

関数型プログラミングの特徴を一言で言えば，プログラム中の#keyword[破壊的代入]を禁止することである．変数 $x$ に $1$ という数値が一度代入されたら，変数 $x$ の値をプログラム中に書き換える，すなわち破壊的代入をすることはできない．この結果，変数の値はプログラムのどこでも，どの時点で読み出しても同じであることが保証される．これを変数の#keyword[参照透過性]と呼ぶ．

プログラム全体に参照透過性があると，そのプログラムはブロックに分割しやすく，各々のブロックは再利用しやすい．またプログラムのどの断片から読み始めても，全体の構造を見失いにくい．これが関数型プログラミングとそれを強くサポートするHaskellを習得する理由である．

参照透過性がもたらすもう一つのボーナスは変数の#keyword[遅延評価]である．変数はいつ評価しても値が変わらないのだから，コンパイラは変数をできるだけ遅く評価してよい．この遅延評価によって，Haskellコンパイラは他の言語に見られない#keyword[無限リスト]を扱う能力を獲得している．

ここで数学とプログラミングの関係について述べておこう．ある方程式を解くためにコンピュータによって数値シミュレーションを行うとか，非常に複雑な微分を機械的に行うとか，プログラミングによって数学をサポートすることは計算機科学の主たる分野の一つであるが，ここではもっと根源的な話をする．

数学者もプログラマも#keyword[関数]をよく使う．数学者が使う関数とは，引数がいくつかあって，その結果決まる戻り値があるようなものだ．一方でプログラマが使う関数というのは，引数と戻り値はだいたい同じとして，中身に条件分岐があったり，ループがあったり，外部変数を書き換えたり，入出力をしたりする．

どちらも同じ関数であるのに，なぜこうもイメージが違うのだろうか．

もし，我々が関数型プログラミングの原則を忠実に守り，プログラム中のいかなる破壊的代入をも禁止するとすると，両者の関数は全く同じ性格になる．逐次実行も条件分岐もループも，それどころか定数さえ，#keyword[ラムダ式]という式だけで書けるようになる．あらゆるプログラムが，最終的には単一のラムダ式で書ける．

ところが，入出力，状態変数，例外など，プログラミングに使われる多くのテクニックは関数の副作用を前提としている．参照透過性と副作用を統一的に扱うためには#keyword[モナド]という数学概念が必要である．Haskellはモナドを陽に扱うプログラミング言語である．

== 関数型という考え方

関数型プログラミングという考え方自体は，プログラミングに必ずしも束縛されるものではない．

たとえばいま，ある英文テキストファイルから，単語を出現頻度順に取り出したいとしよう．こんなとき，プログラマならば次のように考えるのではないだろうか．

「まずは英文テキスト中の大文字を全部小文字にしよう」「それからアルファベットと空白以外を全部捨ててしまおう」「空白を改行に置き換えると，1行に1単語になるな」「ここまで来たら出現頻度順に並べ直すのはわけないことだ」……

これらの言葉をUNIXの言葉に置き換えてみる．ここでは英文テキストを `the-great-gatsby.txt` としておこう．中身はフィッツジェラルドの名作「The Great Gatsby」（華麗なるギャッツビー）だ．最初の「まずは英文テキスト中の大文字を全部小文字にしよう」はUNIXコマンドではこうなる．

#sourcecode[```shell-unix-generic
$ cat the-great-gatsby.txt | tr '[A-Z]' '[a-z]'
```]

この出力を適当なファイルにリダイレクトすれば，大文字がすべて小文字に置き換わったテキストファイルになる．

次にするのは「それからアルファベットと空白以外を全部捨ててしまおう」だ．UNIXコマンドではこうなる．

#sourcecode[```shell-unix-generic
$ cat the-great-gatsby.txt | tr '[A-Z]' '[a-z]' | tr -C -d ‘[a-z ]'
```]

これで単語だけのテキストファイルが出来る．次に空白をすべて改行に置き換えてしまおう．UNIXコマンドでこうする．

#sourcecode[```shell-unix-generic
$ cat the-great-gatsby.txt | tr '[A-Z]' '[a-z]' | tr -C -d ‘[a-z ]' | tr ' ' '\n'
```]

1行に1単語ずつ並べられたテキストファイルがこれで手に入ることになる．空行もあるが，それは問題ない．このファイルの中身をアルファベット順にソートする．

#sourcecode[```shell-unix-generic
$ cat the-great-gatsby.txt | tr '[A-Z]' '[a-z]' | tr -C -d ‘[a-z ]' | tr ' ' '\n' | sort
```]

ソートできれば，同一の連続する行を数え上げて，一つの行にすればいい．

#sourcecode[```shell-unix-generic
$ cat the-great-gatsby.txt | tr '[A-Z]' '[a-z]' | tr -C -d ‘[a-z ]' | tr ' ' '\n' | sort | uniq -c
```]

最後に，出現頻度順に逆順ソートをかけると「出現頻度順」になる．それには以下のようにする．

#sourcecode[```shell-unix-generic
$ cat the-great-gatsby.txt | tr '[A-Z]' '[a-z]' | tr -C -d ‘[a-z ]' | tr ' ' '\n' | sort | uniq -c | sort -nr
```]

この出力の先頭10行は，そのまま出現頻度上位10傑の単語となる．

さて，この出現頻度上位単語の抽出のどこが「関数型プログラミング」の考え方だったのだろうか．

実はこんな風に考えることが出来る．入力を $x$ とする．いまの例では $x$ がファイル `the-great-gatsby.txt` である．出力を $y$ とする．ここに $y$ は出現頻度順に並んだ出現頻度と単語のリストである．僕たちが欲しいのは

$ y = f(x) $

となるようなプログラム $f$ だった．プログラム $f$ は簡単には手に入らないので，僕たちはUNIXコマンドの `tr` とか `sort` とか `uniq` とかをつなぎ合わせて作った．それらを「数学風」に書くと次のようになる．

$ f_1 &= "tr"_([A...Z]->[a...z])\
  f_2 &= "tr"_(overline([a...z, square])->emptyset)\
  f_3 &= "tr"_(square->arrow.bl.hook)\
  f_4 &= "sort"\
  f_5 &= "uniq"_c\
  f_6 &= "sort"_(n,r) $

そして $x$ から $y$ を得るために $y = f_6(f_5(f_4(f_3(f_2(f_1(x))))))$ という計算を行った．カッコが多すぎるので，この式を$y = f_6 compose f_5 compose f_4 compose f_3 compose f_2 compose f_1(x)$ と書き直そう．ここに演算子 $compose$ は「#keyword[関数合成演算子]」だ．

関数合成演算子を使うと，プログラム $f$ を $f = f_6 compose f_5 compose f_4 compose f_3 compose f_2 compose f_1$ と定義することも出来る．これが何を意味しているかと言うと，プログラムを小さな部分プログラムに分解したということだ．

分解したなら，合成する方法が必要になる．この例では，プログラムの各部分が他の部分に依存していないために，合成は数学的な関数合成と同じ方法が使える．

上記の例のように，数学における関数合成をそのままプログラミングに持ち込めれば，部分プログラムの合成も見通しが良いものになる．このような考え方が「関数型プログラミング」のエッセンスなのである．

#tk

= 変数・関数・型

== 変数

変数 $x$ に値 $1$ を代入するには次のようにする．#footnote[Haskellでは `x = 1` と書く．]

$ x = 1 $<binding>

変数という呼び名に反して，変数の値は一度代入したら変えられない．そこで変数に値を代入するとは呼ばずに，変数に値を#keyword[束縛]するという． @binding の右辺のように数式にハードコードされた値を#keyword[リテラル]と呼ぶ．

リテラルや変数には#keyword[型]がある．型は数学者の#keyword[集合]と似た意味で，整数全体の集合 $ZZ$ に相当する#keyword[整数型]や，実数全体の集合 $RR$ に相当する#keyword[浮動小数点型]がある．整数と整数型，実数と浮動小数点型は異なるため，整数型を $haskell.Int$ で，浮動小数点型を $haskell.Double$ で表すことにする．#footnote[Haskellでは `Int` および `Double` と書く．]

数学者は変数 $x$ が整数であることを $x in ZZ$ と書くが，本書では $x colon.double haskell.Int$ と書く．これは記号 $in$ を別の用途に用いるためである．#footnote[Haskellでは $x colon.double haskell.Int$ を `x :: Int` と書く．]

本書では変数名を原則1文字として，イタリック体で表し $w,x,y,z$ のような $n$ 以降のアルファベットを使う．

変数の値がいつでも変化しないことを#keyword[参照透過性]と呼ぶ．プログラマが変数の値を変化させたい，つまり#keyword[破壊的代入]を行いたい理由はユーザ入力，ループ，例外，内部状態の変化，大域ジャンプ，継続を扱いたいからであろう．しかし，後に見るようにループ，例外，内部状態の変化，大域ジャンプ，継続に変数の破壊的代入は必要ない．ユーザ入力に関しても章を改めて取り上げる．参照透過性を強くサポートするプログラミング言語をを#keyword[関数型プログラミング言語]と呼ぶ．

== 変数の型

#tk

$ x colon.double haskell.Int $

$ x = 1 $

$ x colon.double haskell.Int = 1 $

== 関数

整数 $x$ に $1$ を足す#keyword[関数] $f$ は次のように定義できる．
$ f x = x + 1 $
ここに $x$ は関数 $f$ の#keyword[引数]である．引数は括弧でくるまない．#footnote[Haskellでは `f x = x + 1` と書く．]

本書では関数名を原則1文字として，イタリック体で表し，$f,g,h$ のようにアルファベットの $f$ 以降の文字を使う．ただし有名な関数についてはローマン体で表し，文字数も2文字以上とする．たとえば $sin$ などの三角関数や指数関数がそれにあたる．

変数 $x$ に関数 $f$ を#keyword[適用]する場合は次のように書く．ここでも引数を括弧でくるまない．#footnote[Haskellでは `z = f x` と書く．]
$ z = f x $

関数 $f$ が引数をふたつ取る場合は，次のように書く．#footnote[Haskellでは `z = f x y` と書く．]
$ z = f x y $

なお $f x y$ は $(f x)y$ と解釈される．前半の $(f x)$ は1引数の関数とみなせる．2引数関数を連続した1引数関数の適用とみなす考え方を，関数の#keyword[カリー化]と呼ぶ．


== 有名な関数

#tk

== 関数の型

#tk

== 関数合成

変数 $x$ に関数 $f$ と関数 $g$ を連続して適用したい場合
$ z = g(f x)$
とするところであるが，事前に関数 $f$ と関数 $g$ を#keyword[合成]しておきたいことがある．

関数の合成は次のように書く．
$ k = g compose f $
関数の連続適用 $g(f x)$ と合成関数の適用 $(g compose f)x$ は同じ結果を返す．#footnote[Haskell では $k = g compose f$ を `k = g . f` と書く．]

関数合成演算子 $compose$ は以下のように#keyword[左結合]する．
$ k &= h compose g compose f \
    &= (h compose g) compose f $

関数適用のための特別な演算子 $haskell.apply$ があると便利である．演算子 $haskell.apply$ は関数合成演算子よりも優先順位が低い．例を挙げる．#footnote[Haskellでは $z = h haskell.apply g compose f x$ を `z = h $ (g . f) x` と書く．]
$ z &= h compose (g compose f) x \
    &= h haskell.apply g compose f x $


== IOサバイバルキット1

プログラムとは合成された関数である．多くのプログラミング言語では，プログラムそのものにmainという名前をつける．本書では「#keyword[IOモナド]」の章で述べる理由によって，main関数をサンセリフ体で $haskell.main$ と書く．

実用的なプログラムはユーザからの入力を受け取り，関数を適用し，ユーザへ出力する．Haskellではユーザからの1行の入力を $haskell.getLine$ で受け取り，変数の値を $haskell.print$ で書き出せる．ここに $haskell.getLine$ と $haskell.print$ は関数（ファンクション）ではあるが，特別に「#keyword[アクション]」とも呼ぶ．関数 $haskell.main$もアクションである．

引数 $x$ の2乗を求める関数 $f$ は次のように定義できる．
$
  &f colon.double haskell.Double -> haskell.Double\
  &f x = x times x
$<square>

ユーザからの入力に関数 $f$ を適用してユーザへ出力するプログラムをHaskellで書くと次のようになる．
$ haskell.main = haskell.print compose f compose haskell.read haskell.bind haskell.getLine $<first-main>
ここに関数 $haskell.read$ は#keyword[文字列]であるユーザ入力を数に変換する関数である．また演算子 $haskell.bind$ は新たな関数合成演算子で，アクションとアクションを合成するための特別な演算子である．詳細は「#keyword[モナド]」の章で述べる．

#haskell.block[Haskell では@square と@first-main をまとめて次のように書く．
#sourcecode[```haskell
f :: Double -> Double
f x = x * x

main = print . f . read =<< getLine
```]]

= 条件分岐と再帰呼び出し

== ラムダ

関数とは，変数名に束縛された#keyword[ラムダ式]である．引数をひとつとり，その引数に $1$ を足して返す関数 $f$ はラムダ式を用いて次のように書ける．
$ f = backslash x |-> x + 1 $
ラムダ式は入れ子に出来る．引数をふたつとり，その引数同士を足すラムダ式は次のように書ける．
$ backslash x |-> (backslash y |-> x + y) $<lambda-nested>
より簡潔に@lambda-nested を
$ backslash x y |-> x + y $<lambda-nested-alternative>
と書いても良い．

本書では無名変数 $lozenge.stroked.medium$ を用いた以下の書き方も用いる．#footnote[無名変数はHaskellには無いが，代わりに「セクション」という書き方ができる．式 $f = (lozenge.stroked.medium + 1)$ をHaskellでは `f = (+1)` と書く．]
$
  f &= (lozenge.stroked.medium + 1)\
    &= backslash x |-> x + 1
$

無名変数が2回以上登場した場合は，その都度新しいパラメタを生成する．たとえば次のとおりである．#footnote[Haskellでは $f = (lozenge.stroked.medium + lozenge.stroked.medium)$ を `f = (+)` と書く．]
$
  f &= lozenge.stroked.medium + lozenge.stroked.medium\
    &= backslash x |-> backslash y |-> x + y\
    &= backslash x y |-> x + y
$

== ローカル変数

関数内で#keyword[ローカル変数]を使いたい場合は以下のように行う．#footnote[Haskellでは $z = haskell.kwlet y haskell.leteq 1 haskell.kwin x + y$ を `z = let y = 1 in x + y` と書く．]
$ z = haskell.kwlet y haskell.leteq 1 haskell.kwin x + y $<let-in>

ローカル変数はラムダ式のシンタックスシュガーである．@let-in は次の式と等価である．
$ z = (backslash y |-> x + y) 1 $<let-in-alternative>

ローカル変数の定義は次のように後置できる．#footnote[Haskellでは $z = x + y haskell.kwwhere y haskell.leteq 1$ を `z = x + y where y = 1` と書く．]
$ z = x + y haskell.kwwhere y haskell.leteq 1 $<where>

== クロージャ

ラムダ式を返す関数は，ラムダ式内部に値を閉じ込めることができる．たとえば
$ f n = backslash x |-> n + x $<closure>
のように関数を定義して良い．関数 $f$ に引数 $n$ を与えると，新たな1引数関数が得られる．例を挙げる．
$ n &= 3\
  g &= f n $<closure-example>
この例では，関数 $g$ の中に値 $n=3$ が閉じ込められているため $g 1$ は $4$ と評価される．値を閉じ込めたラムダ式を#keyword[クロージャ]と呼ぶ．

== 型

#tk 一部前倒し

すべての変数，関数には#keyword[型]がある．代表的な型には整数型，浮動小数点型，ブール型，文字型がある．整数型を $haskell.Int$ で，浮動小数点型を $haskell.Double$ で表すことはすでに述べたとおりである．

Haskellには2種類の整数型がある．ひとつは#keyword[固定長整数型]で，もうひとつは#keyword[多倍長整数型]である．Haskellでは前者を `Int` で，後者を `Integer` で表す．多倍長整数型はメモリの許す限り巨大な整数を扱えるので，整数全体の集合に近いのであるが，本書では主に固定長整数型を用いる．

浮動小数点型には#keyword[単精度浮動小数点型]と#keyword[倍精度浮動小数点型]があり，Haskellでは前者を `Float` で，後者を `Double` で表現する．単精度浮動小数点型はめったに用いられないため，本書では浮動小数点型と言えば倍精度浮動小数点型を意味することにする．

#keyword[論理型]は論理値 $haskell.True$ または $haskell.False$ のいずれかしか値をとれない型である．論理型のことを $haskell.Bool$と書く．#footnote[Haskellではブール型を `Bool` と書く．]

#keyword[文字型]を $haskell.Char$ と書く．#footnote[HaskellではUnicode文字型を `Char` と書く．]

変数 $x$ の型が $haskell.Int$のとき，以下のように#keyword[型注釈]を書く．#footnote[Haskellでは `x :: Int` と書く．]
$ x colon.double haskell.Int $

1引数関数の型は次のように注釈できる．#footnote[Haskellでは `f :: Int -> Int` と書く．]
$ f colon.double haskell.Int -> haskell.Int $

ここで関数 $f$ は整数型の引数をひとつとり，整数型の値を返す．#footnote[正確には `->` は型コンストラクタである．無名の型引数を $lozenge.filled.medium$ で表すと `->` は $(lozenge.filled.medium -> lozenge.filled.medium)$ という，ふたつの型引数を取る型コンストラクタである．]

2引数関数の方は次のように注釈できる．#footnote[Haskellでは `f :: Int -> Int -> Int` と書く．]
$ f colon.double haskell.Int -> haskell.Int -> haskell.Int $

ここで関数 $f$ は整数型の引数をふたつとり，整数型の値を返す．型 $haskell.Int -> haskell.Int -> haskell.Int$ は $haskell.Int -> (haskell.Int -> haskell.Int)$ と解釈される．

$(haskell.Int -> haskell.Int)$ 型の関数を受け取り $(haskell.Int -> haskell.Int)$ 型の関数を返す関数は次の型を持つ．#footnote[Haskellでは `f :: (Int -> Int) -> (Int -> Int)` と書く．]
$ f colon.double (haskell.Int -> haskell.Int) -> (haskell.Int -> haskell.Int) $

なお後半の括弧は省略可能なので次のように書いても良い．
$ f colon.double (haskell.Int -> haskell.Int) -> haskell.Int -> haskell.Int $

Haskellではすべての変数，関数に型があり，型はコンパイル時に決定されていなければならない．ただし，式から#keyword[型推論]が行える場合は型注釈を省略できる．

== 条件

#keyword[条件分岐]は次のように書く．#footnote[Haskell では `z = if x > 0 then x else (-x)` と書く．]
$ z = haskell.kwif x > 0 haskell.kwthen x haskell.kwelse (-x) $

$ f = haskell.kwcase x haskell.kwof cases(1 --> 1, dash.wave.double --> 0) $
この場合 $x equiv 1$ ならば $f$ は $1$ を，そうでなければ $f$ は $0$ を返す．ここに $dash.wave.double$ はすべてのパターンに一致する記号である．パターンマッチは上から順に行われる．条件分岐の代わりに以下のような#keyword[パターンマッチ]も使える．#footnote[Haskellでは以下のように書くのが一般的である．
```haskell
      f = case x of 1 -> 1
                    _ -> 0
```]

// https://haskell-tech.nkhn37.net/haskell-function-pattern-match/

関数定義にもパターンマッチを使える．#footnote[Haskellでは次のように書く．
```haskell
      f 1 = 1
      f _ = 0
```]
$ f 1 &= 1\
  f dash.wave.double &= 0 $

関数定義には次のように#keyword[ガード]と呼ばれる条件を付与することができる．#footnote[Haskellでは次のように書く．
```haskell
      f x | x > 0     = x
          | otherwise = (-x)
```]
$ f x &bar.v_(x > 0) = x\
    &bar.v_haskell.otherwise = (-x) $
ここに $haskell.otherwise$ は $haskell.True$ の別名である．

ガードは上から順にマッチされる．

== 関数の再帰呼び出し

関数は再帰的に呼び出せる．$n>=0$ を前提とすると，$n$ 番目のフィボナッチ数を計算する関数 $"fib"$ を次のように定義できる．#footnote[Haskellでは次のように書く．ただしHaskellには符号なし整数型がないために `n` が正であることを別に担保する必要がある．またこのコードは無駄な再帰呼び出しを行っており実用的ではない．
```haskell
      fib 0 = 0
      fib 1 = 1
      fib n = fib (n-1) + fib (n-2)
```]
$ "fib" 0 &= 0\
  "fib" 1 &= 1\
  "fib" n &= "fib" (n-1) + "fib" (n-2) $

== タプル

複数の変数をまとめてひとつの#keyword[タプル]にすることができる．例を挙げる．#footnote[Haskellでは `z = (x, y)` と書く．]
$ z = (x, y) $

タプルの型は，要素の型をタプルにしたものである．例えば $haskell.Int$ が2個からなるタプルの型は次のようになる．#footnote[Haskellでは `z :: (Int, Int)` と書く．]
$ z colon.double (haskell.Int, haskell.Int) $

要素を含まないタプルを#keyword[ユニット]と呼ぶ．ユニットは次のように書く．#footnote[Haskellでは `z = ()` と書く．]
$ z = () $

ユニットの型は#keyword[ユニット型]で，型注釈を次のように書く．#footnote[Haskellでは `z :: ()` と書く．]
$ z colon.double haskell.Unit $

= リスト

== リスト

任意の型について，その型の要素を並べた列を#keyword[リスト]と呼ぶ．

ある変数がリストであるとき，その変数がリストであることを忘れないように $haskell.list(x)$ と小さく $"s"$ を付けることにする．

#keyword[空リスト]は次のように定義する．#footnote[Haskellでは `xs = []` と書く．]
$ haskell.list(x) = emptyset $

任意のリストは次のように#keyword[リスト構築演算子] $:$ を用いて構成する．
$ haskell.list(x) = x_0:x_1:x_2:...:emptyset $

リストの型はその構成要素の型をブラケットで包んで表現する．#footnote[Haskell では `xs :: [Int]` と書く．]
$ haskell.list(x) colon.double [haskell.Int] $

リストは次のように構成することもできる．#footnote[Haskellでは `xs = [1, 2..100]` と書く．ピリオドの数に注意しよう．]
$ haskell.list(x) = [1, 2...100] $

なお次のような#keyword[無限リスト]を構成しても良い．#footnote[Haskellでは `xs = [1, 2..]` と書く．]
$ haskell.list(x) = [1, 2...] $

リストとリストをつなぐ場合は#keyword[リスト結合演算子] $smash$ を用いる．#footnote[Haskellでは `zs = xs ++ ys` と書く．]
$ haskell.list(z) = haskell.list(x) smash haskell.list(y) $

関数はリストを受け取ることができる．次の書き方では，関数 $f$ は整数リストの最初の要素 $x$ と残りの要素 $haskell.list(x)$ を別々に受け取り，先頭要素だけを返す．
$ &f colon.double [haskell.Int] -> haskell.Int\
  &f (x : haskell.list(x)) = x $<list-head>

ただし，引数のリストが空リストである可能性を考慮して，@list-head は次のように書き直すべきである．
$ &f colon.double [haskell.Int] -> haskell.Int\
  &f emptyset = 0\
  &f (x : haskell.list(x)) = x $

$f emptyset$ が $0$ を返すのは不自然だが，関数$f$の戻り型を整数型としているためこれは仕方がない．エラーを考慮する場合は@maybe で述べるMaybeを使う必要がある．

== 内包表記

== 文字列

== マップと畳み込み

== IOサバイバルキット2

= 関手とモナド

== Maybe
<maybe>

== Maybeに対する計算

== Maybeの中のリスト

== 型パラメタと型クラス

== 関手

== 関手としての関数

= アプリカティブ関手

== アプリカティブ関手

== モナド

/* 

\tobewritten{headは非推奨}

\tobewritten{リスト先頭2要素の和}

リストのリストは次のように構成できる．
\begin{equation}
\mathListList{z}=[[1,2],[3,4]]
\end{equation}

\tobewritten{線形リストであることとvectorの話し．}

\section{内包表記}

リストの構成には#keyword[内包表記}が使える．例を挙げる．#footnote[Haskell では次のように書く．
\begin{footcode}
      xs = [x^2 | x <- [1, 2..100], x>50]
\end{footcode}}
\begin{equation}
\mathList{x}=\mathMakeListComplehention{x^2}{x\mathIn\mathMakeList{1,2\dots100},\mathEven x}
\end{equation}
関数$\mathEven$は引数が偶数の場合にだけ$\mathTrue$を返す関数である．この例では数列$\mathMakeList{1,2\dots100}$のうち偶数だけを2乗したリストを作っている．

\tobewritten{内包表記のlet文．}

\section{文字列}

文字型のリストを文字列型と呼び$\mathTypeString$で表す．$\mathTypeString$型は次のように予約語$\mathKeyword{type}$を用いて，#keyword[型シノニム}すなわち型の別名として次のように定義される．
\begin{equation}
\mathTypeSynonim{\mathTypeString}{\mathTypeList{\mathTypeChar}}
\end{equation}

文字列型のリテラルは次のように書く．#footnote[Haskell では `xs = "Hello, World!"| と書く．}
\begin{equation}
\mathString{x}=\mathLiteralString{Hello, World!}
\end{equation}

\tobewritten{Stringに関する有名な関数．}

リストに対するすべての演算は文字列にも適用可能である．

\section{マップと畳み込み}

リスト$\mathList{x}$の各要素に関数$f$を適用して，その結果をリスト$\mathList{z}$に格納するためには次のように#keyword[マップ演算子}$\mathMap$を用いる．#footnote[Haskell では `zs = f `map` xs| と書く．}
\begin{equation}
\mathList{z}=f\mathMap\mathList{x}
\label{eq:map}
\end{equation}
式\eqref{eq:map}は次の式と同じである．#footnote[Haskell では \verb/zs = [f x | x <- xs]/ と書く．}
\begin{equation}
\mathList{z}=\mathMakeListComplehention{fx}{x\mathIn\mathList{x}}
\end{equation}

リスト$\mathList{x}$の各要素を先頭から順番に二項演算子を適用して，その結果を得るには畳み込み演算子を用いる．たとえば整数リストの和は次のように書ける．#footnote[Haskell では `z = foldl 0 (+) xs| と書く．}
\begin{equation}
z=\mathFold{0}{(\mathAnonymousParameter+\mathAnonymousParameter)}\mathList{x}
\end{equation}
Haskell では
\begin{equation}
\mathSum=\mathFold{0}{(\mathAnonymousParameter+\mathAnonymousParameter)}
\end{equation}
として関数$\mathSum$が定義されている．#footnote[Haskell では関数$\mathSum$を `sum| と書く．}

リスト$\mathList{x}$が$\mathList{x}=[x_0,x_1,\dots,x_n]$のとき，一般に
\begin{equation}
\mathFold{a}{\mathAnonymousParameter\mathAnonymousOperator\mathAnonymousParameter}{\mathList{x}}
=a\mathAnonymousOperator x_0\mathAnonymousOperator x_1\dots x_{n-1}\mathAnonymousOperator x_n
\end{equation}
である．ここに$\mathAnonymousOperator$は任意の二項演算子である．

畳み込み演算子には次の右結合バージョンが存在する．#footnote[Haskell では `foldr| を用いる．}
\begin{equation}
\mathFoldRight{a}{\mathAnonymousParameter\mathAnonymousOperator\mathAnonymousParameter}{\mathList{x}}
=a\mathAnonymousOperator\left(x_0\dots\left(x_{n-2}\mathAnonymousOperator\left(x_{n-1}\mathAnonymousOperator x_n\right)\right)\right)
\end{equation}

\section{IOサバイバルキット2}

1行ごとに3次元ベクトルが並べられた，以下の入力ファイルがあるとする．
\begin{sourcecode}{input.txt}
\begin{verbatim}
1.0 2.0 3.0
4.5 5.5 6.5
\end{verbatim}
\end{sourcecode}
このようなファイル形式は計算機科学者にとって見慣れたものである．

各行つまり各ベクトルごとに，そのノルムを計算して出力するプログラムを書きたいとしよう．まず数列を受け取ってそのノルムを返す関数$\mathNorm$を次のように定義する．#footnote[Haskell では次のように書く．
\begin{footcode}
      norm :: [Double] -> Double
      norm [] = 0.0
      norm xs = sqrt (sum [x * x | x <- xs])
\end{footcode}}
\begin{gather}
  \mathNorm\mathTypeIs\mathTypeFunction{\mathTypeList{\mathTypeDouble}}{\mathTypeDouble}\\
  \left\{
  \begin{aligned}
    \mathNorm\mathEmptyList&=0.0\\
    \mathNorm\mathList{x}&=\mathSqrt\left(\mathSum\mathMakeListComplehention{x*x}{x\mathIn\mathList{x}}\right)
  \end{aligned}
  \right.
\end{gather}

入力ファイル全体を受け取るにはアクション$\textsl{getContents}$を用いる．入力ファイルを1行毎のリストにするには関数$\textrm{lines}$を用いる．各行を空白で区切ってリストに格納するには関数$\mathWords$を用いる．

各文字列を数に変換するには次の関数$\mathReadDouble\mathTypeIs\mathTypeFunction{\mathTypeString}{\mathTypeDouble}$を用いる．#footnote[Haskell では次のように書く．
\begin{footcode}
      readDouble :: String -> Double
      readDouble = read
\end{footcode}}
\begin{align}
  \mathReadDouble&\mathTypeIs\mathTypeFunction{\mathTypeString}{\mathTypeDouble}\\
  \mathReadDouble&=\mathRead
\end{align}
関数$\mathReadDouble$は標準関数$\mathRead$に型注釈を付けたものである．

入力ファイルの各行に書かれたベクトルを対象に関数$\mathNorm$を適用して，結果を書き出すには次のように書く．#footnote[Haskell では次のように書く．
\begin{footcode}
      main = print 
        . (norm <$>) 
        . ((readDouble <$>) <$>) 
        . (words <$>) 
        . lines 
        =<< getContents
\end{footcode}}
\begin{multline}
\mathMain=\mathPrint
\mathCompose(\mathNorm\mathMap)
\mathCompose((\mathReadDouble\mathMap)\mathMap)\\
\mathCompose(\mathWords\mathMap)
\mathCompose\mathLines
\mathBind\mathGetContents
\end{multline}

アクション$\mathPrint$に代えて次の$\mathPrintEach$を用いると，入力と出力を同じ形式にできる．#footnote[Haskell では `printEach xs = print `mapM` xs| と書く．}
\begin{equation}
\mathPrintEach\mathList{x}=\mathPrint\mathMapM\mathList{x}
\end{equation}
演算子$\mathMapM$はアクション版のマップ演算子である．

\chapter{関手とモナド}

\section{Maybe}
\label{sec:maybe}

計算は失敗する可能性がある．たとえば
\begin{equation}
z=y/x
\end{equation}
のときに$x\mathCompareEq0$であったとしたら，この計算は失敗する．プログラムが計算を失敗した場合，たいていのプログラマは大域ジャンプを試みる．しかし大域ジャンプは変数の書き換えを行うことであるから，別の方法が望まれる．Haskell では失敗する可能性がある場合にはMaybeという機構が使える．

いま関数$f$が引数$x$と$y$を取り，$x\neq0$であるならば$y/x$を返すとする．もし$x\mathCompareEq0$であれば失敗を意味する$\mathNothing$（ナッシング）を返すとする．すると関数$f$の定義は次のようになる．
\begin{equation}
fxy=\mathIf{x\neq0}{y/x}{\mathNothing}\incomplete
\end{equation}
残念ながら上式は不完全である．なぜならば$x\neq0$のときの戻り値は数であるのに対して，$x\mathCompareEq0$のときの戻り値は数ではないからである．そこで
\begin{equation}
\mathMonadic{f}xy=\mathIf{x\neq0}{\mathMakeJust{y/x}}{\mathNothing}
\end{equation}
とする．ここに$\mathMakeJust{y/x}$は数$y/x$から作られる，Maybeで包まれた数である．#footnote[Haskell では `f x y = if x /= 0 then Just y/x else Nothing| と書く．}
% ~fの理由．

整数型$\mathTypeInt$をMaybeで包む場合は$\mathTypeMaybe{\mathTypeInt}$と書く．Maybeで包まれた型を持つ変数は$\mathMaybe{x}$のように小さく$?$をつける．例を挙げる．#footnote[Haskell では `xm :: Maybe Int| と書く．}
\begin{equation}
\mathMaybe{x}\mathTypeIs\mathTypeMaybe{\mathTypeInt}
\end{equation}

Maybeで包まれた型を持つ変数は，値を持つか$\mathNothing$（ナッシング）であるかのいずれかである．値をもつ場合は
\begin{equation}
\mathMaybe{x}=\mathMakeJust{1}
\end{equation}
のように書く．#footnote[Haskell では `xm = Just 1| と書く．}

Maybe変数が値を持たない場合は
\begin{equation}
\mathMaybe{x}=\mathNothing
\end{equation}
と書く．#footnote[Haskell では `xm = Nothing| と書く．}

一度Maybeになった変数を非Maybeに戻すことは出来ない．

\section{Maybeに対する計算}

Maybe変数に，非Maybe変数を受け取る関数を適用することは出来ない．そこで特別な演算子$\mathFMap$を用いて，次のように計算する．#footnote[Haskell では `zm = (+1) <$> xm| と書く．}
\begin{equation}
\mathMaybe{z}=f\mathFMap\mathMaybe{x}
\end{equation}
ここに関数$f$は1引数関数で，演算子$\mathFMap$は
\begin{align}
\mathMakeJust{fx}&=f\mathFMap\mathMakeJust{x}\\
\mathNothing&=f\mathFMap\mathNothing
\end{align}
と定義される．

\tobewritten{Bindもここへ．}

Returning \emph{List}.
\begin{equation}
	.
\end{equation}
Returning \emph{Maybe}:#footnote[In Haskell, `f :: Int -> Maybe Int| and `f x = Just x|.}
\begin{gather}
f\mathTypeIs\mathTypeFunction{\mathTypeInt}{\mathTypeMaybe{\mathTypeInt}}\\
fx=\mathMakeJust{x}
\end{gather}
% Applicative.
Returning \emph{monad}:
\begin{gather}
f\mathTypeIs
  \mathTypeFunction{\mathTypeInt}{\mathFunctorTypeGeneral{\mathClassGeneral{m}}{\mathTypeA}}\\
fx=\mathMakeReturn{x}
\end{gather}


Returning monadic value:#footnote[In Haskell, `f :: Monad m => a -> m a|.}
\begin{equation}
f\mathTypeIs
  \mathTypeClass{\mathClassMonad}
    {\mathClassGeneral{m}}
    {\mathTypeFunction{\mathTypeA}{\mathFunctorTypeGeneral{\mathClassGeneral{m}}{\mathTypeA}}}
\end{equation}

Monadic function binding:#footnote[In Haskell, `zm = xm >>= f1 >>= f2|.}
\begin{equation}
\mathPure{z}=\mathPure{x}\mathBindRight f_1\mathBindRight f_2
\end{equation}
where
\begin{align}
f_1&\mathTypeIs\mathTypeFunction{\mathTypeInt}{\mathTypeMaybe{\mathTypeInt}}\\
f_2&\mathTypeIs\mathTypeFunction{\mathTypeInt}{\mathTypeMaybe{\mathTypeInt}}.
\end{align}

Function binding of monadic function and non-monadic function:#footnote[In Haskell,
\begin{footcode}
zm = xm >>= f >>= g'
  where g' w = pure (g w)
\end{footcode}}
\begin{equation}
\mathPure{z}=\mathPure{x}\mathBindRight f\mathBindRight g'
\mathWhere{g'w=\mathMakePure{gw}}
\end{equation}
or
\begin{equation}
  \mathPure{z}=\mathPure{x}\mathBindRight(f\mathComposeMonadRight g')
  \mathWhere{g'w=\mathMakePure{gw}}
\end{equation}
where
\begin{align}
f&\mathTypeIs\mathTypeFunction{\mathTypeInt}{\mathTypeMaybe{\mathTypeInt}}\\
g&\mathTypeIs\mathTypeFunction{\mathTypeInt}{\mathTypeInt}.
\end{align}
Another solution is:
\begin{equation}
\mathPure{z}=(\mathLiftM{g}\mathCompose f)\mathBind\mathPure{x}
\end{equation}
where $\mathLiftM{g}$ means `liftM g| in Haskell.#footnote[In Haskell, `zm = (liftM g . f) xm|.}

\section{Maybeの中のリスト}

リストがMaybeの中に入っている場合は，リストの各要素に関数を適用することができる．例を挙げる．
\begin{equation}
\mathMaybe{x}=\mathMakeJust{[1,2,\dots,100]}
\end{equation}
のとき，リストの各要素に関数$f\mathTypeIs\mathTypeFunction{\mathTypeInt}{\mathTypeInt}$を適用するには次のように書く．#footnote[Haskell では `zm = (f <$>) <$> xm| と書く．最初の `<$>| はリストの各要素に関数$f$を適用する演算子，2番目の `<$>| はMaybeの中のリストの各要素に関数$f$を適用する演算子である．}
\begin{equation}
\mathMaybe{z}=(f\mathMap)\mathFMap\mathMaybe{x}
\end{equation}

\section{型パラメタと型クラス}

型をパラメタとして扱うことができる．任意の型を$\mathTypeA$と，ボールド体小文字で書く．ある型$\mathTypeA$の引数を取り，同じ型を返す関数の型は次のように書ける．#footnote[Haskell では `f :: a -> a| と書く．}
\begin{equation}
f\mathTypeIs\mathTypeFunctionAA
\end{equation}

#keyword[型パラメタ}には制約をつけることができる．型の集合を#keyword[型クラス}と呼び，フラクチュール体で書く．たとえば数を表す型クラスは$\mathClassNum$である．型パラメタ$\mathTypeA$が型クラス$\mathClassNum$に属するとき，上述の関数$f$の型注釈は次のようになる．#footnote[Haskell では `f :: Num a => a -> a| と書く．}
\begin{equation}
f\mathTypeIs
  \mathTypeClass{\mathClassNum}
    {\mathTypeA}
    {\mathTypeFunctionAA}
\end{equation}
ここに$\mathClassNum$型クラスには，整数型$\mathTypeInt$，浮動小数点型$\mathTypeDouble$が含まれる一方，論理型$\mathTypeBool$は含まれない．% ほか...

\tobewritten{型の条件}

型クラスは型に制約を与える．

\tobewritten{\texttt{Num a => x :: a} ならば\texttt{x}が持つべき演算子．}

\tobewritten{型クラスの例．}

\section{関手}

型$\mathTypeA$のリストの変数は
\begin{equation}
\mathList{x}\mathTypeIs\mathTypeList{\mathTypeA}
\end{equation}
という型注釈を持つ．これは
\begin{equation}
\mathList{x}\mathTypeIs\mathFunctorTypeGeneral{[]}{\mathTypeA}
\end{equation}
のシンタックスシュガーである．#footnote[Haskell では `xs :: [] a| と書く．}

型$\mathTypeA$のMaybeの変数は
\begin{equation}
\mathMaybe{x}\mathTypeIs\mathTypeMaybe{\mathTypeA}
\end{equation}
という型注釈を持つ．

普段遣いの関数
\begin{equation}
f\mathTypeIs\mathTypeFunctionAA
\end{equation}
をリスト変数$\mathList{x}$に適用する場合は
\begin{equation}
\mathList{z}=f\mathMap\mathList{x}
\end{equation}
とする．同じく関数$f$をMaybe変数$\mathMaybe{x}$に適用する場合は
\begin{equation}
\mathMaybe{z}=f\mathFMap\mathMaybe{x}
\end{equation}
とする．

リストもMaybeも元の型$\mathTypeA$から派生しており，関数適用のための特別な演算子を持つことになる．そこで，リストやMaybeは#keyword[関手}という型クラスに属する，型パラメタを伴う型であるとする．関手の型クラスを$\mathClassFunctor$で表す．関手型クラスの$\mathTypeA$型の変数を次のように型注釈する．#footnote[Haskell では `xm :: Functor f => f a| と書く．}
\begin{equation}
\mathPure{x}\mathTypeIs
  \mathTypeClass{\mathClassFunctor}
    {\mathClassF}
    {\mathFunctorTypeGeneral{\mathClassF}{\mathTypeA}}
\end{equation}

型クラス$\mathClassFunctor$に属する型は$\mathFMap$演算子を必ず持つ．演算子$\mathFMap$は次の形を持つ．#footnote[Haskell では `zm = f <$> xm| と書く．}
\begin{equation}
\mathPure{z}=f\mathFMap\mathPure{x}
\end{equation}
演算子$\mathFMap$の型は次のとおりである．
\begin{equation}
\mathAnonymousParameter\mathFMap\mathAnonymousParameter
  \mathTypeIs
    \mathTypeClass{\mathClassFunctor}{\mathClassGeneral{f}}{%
    \mathTypeFunctionII{\left(\mathTypeFunctionAB\right)}
    {\mathFunctorTypeGeneral{\mathClassF}{\mathTypeA}}
    {\mathFunctorTypeGeneral{\mathClassF}{\mathTypeB}}%
    }
\end{equation}

もし変数$\mathPure{x}$の型がリストであれば
\begin{equation}
\mathFMap=\mathMap
\end{equation}
であると解釈する．

\section{関手としての関数}

\tobewritten{移動する．}

\begin{equation}
f\mathTypeIs\mathTypeFunction{\mathTypeGeneral{q}}{\mathTypeGeneral{r}}
\end{equation}

Function as a functor:#footnote[In Haskell, `f :: ((->) r) q|.}
\begin{equation}
f\mathTypeIs\left(\mathTypeFunction{\mathAnonymousTypeParameter}{\mathTypeGeneral{r}}\right)\mathTypeGeneral{q}
=\mathFunctorTypeGeneral{\left(\mathTypeFunction{\mathAnonymousTypeParameter}{\mathTypeGeneral{r}}\right)}
  {\mathTypeGeneral{q}}
\end{equation}

Thus,
\begin{equation}
f_2\mathCompose f_1\equiv f_2\mathFMap f_1
\end{equation}

\begin{align}
\mathId\mathCompose f&=\mathId f=f\\
(h\mathCompose g)\mathCompose f&=((h\mathCompose)\mathCompose(g\mathCompose))f\\
&=h\mathCompose(g\mathCompose f)
\end{align}

\chapter{アプリカティブ関手}

\section{アプリカティブ関手}

演算子$\mathFMap$は関手型クラスの型の値に1引数関数を適用することを可能にした．一方で2引数関数を適用するのは若干面倒である．いま関数$f$が2引数をとるとし，関手型クラスの型の変数$\mathPure{x}$と$\mathPure{y}$があるとする．関数$f$に変数$\mathPure{x}$を部分適用して関数$f'$すなわち
\begin{equation}
f'=f\mathFMap\mathPure{x}
\end{equation}
を作ると，定義によって関数$f'$は関手型クラスの型の変数になる．そこで，関手型クラスの型の関数を関手型クラスの型の変数に適用する新しい演算子が必要になる．このような演算子を#keyword[アプリカティブマップ演算子}と呼び$\mathApplicativeMap$で表す．アプリカティブマップ演算子を用いると
\begin{align}
\mathPure{z}&=f'\mathApplicativeMap\mathPure{y}\\
&=f\mathFMap\mathPure{x}\mathApplicativeMap\mathPure{y}
\label{eq:fmap-and-amap}
\end{align}
と書ける．

任意の変数または関数を関手型クラスの型に入れる#keyword[ピュア演算子}があり，次のように書く．#footnote[Haskell では `zm = pure x| と書く．}
\begin{equation}
\mathPure{z}=\mathMakePure{x}
\end{equation}
なおピュア演算子の名称は「純粋(pure)」であるが，意味合いはむしろ「不純(impure)」のほうが近い．

ピュア演算子を用いると，式\eqref{eq:fmap-and-amap}は
\begin{equation}
\mathPure{z}=\mathMakePure{f}\mathApplicativeMap\mathPure{x}\mathApplicativeMap\mathPure{y}
\label{eq:applicative-style}
\end{equation}
と書ける．#footnote[Haskell では `zm = (pure f) <*> xm <*> ym| と書く．}

式\eqref{eq:applicative-style}はかつて
\begin{equation}
\mathPure{z}=\mathApplicativeFuncCall{f\,\mathPure{x}\,\mathPure{y}}
\end{equation}
のように書くことも提案されたが，普及はしなかった．#footnote[現在のHaskell では `zm = liftA2 f xm ym| と書くことで代用されている．元の提案は \verb/zm = [|f xm ym|]/ であった．}

ピュア演算子とアプリカティブマップ演算子を必ず持つ関手のことを#keyword[アプリカティブ関手}と呼び$\mathClassApplicative$で表す．

いま関数$f\mathTypeIs\mathTypeFunctionAB$に対して，新たな関数$\mathPure{f}$ただし
\begin{equation}
\mathPure{f}=\mathMakePure{f}
\end{equation}
を作ったとすると，関数$\mathPure{f}$は
\begin{equation}
  \mathPure{f}\mathTypeIs
  \mathTypeClass{\mathClassApplicative}
    {\mathClassF}
    {\mathFunctorTypeGeneral{\mathClassF}}
    {\mathTypeFunctionAB}
\end{equation}
という型を持つ．アプリカティブマップ演算子は変数
\begin{equation}
\mathPure{x}\mathTypeIs\mathTypeClass{\mathClassApplicative}{\mathClassF}{\mathFunctorTypeGeneral{\mathClassF}}{\mathTypeA}
\end{equation}
に対して，関数$\mathPure{f}$を
\begin{equation}
\mathPure{z}=\mathPure{f}\mathApplicativeMap\mathPure{x}
\end{equation}
のように作用させる．変数$\mathPure{z}$の型は
\begin{equation}
  \mathPure{z}\mathTypeIs\mathTypeClass{\mathClassApplicative}{\mathClassF}{\mathFunctorTypeGeneral{\mathClassF}}{\mathTypeB}
\end{equation}
である．



\section{モナド}


\section{種}

\begin{equation}
\mathTypeFunction{\mathAnyKind}{\mathAnyKind}
\end{equation}

\section{Data}

Data:#footnote[In Haskell,
\begin{footcode}
data Suit = Spade | Heart | Club | Diamond
\end{footcode}}
\begin{equation}
\mathData{\mathTypeGeneral{Suit}}
  {\mathConstructor{Spade}\mathOr\mathConstructor{Heart}\mathOr\mathConstructor{Club}\mathOr\mathConstructor{Diamond}}
\end{equation}

Data with parameters:#footnote[In Haskell,
\begin{footcode}
data V2 = V2 { x :: Int, y :: Int}
\end{footcode}
or `data V2 = V2 Int Int|.}
\begin{equation}
\mathData{\mathTypeGeneral{V^2}}
  {\mathConstructor{V^2}\left\{x\mathTypeIs\mathTypeInt,y\mathTypeIs\mathTypeInt\right\}}
\end{equation}

\section{型クラスとインスタンス}

\section{IOモナド}

IO example:#footnote[In Haskell, `main = getLine >>= print >> return 0|.}
\begin{equation}
\mathMain=\mathGetLine\mathBindRight\mathPrint\mathNext\mathMakeReturn{0}
\end{equation}

\section{Do構文}

Do notation:#footnote[In Haskell, `z = do {x' <- x; y' <- y; f x'; g y'}|.}
\begin{equation}
\mathPure{z}=\mathDo{x'\leftarrow\mathPure{x};y'\leftarrow\mathPure{y};fx';gy'}
\end{equation}

\dbend

\section{モノイド}

任意の関数$f$に対して
\begin{equation}
\mathId f=f
\end{equation}
なる関数$\mathId$があり，かつ任意の関数$f,g,h$に対して
\begin{equation}
(h\mathCompose g)\mathCompose f=h\mathCompose(g\mathCompose f)
\end{equation}
が成り立つとする．このとき関数は#keyword[モノイド}であるという．

\tobewritten{一般のモノイド．}

\section{モノイド則}
型$\mathTypeA$の変数$x,y,z\mathTypeIs\mathTypeA$について，特別な変数$\mathIdentity\mathTypeIs\mathTypeA$および二項演算子$\mathAnyBinaryOperator$ただし$x\mathAnyBinaryOperator y\mathTypeIs\mathTypeA$があり，
\begin{align}
\mathIdentity\mathAnyBinaryOperator x&=x\dots\text{（単位元の存在）}\\
(x\mathAnyBinaryOperator y)\mathAnyBinaryOperator z&=x\mathAnyBinaryOperator(y\mathAnyBinaryOperator z)\dots\text{（結合律）}
\end{align}
であるとき，組み合わせ$(\mathTypeA,\mathAnyBinaryOperator,\mathIdentity)$をモノイドと呼ぶ．

組み合わせ$(\mathTypeInt,+,0)$や$(\mathTypeInt,\times,1)$はモノイドである．

同じ型から同じ型への1引数関数を改めて$\mathTypeFunctionAA$で表し，特別な変数$\mathIdentity$を関数$\mathId$，二項演算子を$\mathCompose$とすると以下の関係が成り立つ．
\begin{align}
\mathId\mathCompose f&=f\dots\text{（単位元の存在）}\\
(h\mathCompose g)\mathCompose f&=h\mathCompose(g\mathCompose f)\dots\text{（結合律）}
\end{align}
そこで組み合わせ$(\mathTypeFunctionAA,\mathCompose,\mathId)$はモノイドであると言える．

\section{関手則}

関手のマップ演算子$\mathFMap$は以下の#keyword[関手則}に従う．
\begin{align}
\mathId\mathFMap\mathPure{x}&=\mathId\mathPure{x}\\
(g\mathCompose f)\mathFMap\mathPure{x}&=((g\mathFMap)\mathCompose(f\mathFMap))\mathPure{x}\\
&=g\mathFMap(f\mathFMap\mathPure{x})
\end{align}

関手則は#keyword[関手（数学）}に由来する．

#keyword[圏}$\mathCategory{C}$の#keyword[対象}を$\mathObject{X}$とする．圏$\mathCategory{D}$の対象は関手（数学）$\mathFunctor{F}$によって対象$\mathObject{X}$と関係づけられる．圏$\mathCategory{C}$における#keyword[射}$f:\mathObject{X}\rightarrow\mathObject{Y}$が$\mathFunctor{F}f:\mathFunctor{F}\mathObject{X}\rightarrow\mathFunctor{F}\mathObject{Y}$に対応し，次の関係を満たす．
\begin{itemize}
\item $\mathObject{X}\in\mathCategory{C}$に対して$\mathFunctor{F}\mathId_{\mathObject{X}}=\mathId_{\mathFunctor{F}\mathObject{X}}$
\item $f:\mathObject{X}\rightarrow\mathObject{Y}$および$g:\mathObject{Y}\rightarrow\mathObject{Z}$に対して$\mathFunctor{F}(g\mathCompose f)=(\mathFunctor{F}g)\mathCompose(\mathFunctor{F}f)$
\end{itemize}

いま
\begin{align}
\mathId_{\mathObject{X}},\mathId_{\mathFunctor{F}\mathObject{X}}&\rightarrow\mathId\\
f\mathFMap&\rightarrow\mathFunctor{F}f
\end{align}
と対応付けると，関手（数学）が満たす法則と関手則は一致する．

\section{アプリカティブ関手則}

アプリカティブ関手のマップ演算子$\mathApplicativeMap$は以下の規則に従う．
\begin{align}
\mathMakePure{\mathId}\mathApplicativeMap\mathPure{x}&=\mathPure{x}\\
\mathMakePure{f}\mathApplicativeMap\mathMakePure{x}&=\mathMakePure{fx}\\
\mathPure{f}\mathApplicativeMap\mathMakePure{x}&=\mathMakePure{\mathAnonymousParameter\mathApply x}\mathApplicativeMap\mathPure{f}\\
\mathMakePure{\mathAnonymousParameter\mathCompose\mathAnonymousParameter}\mathApplicativeMap\mathPure{h}\mathApplicativeMap\mathPure{g}\mathApplicativeMap\mathPure{f}
&=\mathPure{h}\mathApplicativeMap(\mathPure{g}\mathApplicativeMap\mathPure{f})
\end{align}

\section{モナド則}

モナドのマップ演算子$\mathBind$は以下の規則に従う．
\begin{align}
\mathMonadic{f}\mathBind\mathMakeReturn{x}&=\mathMonadic{f}x\\
\mathMakeReturn{\mathAnonymousParameter}\mathBind\mathPure{x}&=\mathPure{x}\\
(\mathMonadic{g}\mathBind\mathMonadic{f})\mathBind\mathPure{x}&=\mathMonadic{g}\mathBind(\mathMonadic{f}\mathBind\mathPure{x})
\end{align}
% つまり，組み合わせ$(\mathTypeFunction{\mathTypeA}{\mathFunctorTypeGeneral{\mathTypeGeneral{m}}{\mathTypeA}},\mathMakePure{\mathAnonymousParameter},\mathBind)$はモノイドである． -- bindの両辺の型が一致しないのでモノイドではない．

次の#keyword[クライスリスター}すなわち
\begin{equation}
\mathKleisliStar{f}=(\mathMonadic{f}\mathBind\mathAnonymousParameter)
\end{equation}
を用いると，モナド則は次のように書き換えられる．
\begin{align}
\left(\mathKleisliStar{f}\right)\mathMakePure{x}&=\mathMonadic{f}x\\
\mathKleisliStar{\left(\mathMakePure{\mathAnonymousParameter}\right)}\mathPure{x}&=\mathPure{x}\\
\mathKleisliStar{\left(\mathKleisliStar{g}\mathMonadic{f}\right)}\mathPure{x}&=\mathKleisliStar{g}\left(\mathKleisliStar{f}\mathPure{x}\right)
\end{align}

% \begin{tikzpicture}[nodes = {text depth = 1ex, text height = 2ex}]
%   \graph{ tex -> dvi -> ps -> pdf,
%   bib -> bbl,
%   bbl -> dvi};
% \end{tikzpicture}

\section{クラスの定義}

アプリカティブ関手は関手の拡張である．

% class Functor f => Applicative f where
% pure :: a -> f a
% (<*>) :: f (a -> b) -> f a -> f b

\begin{gather}
  \mathClass{\mathClassFunctor}{\mathClassF}{\mathClassApplicative}{\mathClassF}\\
  \begin{aligned}
    \mathMakePure{\mathAnonymousParameter}
    &\mathTypeIs\mathTypeFunction{\mathTypeA}{\mathFunctorTypeGeneral{\mathClassF}{\mathTypeA}}\\
    \mathAnonymousParameter\mathApplicativeMap\mathAnonymousParameter
    &\mathTypeIs\mathTypeFunctionII{\mathFunctorTypeGeneral{\mathClassF}{\mathTypeFunctionAB}}{\mathFunctorTypeGeneral{\mathClassF}{\mathTypeA}}{\mathFunctorTypeGeneral{\mathClassF}{\mathTypeB}}
  \end{aligned}
\end{gather}

*/

#pagebreak()

= Test Part

== Function application
$ z = f x $

#sourcecode[```haskell
z = f x
```]

== List map
$ haskell.list(z) = f * haskell.list(x) $

#sourcecode[```Haskell
zs = map f xs
```]
or
#sourcecode[```Haskell
zs = f `map` xs
```]

== Maybe map
$ haskell.maybe(z) = f haskell.fmap haskell.maybe(x) $

#sourcecode[```haskell
zm =  fmap f xm
```]
or
#sourcecode[```haskell
zm =  f <$> xm
```]

== Functor map
$ haskell.ctxt(z) = f haskell.fmap haskell.ctxt(x) $

#sourcecode[```haskell
zm = f <$> xm
```]

== Applicative map
$ haskell.ctxt(z) = haskell.ctxt(f) haskell.amap haskell.ctxt(x) $

#sourcecode[```Haskell
zm = fm <*> xm
```]

== Apllicative map 2
$ haskell.ctxt(z) = haskell.ctxt(g) haskell.amap haskell.ctxt(x) haskell.amap haskell.ctxt(y) $

#sourcecode[```haskell
zm = gm <*> xm <*> ym
```]

Or,

$ haskell.ctxt(z) = g haskell.fmap haskell.ctxt(x) haskell.amap haskell.ctxt(y) $

#sourcecode[```haskell
zm = g <$> xm <*> ym
```]

== Monadic function application
$ haskell.ctxt(z) = haskell.monadic(f) x $

#sourcecode[```Haskell
zm = f x
```]

== Bind
$ haskell.ctxt(z) = haskell.monadic(f) haskell.bind haskell.ctxt(x) $

#sourcecode[```Haskell
zm = f =<< xm
```]

== Double bind
$ haskell.ctxt(z) = haskell.monadic(g) haskell.bind haskell.monadic(f) haskell.bind haskell.ctxt(x) $

#sourcecode[```haskell
zm = g =<< f =<< xm
```]

== Contextual map
$ haskell.action("printEach") = haskell.action("print") haskell.mapM haskell.list(x) $

#sourcecode[```haskell
printEach = print `mapM` xs
```]

= Test Part 2

== Lambda

$ (backslash x |-> x + 1) y $

#sourcecode[```haskell
(\x -> x + 1) y
```]

== Operators

Scalar:
$ z &= f x $

#sourcecode[```haskell
z = f x
```]

List:
$ z_"s" = f * x_"s" $

#sourcecode[```haskell
zs = f `map` xs
```]

Maybe:
$ z_"m" = f ast.o x_"m" $

#sourcecode[```haskell
zm = f <$> xm
```]

Any functor:
$ z_* = f ast.o x_* $

#sourcecode[```haskell
z = f <$> x
```]

Applicative version:
$ z_* = shell.l f shell.r ast.square x_* $

#sourcecode[```haskell
z = f <*> x
```]

Composition.
$ h = g compose f $

#sourcecode[```haskell
h = f . g
```]

Scalar to contextual:
$ z_* = tilde(f) x $

#sourcecode[```haskell
z = f x
```]

Monadic composition.
$ tilde(h) = tilde(g) class("binary", suit.heart.stroked) tilde(f) $

#sourcecode[```haskell
h = g =<< f
```]

== Types

Scaler type.
$ x colon.double bold("Int") $

Function type.
$ f colon.double bold(a) -> bold(b) $

Functor type.
$ x_"s" &colon.double [bold("Int")]\
  x_*   &colon.double frak("Monad") supset bold(m), frak("Eq") supset bold(a) => bold(m)_bold(a)\
  f     &colon.double (bold(r) -> lozenge.filled.medium)_bold(q) $
  
型引数は添字として表現することにした．

