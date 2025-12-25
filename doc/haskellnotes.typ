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

#set document(title: [Haskell Notes by Ichi Kanaya])

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
#let keyword(x) = [#highlight(fill: rgb("#FFCC99"))[#x]]

#let uparrow = $class("binary", arrow.t)$
#let uparrow2 = $class("binary", arrow.t arrow.t)$

#import "haskell.typ"

#title()

#outline()
#pagebreak()

= 凡例

#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: center,
  table.header([*種類*], [*字体・表記法*], [*例*]),
  [変数・関数], [イタリック（1文字）], $x, f$,
  [有名な変数・関数・定数], [ローマン・小文字], $haskell.first, haskell.id, haskell.otherwise$,
  [リスト変数], [変数名にsをつける], $x_"s"$,
  [Maybe変数], [変数名に $?$ をつける], $x_?$,
  [Either変数], [変数名に $!$ をつける], $x_!$,
  [一般のコンテナ変数], [変数名に $*$ をつける], $x_*$,
  [定数値コンストラクタ], [ローマン・大文字], $haskell.True, haskell.Nothing$,
  [値コンストラクタ], [ローマン・大文字], $haskell.Just(x)$,
  [有名な定数値コンストラクタ], [数学記号], $emptyset, emptyset.rev$,
  [有名な値コンストラクタ], [特別な括弧で包む], $[x], shell.l y shell.r$,
  [アクション（文脈に入れる関数）], [ギリシア文字（1文字）], $alpha, mu$,
  [有名なアクション], [サンセリフ], $haskell.main, haskell.print$,
  [型（引数なし）], [ボールドイタリック（1文字）], $haskell.a$,
  [型（引数あり）], [ボールドイタリック（1文字）], $haskell.typename1(m, a)$,
  [有名な型（引数なし）], [ボールド・大文字], $haskell.Int$,
  [有名な型（引数あり）], [特別な括弧で包む], $[haskell.a], [haskell.Int]$,
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

== Haskellコンパイラの準備

Haskellはコンパイラ言語であり，またほとんどのOSで標準言語という位置づけでもないため，Haskellコンパイラを自身のOSにインストールする必要がある．Linux, macOS, WindowsではHaskell StackというHaskell言語環境をインストールするのが簡単である．

macOSでは，以下のようにインストールすることを推奨する．

まずHomebrewというパッケージマネージャをmacOSにインストールする．それには，コマンドシェルから次のようにする．

#sourcecode[```shell-unix-generic
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```]

Homebrewがインストールできたら，続けてHaskell Stackを次のコマンドでインストールする．

#sourcecode[```shell-unix-generic
$ brew install haskell-stack
```]

Haskell Stackで新規プロジェクトを作成する．

#sourcecode[```shell-unix-generic
$ stack new myProject
```]

自分の関数は `myProject/src/Lib.hs` に書かれている
#sourcecode[```haskell
someFunc :: IO ()
someFunc = putStrLn "someFunc"
```]
を書き換えることになる．

書き換え後は
#sourcecode[```shell-unix-generic
$ stack build
```]
でコンパイルし，
#sourcecode[```shell-unix-generic
$ stack run
```]
で実行する．

#tk


== 余談：本書の構成

#tk

== この章のまとめ

#tk

= 関数型という考え方

#tk

== 単語を数える

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
$ cat the-great-gatsby.txt | tr '[A-Z]' '[a-z]' | tr -C -d ‘[a-z ]' | tr ' ' '\n' | sort | uniq -c | sort -n -r
```]

この出力の先頭10行は，そのまま出現頻度上位10傑の単語となる．

== コマンドを関数として捉える

さて，上述の出現頻度上位単語の抽出のどこが「関数型プログラミング」の考え方だったのだろうか．

実はこんな風に考えることが出来る．入力を $x$ とする．いまの例では $x$ がファイル `the-great-gatsby.txt` である．出力を $y$ とする．ここに $y$ は出現頻度順に並んだ出現頻度と単語のリストである．我々が欲しいのは

$ y = f(x) $

となるようなプログラム $f$ だった．プログラム $f$ は簡単には手に入らないので，僕たちはUNIXコマンドの `tr` とか `sort` とか `uniq` とかをつなぎ合わせて作った．それらを「数学風」に書くと次のようになる．

$ f_1 &= "tr"_([A...Z]->[a...z])\
  f_2 &= "tr"_(overline([a...z, square])->emptyset)\
  f_3 &= "tr"_(square->arrow.bl.hook)\
  f_4 &= "sort"\
  f_5 &= "uniq"_c\
  f_6 &= "sort"_(n,r) $

そして $x$ から $y$ を得るために $y = f_6(f_5(f_4(f_3(f_2(f_1(x))))))$ という計算を行った．括弧が多すぎるので，この式を$y = f_6 compose f_5 compose f_4 compose f_3 compose f_2 compose f_1(x)$ と書き直そう．ここに演算子 $compose$ は「#keyword[関数合成演算子]」だ．

関数合成演算子を使うと，プログラム $f$ を $f = f_6 compose f_5 compose f_4 compose f_3 compose f_2 compose f_1$ と定義することも出来る．これが何を意味しているかと言うと，プログラムを小さな部分プログラムに分解したということだ．

分解したなら，合成する方法が必要になる．この例では，プログラムの各部分が他の部分に依存していないために，合成は数学的な関数合成と同じ方法が使える．

上記の例のように，数学における関数合成をそのままプログラミングに持ち込めれば，部分プログラムの合成も見通しが良いものになる．このような考え方が「関数型プログラミング」のエッセンスなのである．

== 参照透過性と入出力

#tk

== 余談：参照透過性を強くサポートするプログラミング言語

#tk

== この章のまとめ

#tk

= カリー風な書き方

本書では一般の数学書やプログラミングの教科書からは少し異なった記法を用いる．ある概念が発明されてからずっと後になって正しい記法が見つかり，それがきっかけとなって正しく理解されるという現象は歴史上よくあることである．本書でも様々な新しい記号，記法を導入するが，この章ではHaskellに近い記法から始めることにする．

== 関数

数学やプログラミミング言語には書き方に一定の決まりがある．この章ではまず「カリー風の」数式記述方式を見てみることにする．「カリー風」というのは，数学者ハスケル・カリーから名前を借りた言い方で，筆者が勝手に命名したものだ．

カリー風の書き方は数学の教科書やプログラミングの教科書で見かけるものとは若干違うが，圧倒的にシンプルでHaskellとの親和性も高く，慣れてくると非常に読みやすいものなので，本書でも全面的に採用する．

まずは#keyword[関数]から見ていくことにしよう．Pythonや一般的な数学書では引数 $x$ をとる関数 $f$ を $f(x)$ と書くが，括弧は冗長なので今後は $f x$ と書くことにする．#footnote[Haskell では関数 `f` に引数 `x` を適用させることを `f x` と書く．数学や物理学では $x$ をパラメタとする関数を $f(x)$ と書く場合もあるし，$f$ のようにパラメタを省略する場合もある．数学や物理学でパラメタを省略した場合は，$f(x_0)$ の意味で $f|_(x=x_0)$ と書くことがある．]

関数 $f$ に引数 $x$を「食わせる」ことを#keyword[関数適用]と呼ぶ．もし $f x$ と書いてあったら，それは $f$ と $x$ の積，つまり $f times x$ ではなく，従来の $f(x)$ すなわち関数 $f$ に引数 $x$ を与えているものと解釈する．高校生向けの数学書でも $sin x$ のように三角関数に限ってはカリー風に書くことになっているので，まるで馴染みがないということもないだろう．なお，関数はいつも引数の左側に書くことにする．これを「関数 $f$ が変数 $x$ の左から作用する」と言い，また関数 $f$ のことを#keyword[左作用素]とも呼ぶ．

複数引数をとる関数をPythonや一般的な数学の教科書では $g(x, y)$ と書くが，これも括弧が冗長なので今後は $g x y$ と書く．この場合式 $g x y$ は左を優先して結合する．つまり $g x y = (g x) y$ である．これは引数 $y$ に関数 $(g x)$ が左から作用していると解釈する．関数 $(g x)$ は引数 $x$ に関数 $g$ を作用させて作った関数である．引数に「飢えた」関数 $(g x)$ を#keyword[部分適用]された関数と呼ぶ．

このように式の左側を優先的に演算していくことを#keyword[左結合]と呼ぶ．Haskellの場合，関数適用はいつも左結合である．

部分適用の例を見てみよう．例えばふたつの引数のうち大きい方を返す関数 $max$ は $max x y$ として使われるが，関数適用は左結合であるから $(max x) y$ としても同じである．そこで $(max x)$ だけ取り出すと，これは「引数が $x$ よりも小さければ $x$ を，そうでなければ引数を返す関数」とみなすことができる．#footnote[Haskellでは $max x y$ を `max x y` と書く．なお関数 $(max x)$ のことを $max_x$ と書く教科書も多い．関数引数を添え字で表す記法は，本書でも後に採用する．]

== ラムダ式

関数の正体は#keyword[ラムダ式]である．ラムダ式とは，仮の引数をとり，その値をもとになにがしかの演算を行い，その結果を返す式である．ラムダ式は名前のない関数のようなものだ．それゆえ，無名関数と呼ばれることもある．

例えば引数 $x$ をとり値 $1+x$ を返すラムダ式をPythonでは
#sourcecode[```python
lambda x: 1 + x
```]
と書くが，我々はより簡潔に $backslash x |-> 1 + x$ と書くことにする．

この式は多くの書物で $lambda x class("binary", .) 1 + x$ と記述されるところである．しかし我々はすべてのギリシア文字を変数名のために予約しておきたいのと，ピリオド記号 $.$ が今後登場する二項演算子と紛らわしいため，上述の記法を用いる．#footnote[Haskellではラムダ式 $backslash x |-> 1 + x$ を ` \x -> 1 + x` と書く．ラムダ式は元々は $hat(x) class("binary", .) 1 + x$ のように書かれていた．これが次第に $hat x class("binary", .) 1 + x$ となり，$Lambda x class("binary", .) 1 + x$ そして $lambda x class("binary", .) 1 + x$ に変化していったと言われている．Haskell が $lambda$ の代わりに $backslash$ 記号を使うのは，その形が似ているからである．]

ラムダ式は関数である．ラムダ式を適用するには，ラムダ式を括弧で包む必要がある．例を挙げる．
$ (backslash x |-> 1 + x) space 2 $

この式は結果として $3$ を返す．

複数引数をとるラムダ式は例えば $backslash x y |-> x + y$ のように引数を並べて書く．

本書では新たに，次のラムダ式記法も導入する．式中に記号 $lozenge.stroked.medium$ が現れた場合，その式全体がラムダ式であるとみなす．記号 $lozenge.stroked.medium$ の部分には引数が入る．第 $n$ 番目の $lozenge.stroked.medium$ には第 $n$ 番目の引数が入る．例えばラムダ式 $backslash x y |-> x + y$ は $lozenge.stroked.medium + lozenge.stroked.medium$  と書いても良い．式を左から読んで1番目の $lozenge.stroked.medium$ が元々の $x$ すなわち第1引数を，2番目の $lozenge.stroked.medium$ が元々の $y$ すなわち第2引数を意味する．この省略記法はプログラミング言語Schemeにおける `cut` プロシジャに由来する．#footnote[Haskellでは，中置演算子に限ってこの表現が使える．例えば $(lozenge.stroked.medium + lozenge.stroked.medium)$ は単に `(+)` と表現できる．ただしSchemeにおける `cut` プロシジャの `<>` はHaskellにはないため，Schemeでいう `(cut f <> y)` に相当するコードを直接は書けない．]

== パタンマッチ・ガード・条件分岐

関数の定義は，基本的にはラムダ式の変数への代入である．引数 $x$ をとり値 $2x$ を返す関数 $f$ は $f = backslash x |-> 2 times x$ と定義できる．ただし，この省略形として $f x = 2 times x$ と書いても良い．#footnote[Haskellでは $f = backslash x |-> 2 times x$ を `f = \ x -> 2 * x` と書き，一方 $f x = 2 times x$ を `f x = 2 * x` と書く．]

関数に#keyword[スペシャルバージョン]がある場合はそれらを列挙する．例えば引数が $0$ の場合は特別に戻り値が $1$ であり，その他の場合は関数 $f$ と同じ振る舞いをする関数 $g$ を考える．このとき $g$ は以下のように定義できる．これを関数の#keyword[パタンマッチ]と呼ぶ．#footnote[Haskellでは
#sourcecode[```haskell
  g 0 = 1
  g x = 2 * x
```]
と書く．]
$ g space 0 &= 1 \
  g x &= 2 times x $

関数のパタンマッチは，関数の内部に書いても良い．関数内部にパタンマッチを書きたい場合は次のように書く．
$ g x = haskell.kwcase x haskell.kwof cases(0 --> 1,
rect.stroked.h --> frac(sin x, x, style: "skewed")) $

ここに $rect.stroked.h$ は任意の値の意味である．パタンマッチは上から順番にマッチングしていくため，この場合は $0$ 以外を意味する．#footnote[Hhaskellでは
```haskell
  g x = case x of 0 -> 1
                  _ -> (sin x) / x
```
または `g x = case x of {0 -> 1; _ -> (sin x) / x}` と書く．]

一部のプログラミング言語では#keyword[デフォルト引数]という，引数を省略できるメカニズムがあるが，我々は引数をいつも省略しないことにする．#footnote[Haskellにもデフォルト引数はない．]

関数定義にパタンマッチではなく#keyword[場合分け]が必要な場合は#keyword[ガード]を用いる．例えば引数の値が負の場合は $0$ を，$0$ の場合は $1$ を，それ以外の場合は関数 $f$ と同じ振る舞いをする関数 $h$ は以下のように定義する．#footnote[Haskellでは
```haskell
  h x | x < 0     = 0
      | x == 0    = 1
      | otherwise = f x
```
と書く．]
$ h x&|_(x < 0) = 0 \
  &|_(x equiv 0) = 1 \
  &|_haskell.otherwise = f x $

関数定義の場合分けを駆使すれば#keyword[条件式]はなくても構わないが，条件式の記法があるのは便利である．Pythonには
#sourcecode[```python
def f(x):
  if x == 0:
    return 1
  else:
    return sin(x) / x
```]
のような#keyword[制御構造]としての条件文があるが，我々は値を持つ#keyword[条件式]を考える．

我々の条件式とは $f x = haskell.kwif x equiv 0 haskell.kwthen 1 haskell.kwelse frac(sin x, x, style: "skewed")$ のように $haskell.kwif$ 節，$haskell.kwthen$ 節，及び $haskell.kwelse$ 節からなるものであって，$haskell.kwthen$ 節も $haskell.kwelse$ 節も省略できないものとする．$haskell.kwif$ 節の式の値が真 $haskell.True$ であれば $haskell.kwthen$ 節の式が評価され，偽 $haskell.False$ であれば $haskell.kwelse$ 節の式が評価される．我々の条件式はCにおける条件演算子（三項演算子）と等しく見えるが，Haskellの場合は遅延評価が行われ
るため，結果として条件式の#keyword[短絡評価]が行われる点が異なる．#footnote[Haskellではを $f x = haskell.kwif x equiv 0 haskell.kwthen 0 haskell.kwelse (sin x) / x$ を `f x = if x==0 then 1 else (sin x)/x` と書く．]

== 余談：局所変数

#tk

== この章のまとめ

#tk

= さらにカリー風な書き方

我々は関数とラムダ式の「カリー風」な書き方を見てきた．この章ではさらに演算子，関数合成についても「カリー風」な書き方を見ていく．

== 演算子

#keyword[演算子]は関数の特別な姿である．演算子は#keyword[作用素]と呼んでも良い．どちらも英語のoperatorの和訳である．演算子は普通アルファベット以外のシンボル1個で表現し，変数や関数の前に置いて直後の変数や関数に作用させるか，2個の変数や関数の中間に置いてその両者に作用させる．例えば $-x$ のマイナス記号 $(-)$ は変数の前に置いて直後の変数 $x$ に作用する演算子であり，$x+y$ のプラス記号 $(+)$ は2個の変数の間に置いてその両者 $(x, y)$ に作用する．

1個の変数または関数に作用する演算子を#keyword[単項演算子]と呼び，2個の変数または関数に作用する演算子を#keyword[二項演算子]と呼ぶ．本書では単項演算子はすべて変数の前に置く，すなわち#keyword[前置]する．前置する演算子のことを#keyword[前置演算子]と呼ぶが，数学者は同じものを左作用素と呼ぶ．

Haskellには単項マイナス $(-)$ を除いて他に単項演算子はない．今後，誤解を避けるために数式中の $-x$ はすべて $(-x)$ と書く．

二項演算子のうちよく使われるものは和 $(+)$，積 $(times)$，論理和 $(or)$，論理積 $(and)$，同値 $(equiv)$，大なり$(>)$，小なり $(<)$ 等である．二項演算子はたとえ積記号であっても省略できない．二項演算子は多数あるので，その都度説明する．#footnote[Haskellでは $and$ を `&&` と書き，$or$ を `||` と書く．]

二項演算子は#keyword[中置]することが基本であるが，括弧で包むことで前置することも可能である．任意の二項演算子 $haskell.anyop$ について $x class("binary",haskell.anyop) y$ 及び $(haskell.anyop) x y$ は全く同じ意味である．すなわち $(haskell.anyop) x y = x class("binary", haskell.anyop) y$ である．従って，二項演算子と2引数関数に本質的な差はない．本書では演算子と関数という用語は全く同じ意味で用いる．#footnote[Haskellでは任意の二項演算子を括弧で包むことで前置演算子として使うことができる．例えば `x + y` と `(+) x y` は同じ結果を返す．]

一般の関数が左結合であることを思い出すと，二項演算子を関数に見立てた $(haskell.anyop)$ も $(haskell.anyop) x y = ((haskell.anyop) x) y$ であるから，部分適用が可能である．この式から第2引数 $y$ を取り除いて $(haskell.anyop) x$ という「餓えた」1引数関数を取り出せる．例えば関数 $((+)1)$ は引数に $1$ を加える関数である．#footnote[Haskellでは $((+)1)$ を `((+)1)` と書く．]

前置される二項演算子 $(haskell.anyop)$ は，ラムダ式 $(lozenge.stroked.medium class("binary", haskell.anyop) lozenge.stroked.medium)$ の無名パラメタ $lozenge.stroked.medium$ を省略したものと考えても良い．また $(lozenge.stroked.medium class("binary", haskell.anyop) x)$ や $(x class("binary", haskell.anyop) lozenge.stroked.medium)$ から無名パラメタを省略した $(haskell.anyop x)$ と $(x haskell.anyop)$ も有効な表現であり，特別に#keyword[セクション]と呼ばれる．

二項演算子 $haskell.anyop$ に対して $(haskell.anyop x)$ および $(x haskell.anyop)$ はそれぞれ以下の通りである．
$ (haskell.anyop x) &= (lozenge.stroked.medium class("binary", haskell.anyop) x) \
 (x haskell.anyop) &= (x class("binary", haskell.anyop) lozenge.stroked.medium)
 = (haskell.anyop) x $

例えば $(1+)$ は $((+)1)$ と等価であり，これは $(+1)$ とも等価である．ただし，マイナス演算子 $(-)$ だけは例外で，$(-1)$ はマイナス $1$ を表す．負の数をいつも括弧で包んでおくのは良いアイディアである．#footnote[Haskell は $(1+)$ を `(1+)` と書く．また `(-1)` はセクションではなくマイナス $1$ を表す（`-1` というリテラルとみなされる）．ただし `(- 1)` のように空白を挟んでも同じくマイナス $1$ とみなされる（`1` というリテラルに単項マイナス演算子が適用される）．]

なお，二項演算子の結合性，すなわち左結合か右結合かは，演算子によって異なる．また演算の優先順位を明示的に与えるために括弧が用いられる．

一般の関数 $f$ を中置演算子に変換する記号 $haskell.infix(f)$ を今後用いる．この記号を用いると値 $f x y$ のことを $x haskell.infix(f) y$ と書くことができる．

== 関数合成と関数適用

ある変数に複数の関数を順に適用することはよくあることである．例えば
#sourcecode[```python
y = f(x)
z = g(y)
```]
あるいは同じことであるが
#sourcecode[```python
z = g(f(x))
```]
とすることがある．本書の記法で書けば $z = g(f x)$ である．この式から括弧を省略して $z = g f x$ としてしまうと，関数適用は左結合するから $z = (g f) x$ の意味になってしまう．関数 $g$ が引数に関数をるので無い限り $(g f)$ は無意味なので，$ z = g(f x)$ の括弧は省略できない．

ここで，引数のことは忘れて，関数 $f$ と関数 $g$ を先に#keyword[合成]しておきたいとしよう．その合成を $g compose f$ と書く．演算子 $compose$ は#keyword[関数合成演算子]と呼ぶ．合成はラムダ式を使って $g compose f = g(f lozenge.stroked.medium)$ と定義できる．関数合成演算子 $compose$ は関数適用よりも優先順位が高く，$(g compose f)x$ は単に $g compose f x$ と書いても良い．この記法は括弧の数を減らすためにしばしば用いられる．#footnote[Haskellでは関数 `g` と関数 `f` の合成は `g.f` である．式 $z = g compose f x$ は `z = g.f x` と書く．]

関数合成演算子は，連続して用いることができる．関数合成演算子は左結合するので，関数 $f, g, h$ について $h compose g compose f = (h compose g) compose f$ であるが，これを展開すると以下のようになる．
$ (h compose g) compose f &= (h compose g)(f lozenge.stroked.medium) \
  &= h(g(f lozenge.stroked.medium)) \
  &= h compose (g compose f) $

そのため $h compose g compose f = h compose (g compose f)$ である．つまり，関数合成は順序に依存しない．

関数合成演算子とは逆に，結合の優先順位の低い#keyword[関数適用演算子]も考えておくと便利なこともある．関数適用演算子 $haskell.apply$ を次のように定義しておく．
$ f haskell.apply x = f x $

演算子 $haskell.apply$ の優先順位は関数適用も含めあらゆる演算子よりも低いものとする．関数適用演算子を用いて $z = g(f x)$ を書き直すと $z = g haskell.apply f x$ となる．演算子 $haskell.apply$ の優先順位は足し算よりも低いので $f(x + 1)$ は $f haskell.apply x + 1$ と書くこともできる．演算子 $haskell.apply$ を閉じ括弧のいらない開き括弧と考えてもよい．#footnote[Haskellでは $g haskell.apply f x$ を `g $ f x` と書く．]

関数適用演算子のもう一つの興味深い使い方は，関数適用演算子の部分適用である．セクション $(lozenge.stroked.medium haskell.apply x)$ を用いると $(lozenge.stroked.medium haskell.apply x)f = f haskell.apply x$ であるから，関数適用演算子を用いて引数を関数に渡すことができる．#footnote[Haskell では $(lozenge.stroked.medium haskell.apply x)f$ を `($x)f` と書く．]

== 高階関数

関数を引数に取ったり，あるいは関数を返す関数のことを#keyword[高階関数]と呼ぶことがある．関数合成演算子と関数適用演算子は高階関数の好例である．

他に例えば，引数として整数 $a$ を取り，関数 $f x = a + x$ を返すような関数 $g$ を次のように定義することが出来る．
$ g a = a + lozenge.stroked.medium $

このとき，
$ f &= g space 100 \
  x &= f space 1 $
とすれば $x = 101$ を得る．#footnote[Haskell では $g a = a + lozenge.stroked.medium$ を $g a = backslash x |-> a + x$ と展開しておいて `g a = \ x -> a + x` と書く．]

高階関数は今後度々顔をだすことになる．後で登場するマップ演算子や畳込み演算子は高階関数の一種である．

== 余談：演算子の定義

Haskellでは関数だけでなく，新しい演算子も定義できる．#footnote[Haskellで演算子に使える記号は `! @ # $ % ^ & * - + = . \ | / < : > ? ~` の組み合わせである．]

計算機科学者ドナルド・クヌースは，整数 $x, n$ が与えられたとき $x$ の $n$ 乗を $x^n$ ではなく $x uparrow n$ と書いた．これは
$ x uparrow n = underbrace(x times x times ... times x, n) $
という意味である．#footnote[Haskellでは $x uparrow n$ を `x ^ n` と書く．]

クヌースはさらに演算子 $uparrow2$ を
$ x uparrow2 n = underbrace(x uparrow x uparrow ... uparrow x, n) $
のように定義した．これを#keyword[クヌースの矢印]と呼ぶ．クヌースの矢印は
$ x uparrow2 n &|_(n <= 0) = 1 \
  &|_"otherwise" = x uparrow (x uparrow2 (n - 1)) $
と定義できる．#footnote[Haskellでは次のように定義する．
```haskell
  x^^.n | n <= 0 = 1 
        | otherwise = x^(x^^.(n-1))
```
なお厳密には
```haskell
  (^^.) :: Integral a => a -> a -> a
```
と演算子の型を宣言しておく必要がある．]

なおこの定義は自分自身を呼び出す#keyword[再帰]を行っている．再帰に関しては〜〜〜で詳しく述べる．

== この章のまとめ

#tk

= 型

Haskellの変数，関数にはすべて型がある．プログラマの言う型とは，数学者の言う集合のことである．本章では，Haskellが扱う基本的な型であるデータ型と，パラメトリックな型である多相型，および型の型である型クラスについて述べる．また関数のカリー化についても述べる．

== データ型

#keyword[型]とは変数が取りうる値に言語処理系が与えた制約のことである．Haskellを含む多くのコンパイラ言語は#keyword[静的型付け]と言って，コンパイル時までに変数の型が決まっていることをプログラマに要求する．一方，Pythonのようなインタプリタ言語はたいてい#keyword[動的型付け]と言って，プログラムの実行時まで変数の型を決めない．

変数に型の制約を設ける理由は，プログラム上のエラーが減ることを期待するためである．例えば真理値が必要とされるところに整数値の変数が来ることは悪い予兆である．一方でC言語のように全ての変数にいちいち型を明記していくのも骨が折れる．

数学者や物理学者は変数に型の制約を求める一方，新しい変数の型は明記せず読者に推論させる方法をしばしばとる．例えば，質量 $m$ は「スカラー」という型を持つし，速度 $v$ は「3次元ベクトル」という型を持つ．スカラーと3次元ベクトルの間に足し算は定義されていないため，例えば $m+v$ という表記を見たときに，両者の型を知っていれば直ちにエラーであることがわかる．

Haskellはコンパイラが型推論を行うことで，型が自明の場合は型を省略することができる．

Haskellにはよく使う型が予め用意されている．例えば#keyword[論理型]は論理値すなわち真 ($haskell.True$) または偽 ($haskell.False$) という値をとる変数の型である．ある変数 $x$ が論理型であることを，Haskellでは $x colon.double haskell.Bool$ と書く．数学者なら同じことを $x in BB$ と書くところであるが，ここはHaskellの流儀に従おう．また型定義と値定義はよく一緒に行われるので，今後 $x colon.double haskell.Bool = haskell.True$ のようにまとめて書くことにしよう．#footnote[Haskellでは
```haskell
  x :: Bool
  x = True
```
と書く．]

この場合変数 $x$ が $haskell.Bool$ 型であることは自明であるため $x colon.double haskell.Bool$ は省略できるが，可能な限り型を明記しておくことは良い習慣である．また必要に応じて変数に型名を注釈することがある．例えば $x = haskell.True colon.double haskell.Bool$ のように書く場合がある．#footnote[Haskellでは $x = haskell.True colon.double haskell.Bool$ を `x = True :: Bool` と書く．]

他に整数を表す#keyword[整数型]がある．整数型には2種類あって，その一つは $haskell.Int$ である．この $haskell.Int$ はCの `int` と似た「計算機にとって都合の良い整数」である．計算機にとって都合の良い整数とは，例えば64ビット計算機の場合 $-2^(63)$ から $2^(63)-1$ の間の整数という意味である．#footnote[Haskellでは $haskell.Int$ を `Int` で表す．]

整数型には $haskell.Integer$ もある．この $haskell.Integer$ は計算機にとっては非常識なぐらい大きな，あるいは小さな値を表すことができる．#footnote[Haskellでは $haskell.Integer$ を `Integer` で表す．]

計算機は残念ながら無限精度の実数を扱えない．そこで標準精度（単精度）の#keyword[浮動小数点数型]である $haskell.Float$ と，#keyword[倍精度浮動小数点型]である $haskell.Double$ が提供される．#footnote[Haskellでは $haskell.Float$, $haskell.Double$ をそれぞれ `Float` と `Double` で表す．]

もう一つ，計算機ならではの型がある．それは $haskell.Int$ とよく似ているが，特別に文字を扱うために考えられた#keyword[文字型] $haskell.Char$ である．文字といってもその中身は整数である．整数ではあるが，わざわざ別な型とするのには理由がある．#footnote[Haskellでは $haskell.Char$ を `Char` で表す．]

理由の第一は，文字が小さな整数であるため，文字型を独立して定義しておくことでメモリを節約できるのである．特にメモリが高価であった時代はこれが唯一の理由であった．現在でも，整数が一般に64ビットを消費するのに対し，UTF-8文字エンコードを用いている場合，アルファベットは8ビットしか消費しない．

理由の第二は，単純に整数と文字が異なるからである．文字を表す変数に整数を代入するのは悪い兆しである．

理由の第三は，文字が数値にエンコードされる方式が可変長である場合に備えて，整数と区別しておくためである．例えばUTF-8文字エンコードは可変長エンコーディングを行う．

このような基本的な型を#keyword[データ型]と呼ぶ．

関数にも型がある．例えば整数引数を一つ取り，整数を返す関数 $f$ は $f colon.double haskell.Int -> haskell.Int$ という型を持つ．この型は
$ f colon.double underbrace(haskell.Int, x) -> underbrace(haskell.Int, f x) $
のようにイメージすると良い．これは関数 $f$ が集合 $haskell.Int$ から集合 $haskell.Int$ への#keyword[写像]であると読む．#footnote[Haskellでは `f :: Int -> Int` と書く．]

== カリー化

Haskellでは，どのような関数であれ引数は1個しかとらない．引数が2個あるように見える関数として，例えば $g x y$ があったとしよう．ここに $g$ は関数，$x$ と $y$ は変数である．関数適用は左結合であるから，これは　$(g x)y$ である．ここに $(g x)$ は引数 $y$ をとる関数であると見ることができる．つまり，関数 $g$ とは引数 $x$ をとり「引数 $y$ をとって値を返す関数 $(g x)$ を返す」関数であると言える．

二項演算 $x + y$ は $(+)x y$ とも書けたことを思い出そう．これも左結合を思い出すと $(+)x y = ((+)x)y$ であるから，$y$ という引数を $((+)x)$ という関数に食わせていると解釈できる．

ラムダ式の場合は話はもっと単純で，形式的に
$ backslash x y |-> x + y = backslash x |-> (backslash y |-> x + y) $
のように展開すれば1引数にできる．矢印 $|->$ は#keyword[右結合]である．そこでこのラムダ式は括弧を省略して
$ backslash x y |-> x + y = backslash x |-> backslash y |-> x + y $
とも書かれる．

複数引数をとる関数を1引数関数に分解することを#keyword[カリー化]と呼ぶ．これはこの分野の先駆者であるハスケル・カリーの名前に由来する．

整数引数を二つ取り，整数を返す関数 $g$ は
$ g colon.double haskell.Int -> haskell.Int -> haskell.Int $
という型を持つ．写像の矢印記号は右結合するので，これは
$ g colon.double haskell.Int -> (haskell.Int -> haskell.Int) $
と同じ意味である．上式は
$ g colon.double underbrace(haskell.Int, x) -> underbrace(overbrace(haskell.Int, y) -> overbrace(haskell.Int, (g x)y), g x) $
のようにイメージすると良い．

自然言語で考えると $haskell.Int$ 型の引数を一つ取り，$haskell.Int$ 型の引数を一つ取って $haskell.Int$ 型の値を返す関数を返す，と読める．#footnote[関数の型に出てくる $->$ は2引数をとる型コンストラクタである．型コンストラクタに関しては〜〜〜で詳しく述べる．例えば $haskell.a -> haskell.b$ という型は $(->)haskell.a haskell.b$ の別名であり，型コンストラクタ $(->)$ に引数 $haskell.a$ と $haskell.b$ を与えたものと読む．]

Haskellには#keyword[タプル]という型がある．タプルとは，複数の変数を組み合わせたもので，例えば変数 $x$ と $y$ をひとまとめにした $paren.l.flat x, y paren.r.flat$ はタプルである．変数 $x$, $y$ の型は同じでも良いし，異なっても良い．#footnote[Haskellでは $paren.l.flat x, y paren.r.flat$ を `(x, y)` と書く．]

いまタプルを引数に取る関数 $f paren.l.flat x, y paren.r.flat = x + y$ があったとしよう．Haskellにはタプルをとる関数をカリー化する関数 $haskell.curry$ があり，$(haskell.curry f) x y$ は $x + y$ になる．

逆に，カリー化された関数 $f' x y = x + y$ に関しては $(haskell.uncurry f')paren.l.flat x, y paren.r.flat$ のように#keyword[アンカリー化]することで，タプルに適用することができる．

タプルの中身の個数は0個または2個以上でなければならず，上限は処理系によって定められている．2個の変数からなるタプルを特別にペア，3個の変数からなるタプルを特別にトリプルと呼ぶ．中身が0個のタプルを $emptyset.rev$ で表し，特別に#keyword[ユニット]と呼ぶ．#footnote[GHC v8.2.1 は最大62個の変数からなるタプルまで生成できる．]

== 多相型と型クラス

整数型 $(haskell.Int)$ と浮動小数点型 $(haskell.Float)$ はよく似ている．どちらも値同士を比較可能で，それ故どちらにも等値演算子が定義されている．

整数型の等値演算子は 
$ (equiv) colon.double haskell.Int -> haskell.Int -> haskell.Bool $
であり，浮動小数点型の等値演算子は
$ (equiv) colon.double haskell.Double -> haskell.Double -> haskell.Bool $
である．

このように型が異なっても（だいたい）同じ意味で定義されている演算子のことを#keyword[多相的]な演算子と呼ぶ．等値演算子は多相的な演算子の例である．

具体的な型を指定せずに，仮の変数で表したものを#keyword[型パラメタ]と呼ぶ．我々は型パラメタをボールド体で表す．いま型を表す仮の変数を $haskell.a$ として，等値演算子の型を
$ (equiv) colon.double haskell.a -> haskell.a -> haskell.Bool $<equiv>
と表現してみよう．このような型パラメタを用いた型を総称して#keyword[多相型]と呼ぶ．

実は@equiv は不完全なものである．このままでは型 $haskell.a$ に何の制約もないため，等値演算の定義されていない型が来るかもしれないからである．そこで，型自身が所属する，より大きな型があるとしよう．そのような型を我々は#keyword[型クラス]と呼ぶ．例えば型 $haskell.Bool, haskell.Int,haskell.Integer, haskell.Float, haskell.Double$ は全て等値演算が定義できるので，型クラス $haskell.Eq$ に属すとする．この関係を我々は
$ haskell.Eq supset haskell.Bool, haskell.Int, haskell.Integer, haskell.Float, haskell.Double $
と書く．ここに $haskell.Eq supset haskell.a$ と書いて「型 $haskell.a$ は型クラス $haskell.Eq$ の#keyword[インスタンス]である」と読む．

@equiv に型クラスの制約を加えてみよう．型 $haskell.a$ は型クラス $haskell.Eq$ に属さなければならないから，新たな記号 $==>$ を使って
$ (equiv) colon.double haskell.Eq supset haskell.a ==> haskell.a -> haskell.a -> haskell.Bool $
と書くことにする．#footnote[Haskellでは `(==) :: Eq a => a -> a -> Bool` と書く．記号 $supset$ は省略する．]

型 $haskell.a$ の変数同士の間で大小関係が定義されている場合，かつその型が型クラス $haskell.Eq$ に属する場合，その型は型クラス $haskell.Ord$ にも属する．型クラス $haskell.Ord$ に属する型は比較演算子 $<, <=, >=, >$ を提供する．例えば型 $haskell.Int$ は型クラス $haskell.Ord$ に属すが，型 $haskell.Bool$ は型クラス $haskell.Ord$ に属さない．

型 $haskell.a$ の変数同士の間で四則演算関係が定義されている場合，かつその型が型クラス $haskell.Eq$ に属する場合，その型は型クラス $haskell.Num$ にも属する．型クラス $haskell.Num$ に属する型は二項演算子 $+, -, *, slash$ を提供する．ここに $-$ は二項演算子のマイナスである．

型 $haskell.a$ が型クラス $haskell.Ord$ 及び型クラス$haskell.Num$ に属しているとき，かつそのときに限り，型 $haskell.a$は型クラス $haskell.Real$ にも属する．

型 $haskell.a$ の変数について，一つ小さい値を返す関数 $haskell.pred$ と一つ大きい値を返す関数 $haskell.succ$ が定義されているとき，かつそのときに限り，型 $haskell.a$ は型クラス $haskell.Enum$ に属する．

型 $haskell.a$ が型クラス $haskell.Real$ 及び型クラス$haskell.Enum$ に属しているとき，かつそのときに限り，型 $haskell.a$ は型クラス $haskell.Integral$ にも属する．

便利な型変換演算子をひとつ紹介しておこう．型変換演関数 $haskell.fromIntegral$ は
$ haskell.fromIntegral colon.double haskell.Integral supset haskell.a
  ==> haskell.a -> haskell.b $
という型を持ち，$haskell.Integral$ 型クラスの型の変数を任意の型へ変換する．例えば，
$ x colon.double haskell.Double = haskell.fromIntegral 1 colon.double haskell.Int $
とすることで，$haskell.Double$ 型の変数 $x$ に $haskell.Int$ 型の定数を代入できる．#footnote[Haskellでは `x :: Double = fromIntegral 1 :: Int` と書く．]

== 余談：モノイド
整数全てからなる#keyword[集合]を $ZZ$ で表すことにする．計算機科学で整数と言うと，本当の整数と，例えば $-2^(63)$ から $2^(63)-1$ までの間の整数の意味と両方あるが，今は前者の意味である．

集合 $ZZ$ の任意の#keyword[元]（#keyword[要素]）$z$ を $z in ZZ$ と書く．

二つの整数 $z_1, z_2 in ZZ$ があるとしよう．両者の間には#keyword[足し算] $(+)$ が定義されており，その結果すなわち#keyword[和]もまた整数である．ここで $z_1 + z_2 in ZZ$ であるとき，演算子 $+$ が集合 $ZZ$ に対して#keyword[全域性]を持つと言う．

一般に集合 $AA$ の元に対して二項演算子 $haskell.anyop$ が定義されていて，$a_1, a_2 in AA$ のときに
$ a_1 haskell.anyop a_2 in AA $<totality>
である場合，つまり演算子 $haskell.anyop$ が集合 $AA$ に対して全域性を持つ場合，組み合わせ $(AA, haskell.anyop)$ を#keyword[マグマ]と呼ぶ．組み合わせ $(ZZ, +)$ はマグマの例であり，$(ZZ, times)$ もマグマの例である．

他に#keyword[論理集合] $BB = \{tack.b, tack.t\}$ に対して，#keyword[論理和] $(or)$ は全域性を持つから，組み合わせ $(BB, or)$ はマグマであるし，同様に#keyword[論理積] $(and)$ も全域性を持つから，組み合わせ $(BB, and)$ もマグマである．論理集合 $BB$ とは論理型 $haskell.Bool$ を数学風に言い換えたものである．#footnote[記号 $tack.b$ は $haskell.True$ を，記号 $tack.t$ は $haskell.False$ を抽象化したものである．記号 $and$ はandと読み，記号 $or$ はorと読む．]

マグマのうち，演算を2回続ける場合，その順序によって結果が異ならない，つまり
$ a_1 haskell.anyop (a_2 haskell.anyop a_3) = (a_1 haskell.anyop a_2) haskell.anyop a_3 $<associativity>
ただし $a_1, a_2, a_3 in AA$ のとき，組み合わせ $(AA, haskell.anyop)$ のことを#keyword[半群]と呼ぶ．この@associativity で表される性質を#keyword[結合性]と呼ぶ．組み合わせ $(ZZ, +), (ZZ, times), (BB, or), (BB, and)$ はすべて半群である．

ところで，整数全体の集合 $ZZ$ には特別な元 $0 in ZZ$ がある．この元 $0$ は $z in ZZ$ のとき
$ 0 + z = z + 0 = z $
という性質を持つ．この $0$ を演算 $+$ における#keyword[単位元]と呼ぶ．足し算のことを#keyword[加法]とも言うので $0$ のことは#keyword[加法単位元]と呼ぶこともあるし，文字通り#keyword[零元]と呼ぶこともある．

一般に，$a in AA$ として
$ 0 haskell.anyop a = a haskell.anyop 0 = a $<identity>
であるとき，元 $0$ を単位元と呼ぶ．#footnote[厳密には $0_"left" haskell.anyop a = a$ のとき $0_"left"$ を#keyword[左単位元]と呼び，$a haskell.anyop 0_"right" = a$ のとき $0_"right"$ を#keyword[右単位元]と呼ぶが，本書では両者を区別せず単位元と呼ぶ．]

組み合わせ $(AA, haskell.anyop)$ が半群のとき，集合 $AA$ の単位元 $0$ との組み合わせ $(AA, haskell.anyop, 0)$ のことを#keyword[モノイド]または#keyword[単位的半群]と呼ぶ．例えば $(ZZ, +, 0)$ はモノイドであるし，$(ZZ, times, 1), (BB, or, tack.t)$, $(BB, and, tack.b)$ もモノイドである．

このように，数学者は数の性質を抽象化し，集合とその集合に対する演算というものの見方をよく行う．プログラミングの言葉で言えば，複数のクラスに共通のインタフェースを定義するようなものである．


型 $haskell.a$ を任意の型としたとき，型 $haskell.a -> haskell.a$ の関数もまたモノイドとなる．まず「何もしない」関数 $haskell.id$ を次のように定義する．
$ id = lozenge.stroked.medium $
これはもちろん $id = backslash x |-> x$ の意味で，引数をそのまま返す関数である．

我々は関数を合成できる．そこで $haskell.a -> haskell.a$ 型の関数 $f$ と関数 $haskell.id$ の合成を考えると $haskell.id compose f = f compose id = f$ であり，また関数 $f, g, h colon.double haskell.a -> haskell.a$ について $(h compose g) compose f = h compose (g compose f)$ でるから，組み合わせ $(haskell.a -> haskell.a, compose, haskell.id)$ はモノイドであることがわかる．

== この章のまとめ

#tk

= リスト

型から作る型をコンテナと呼ぶ．代表的なコンテナはある型のホモジニアスな配列であるリストである．この章ではリストと，リストに対する重要な演算である畳み込み，マップを取り扱う．

== リスト

同じ型の値を一列に並べたもの，つまりホモジニアスな配列のことを#keyword[リスト]と呼ぶ．Pythonではリスト `ls` を
#sourcecode[```python
xs = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```]
のように定義できる．

我々も $0$ から始まり $9$ まで続く整数のリストを $[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]$ と書くことにしよう．ただし，これでは冗長なので#keyword[等差数列]に限って簡略化した書き方を許す．例えば $0$ から $9$ までのリストは $[0, 1, ..., 9]$ と書いても良い．#footnote[Haskellでは `[0, 1..9]` と書く．ピリオドの数に注意しよう．]

リストの中身の一つ一つの値のことを#keyword[要素]と呼ぶ．要素のことは元と呼んでも良いが，本書では要素と呼ぶことにする．要素も元も英語のelementの和訳である．

複数の型の要素が混在してもよい配列のことをヘテロジニアスな配列と呼び，ホモジニアスな配列とは区別する．

今後，リストを指す変数は，リストであることを忘れないように変数名にsをつけて $x_"s" = [0, 1, ..., 9]$ と書くことにする．なお，変数 $x$ とリスト変数 $x_"s"$ は異なる変数であるとする．#footnote[Haskellでは `s` を変数名にくっつけて `x_"s" = [0, 1..9]` のように書く習慣がある．]

Pythonではリスト内包表記が使える．例えば $0$ から $9$ までの倍数のリストは次のように作った．
#sourcecode[```python
xs = [x * 2 for x in range(0, 10)]
```]
ここに `range(a, b)` は `a` から増加する方向に連続する `b` 個の整数からなるリストを返すPythonの関数である．

我々も内包表記を
$ x_"s" = [x times 2 | x in [0, 1, ..., 9]] $
のように書こう．ここに右辺のリストから一つずつ要素を取り出して左辺に代入する演算子 $in$ を用いた．#footnote[Haskellでは $x_"s" = [x times 2 | x in [0, 1, ..., 9]]$ を `x_"s" = [x * 2 | x <- [0, 1..9]]` と書く．]

内包表記の式は複数あっても良い．例えば
$ x_"s" = [x + y | x in [0, 1, ..., 9], y in [0, 1, ..., 5], x + y > 3]$
は $0 <= x <= 9$ かつ $0 <= y <= 5$ の範囲で $x + y > 3$ となる $x$ 及び $y$ から $x + y$ を並べたリストである．これはPythonでいう
#sourcecode[```python
xs = [x + y for x in range(0, 10) for y in range(0, 6) if x + y > 3]
```]
のことである．#footnote[Haskellでは `x_"s" = [x + y | x <- [0, 1..9], y <- [0, 1..5], x + y > 3]` と書く．]

整数型 $(haskell.Int)$ のリストは $[haskell.Int]$ と書き，整数のリスト型と呼ぶ．一般に $haskell.a$ 型のリストを $[haskell.a]$ と書く．仮の型である $haskell.a$ の事を #keyword[型パラメタ]と呼ぶ．

型 $haskell.a$ から型 $[haskell.a]$ を生成する演算子を#keyword[リスト型コンストラクタ]と呼んで $[]$ と書く．型 $[haskell.a]$ は $haskell.typeconstructor1([], haskell.a)$ のシンタックスシュガーである．#footnote[Haskellでは $haskell.typeconstructor1([], haskell.a)$ を `[] a` と書く．これは `[a]` と同じことである．]

型コンストラクタの概念はPythonには無い（必要無い）が，静的型付け言語であるC++の「クラステンプレート」が相当する．

$[x]$ のように $haskell.a$ 型の変数 $x$ を入れた $[haskell.a]$ 型の変数を作る演算子を#keyword[リスト値コンストラクタ]と呼ぶ．$[haskell.a]$ 型の変数のことを#keyword[リスト変数]とも呼ぶ．$haskell.a$ 型の変数 $x$ からリスト値コンストラクタを使ってリスト$x_"s"$ を作ることは $x_"s" = [x]$ と書く．#footnote[Haskellでは `x_"s" = [x]` と書く．]

リスト型を表す $[haskell.a]$ と，1要素のリストである $[x]$ の違いにはいつも気をつけておこう．本書では中身がボールド体ならばリスト型，中身がイタリック体ならリスト値である．

ある型を包み込んだ別の型を一般に#keyword[コンテナ型]または単に#keyword[コンテナ]と呼ぶ．コンテナ型の変数を#keyword[コンテナ変数]と呼ぶ．コンテナ型は多相型の一種である．

リストは#keyword[結合]できる．例えばリスト $x_"s"$ とリスト $haskell.y_"s"$ を結合したリストは $x_"s" smash y_"s"$ と表現する．リストの結合演算子の型は
$ (smash) colon.double [haskell.a] -> [haskell.a] -> [haskell.a] $
である．#footnote[Haskellでは $x_"s" smash haskell.y_"s"$ を `x_"s" ++ y_"s"` と書く．]

リストは空でもよい．#keyword[空リスト]は $emptyset$ で表す．#footnote[Haskellでは空リストを `[]` で表す．]

関数 $haskell.null$ はリストが空リストかどうかを判定する．リスト $x_"s"$ が空リストの場合 $haskell.null x_"s"$ は $haskell.True$ を，そうでなければ $haskell.False$ を返す．関数 $haskell.null$ は
$ haskell.null colon.double [haskell.a] -> haskell.Bool $
である．

我々は無限リストを持つことができる．例えば自然数を表すリスト $n_"s"$ は $n_"s" = [1, 2, ...]$ と書くことができる．#footnote[Haskellでは `ns = [1, 2..]` と書く．]

無限リストを扱えるのは，我々がいつも遅延評価を行うからである．遅延評価とは，本当の計算は必要になるまで行わないという方式のことである．

もし本当に無限リストを計算機の上で再現する必要があったなら，計算機には無限のメモリが必要になってしまう．しかし我々は，計算が必要になるまで評価を行わないので，無限リストの中から有限個の要素が取り出されるのを待つことができるのである．例えば関数 $haskell.take m space n_"s"$ はリスト $n_"s"$ から最初の $m$ 個の要素からなるリストを返す．いま
$ x_"s" = haskell.take 5 space n_"s" $
とすると，リスト $x_"s"$ は $x_"s" = [1, 2, ..., 5]$ という値を持つ．#footnote[Haskellでは `x_"s" = take 5 ns` と書く．]

関数 $haskell.take$ の型は $haskell.take colon.double haskell.Int -> [haskell.a] -> [haskell.a]$ である．

リスト $x_"s"$ の $n$ 番目の要素には $x_"s" haskell.bangbang n$ とすることでアクセスできる．#footnote[Haskellでは `x_"s" !! n` と書く．]

== 畳み込み

我々はよくリストの総和を表現するために総和演算子 $(sum)$ を使う．総和演算子とはリスト $[x_0, x_1, ..., x_n]$ に対して
$ sum [x_0, x_1, ..., x_n] = x_0 + x_1 + ... + x_n $
で定義される演算子である．

この表現を一般化してみよう．リスト $[x_0, x_1, ..., x_n]$ が与えられたとき，任意の二項演算子を $haskell.anyop$ として
$ haskell.fold_a^haskell.anyop [x_0, x_1, ..., x_n]
  = a haskell.anyop x_1 haskell.anyop ... haskell.anyop x_n $
であると定義する．

この新しい演算子 $haskell.fold$ は#keyword[畳み込み演算子]と呼ばれる．変数 $a$ は#keyword[アキュムレータ]と呼ぶ．アキュムレータは右側の引数が空であった場合のデフォルト値と考えても良い．#footnote[Haskellでは $haskell.fold_a^+ x_"s"$ を `foldl (+)) a x_"s"` と書く．]

Python 2.7 には畳み込み演算子に相当する `reduce` 関数があり，リスト `ls` の総和 `s` を
#sourcecode[```python
# Python 2.7
ls = [0, 1, 2, 3, 4, 5]
s = reduce(lambda x, y: x + y, ls, 0)
```]
のように求めることができる．この `reduce` 関数はPythonバージョン3では非推奨になっているが，Rubyには受け継がれていて，Rubyでは
#sourcecode[```ruby
# Ruby
ls = [0, 1, 2, 3, 4, 5]
s = ls.inject(0) { |x, y| x+y }
```]
と書ける．

リストの総和をとる演算子 $sum$ は
$ sum x_"s" = haskell.fold_0^+ x_"s" $
とすれば得られる．この式は両辺の $x_"s"$ を省略して
$ sum = haskell.fold_0^+ $
とも書く．

リストの要素のすべての積をとる演算子 $product$ は
$ product = haskell.fold_1^times $
とすれば得られる．

畳み込み演算子は第1（上）引数に $haskell.a$ 型と $haskell.b$ 型の引数を取り $haskell.a$ 型の戻り値を返す二項演算子，第2（下）引数に $haskell.a$ 型，第3（右）引数に $haskell.b$ 型のリストすなわち $[haskell.b]$ 型を取り，$haskell.a$ 型の値を返す．従って畳み込み演算子の型は
$ haskell.fold colon.double (haskell.a -> haskell.b -> haskell.a)
  -> haskell.a -> [haskell.b] -> haskell.a $
である．

畳み込み演算子には次のようなもう一つのバリエーションがある．
$ haskell.foldright_a^haskell.anyop [x_0, x_1, ..., x_n]
  = (x_0 haskell.anyop (x_1 haskell.anyop ... haskell.anyop (x_n haskell.anyop a))) $
これは#keyword[右畳み込み]と呼ばれる演算子である．#footnote[Haskellでは `foldr (+) xs a` と書く．引数の順序に注意しよう．]

畳み込み演算子の面白い応用例を示そう．リストの結合演算子 $(smash)$ を使うと
$ haskell.fold_emptyset^smash [[0, 1, 2], [3, 4, 5], ...] = [0, 1, 2, 3, 4, 5, ...] $
であるから，演算子 $haskell.fold_emptyset^smash$ はリストを平坦化する#keyword[平坦化演算子]である．平坦化演算子はconcat演算子とも呼ばれることもあるが，基本的な演算子であるため特別な記号をつけておこう．我々は
$ haskell.flat = haskell.fold_emptyset^smash $
と定義することにする．#footnote[Haskellでは演算子 $haskell.flat$ の代わりに `concat` 関数（または `join` 関数）を使う．]

// [[0, 1, 2, 3, ...]] にならないか？

== マップ

リストの各要素に決まった関数を適用したい場合がある．Pythonではリスト `ls` に関数 `f` を適用するときには
#sourcecode[```python
map(f, ls)
```]
のように `map` 関数を用いる．例えば
#sourcecode[```python
f = lambda x: 100 + x
ls = [1, 2, 3, 4, 5]
ms = map(f, ls)
```]
とすると，結果として `ms` には `[101, 102, 103, 104, 105]` が入る．

このように引数として関数 $f$ とリスト $[x_0, x_1, ..., x_n]$ を取り，戻り値として $[f x_0, f x_1, ..., f x_n]$ を返す演算子 $*$ を考えよう．このとき
$ f * [x_0, x_1, ..., x_n] = [f x_0, f x_1, ..., f x_n] $
であると定義する．この演算子 $*$ をリストの#keyword[マップ演算子]と呼ぶ．#footnote[Haskellでは `map f x_"s"` または `f <$> x_"s"` と書く．演算子 `<$>` は `fmap` 演算子の中置バージョンである．]

リストのマップ演算子の型は
$ (*) colon.double (haskell.a -> haskell.b) -> [haskell.a] -> [haskell.b] $
である．矢印 $->$ は右結合なので，これは
$ (*) colon.double (haskell.a -> haskell.b) -> ([haskell.a] -> [haskell.b]) $
の意味でもある．念のため上式に注釈を加えると
$ (*) colon.double underbrace((haskell.a -> haskell.b.), f)
  -> (underbrace([haskell.a], [x_0, x_1, ..., x_n]) -> underbrace([haskell.b], [f x_0, f x_1, ..., f x_n])) $
である．

ここで $f$ と $f*$ の型を並べてみると
$ f &colon.double haskell.a -> haskell.b \
  (f *) &colon.double [haskell.a] -> [haskell.b] $
となり，マップ演算子が何をしているのか一目瞭然になる．

具体例を見てみよう．先程のPythonコードの例にあわせて
$ f &= backslash x |-> 100 + x \
  x_"s" &= [1, 2, ..., 5] \
  y_"s" &= f * x_"s" $
とすると $y_"s"$ の値は $101, 102, 103, 104, 105]$ となる．

== 余談：リストの実装


ここでリストの実装について述べておこう．紙上ではリストは自由に考えられるが，計算機上ではそれほど自由ではないからである．我々はリストをLISPにおけるリストと同じ構造を持つものとする．LISPにおけるリストとは変数 $haskell.first$ と変数 $haskell.rest$ からなるペアの集合である．変数$haskell.first$ がリストの要素を参照し，変数 $haskell.rest$ が次のペアを参照する．リストの最後のペアの $haskell.rest$ は空リストを参照する特別な値を持つ．

リストのための特別な表現 $haskell.first : haskell.rest$ を用い，リファレンス $haskell.first$ はリストが保持する型，リファレンス $haskell.rest$ はリスト型であるとする．演算子 $:$ をLISPに倣って#keyword[cons演算子]と呼ぶ．#footnote[Haskellでも要素 `x` をリスト `x_"s"` の先頭に追加することを `x : x_"s"` と書く．]

要素 $haskell.rest$ はリストまたは空リストであるから，一般にリストは次のように展開できることになる．
$ [x_0, x_1, ..., x_n] &= x_0 : [x_1, x_2, ..., x_n] \
  &= x_0 : x_1 : [x_2, ..., x_n] \
  &= x_0, x_1 : ... : x_n : emptyset $
\begin{align}
cons演算子 $(:)$ は右結合する．すなわち $x_0 : x_1 : x_2 = x_0 : (x_1 : x_2)$ である．

マップ演算子の実装は，リストの実装に踏み込めば簡単である．空でないリストは必ず $x : x_"s"$ へと分解できるから
$ f * emptyset &= emptyset \
  f * (x : x_"s") &= (f x) : (f * x_"s") $
とマップ演算子 $(*)$ を定義できる．つまりマップ演算子 $(*)$ はcons演算子 $(:)$ から作ることができる．換言すれば，マップ演算子はシンタックスシュガーである．

Haskellでは任意のリスト $x_"s"$ に対し，次の関数が用意されている．
$ haskell.head x_"s" &... "先頭要素" \
  haskell.tail x_"s" &... "2番目以降の要素からなるリスト" $
これらはLISPの `car` 関数，`cdr` 関数と同じものであり，この二者を用いればどのようなリストの処理も可能である．#footnote[Haskellでは `head` 関数の利用は非推奨である．これは `head []` と書くとエラーになるからである．]

このように基本的な関数から高機能な関数を実装する方法はよく行われる．この例ではcons演算子からマップ演算子を合成した．

リストを引数にとる関数はいつでも $f (x : x_"s") = ...$ という風にパタンマッチを行えるが，式の右辺でリスト全体すなわち $(x : x_"s")$ を参照したい場合もあるであろう．そのような場合は
$ f a_"s" haskell.at (x : x_"s") = ... $
として，変数 $a_"s"$ でリスト全体を参照することも可能である．このような記法を#keyword[asパタン]と呼ぶ．#footnote[Haskellでは `f as @ (x : xs)` と書く．]

== この章のまとめ

#tk

= 再帰

== 関数の再帰適用

自然数 $n$ の#keyword[階乗]は次のように定義される．
$ n! = n times (n - 1) times ... times 1 $

数学者は $0! = 1$ と定義するので，この式は
$ 0! &= 1 \
  n! &= n times (n - 1)! $
という風に「#keyword[再帰]的に」書き直すことが出来る．再帰とは，定義式の両辺に同じ関数名が現れることを指す．

Haskellで書きやすいように，後置演算子 $!$ のかわりに関数 $haskell.fact$ を定義しよう．関数は内部で自分自身を適用しても良いので，階乗関数 $haskell.fact$ の定義は次のようになる．
$ haskell.fact x = haskell.kwcase x haskell.kwof cases(0 --> 1,
  rect.stroked.h --> x times haskell.fact(x - 1)) $
と定義できる．関数が自分自身を適用することを関数の#keyword[再帰適用]と呼ぶ．#footnote[Haskellでは
```haskell
  fact x = case x of
    0 -> 1
    _ -> x * fact (x - 1)
```
と書く．]

これで我々は関数の適用，変数の代入，ラムダ式，条件式，再帰の方法を学んだわけである．これだけあれば，原理的にはどのようなアルゴリズムも書くことができる．今日からはカリー風な数学であらゆるアルゴリズムを表現できるのである！

cons演算子 $(:)$ は関数引数のパタンにも使える．これは，例えばリストの和をとる関数 $sum$ は
$ sum nothing &= 0 \
  sum (x : x_"s") &= x + sum x_"s" $
のようにも定義できるということである．#footnote[Haskellでは
```haskell
  sum []     = 0
  sum (x:x_"s") = x + sum x_"s"
```
と書く．]

なお，関数は再帰させるたびに計算機のスタックメモリを消費する．これを回避するためのテクニックが，次節で述べる末尾再帰である．

== 末尾再帰

計算機科学者は，同じ再帰でも#keyword[末尾再帰]という再帰のスタイルを好む．末尾再帰とは，関数の再帰適用を関数定義の末尾にすることである．この章に出てきた階乗関数 $haskell.fact$ を例にとろう．階乗関数 $haskell.fact$ は
$ haskell.fact x = haskell.kwcase x haskell.kwof cases(0 --> 1, rect.stroked.h --> x times haskell.fact(x - 1)) $
のような形をしていた．末尾の関数をよりはっきりさせるために演算子 $(*)$ を前置にして
$ haskell.fact x = haskell.kwcase x haskell.kwof cases(0 --> 1, rect.stroked.h --> (times) x space haskell.fact(x - 1)) $
と書いてみよう．この定義の末尾の式は $(times)x space haskell.fact(x - 1)$ である．これだと末尾の関数は $haskell.fact$ ではなく演算子 $(times)$ なので，末尾に再帰適用を行ったことにはならない．

そこで，次のように形を変えた階乗関数 $haskell.fact'$ を考えてみる．
$ haskell.fact' a x = haskell.kwcase x haskell.kwof cases(0 --> a, rect.stroked.h --> haskell.fact' (a times x) space (x - 1)) $
こうすれば末尾の関数がもとの $haskell.fact'$ と一致する．#footnote[Haskellでは
```haskell
  fact' a x = case x of 0 -> 1
                        _ -> fact' (a*x) (x-1)
```
と書く．]

関数 $haskell.fact$ が，例えば
$ haskell.fact 3 &= 3 times haskell.fact 2 \
  &= 3 times 2 times haskell.fact 1 \
  &= 3 times 2 times 1 times haskell.fact 0 \
  &= 3 times 2 times 1 times 1 \
  &= 6 $
と展開されるのに対し，同じく $haskell.fact' space 3$ は
$ haskell.fact' space 1 space 3 &= haskell.fact' (1 times 3) space (3 - 1) \
  &= haskell.fact' space 3 space 2 \
  &= haskell.fact' (3 times 2) space (2 - 1) \
  &= haskell.fact' space 6 space 1 \
  &= haskell.fact' (6 times 1) space (1 - 1) \
  &= haskell.fact' space 6 space 0 \
  &= 6 $
であるから，関数 $haskell.fact$ が「横に伸びる」のに対して，関数 $haskell.fact'$ は「横に伸びない」ことになる．計算式が「横に伸びない」性質は，計算機のリソースを無駄に消耗しないことが期待されるため，計算機科学者が好むのである．また末尾再帰は後述する「末尾再帰最適化」のチャンスをコンパイラに与える．

Haskellを含む幾つかのプログラミング言語処理系は，コンパイル時に#keyword[末尾再帰最適化]を行う．末尾再帰最適化とは，一言で言うと再帰を計算機が扱いやすいループに置き換えることである．では最初から我々もループで関数を表現しておけば，と思われるかもしれないが，再帰以外の方法でループを表現する場合には必ず変数（ループカウンタ）への破壊的代入が必要になるため，我々は末尾再帰に慎ましくループを隠すのである．#footnote[Schemeは末尾再帰最適化を行うことが言語仕様によって決められている．]

== 遅延評価

Haskellは，意図しない限り遅延評価を行う．これは特に左畳み込み演算子 $union$ を使う場合に問題となる．いま $x_"s" = [x_0, x_1, x_2, x_3]$ とすると，左畳み込み演算 $union_0^+ x_"s"$ は
$ haskell.fold_0^+ x_"s" &= union_0^+(x_0 : x_1 : x_2 : emptyset) \
  &= haskell.fold_(0+x_0)^+(x_1 : x_2 : x_3 : emptyset) \
  &= haskell.fold_((0 + x_0) + x_1)^+ (x_2 : x_3 : emptyset) \
  &= haskell.fold_(((0 + x_0) + x_1) + x_2)^+ (x_3 : emptyset) \
  &= haskell.fold_((((0 + x_0) + x_1) + x_2) + x_3) emptyset \
  &= (((0 + x_0) + x_1) + x_2) + x_3 $
と展開される．遅延評価のために，Haskell処理系は値ではなく式をメモリにストアしなければならないが，左畳み込み演算は大きなメモリを必要としがちである．もし例えば予め $0 + x_0$ を先に計算しておくなど左畳み込みだけ先に評価しておけば，大いにメモリの節約になる．そのためにHaskellは「遅延評価無し」の左畳み込み演算子を用意している．#footnote[「遅延評価無し」の左畳み込み演算子をHaskellでは `foldl'` と書く．]

== 余談：クロージャ

ラムダ式をサポートするほとんどのプログラミング言語は，#keyword[レキシカルクロージャ]をサポートする．レキシカルクロージャとは，ラムダ式が定義された時点での，周囲の環境をラムダ式に埋め込む機構である．例えば
$ a &= 100 \
  f &= a + lozenge.stroked.medium $
というラムダ式があるとする．当然我々は関数 $f$ がいつも $f = 100 + lozenge.stroked.medium$ であることを期待するし，Haskellにおいてはいつも保証される．#footnote[Haskellでは
```haskell
  a = 100
  f = \x -> a+x
```
と書く．]

ところが，参照透過性のない言語，言い換えると変数への破壊的代入が許されている言語では，変数 $a$ の値がいつ変わっても不思議ではない．そこで，それらの言語では関数 $f$ が定義された時点での $a$ の値を，関数 $f$ の定義に含めておく．これがレキシカルクロージャの考え方である．

Haskellではそもそも変数への破壊的代入がないので，関数 $f$ がレキシカルクロージャであるかどうか悩む必要はない．あえて言えば，Haskellではラムダ式はいつもレキシカルクロージャである．もしあなたのそばのC++プログラマが「え？　Haskellにはレキシカルクロージャが無いの？」などと聞いてきたら，「ええ，Haskellには破壊的代入すらありませんから」と答えておこう．

== この章のまとめ

#tk

= Maybe

この章では計算結果が正しいかもしれないし，正しくないかもしれないという曖昧な状況を表す型を導入する．手始めにPythonでクラス `Possibly` を実装し，それがカリー風の数式で綺麗に書けることを示す．またリストとの共通点についても見ていくことにする．

== Possibly

計算の途中で，計算にまつわる状態を残りの計算に引き継ぎたくなる場合がある．例えば，整数 $x, y, z$ があり $z = frac(y, x, style: "skewed")$ なる値を続く計算で利用したいとする．だが $x equiv 0$ のときには $z$ は正しく計算されない．こんなときプログラマが取れる手段は
- $z = frac(y, x, style: "skewed") $ を計算した時点で#keyword[ゼロ除算例外]を発生させ，プログラムの制御を他の場所へ移す（大域ジャンプを行う）
- グローバル変数にゼロ除算エラーが起こったことを記録しておき，$z$ にはとりあえずの数値，例えば $0$ を代入しておいて，計算を続行させる
- $z$ にエラー状態を示す印を新たにつけておいて，計算を続行させる
といったところだろう．

大域ジャンプも，グローバル変数の書き換えも破壊的代入を伴うものであり，受け入れがたい．そこで我々は第三のエラー状態を示す印をつける方法を採用することにする．普通変数が整数だろうが実数だろうが，計算機表現には余分なビットが残っていないので，変数をラップする次のようなクラス `Possibly` を導入することにしよう．メンバ変数 `value` が値を，メンバ変数 `valid` がエラーの有無を表す．
#sourcecode[```python
class Possibly:
  def __init__(self, a_valid, a_value = 0):
    self.valid = a_valid
    self.value = a_value
```]

例えば整数値 `123` を持つ `Possibly` クラスの値 `p` は
#sourcecode[```python
p = Possibly(True, 123)
```]
として生成できるし，`Possibly` 値 `p` が計算エラーを表す場合は
#sourcecode[```python
p = Possibly(False)
```]
と初期化できる．

ここで，引数に `1` を加えて返す関数 `f` があるとしよう．関数 `f` の定義は次の通りである．
#sourcecode[```python
f = lambda x: 1 + x
```]

関数 `f` に直接 `Possibly` 値 `p` を食わせるとランタイムエラーを引き起こす．
#sourcecode[```python
q = f(p) # エラー!!
```]
これは関数 `f` が引数として数値を期待していたにもかかわらず，`Possibly` クラスの値が渡されたからである．もし関数 `f` のほうをいじりたくないとすれば，次のような関数 `map_over` を使って
#sourcecode[```python
q = map_over(f, p)
```]
というふうに間接的に関数適用を行う必要がある．

関数 `map_over(f, p)` はもし `p` がエラーを表す値でなければ中身の値を関数 `f` に適用し，その結果を `Possibly` クラスに包んで返す．もし `p` がエラー値を表す値であれば，結果もエラー値である．関数 `map_over` の実装は次のようになる．
#sourcecode[```python
def map_over(f, p):
  if p.valid == True:
    return Possibly(True, f(p.value))
  else:
    return Possibly(False)
```]
さて，次節では以上のようなことを抽象数学的に綺麗に描いてみよう．

== Maybe

もう一度振り出しに戻る．

整数 $x, y, z$ があり $z = frac(y, z, style: "skewed")$ という式があるとする．この式は $x equiv 0$ のときにはゼロ除算エラーである．しかし「例外」は内部状態の書き換えであり，我々の計算に入れたくない．そこで変数 $z$ が正しく計算されたかもしれないし，されていないかもしれないということを $w_"?"$ のように印をつけた変数に入れて，忘れないようにしておこう．

ここで変数 $w_"?"$ が取り得る値は正しく計算された値 $z$ をラップしたものか，あるいはエラーを表す値 $haskell.Nothing$ である．このように計算結果に「意味付け」をすることを#keyword[文脈]に入れると言う．定数 $haskell.Nothing$ は「ナッシング」と呼ぶ．#footnote[Haskellでは $haskell.Nothing$ を `Nothing` と書く．]

この変数 $w_"?"$ はもはや整数 $(haskell.Int)$ 型とは言えない．そこでこの $z_"?"$ の型を $haskell.MaybeType(haskell.Int)$ と表して「Maybe整数（おそらく整数）」型と呼ぶことにしよう．型 $haskell.a$ から型 $haskell.MaybeType(haskell.a)$ を生成するとき，$haskell.Maybe$ を#keyword[型コンストラクタ]と呼ぶ．#footnote[Haskellでは `Maybe a` と書く．]

$haskell.a$ 型の変数を $haskell.MaybeType(haskell.a)$ 型の変数に代入するには，次のMaybe値コンストラクタを用いて
$ w_"?" = haskell.Just(z) $
とする．#footnote[Haskellでは `w = Just x` と書く．Maybeを表す疑問符は省略する．]

変数 $z$ が一度ゼロ除算の危険性に「汚染」された場合，その後ずっとMaybe変数に入れ続けなければいけない．そこで，普通の変数を引数にとる関数 $f$ にMaybe変数 $w_"?"$ を食わせるには，リストの時と同じようなマップ演算子が必要になる．具体的には，変数 $x$ が $haskell.Int$ 型として，Maybe変数 $w_"?"=haskell.Just(x)$ が与えられたとき
$ f ast.op.o w_"?" = haskell.Just(f x) $
となるようなMaybeバージョンのマップ演算子 $ast.op.o$ を用いる．ここに $f ast.op.o w_"?"$ の型は，もし $f colon.double haskell.Int -> haskell.Float$ ならば $haskell.MaybeType(haskell.Float)$ である．#footnote[Haskellでは $f ast.op.o w_"?"$ を `f <$> w` と書く．]

実際には $w_"?" equiv haskell.Nothing$ の可能性も考えなければならないから，Maybeバージョンのマップ演算子は
$ f ast.op.o w_"?" = haskell.kwcase w_"?" haskell.kwof
  cases(haskell.Just(x) --> haskell.Just(f x),
    rect.stroked.h --> haskell.Nothing) $
でなければならない．このMaybeバージョンのマップ演算子 $ast.op.o$ は
$ f ast.op.o haskell.Just(x) &= haskell.Just(f x) \
  f ast.op.o haskell.Nothing &= haskell.Nothing $
と定義すれば得られる．#footnote[Haskellでは
```haskell
  f <$> Just x  = Just (f x)
  f <$> Nothing = Nothing
```
と書く．]

今後，普通の（引数にMaybeが来ることを想定していない）関数 $f$ をMaybe型である変数 $w_"?"$ に適用させるときには，必ず
$ z_"?" = f ast.op.o w_"?" $
のようにMaybeバージョンのマップ演算子 $ast.op.o$ を用いることにする．これはプログラムの安全性のためである．変数が一旦ゼロ除算の可能性に汚染されたら，最後までMaybeに包んでおかねばならない．

PythonでMaybeの概念を忠実になぞることは難しい．と言うのもPythonは動的型付け言語であるため，型コンストラクタという概念が無いからだ．一方でMaybeの概念を静的型付け言語であるC++やJavaで実現することはできる．そこでC++の本物のコードで示しておこう．ただしポインタを使わないでおいたのでC++プログラマもJavaプログラマも参考にできるだろう．

Maybeは次の `maybe` クラステンプレートで表現できる．（Javaプログラマへの注意：これは `maybe<a>` クラスの定義と同じ意味である．）
#sourcecode[```cpp
template <typename a> class maybe {
  private:
    a value;
    bool valid;
  public:
    maybe(): value(0), valid(false) { }
    maybe(a a_value): value(a_value), valid(true) { }
    a get_value() const { return value; }
    bool is_valid() const { return valid; }
};
```]
デフォルトコンストラクタ `maybe()` は例外的な状況を表す $haskell.Nothing$ を生成し，1引数コンストラクタ `maybe(a)` は `maybe<a>` で包んだ引数値を生成する．

C++プログラムで良く見かけるクラス設計と違い，この `maybe` クラスはコンストラクタ以外に中身を書き換える手段が提供されていない．これが破壊的代入の禁止が意味することである．

当然我々にはMaybeバージョンのマップ演算子が必要である．ここでは関数 `map_over` として書いてみよう．（Javaプログラマへの注意：関数 `map_over` はどのクラスにも属していないが，それで正解なのである．）
#sourcecode[```cpp
template <typename a, typename b, typename fn>
maybe<b> map_over(fn f, maybe<a> w) {
  if (w.is_valid()) {
    return maybe<b>(f(w.get_value()));
  }
  else {
    return maybe<b>();
  }
}
```]
テンプレートの3番目の引数 `fn` は関数 `f` を受け取るために必要である．C++はコンパイル時までにすべての変数の型が決定していないといけないが，関数 `f` の型は関数 `map_over` 設計時には確定できないため，このようにテンプレートにしている．

整数 $x$ からMaybe値 $u_"?" = haskell.Just(x)$ を作り，関数 $g x = 1 + x$ をMaybe値 $u_"?"$ に食わせてMaybe値 $v_"?"$ ただし $v_"?" = g ast.op.o u_"?"$ を得ることをC++では次のように書くことになる．
#sourcecode[```cpp
int x = 123;
maybe<int> u(x);
auto g = [](int x) -> int { return 1 + x; };
maybe<int> v = map_over(g, u);
```]
注意してほしいのは `g(x)` も `map_over(g, u)` も正当なコードだが `g(u)` は型エラーであることだ．また `g(u.get_value())` は正当なコードだが，わざわざ `u` が持つ文脈を捨てることになる．

== リストとMaybe

関数 $f$ をMayby値 $u_"?"$ に適用するために
$ v_"?" = f ast.op.o u_"?" $
のようなMaybeバージョンのマップ演算子 $(ast.op.o)$ を使った．一方で，同じ関数 $f$ をリスト $x_"s"$ に適用するには
$ y_"s" = f * x_"s" $
のようなリストバージョンのマップ演算子 $(*)$ を使った．

リストバージョンのマップ演算子 $(*)$ をもしC++で書くとしたら，次のようなコードになる．ここでリスト型としてC++の標準テンプレートライブラリ(STL)の `std::list` クラスを流用した．
#sourcecode[```cpp
template <class a, class b, class fn>
std::list<b> map_over(fn f, std::list<a> xs) {
  std::list<b> y_s(xs.size());
  auto i = xs.cbegin();
  auto j = ys.begin();
  while (i != xs.cend()) {
    *j = f(*i); ++i; ++j;
  }
  return std::list<b>(ys);
}
```]
この関数 `map_over` の中身部分はどうでもよろしい．それよりも，リストバージョンのマップ演算子のC++関数のインタフェースと，Maybeバージョンのマップ演算子のC++関数のインタフェースを見比べてみよう．

#sourcecode[```cpp
// List
template <class a, class b, class fn>
std::list<b> map_over(fn f, std::list<a> x_"s");
// Maybe
template <class a, class b, class fn>
maybe<b> map_over(fn f, maybe<a> w);
```]

やはりそっくりである．であるならば，うまく統一したい．C++では次のような書き方が文法的には可能である．

#sourcecode[```cpp
template <class a, class b, template<class> X, class fn>
X<b> map_over(fn f, X<a> x);
```]

これは一見上手く行きそうに見えるが，このコードは `map_over` のインスタンス化で躓くため，次のように `b` 型のダミー変数が必要になる．

#sourcecode[```cpp
template <class a, class b, template<class> X, class fn>
X<b> map_over(fn f, X<a> x, b dummy);
```]

残念なことに，いずれのコードにしてもリストとMaybeの本質的な抽象化にはなってない．型 `X` がマップ可能なコンテナであることをテンプレート機構を使って保証することができないためである．この問題はC++26で導入予定の「コンセプト」機能によって解決する見込みである．

一方で，数学者たちが見つけた圏という代数的構造が，リストもMaybeも統一的に扱うことを可能にしている．これを発見したのは Eugenio Moggi を始めとする計算機科学者たちである．この人類の英知は第〜〜〜章から見ていくことにしよう．

== 余談: Either

Maybeとよく似た型にEitherがある．Maybeが $haskell.a$ 型または $haskell.Nothing$ のいずれかの値をとったように，Eitherは $haskell.a$ 型または $haskell.b$ 型のいずれかの値を取る．$haskell.a$ 型または $haskell.b$ 型を取るEither型の変数 $e_!$ があるとすると，
$ e_! colon.double haskell.EitherType(haskell.a, haskell.b) $
と書く．Either型の生成は型 $haskell.a$ および $haskell.b$ から型コンストラクタを用いて $haskell.EitherType(haskell.a, haskell.b)$ と書く．#footnote[Haskellでは `Either a b` と書く．]

Eitherには値コンストラクタが2種類あり，それぞれ $haskell.Right(x)$ と $haskell.Left(x)$ である．値コンストラクタは
$ e_! = haskell.Right(x) $
または
$ e_! = haskell.Left(x) $
のように使う．#footnote[Haskellではそれぞれ `e = Right x` および `e = Left x` と書く．]

Eitherはより複雑な計算エラーが発生する場合に用いる．Maybeが単に失敗を表す $haskell.Nothing$ しか表現できなかったのに対し，Eitherは任意の型の変数で表現できる．習慣的に，正しい(right) 計算結果は $haskell.Right(x)$ 値コンストラクタで格納し，残された (left) エラーの情報は $haskell.Left(x)$ 値コンストラクタで格納する．

Either型はCの共有型 (`union`) やC++のバリアント型 (`std::variant`) に近い．

== この章のまとめ

#tk

/*

\chapter{関手*}
\label{ch:functor}

\begin{leader}
A...
\end{leader}

\begin{itemize}
  \item リストとMaybeの共通点
  \item 関手
  \item 関数
  \item 余談：アプリカティブ関手
  \item まとめ
\end{itemize}

Function laws.

\begin{align}
\hxFunc{f}\hCompose\hId&=\hxFunc{f}\\
\hId\hCompose\hxFunc{f}&=\hxFunc{f}\\
(\hxFunc{h}\hCompose\hxFunc{g})\hCompose\hxFunc{f}&=\hxFunc{h}\hCompose(\hxFunc{g}\hCompose\hxFunc{f})
\end{align}

Functor laws.

\begin{align}
\hId\hFunctorMap&=\hId\\
(\hxFunc{g}\hCompose\hxFunc{f})\hFunctorMap&=(\hxFunc{g}\hFunctorMap)\hCompose(\hxFunc{f}\hFunctorMap)
\end{align}

Map operator.

\begin{equation}
  (\hFunctorMap)\hIsTypeOf\hFunctor\hHasElementsOf\hTypeConstructor{f}\hAndThen
    (haskell.a\hFunctionArrowhaskell.b)\hFunctionArrow\hTypeConstruct{\hTypeConstructor{f}}{haskell.a}\hFunctionArrow\hTypeConstruct{\hTypeConstructor{f}}{haskell.b}
\end{equation}

\begin{align}
  \hxFunc{f}\hFunctorMap{}\hListWith{\hxVar{x}}&=\hListWith{\hxFunc{f}\hxVar{x}}\\
  \hxFunc{f}\hFunctorMap{}\hJustWith{\hxVar{x}}&=\hJustWith{\hxFunc{f}\hxVar{x}}
\end{align}

Composition operator.

\begin{equation}
  (\hCompose)\hIsTypeOf{}(haskell.a\hFunctionArrowhaskell.b)\hFunctionArrow\hTypeConstruct{(\hFunctionArrow)\hTypeName{r}}{haskell.a}\hFunctionArrow\hTypeConstruct{(\hFunctionArrow)\hTypeName{r}}{haskell.b}
\end{equation}

Applicative functor laws.

\begin{align}
\hPure\hId\hApplicativeMap&=\hId\\
\hPure\hxFunc{f}\hApplicativeMap\hPure\hxVar{x}&=\hPure(\hxFunc{f}\hxVar{x})\\
\hAnyContextDecor{\hxFunc{g}}\hApplicativeMap\hPure\hxFunc{f}&=\hPure(\hApply\hxFunc{f})\hApplicativeMap\hAnyContextDecor{\hxFunc{g}}\\
\hAnyContextDecor{\hxFunc{h}}\hApplicativeMap(\hAnyContextDecor{\hxFunc{g}}\hApplicativeMap\hAnyContextDecor{\hxFunc{f}})&=(\hPure(\hCompose)\hApplicativeMap\hAnyContextDecor{\hxFunc{h}}\hApplicativeMap\hAnyContextDecor{\hxFunc{g}})\hApplicativeMap\hAnyContextDecor{\hxFunc{f}}
\end{align}

Monad law.

\begin{equation}
\hxFunc{\psi}\hMonadicCompose\hxFunc{\phi}=\hxFunc{\psi}{}\hMonadicBind(\hxFunc{\phi}\hMonadicBind\hxAnonParam)
\end{equation}

\begin{align}
\hxFunc{\phi}\hMonadicCompose\hReturn&=\hxFunc{\phi}\\
\hReturn\hMonadicCompose\hxFunc{\phi}&=\hxFunc{\phi}\\
(\hxFunc{\omega}\hMonadicCompose\hxFunc{\psi})\hMonadicCompose\hxFunc{\phi}&=\hxFunc{\omega}\hMonadicCompose(\hxFunc{\psi}\hMonadicCompose\hxFunc{\phi})
\end{align}

Bind operator.

\begin{equation}
  \hAction{\phi}\hMonadicBind{}\hIOWith{\hxVar{x}}
    =\hIOWith{\hxFunc{f}\hxVar{x}}
\end{equation}
where
\begin{equation}
  \hAction{\phi}\hxVar{x}=\hIOWith{\hxFunc{f}\hxVar{x}}
\end{equation}

\separator

「普通の」変数$x$に「普通の」関数$f$を適用する．
$$
\hxVar{z}=\hxFunc{f}\hxVar{x}
$$

「普通の」変数$x$にモナドを返す関数$\phi$を適用する．
$$
\hAnyContextVar{z}=\hAction{\phi}\hxVar{x}
$$

文脈を持つ変数$\Tilde{x}$に「普通の」関数$f$を適用する．
$$
\hAnyContextVar{x}=\hxFunc{f}\hFunctorMap\hAnyContextVar{x}
$$

2引数の場合．
\begin{align*}
\hAnyContextVar{z}
&=\hxFunc{g}\hFunctorMap\hAnyContextVar{x}\hApplicativeMap\hAnyContextVar{y}\\
&=\hPure\hxFunc{g}\hApplicativeMap\hAnyContextVar{x}\hApplicativeMap\hAnyContextVar{y}
\end{align*}

文脈を持つ変数$haskell.athbf{x}$にモナドを返す関数$\Tilde{f}$をMaybe値に適用する．
$$
\hAnyContextVar{y}=\hAction{\phi}\hMonadicBind\hAnyContextVar{x}
$$

2引数の場合．
\begin{align*}
\hAnyContextVar{z}
&=(\hxLambdaSyntax{\hxVar{y'}}{(\hxLambdaSyntax{\hxVar{x'}}{\hAction{\phi}\hxVar{x'}\hxVar{y'}})\hMonadicBind\hAnyContextVar{x}})\hMonadicBind\hAnyContextVar{y}\\
&=\hDoSyntax{\hxVar{x'}\hDoArrow\hAnyContextVar{x};\;
\hxVar{y'}\hDoArrow\hAnyContextVar{y};\;
\hAction{\phi}\hxVar{x'}\hxVar{y'}}
\end{align*}

\separator

書くこと．

\begin{itemize}
\item applicative style
\item y compbinator
\item IO monad
\item ST monad
\item random numbers
\item category
\item continuation
\item arrow
\item supermonad
\item Alternative
\item monda transformer
\item category theory
\item The Curry–Howard isomorphism
\end{itemize}


\section{リストとMaybe}
\section{ファンクター}
\section{モナド}
\section{余談：関数}
\section{この章のまとめ}

% \section{圏と関手}

$haskell.a$ 型の変数 $\hxVar{x},\hxVar{y}\hIsTypeOfhaskell.a$ について，関数 $\hxFunc{f}\hIsTypeOfhaskell.a\hFunctionArrowhaskell.a$ があり
\begin{equation}
  \hxVar{y}
  =\hxFunc{f}\hxVar{x}
\end{equation}
であるとしよう．このように型 $haskell.a$ で閉じた世界を仮に $haskell.a$ 世界と呼ぶことにする．

型 $\hMaybeConstruct{haskell.a}$ の変数 $\hMaybeVar{u},\hMaybeVar{v}\hIsTypeOf\hMaybeConstruct{haskell.a}$ について，関数
\begin{equation}
  \hxFunc{g}
  \hIsTypeOf\hMaybeConstruct{haskell.a}\hFunctionArrow\hMaybeConstruct{haskell.a}
\end{equation}
があり
\begin{equation}
  \hMaybeVar{v}
  =\hxFunc{g}\hMaybeVar{u}
\end{equation}
であるとしよう．このように $\hMaybeConstruct{haskell.a}$ で閉じた世界を仮に $\hMaybeConstruct{haskell.a}$ 世界と呼ぶことにする．

ここで，変数 $\hxVar{x},\hxVar{y}$ とMaybe変数 $\hMaybeVar{u},\hMaybeVar{v}$ はMaybe値コンストラクタによって
\begin{align}
  \hMaybeVar{u}
  &=\hJustWith{\hxVar{x}}\\
  \hMaybeVar{v}
  &=\hJustWith{y}
\end{align}
の関係にあるとしよう．値コンストラクタは値を $haskell.a$ 世界から $\hMaybeConstruct{haskell.a}$ 世界へとジャンプさせる機能を持っている．

他に $haskell.a$ 世界から $\hMaybeConstruct{haskell.a}$ 世界へジャンプさせるものがあるだろうか．よく考えてみると，マップ演算子もそうである．いま $\hMaybeVar{u}=\hJustWith{\hxVar{x}},\hMaybeVar{v}=\hJustWith{y}$ なのだから，$haskell.a$ 世界の関数 $\hxFunc{f}$ と $\hMaybeConstruct{haskell.a}$ 世界の関数 $\hxFunc{g}$ は無関係ではなく
\begin{equation}
  \hMaybeVar{v}
  =\hxFunc{g}\hMaybeVar{u}
  =\hxFunc{f}\hFunctorMap\hMaybeVar{u}
\end{equation}
であり，
\begin{equation}
  \hxFunc{g}
  =\hxFunc{f}\hFunctorMap
\end{equation}
である．つまりマップ演算子 $\hFunctorMap$ が関数 $\hxFunc{f}$ を $haskell.a$ 世界から $\hMaybeConstruct{haskell.a}$ 世界へとジャンプさせているのである．

いま「世界」と呼んだものを，数学者は#keyword[圏}と呼ぶ．圏とは#keyword[対象}と#keyword[射}の組み合わせである．本書では「対象」とは型のことであり，射とは関数だと思えば良い．（厳密にはコンテナに入れられた関数も射に含まれる．）そして，圏から圏へとジャンプさせるものを#keyword[関手}と呼ぶ．この例で言えば値コンストラクタ $\hJustWith{\hxVar{x}}$ とマップ演算子 $\hFunctorMap$ が関手である．値コンストラクタ $\hJustWith{\hxVar{x}}$ は $haskell.a\hFunctionArrow\hMaybeConstruct{haskell.a}$ という型を持ち，マップ演算子 $\hFunctorMap$ は $(haskell.a\hFunctionArrowhaskell.b)\hFunctionArrow(\hMaybeConstruct{haskell.a}\hFunctionArrow\hMaybeConstruct{b})$ という型を持つ．#footnote[関手は英語でファンクター(functor)と言うが，\cxx の関数オブジェクト (function object) もかつてはファンクター(functor)と呼ばれていた．\cxx のファンクターとはクロージャの代用品のことで，本書で述べる関手とは異なる概念である．混同しないように注意しよう．}

同じことはリストにも言える．値コンストラクタ $[\hxVar{x}]$ とマップ演算子 $\hMap$ もまた関手である．この場合値コンストラクタは $haskell.a\hFunctionArrow\hListConstruct{haskell.a}$ という型を持ち，マップ演算子も同じく $(haskell.a\hFunctionArrowhaskell.b)\hFunctionArrow(\hListConstruct{haskell.a}\hFunctionArrow[haskell.b])$ という型を持つ．

\separator

Haskellではマップ演算子が定義された型を関手（型）と呼ぶ．具体的には，マップ演算子が定義された全ての型は $\hFunctor$ 型クラスのインスタンスであるとする．つまり，$\hFunctor$ 型クラスには一般化されたマップ演算子が定義されており，そのインスタンスであるリストやMaybeは独自のマップ演算子を定義しなければならないということである．

一般化されたマップ演算子を $\mMap$ で表そう．この $\mMap$ 演算子は
\begin{equation}
  (\mMap)
  \hIsTypeOf{}\hFunctor
  \hHasElementsOf\mTypeConstructor{f}
  \hAndThen(haskell.a\hFunctionArrowhaskell.b)
  \hFunctionArrow\mPolymorphicTypeAssemble{f}{a}
  \hFunctionArrow\mPolymorphicTypeAssemble{f}{b}
\end{equation}
という型を持つ．ここに $\hFunctor\hHasElementsOf\mTypeConstructor{f}$ は，$\mTypeConstructor{f}$ が $\hFunctor$ 型クラスに属すという制約を表している．また $\mTypeConstructor{f}$ は型コンストラクタであり，$\mPolymorphicTypeAssemble{f}{a}$ は $\mTypeConstructor{f}$ 型コンストラクタと$haskell.a$ 型によって作られたコンテナ型である．

もし型コンストラクタがリスト型コンストラクタであれば，つまり $\mTypeConstructor{f}=\mListTypeConstructor$ であれば
\begin{equation}
  (\hMap)
  \hIsTypeOf{}(haskell.a\hFunctionArrowhaskell.b)\hFunctionArrow\hListConstruct{haskell.a}\hFunctionArrow[haskell.b]
\end{equation}
であるし，もし型コンストラクタがMaybe型コンストラクタであれば，つまり
$\mTypeConstructor{f}=\hMaybe$ であれば
\begin{equation}
  (\hFunctorMap)
  \hIsTypeOf{}(haskell.a\hFunctionArrowhaskell.b)\hFunctionArrow\hMaybeConstruct{haskell.a}\hFunctionArrow\hMaybeConstruct{b}
\end{equation}
である．

リストとMaybeは両者ともマップ演算子（と値コンストラクタ）を持つ．両者の関係をまとてみたのが表\ref{tab:list-and-maybe}である．オブジェクト指向プログラマなら，リストとMaybeに共通のスーパークラスを設計したくなるであろう．それが型クラス $\hFunctor$ である．

\begin{table*}
\label{tab:list-and-maybe}
\caption{リストとMaybeの関係}
\begin{center}
\begin{tabular}{||c|c|c|c||}\hline
型&型コンストラクタ&マップ&値コンストラクタ\\\hline\hline
$\hListConstruct{haskell.a}$&$\mListTypeConstructor$&$\hMap$&$[\hxVar{x}]$\\
$\hMaybeConstruct{haskell.a}$&$\hMaybe$&$\hFunctorMap$&$\hJustWith{\hxVar{x}},haskell.Nothing$\\\hline
\end{tabular}
\end{center}
\end{table*}

% \section{$\hFunctor$ 型クラス}

% 我々はオブジェクト指向プログラミングよりもエレガントな方法で，リスト
% とMaybeの共通項をくくりだすことにする．いよいよ型クラスの出番である．

% リスト型 $\hListConstruct{haskell.a}$ もMaybe型 $\hMaybeConstruct{haskell.a}$ も
% $\hFunctor$ 型クラスに属すのであった．そこで
% $\hFunctor$ 型クラスは#keyword[一般マップ演算子} $(\mMap)$
% を持つものとする．一般マップ演算子は，リスト型であれば $\hMap$
% 演算子に，Maybe型であれば $\hFunctorMap$ 演算子にオーバーライドされる．

% ---

% 一般マップ演算子 $(\mMap)$ は#keyword[多様的}である．この意味は，も
% し $\hxFunc{f}\mMap\hListVar{x}$ と書いてあれば $\hxFunc{f}\hMap\hListVar{x}$ のことであ
% るし，もし $\hxFunc{f}\mMap\hMaybeVar{u}$ と書いてあれば $\hxFunc{f}\hFunctorMap\hMaybeVar{u}$
% のことであると自動的に解釈することである．そして，何の飾りもつけられ
% ていない変数 $\hxVar{x}$ がふらっと現れ，目の前に $\hxFunc{f}\mMap x$という式が登場し
% ても，落ち着いて変数 $\hxVar{x}$ の型を調べ，変数 $\hxVar{x}$ がリストならば $\mMap$
% の部分に $\hMap$ を，変数 $\hxVar{x}$ がMaybeならば $\mMap$ の部分に
% $\hFunctorMap$ をはめ込むのだ．#footnote[Haskellでは一般マップ演算子
% $(\mMap)$ は \code{fmap} である．ただしその実装は与えられず，対象と
% する型に応じて定義されるものとする．例えばリストに対しては
% \code{fmap = map} と定義されている．}

% \section{アプリカティブ関手}

マップ演算子をさらに汎用性のあるものにするために新しく考え出された演算子が#keyword[アプリカティブマップ演算子}である．

いま関数のリスト $[\hxFunc{f},\hxFunc{g},\mHFunc]$ と変数のリスト $[\hxVar{x},\hxVar{y},\hxVar{z}]$ があるとする．リストのアプリカティブマップ演算子 $haskell.appMapList$ を次のように定義する．
\begin{equation}
  [\hxFunc{f},\hxFunc{g},\mHFunc]haskell.appMapList[\hxVar{x},\hxVar{y},\hxVar{z}]
  =[\hxFunc{f}\hxVar{x},\hxFunc{f}\hxVar{y},\hxFunc{f}\hxVar{z},\hxFunc{g}\hxVar{x},\hxFunc{g}\hxVar{y},\hxFunc{g}\hxVar{z},\mHFunc\hxVar{x},\mHFunc\hxVar{y},\mHFunc\hxVar{z}]
\end{equation}
リストのアプリカティブマップ演算子はこのように，左引数のリスト内のすべての関数を順番に右引数のリスト内の変数に適用し，その結果をリストとして返す．

リストのアプリカティブマップ演算子 $haskell.appMapList$ の型は
$[haskell.a\hFunctionArrowhaskell.b]\hFunctionArrow\hListConstruct{haskell.a}\hFunctionArrow[haskell.b]$ である．これは
\begin{equation}
  haskell.appMapList
  \hIsTypeOf\underbrace{[haskell.ahaskell.apstohaskell.b]}_{[\hxFunc{f}_0,\hxFunc{f}_1\dotsb \hxFunc{f}_n]}
  haskell.apsto\underbrace{\hListConstruct{haskell.a}}_{[\hxVar{x}_0,\hxVar{x}_1\dotsb \hxVar{x}_n]}
  haskell.apsto\underbrace{[haskell.b]}_{[\hxFunc{f}_0\hxVar{x}_0,\hxFunc{f}_0\hxVar{x}_1\dotsb \hxFunc{f}_0\hxVar{x}_n,\hxFunc{f} \hxVar{x}_0,\hxFunc{f} \hxVar{x}_1\dotsb \hxFunc{f}_n\hxVar{x}_n]}
\end{equation}
と解釈すれば良い．

リストバージョンのアプリカティブマップ演算子 $(haskell.appMapList)$ の特別な場合として，左引数のリストの要素数が1の場合を考えると
\begin{equation}
  [\hxFunc{f}]haskell.appMapList{}[\hxVar{x},\hxVar{y},\hxVar{z}]
  =[\hxFunc{f}\hxVar{x},\hxFunc{f}\hxVar{y},\hxFunc{f}\hxVar{z}]
\end{equation}
であり，通常のマップ演算子 $(\hMap)$ を使ったマップすなわち
\begin{equation}
  \hxFunc{f}\hMap{}[\hxVar{x},\hxVar{y},\hxVar{z}]
  =[\hxFunc{f}\hxVar{x},\hxFunc{f}\hxVar{y},\hxFunc{f}\hxVar{z}]
\end{equation}
と右辺が一致する．つまり，マップ演算子はアプリカティブマップ演算子の特別な場合と考えることができる．実際，リストマップ演算子はアプリカティブマップ演算子から
\begin{equation}
  \hxFunc{f}\hMap\hListVar{x}
  =[\hxFunc{f}]haskell.appMapList\hListVar{x}
\end{equation}
と定義できる．

Maybeバージョンについても考えてみよう．Maybeに包まれた関数 $\hMaybeVar{i}$ をMaybeな変数 $\hMaybeVar{u}$ にマップするアプリカティブマップ演算子
$haskell.appMapMaybe$ を
\begin{equation}
  \hMaybeVar{i}haskell.appMapMaybe\hMaybeVar{u}
  =\hCaseSyntax{\hMaybeVar{i}}
  \begin{cases}
    \hJustWith{j}
    &\hIfSo\mJFunc\hFunctorMap\hMaybeVar{u}\\
    \_
    &\hIfSohaskell.Nothing
  \end{cases}
\end{equation}
% \begin{equation}
% \hMaybeVar{i}haskell.appMapMaybe\hMaybeVar{u}
% =\begin{cases}
% \hJustWith{\hxFunc{f}\hxVar{x}}
% &\mIf\left(\hMaybeVar{i}\hIfEq\hJustWith{f}\right)
% \hLogicalAnd
% \left(\hMaybeVar{u}\hIfEq\hJustWith{\hxVar{x}}\right)\\
% haskell.Nothing&\hOtherwise
% \end{cases}
% \end{equation}
で定義する．このMaybeバージョンのアプリカティブマップ演算子 $(haskell.appMapMaybe)$ からMaybeバージョンのマップ演算子 $(\hFunctorMap)$ は
\begin{equation}
  \hxFunc{f}\hFunctorMap\hMaybeVar{u}
  =\hJustWith{f}haskell.appMapMaybe\hMaybeVar{u}
\end{equation}
のように導出できる．

これらの関係を一般化して
\begin{equation}
  \label{eq:general-applicative-map}
  \hxFunc{f}\mMap\mVarContainer{w}
  =\mPureWith{f}haskell.appMap\mVarContainer{w}
\end{equation}
となるような#keyword[一般アプリカティブマップ演算子} $(haskell.appMap)$ を考える．ここに $\hxFunc{f}$ は関数，$\mVarContainer{w}$ はリストやMaybeといったコンテナ型の変数すなわち#keyword[コンテナ変数}である．一般アプリカティブマップ演算子 $(haskell.appMap)$ から一般マップ演算子 $(\mMap)$ を導き出すには，式\eqref{eq:general-applicative-map} のように値コンストラクタが必要である．この一般化された値コンストラクタを#keyword[ピュア演算子}と呼ぶ．アプリカティブマップ演算子とピュア演算子を持つ型クラスを#keyword[アプリカティブ関手}と呼び，$haskell.applicativeTypeClass$ 型クラスと定義する．#footnote[Haskellでは一般アプリカティブマップ演算子を \code{<*>} と書く．}

ピュア演算子をピュア値コンストラクタと呼ばないのは，単純に「ピュア値」というものがないからである．$\hFunctor$ 型クラスはリスト型やMaybe型を抽象化したものであって，直接変数を生成できない．型クラスは，\cxx の用語で言えば純粋仮想クラスのようなものであるし，\objectivec の用語で言えばメタクラスであるからである．もちろんリストのピュア演算子は $[x]$ であるし，Maybeのピュア演算子は $\hJustWith{\hxVar{x}}$ であり，それぞれ具体的な変数を生成する．しかし変数 $\hxVar{x}$ にピュア演算子を適用した
$\mPureWith{x}$ は抽象的な概念であり，そのような変数は実在しない．#footnote[Haskellは一般のピュア演算子の実装を与えていない．変数の型に応じて対応する関数が適用される．}

一般アプリカティブマップ演算子 $(haskell.appMap)$ は多様性によってそれぞれリストバージョンのアプリカティブマップ演算子 $(haskell.appMapList)$ やMaybeバージョンのアプリカティブマップ演算子 $(haskell.appMapMaybe)$ にオーバーライドされ，それぞれリスト値コンストラクタ $([x])$, Maybe値コンストラクタ $(\hJustWith{\hxVar{x}})$ を用いることでリストバージョンのマップ演算子 $(\hMap)$, Maybeバージョンのマップ演算子 $(\hFunctorMap)$ を生成することができる．リスト値コンストラクタ，Maybe値コンストラクタはそれぞれピュア演算子 $(\mPureWith{x})$ をオーバーライドしたものであるから，結局，一般アプリカティブマップ演算子とピュア演算子のふたつがあれば，任意のクラスのマップ演算子を生成することができる．

アプリカティブマップ演算子，ピュア演算子に一般化されたバージョンがあるように，リストの ${\hEmptyList}$ やMaybeの $haskell.Nothing$ を一般化した値が必要である．それを $\mPureNothing$ とする．$\mPureNothing$ には特段名前が無いので，本書では単に「空」と呼ぶことにしよう．

\separator

この節の最後に#keyword[アプリカティブスタイル}という記法を紹介しておこう．アプリカティブマップ演算子は連続して
\begin{equation}
  \label{eq:applicative-style}
  \mVarContainer{w}
  =\mPureWith{f}haskell.appMap\mVarContainer{u}haskell.appMap\mVarContainer{v}
\end{equation}
のように使える．もし $\mVarContainer{u}\hIfEq\mPureNothing$ もしくは $\mVarContainer{v}\hIfEq\mPureNothing$ であれば式の値は $\mPureNothing$ になる．式\eqref{eq:applicative-style}からピュア演算子を消すには，最初のアプリカティブマップ演算子をマップ演算子に置き換えて
\begin{equation}
  \mVarContainer{w}=\hxFunc{f}\mMap\mVarContainer{u}haskell.appMap\mVarContainer{v}
\end{equation}
とすれば良い．このようにアプリカティブマップ演算子を並べる書き方をアプリカティブスタイルと呼ぶ．

% \section{関手としての関数}

関数は関手である．関手とはマップ演算子を持つ型クラスのことであった．そこで，関数がどのようなマップ演算子を持つのか考えてみる．

いま関数 $\hxFunc{f}$ が
\begin{equation}
  \hxFunc{f}
  \hIsTypeOf\mR\hFunctionArrowhaskell.a
\end{equation}
という型を持っているとする．この式は $\hFunctionArrow$ を二項演算子，すなわち2引数関数とみなせば
\begin{equation}
  \hxFunc{f}
  \hIsTypeOf(\hFunctionArrow)\mR\,haskell.a
\end{equation}
と等価である．全く形式的に，$\mFuncTypeConstructor$ なる型コンストラクタがあるとして
\begin{equation}
  \mR\hFunctionArrowhaskell.a=\mFuncTypeConstructorhaskell.a
\end{equation}
であると考えてみる．型 $haskell.a$ から型コンストラクタ $\mFuncTypeConstructor$ によって型 $(\mProjEXP{\mR}{haskell.a})$ が作られると考えるのだ．#footnote[Haskellでは $\mFuncTypeConstructor$ を \code{((->)r)} と書く．}

マップ演算子の型は，$\mFuncTypeConstructorhaskell.a=\mFuncType{a}$ とすると
% $\mFuncTypeConstructorhaskell.a=\mPolymorphicTypeAssemble{\mFuncTypeConstructor}{haskell.a}$ とすると
\begin{equation}
  (\mMap)
  \hIsTypeOf{}\hFunctor\hHasElementsOf\mTypeConstructor{f}
  \hAndThen(haskell.a\hFunctionArrowhaskell.b)
  \hFunctionArrow\mFuncType{a}
  \hFunctionArrow\mFuncType{b}
\end{equation}
であって，関数のマップ演算子を $\mMapFunc$ とすると
\begin{equation}
  (\mMapFunc)
  \hIsTypeOf{}(haskell.a\hFunctionArrowhaskell.b)
  \hFunctionArrow\mFuncType{a}
  \hFunctionArrow\mFuncType{b}
\end{equation}
であり，これはすなわち
\begin{equation}
  (\mMapFunc)
  \hIsTypeOf{}(haskell.a\hFunctionArrowhaskell.b)
  \hFunctionArrow(\mR\hFunctionArrowhaskell.a)
  \hFunctionArrow(\mR\hFunctionArrowhaskell.b)
\end{equation}
のことである．

いま関数 $\hxFunc{f}\hIsTypeOf\mProjEXP{\mR}{haskell.a }$ とは別な関数 $g\hIsTypeOf\mProjEXP{haskell.a }{haskell.b }$ があったとしよう．関数 $\hxFunc{f}$ と関数 $\hxFunc{g}$ の合成 $\hxFunc{g}\hCompose\hxFunc{f}$ の型は
\begin{equation}
\hxFunc{g}\hCompose\hxFunc{f}\hIsTypeOf\mProjEXP{\mR}{haskell.b }
\end{equation}
であるから，
\begin{equation}
(\hCompose)\hIsTypeOf{}\mProjEXP{\mProjEXP{(\mProjEXP{haskell.a }{haskell.b })}{(\mProjEXP{\mR}{haskell.a })}}
  {(\mProjEXP{\mR}{haskell.b })}
\end{equation}
である．つまり関数のマップ演算子 $(\mMapFunc)$ と関数の合成演算子 $(\hCompose)$ は同じ型を持つ．

幸い，我々は関数のマップ演算子の実装に関しては，型さえ守っていれば（そして第\ref{ch:monad}章で述べる関手則さえ守っていれば）自由に選べる．そこで
\begin{equation}
  \hxFunc{g}\mMapFunc\hxFunc{f}
  =\hxFunc{g}\hCompose\hxFunc{f}
\end{equation}
としておこう．これは
\begin{equation}
  \hxFunc{g}\mMapFunc\hxFunc{f}
  =\hxLambdaSyntax{\hxVar{x}}{\hxFunc{g}(\hxFunc{f}\hxVar{x})}
\end{equation}
と書いても同じことである．これが Haskellにおける関数のマップ演算子の定義である．

\separator

関数はアプリカティブ関手でもある．アプリカティブ関手には，アプリカティブマップ演算子とピュア演算子が定義されるのであった．そこで，関数版のアプリカティブマップ演算子を $haskell.appMapFunc$ とし，関数版のピュア演算子を $\mConstWith{x}$ と書くことにしよう．

ピュア演算子は $\mProjEXP{haskell.a }{(\mProjEXP{\mR}{haskell.a })}$ 型を持たなければならない．従って関数版のピュア演算子は変数から関数を作るとも考えられる．我々は関数版のピュア演算子として
\begin{equation}
  \mConstWith{x}
  =\hxLambdaSyntax{\_}{\hxVar{x}}
\end{equation}
を採用する．#footnote[Haskellでは $\mConstWith{x}$ を \code{const x} と書く．}

関数版のアプリカティブマップ演算子を $haskell.appMapFunc$ とすると，その型は
\begin{equation}
  (haskell.appMapFunc)
  \hIsTypeOf\mFuncType{haskell.a\hFunctionArrowhaskell.b}
  \hFunctionArrow\mFuncType{haskell.a}
  \hFunctionArrow\mFuncType{haskell.b}
\end{equation}
つまり
\begin{equation}
  (haskell.appMapFunc)
  \hIsTypeOf{}(\mR\hFunctionArrowhaskell.a\hFunctionArrowhaskell.b)
  \hFunctionArrow(\mR\hFunctionArrowhaskell.a)
  \hFunctionArrow(\mR\hFunctionArrowhaskell.b)
\end{equation}
である．

我々は関数版アプリカティブマップ演算子として
\begin{equation}
\hxFunc{g}haskell.appMapFunc\hxFunc{f}=\hxLambdaSyntax{\hxVar{x}}{\hxFunc{g}\hxVar{x}(\hxFunc{f}\hxVar{x})}
\end{equation}
とする．これは，関数版のピュア演算子の定義と，一般マップ演算子と一般アプリカティブマップ演算子の関係 $\hxFunc{f}\mMap\mVarContainer{w}=\mPureWith{f}haskell.appMap\mVarContainer{w}$ から導かれる．すなわち
\begin{align}
\mConstWith{g}haskell.appMapFunc\hxFunc{f}
&=\hxLambdaSyntax{\hxVar{x}}{\mConstWith{g}\hxVar{x}(\hxFunc{f}\hxVar{x})}\\
&=\hxLambdaSyntax{\hxVar{x}}{(\hxLambdaSyntax{\_}{\hxFunc{g}})\hxVar{x}(\hxFunc{f}\hxVar{x})}\\
&=\hxLambdaSyntax{\hxVar{x}}{\hxFunc{g}(\hxFunc{f}\hxVar{x})}\\
&=\hxFunc{g}\hCompose\hxFunc{f}
\end{align}
であるからである．

% \section{余談：アプリカティブマップ演算子の実装}

リストとMaybeのアプリカティブマップ演算子は，それぞれのマップ演算子から定義することができる．リストのアプリカティブマップ演算子の定義は次の通り．
\begin{equation}
  \left\{
  \begin{aligned}
    {\hEmptyList}haskell.appMapList\hListVar{x}
    &={\hEmptyList}\\
    (f:\hListVar{f})haskell.appMapList\hListVar{x}
    &=\mJoinList{}((\hxFunc{f}\hMap\hListVar{x}):(\hListVar{f}haskell.appMapList\hListVar{x}))
  \end{aligned}
  \right.
\end{equation}
ここに $(f:\hListVar{f})$ は関数のリストであり， $\hListVar{x}$ はリスト変数である．

Maybeのアプリカティブマップ演算子の定義は次の通り．
\begin{equation}
\label{eq:maybe-applicative-map-by-maybe-map}
\hMaybeVar{g}haskell.appMapMaybe\hMaybeVar{u}
=\hCaseSyntax{\hMaybeVar{g}}
\begin{cases}
\hJustWith{h}&\hIfSo h\hFunctorMap\hMaybeVar{u}\\
\_&\hIfSohaskell.Nothing
\end{cases}
\end{equation}
ここに $\hMaybeVar{g}$ はMaybeコンテナに入れられた関数，$\hMaybeVar{u}$ はMaybe変数である．
% 式\eqref{eq:maybe-applicative-map-by-maybe-map}を展開すると
% \begin{align}
% \hMaybeVar{h}haskell.appMapMaybe\hMaybeVar{u}
% &=\begin{cases}
% \left\{
% \begin{array}{ll}
% \hJustWith{\hxFunc{f}\hxVar{x}}&\mIf\hMaybeVar{u}\hIfEq\hJustWith{\hxVar{x}}\\
% haskell.Nothing&\hOtherwise
% \end{array}\right\}
% &\mIf\hMaybeVar{h}\hIfEq\hJustWith{f}\\
% haskell.Nothing&\hOtherwise
% \end{cases}\\
% &=\begin{cases}
% \hJustWith{\hxFunc{f}\hxVar{x}}&\mIf\left(\hMaybeVar{u}\hIfEq\hJustWith{\hxVar{x}}\right)\hLogicalAnd\left(\hMaybeVar{h}\hIfEq\hJustWith{f}\right)\\
% haskell.Nothing&\hOtherwise
% \end{cases}
% \end{align}
% である．

\section{この章のまとめ*}

\begin{enumerate}
\item ...
\end{enumerate}

\chapter{モナド*}
\label{ch:monad}

\section{バインド演算子}

一般マップ演算子をピュア演算子と一般アプリカティブマップ演算子に分解することで，式の見通しを良くすることができるアプリカティブスタイルという記法を採用できた．アプリカティブスタイルでは
\begin{equation}
  \hxFunc{f}\mMap\mVarContainer{u}haskell.appMap\mVarContainer{v}haskell.appMap\mVarContainer{w}
\end{equation}
という風にコンテナ変数 $\mVarContainer{u},\mVarContainer{v},\mVarContainer{w}$ に関数 $\hxFunc{f}$ を適用させることができる．コンテナ変数 $\mVarContainer{u},\mVarContainer{v},\mVarContainer{w}$ のいずれかが $\mPureNothing$ であれば式全体の値が$\mPureNothing$ になる．これは3個の計算を並列に行って，その結果をそれぞれ $\mVarContainer{u},\mVarContainer{v},\mVarContainer{w}$ に入れておき，最後に関数 $\hxFunc{f}$ に投げるという#keyword[計算構造}を具現化したものである．（関数 $\hxFunc{f}$ はCで言えば \code{main} 関数に相当するであろう．）

しかしながら，アプリカティブスタイルでは変数に文脈を与えるタイミングがコンテナ変数を作るときのそれぞれ1回に限られている．そこで，任意のタイミングで変数に文脈を与えられるように，別な方法で一般マップ演算子を分解してみよう．

Maybeの例を思い出そう．Maybe型の変数 $\hMaybeVar{u}$ はラップされた値 $\hJustWith{\hxVar{x}}$ を持つのか，エラーを表す $haskell.Nothing$ を持つのかを選べる．そこで，引数 $\hxVar{x}$ をとり何らかの計算をする関数 $\hxFunc{g}$ を考えよう．この関数 $\hxFunc{g}$ は引数 $\hxVar{x}$ の値次第ではエラーを表す $haskell.Nothing$ を返す．例えば
\begin{equation}
  \begin{aligned}
    \hxFunc{g}\hxVar{x}&\hGuard{x\neq0}=\hJustWith{1/x}\\
    &\hGuard{\hOtherwise}=haskell.Nothing
  \end{aligned}
\end{equation}
といった関数が考えられる．変数 $\hxVar{x}$ は文脈を持っていないが，関数 $\hxFunc{g}$ を適用した結果である $\hxFunc{g}\hxVar{x}$ は文脈を持っていることに注意しよう．いま $\hxFunc{g}\hxVar{x}$ はMaybeという文脈を持っているから，我々は
\begin{equation}
\hMaybeVar{v}=\hxFunc{g}\hxVar{x}
\end{equation}
という風に結果をMaybe変数に保存しなければならない．今まで見てきた $y=\hxFunc{f}\hxVar{x}$ や $\hMaybeVar{v}=\hxFunc{f}\hFunctorMap\hMaybeVar{u}$ の関係とは異なることに注意しよう．

関数 $\hxFunc{g}$ の型は
\begin{equation}
  g\hIsTypeOf\mProjEXP{haskell.a }{\hMaybeConstruct{haskell.a}}
\end{equation}
である．ということは，関数 $\hxFunc{g}$ をMaybe変数に適用させるようと思っても，我々が既に知っているマップ演算子 $\hFunctorMap$ やアプリカティブマップ演算子 $haskell.appMapMaybe$ が使えないということである．前者は第1引数に $\mProjEXP{haskell.a }{haskell.b }$ 型の関数を取るし，後者は第1引数に $\hJustWith{(\mProjEXP{haskell.a }{haskell.b })}$ 型の関数（Maybe関数）を取るからである．

% ***CHECK***

そこで，新しいマップ演算子を発明する．いまMaybe変数 $\hMaybeVar{u}$ を $\hMaybeVar{u}=\hJustWith{\hxVar{x}}$ としよう．新しいマップ演算子 $haskell.bindMaybe$ を使って
\begin{equation}
  \hMaybeVar{v}=\hxFunc{g}haskell.bindMaybe\hMaybeVar{u}
\end{equation}
とする．この新しいマップ演算子 $haskell.bindMaybe$ のことをMaybeの#keyword[バインド演算子}と呼ぶ．ここで，もし計算が成功していたら $\hMaybeVar{v}=\hJustWith{\hxFunc{g}\hxVar{x}}$ であり，失敗していたら $\hMaybeVar{v}=haskell.Nothing$ である．

演算 $ghaskell.bindMaybe\hMaybeVar{u}$ の結果はMaybe値であるから，バインド演算子は連続して用いることができる．通常の引数を取ってMaybe値を返すもう一つの関数 $h$ があるとすると
\begin{equation}
  \hMaybeVar{v}=hhaskell.bindMaybe{}(ghaskell.bindMaybe\hMaybeVar{u})
\end{equation}
のように連続して関数を適用できる．バインド演算子は右結合するので，上式は
\begin{equation}
  \label{eq:maybe-z-bind-style}
  \hMaybeVar{v}=hhaskell.bindMaybe ghaskell.bindMaybe\hMaybeVar{u}
\end{equation}
のように簡潔に書ける．このスタイルなら演算子もすべて統一できていて，かつどの関数でも戻り値を $haskell.Nothing$ に切り替えられるので，アプリカティブスタイルよりも強力と言える．

具体例で考えてみよう．関数 $\hxFunc{g}$ を
\begin{equation}
  \begin{aligned}
    \hxFunc{g}\hxVar{x}&\hGuard{x\neq0}=\hJustWith{1/x}\\
    &\hGuard{\hOtherwise}=haskell.Nothing
  \end{aligned}
\end{equation}
とする．また，関数 $h$ を
\begin{equation}
  \begin{aligned}
    hy&\hGuard{-\frac{\pi}{2}<y<\frac{\pi}{2}}=\hJustWith{\tan y}\\
    &\hGuard{\hOtherwise}=haskell.Nothing
  \end{aligned}
\end{equation}
とする．このとき $\hMaybeVar{u}=\hJustWith{4/\pi}$ とすると
\begin{equation}
\hMaybeVar{v}=hhaskell.bindMaybe ghaskell.bindMaybe\hMaybeVar{u}
\end{equation}
の計算結果として $\hMaybeVar{v}=\hJustWith{1}$ を得る．一方で $\hMaybeVar{u}=\hJustWith{0},\hMaybeVar{u}=\hJustWith{1/\pi},u=haskell.Nothing$ などの場合は $\hMaybeVar{v}=haskell.Nothing$ となり，計算できなかったという結果を得る．

% バインド演算子は向きを反転させても良い．式
% \eqref{eq:maybe-z-bind-style}は\begin{equation}
% \hMaybeVar{z}=\hMaybeVar{x}haskell.bindMaybe\phihaskell.bindMaybe\psi \end{equation}と
% 書いてもよく，矢印の向きを考慮する場合は $haskell.bindLeftMaybe$ を
% #keyword[左バインド演算子}，$haskell.bindRightMaybe$ を#keyword[右バインド
% 演算子}と呼ぶ．

というわけで，$haskell.applicativeTypeClass$ 型クラスをさらに拡張して，一般のバインド演算子を持たせることを考えてみよう．我々はこの新しい型クラスを#keyword[モナド}型クラスと呼び $\mMonadTypeClass$ で表す．

\section{モナド}

$\hFunctor$ 型クラスは一般マップ演算子 $(\mMap)$ を持っていた．$haskell.applicativeTypeClass$ 型クラスはピュア演算子 $(\mPureWith{x})$ と一般アプリカティブマップ演算子 $(haskell.appMap)$ を持っており，このふたつの演算子から一般マップ演算子を合成できた．新しい $\mMonadTypeClass$ 型クラスは，#keyword[一般バインド演算子} $(haskell.bind)$ とピュア演算子を持つものとしよう．後で見るように，一般アプリカティブマップ演算子はピュア演算子と一般バインド演算子から合成できる．#footnote[Haskellには最初に関手が導入され，その次に関手を拡張する形でモナドが導入された．そしてその次に，関手を拡張しなおす形でアプリカティブ関手が導入された．それゆえ，モナドとアプリカティブ関手には概念的重複があるにもかかわらず，別々に定義されるという悲劇が暫くの間続いた．アプリカティブ関手のピュア演算子と，モナドのピュア演算子は概念的に同じものであるにもかかわらず，別々の演算子として定義されていたのである．この状態は GHC v7.10 以降で，モナドがアプリカティブ関手を拡張する形に改められたことで解消した．ただし，かつて「モナド版のピュア演算子」としてモナドに「ユニット演算子」が定義されていたことから，ピュア演算子のことをユニット演算子と呼ぶ場合がある．}

関数 $i$ が次の形をしているとする．
\begin{equation}
  \label{eq:def-of-i}
  ix=\hCaseSyntax{\hxVar{x}}\begin{cases}
    \mLovelyVar
    &\hIfSo\mPureWith{\hxFunc{f}\hxVar{x}}\\
    \_
    &\hIfSo\mPureNothing
  \end{cases}
\end{equation}
ここに $\hxVar{x}$ は非コンテナ変数で，関数 $\hxFunc{f}$ も「普通の」（コンテナに入っていない）関数である．より厳密に言えば $\hxVar{x}\hIsTypeOfhaskell.a$ かつ $\hxFunc{f}\hIsTypeOfhaskell.a\hFunctionArrowhaskell.b$ である．従って，関数 $\mVarContainer{i}$ の型は $haskell.a\hFunctionArrow\mPureType{b}$ である．条件 $\mLovelyVar$ には任意の値を入れてよい．

関数 $i$ をコンテナに入った変数 $u=\mPureWith{x}$ に適用させるのが一般バインド演算子 $(haskell.bind)$ の役割である．計算結果をコンテナ変数 $a$ に格納するとすると，関数 $i$ のコンテナ変数 $\mVarContainer{u}$ への適用は
\begin{equation}
\label{eq:i-love-u}
\mVarContainer{a}=ihaskell.bind\mVarContainer{u}
\end{equation}
と書ける．うまく行けば $\mVarContainer{a}=\mPureWith{\hxFunc{f}\hxVar{x}}$ となるし，そうでなければ $\mVarContainer{a}=\mPureNothing$ となる．

さて $\mVarContainer{u}=\mPureWith{x},\mVarContainer{v}=\mPureWith{y}$ として，かつ $y=\hxFunc{f}\hxVar{x}$ であるとき
\begin{equation}
\mVarContainer{v}=\hxFunc{f}\mMap\mVarContainer{u}=\mPureWith{f}haskell.appMap\mVarContainer{u}
\end{equation}
であった．

\TK{CHECK}

式\eqref{eq:def-of-i}から $ix=\mPureWith{\hxFunc{f}\hxVar{x}}$ すなわち $i=\mPureWith{f\hxAnonParam}$ の関係を抜き出すと式\eqref{eq:i-love-u}は
\begin{equation}
\mVarContainer{a}=\mPureWith{f\hxAnonParam}haskell.bind\mVarContainer{u}
\end{equation}
となる．いま $y=\hxFunc{f}\hxVar{x}$ であったから $\mVarContainer{a}=\mVarContainer{v}$ であり，最終的に
\begin{equation}
\mVarContainer{v}
=\hxFunc{f}\mMap\mVarContainer{u}
=\mPureWith{f}haskell.appMap\mVarContainer{u}
=\mPureWith{f\hxAnonParam}haskell.bind\mVarContainer{u}
\end{equation}
を得る．これが一般バインド演算子と一般アプリカティブマップ演算子，一般マップ演算子の関係である．

\separator

\TK{To be written.}

リストモナド

\begin{equation}
  \mPureWith{x}
  =[x]
\end{equation}

\begin{equation}
  f
  \hIsTypeOf{}haskell.a\hFunctionArrow\hListConstruct{haskell.a}
\end{equation}

\begin{equation}
  fhaskell.bind\hListVar{x}
  =\mJoinList(\hxFunc{f}\hMap\hListVar{x})
\end{equation}

Maybeモナド

\begin{equation}
  \mPureWith{x}
  =\hJustWith{\hxVar{x}}
\end{equation}

\begin{equation}
  f
  \hIsTypeOfhaskell.a\hFunctionArrow\hMaybeConstruct{haskell.a}
\end{equation}

\begin{equation}
  fhaskell.bind\hMaybeVar{u}
  =\hCaseSyntax{\hMaybeVar{u}}
  \begin{cases}
    \hJustWith{\hxVar{x}}
    &\hIfSo\hJustWith{\hxFunc{f}\hxVar{x}}\\
    \_
    &\hIfSohaskell.Nothing
  \end{cases}
\end{equation}

\separator

\TK{To be written.}
\begin{equation}
  fhaskell.bindComp g
  =\hxFunc{f}haskell.bind(g\hxAnonParam)
\end{equation}


\section{関手則・アプリカティブ関手則・モナド則}

関手，アプリカティブ関手，モナドにはそれぞれ従う規則がある．これらは自然法則ではなく，定義である．

関手の一般マップ演算子 $(\mMap)$ は次の規則に従う．
\begin{enumerate}
\item 単位元の存在: $\mId\mMap u=u$
\item 合成則: $(f\hCompose g)\mMap=(\hxFunc{f}\mMap)\hCompose{}(g\mMap)$%=\hxFunc{f}\mMap{}(g\mMap\hxAnonParam)$
\end{enumerate}
ただし関数 $\mId$ は $\mId x=x$ で定義される．もちろん $\mId=\hxAnonParam$ と定義しても同じである．

% https://en.wikibooks.org/wiki/Haskell/The_Functor_class#The_functor_laws

例えば $\mId\mMap\hListVar{x}$ は $\mId\hListVar{x}$ であり，結局は $\hListVar{x}$ である．単位元の存在とは，そのような関数 $\mId$ があるという規則である．

合成則のほうは $\hListVar{x}=[x]$ を例に考えるとわかりやすく，
\begin{align}
  ((\hxFunc{f}\mMap)\hCompose(g\mMap))\hListVar{x}
  &=(\hxFunc{f}\mMap{}(g\mMap\hxAnonParam))\hListVar{x}\\
  &=\hxFunc{f}\mMap{}(g\mMap\hListVar{x})\\
  &=\hxFunc{f}\mMap{}[\hxFunc{g}\hxVar{x}]\\
  &=[(f\hCompose g)x]\\
  &=(f\hCompose g)\mMap{}[x]\\
  &=(f\hCompose g)\mMap\hListVar{x}
\end{align}
のような関係を一般化したものだと考えれば良い．

合成則はHaskellコンパイラによって最適化のために積極的に使われる．

\separator

アプリカティブ関手の一般アプリカティブマップ演算子 $(haskell.appMap)$ およびピュア演算子は次の規則に従う．
\begin{enumerate}
\item 単位元の存在: $\mPureWith{\mId}haskell.appMap u=u$
\item 準同型則: $\mPureWith{f}haskell.appMap\mPureWith{x}=\mPureWith{\hxFunc{f}\hxVar{x}}$
\item 合成則: $\mPureWith{(\hCompose)}haskell.appMap\phihaskell.appMap\psihaskell.appMap v=\phihaskell.appMap{}(\psihaskell.appMap v)$
\item 交換則: $\varphihaskell.appMap\mPureWith{y}=\mPureWith{(\hApply y)}haskell.appMap\varphi$
% \item $\hxFunc{f}\mMap=\mPureWith{f}haskell.appMap$ --- （上述の四つの法則から導かれる）
\end{enumerate}
% https://en.wikibooks.org/wiki/Haskell/Applicative_functors#Applicative_functor_laws
ここでも $\mId=\hxAnonParam$ である．

アプリカティブマップ演算子の準同型則は $w=\mPureWith{\hxFunc{f}\hxVar{x}}$ とした時に，
\begin{equation}
\begin{matrix}
&x&\xrightarrow{\mPureWith{\dotsb}}&\mPureWith{x}\\
f&\Big\downarrow&&\Big\downarrow&\mPureWith{f}haskell.appMap\\
&\hxFunc{f}\hxVar{x}&\xrightarrow{\mPureWith{\dotsb}}&w
\end{matrix}
\end{equation}
のように $\hxVar{x}$ からスタートして，どちらのルートを辿っても $w$ に行き着くという意味である．

アプリカティブマップ演算子の合成則も注釈が必要であろう．仮に $\phi=\mPureWith{g},\psi=\mPureWith{h},v=\mPureWith{z}$ とすると，合成則の左辺は
\begin{align}
\mPureWith{(\hCompose)}haskell.appMap\phihaskell.appMap\psihaskell.appMap v
&=\mPureWith{(\hCompose)g}haskell.appMap\psihaskell.appMap v\\
&=\mPureWith{(\hCompose)gh}haskell.appMap v\\
&=\mPureWith{\hxFunc{g}\hCompose\mHFunc}haskell.appMap v\\
&=\mPureWith{\hxFunc{g}\hCompose\mHFunc\hxVar{z}}
\end{align}
となる一方，合成則の右辺は
\begin{align}
\phihaskell.appMap{}(\psihaskell.appMap v)
&=\phihaskell.appMap\mPureWith{hz}\\
&=\mPureWith{\hxFunc{g}\hCompose\mHFunc\hxVar{z}}
\end{align}
となり一致する．合成則とは，このような関係が満たされるように一般アプリカティブマップ演算子を定義しておきなさいという意味だ．

\separator

モナドの一般バインド演算子 $(haskell.bind)$ は次の規則に従う．
\begin{enumerate}
\item 右単位元の存在: $ihaskell.bind{}\mPureWith{x}=ix$
\item 左単位元の存在: $\mPureWith{\mId}haskell.bind u=u$
\item 結合則: $ihaskell.bind{}(jhaskell.bind v)=(ihaskell.bind{}(j\hxAnonParam))haskell.bind v$
  % または $ihaskell.bind{}(jhaskell.bind v)=(ihaskell.bindComp j)haskell.bind v$
\end{enumerate}
% https://wiki.haskell.org/Monad_laws
% https://en.wikibooks.org/wiki/Haskell/Category_theory#The_monad_laws_and_their_importance

結合則についてのみ解説しておこう．
\begin{equation}
ihaskell.bind\mPureWith{z}=\mPureWith{fz},\,
jhaskell.bind\mPureWith{z}=\mPureWith{gz},\,
v=\mPureWith{y}
\end{equation}
とすると
\begin{align}
ihaskell.bind(jhaskell.bind v)&=ihaskell.bind\mPureWith{gy}\\
&=\mPureWith{f(gy)}\\
&=\mPureWith{f\hCompose gy}
\end{align}
である一方，$k=ihaskell.bind{}(j\hxAnonParam)$ とすると
\begin{align}
kz&=(ihaskell.bind(j\hxAnonParam))z\\
&=ihaskell.bind(jz)\\
&=\mPureWith{f(gz)}\\
&=\mPureWith{f\hCompose gz}
\end{align}
であるから
\begin{equation}
k=ihaskell.bind{}(j\hxAnonParam)=\mPureWith{f\hCompose g\hxAnonParam}
\end{equation}
を得る．ここで
\begin{align}
\mPureWith{f\hCompose g\hxAnonParam}haskell.bind v
&=(f\hCompose g)\mMap v\\
&=\mPureWith{f\hCompose gy}
\end{align}
であるから，結合則
\begin{align}
  ihaskell.bind{}(jhaskell.bind v)
  &=(ihaskell.bind{}(j\hxAnonParam))haskell.bind v\\
  &=(ihaskell.bindComp j)haskell.bind v
\end{align}
を得ることになる．

\begin{figure*}
\begin{center}
\includegraphics[width=100mm]{fig/functor.eps}
\end{center}
\caption{...}
\label{fig:functor}
\end{figure*}

% \section{IOモナド*}

\begin{table*}
\label{tab:monadplus}
\caption{型と型クラスの関係}
\begin{center}
\begin{tabular}{||c||c|c|c|c|c|c||}
\hline
\multirow{4}{*}{型$\backslash$型クラス}
  &\multicolumn{6}{|c||}{$\mMonadPlusTypeClass$}\\
\cline{2-7}
\multirow{3}{*}{}
  &\multicolumn{4}{|c|}{$\mMonadTypeClass$}
  &\multicolumn{2}{|c||}{$\mMonoidTypeClass$}\\
\cline{3-5}
\multirow{2}{*}{}
  &
  &\multicolumn{3}{|c|}{$haskell.applicativeTypeClass$}
  &\multicolumn{2}{|c||}{}\\
\cline{5-5}
\multirow{1}{*}{}
  &
  &\multicolumn{2}{|c|}{}
  &$\hFunctor$
  &\multicolumn{2}{|c||}{}\\
\hline\hline
一般モノイド
  &
  &
  &
  &
  &$\mZero$
  &$\hAnyBinOp$\\
\hline
整数
  &
  &
  &
  &
  &$\hxConstant{0}$
  &$+$\\
\hline
整数
  &
  &
  &
  &
  &$\hxConstant{1}$
  &$*$\\
\hline\hline
一般コンテナ
  &$haskell.bind$
  &$\mPureWith{x}$
  &$haskell.appMap$
  &$\mMap$
  &
  &\\
\hline
リスト
  &$haskell.bindList$
  &$[x]$
  &$haskell.appMapList$
  &$\hMap$
  &${\hEmptyList}$
  &$\hAppend$\\
\hline
Maybe
  &$haskell.bindMaybe$
  &$\hJustWith{\hxVar{x}}$
  &$haskell.appMapMaybe$
  &$\hFunctorMap$
  &$haskell.Nothing$
  &（$\hxVar{x}$ の型に依存）\\
\hline
関数
  &$haskell.bindFunc$
  &$\mConstWith{x}$
  &$haskell.appMapFunc$
  &$\mMapFunc$
  &$\hxAnonParam$
  &$\hCompose$\\
\hline
% \hline
% 記号
%   &\code{=<<}
%   &\code{pure}
%   &\code{fmap}
%   &\code{map}
%   &\\
% \hline
\end{tabular}
\end{center}
\end{table*}

\section{余談：モナドとしての関数}

関数はアプリカティブ関手であった．関数のピュア演算子とアプリカティブマップ演算子はそれぞれ
\begin{align}
\mConstWith{x}&=\hxLambdaSyntax{\_}{\hxVar{x}}\\
\hxFunc{g}haskell.appMapFunc\hxFunc{f}&=\hxLambdaSyntax{\hxVar{x}}{\hxFunc{g}\hxVar{x}(\hxFunc{f}\hxVar{x})}
\end{align}
であった．
% 関数ピュア演算子は，任意の引数 $\hxVar{x}$ を関数に置き換える．ただし，その関数は引数を捨てて元の変数 $\hxVar{x}$ を返す．例えば
% \begin{equation}
% x=\mFuncWith{x}y
% \end{equation}
% と，ダミー変数 $\hxVar{y}$ を使って中身の $\hxVar{x}$ を取り出せる．

関数のバインド演算子 $haskell.bindFunc$ を考えておこう．関数のバインド演算子は
\begin{equation}
ghaskell.bindFunc f=\hxLambdaSyntax{x}{g(\hxFunc{f}\hxVar{x})x}
\end{equation}
と定義する．ピュア演算子とバインド演算子から，関数のマップ演算子を
\begin{align}
\mConstWith{g\hxAnonParam}haskell.bindFunc f
&=\hxLambdaSyntax{x}{\mConstWith{g\hxAnonParam}(\hxFunc{f}\hxVar{x})x}\\
&=\hxLambdaSyntax{x}{\mConstWith{g(\hxFunc{f}\hxVar{x})}x}\\
&=\hxLambdaSyntax{x}{(\hxLambdaSyntax{\_}{g(\hxFunc{f}\hxVar{x})})x}\\
&=\hxLambdaSyntax{x}{g(\hxFunc{f}\hxVar{x})}\\
&=\hxFunc{g}\hCompose f\\
&=\hxFunc{g}\mMapFunc f
\end{align}
のように合成できる．

まとめると
\begin{align}
\mConstWith{x}&=\hxLambdaSyntax{\_}{x}\\
\hxFunc{g}\mMapFunc\hxFunc{f}&=\hxLambdaSyntax{x}{g(\hxFunc{f}\hxVar{x})}=\hxFunc{g}\hCompose f\\
\hxFunc{g}haskell.appMapFunc\hxFunc{f}&=\hxLambdaSyntax{x}{\hxFunc{g}\hxVar{x}(\hxFunc{f}\hxVar{x})}\\
ghaskell.bindFunc f&=\hxLambdaSyntax{x}{g(\hxFunc{f}\hxVar{x})x}
\end{align}
である．

% ***Reason***
% http://south37.hatenablog.com/entry/2014/04/27/Haskell%E3%81%AB%E3%81%8A%E3%81%91%E3%82%8B%E3%83%A2%E3%83%8A%E3%83%89
% https://ja.wikipedia.org/wiki/%E3%83%A2%E3%83%8A%E3%83%89_(%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0)

\separator

関数はモノイドとしての性質も持つ．関数 $\mId=\hxAnonParam$ とすると，任意の関数 $\hxFunc{f}$ に対して
\begin{equation}
\mId\hCompose f=\hxFunc{f}\hCompose\mId=\hxFunc{f}
\end{equation}
であるから，関数全体の集合を $\mFSet$ で表すと，組み合わせ $(\mFSet,\hCompose,\mId)$ はモノイドである．

モナドでありモノイドである型クラスを#keyword[モナドプラス}と呼ぶ．関数はモナドプラスである．

今まで出てきた型と型クラスの関係を表\ref{tab:monadplus}に示す．Maybeに関しては $haskell.a$ 型がモノイドである場合に限って $\hMaybeConstruct{haskell.a}$ 型もモノイドである．

\section{この章のまとめ*}

\begin{enumerate}
\item ...
\end{enumerate}

% http://itpro.nikkeibp.co.jp/article/COLUMN/20120110/378061/

\chapter{IO*}
\label{ch:io}

A...

\section{アクション}

計算機の状態を変えることを#keyword[副作用}と呼ぶ．副作用とは変数への破壊的代入に他ならない．例えば，計算機は画面やプリンタに何かを出力するが，それは画面やプリンタという「変数」を書き換えていることになる．また例えば擬似乱数の生成も副作用である．呼び出されるたびに異なる値を返す擬似乱数生成関数は，そのたびに計算機の内部状態を書き換えているのである．

副作用を持つ関数を#keyword[アクション}と呼ぶ．アクションは値を持つが，その値は計算の実行時までわからない．例えば擬似乱数を生成するアクション $\mRand$ があるとしよう．これを変数 $\alpha$ に
\begin{equation}
\alpha=\mRand
\end{equation}
と代入しても，変数 $\alpha$ に擬似乱数が代入されるわけではない．「擬似乱数を生成する」というアクションが $\alpha$ に代入されたのだ．

では，いつ「擬似乱数を生成する」アクションが実行されるのだろうか．それは，プログラムがまさに計算機の状態を変えるタイミング，つまりプログラムが実行されるタイミングなのである．そのためには，プログラムそのものをアクションで表しておかないといけない．我々はプログラム全体を $\omega$ で表すことにしよう．

プログラムが計算機状態を変える一例として，画面に値を出力することを考える．画面に値を出力するアクションを $\mPutStr$ と名付けよう．例えば次のプログラム例は，画面に ``Hello, world.'' と書き出すものとする．
\begin{equation}
\omega=\mPutStr s\mWhereIsEXP{s}{\mString{``Hello, world.''}}
\end{equation}
アクション $\mPutStr$ は変数を一つとり，その値を画面へ出力すなち破壊的代入を行う．では $\omega=\mPutStr\alpha$ とすればアクション $\alpha$ が実行されて，晴れて擬似乱数が生成され，その値が画面へ出力されるだろうか．もちろんそうはならないのである．

ここに $\alpha$ はアクションであり，変数ではない．一方で，アクション $\mPutStr$ は変数を受け取る．つまり，アクションから何らかの方法で値を「安全に」抜き取らないといけない．ここで安全性にこだわるのは，アクション $\alpha$ が副作用を持つからである．副作用を参照透過な変数へ伝播させてはいけない．副作用を持つアクションは，副作用を持つアクションへのみ受け継がれなければならない．

この話は何かと似ていないだろうか．そう，Maybeである．一度ゼロ除算の可能性に汚染されたコンテナ変数は，コンテナから出すことが許されないのである．Maybeを返す関数$\hxFunc{f}$の戻り値
\begin{equation}
  \begin{aligned}
    \hxFunc{f}\hxVar{x}&\hGuard{x\neq0}=\hJustWith{1/x}\\
    &\hGuard{\hOtherwise}=haskell.Nothing
  \end{aligned}
\end{equation}
を，別の関数
\begin{equation}
  gy=1+y
\end{equation}
に渡そうと思ったら，
\begin{equation}
  ghaskell.bind \hxFunc{f}\hxVar{x}
\end{equation}
のようにバインド演算子で合成しなければならなかった．

我々はアクションにもバインド演算子を拡張して，
\begin{equation}
  \omega=\mPutStrhaskell.bind\alpha
\end{equation}
とする．これは第\ref{ch:monad}章で見たバインド演算子と同じものである．同じバインド演算子が使えるカラクリは，次節で見ていくことにする．

\section{IOモナド}

ある関数 $c$ が引数を取らず，いつも決まった $haskell.Double$ 型の数を返すとしよう．そうすると，関数 $c$ の型は単純に $haskell.Double$ である．

呼び出すたびに異なる擬似乱数を返すアクション $\mRand$ もまた毎回 $haskell.Double$ 型の数を返す．そこで $\mRand$ も $haskell.Double$ 型としたいところだが，こちらは関数ではなくアクションである．そこを区別するために，$\mRand$ の型は $\mIODoubleType$ 型と $\mIOType{\dotsb}$ に入れ
て区別する．#footnote[Haskellでは $\mIODoubleType$ のことを \code{IO Double} と書く．}

呼び出しても何も返さないアクションはどのような型を持つべきだろう．何も返さない関数というものは無意味だが，アクションは副作用を持つので，何も返さないものがあっても良いのである．何も返さないことを「空っぽ」を返すと読み替えて，何も返さないアクションの型を $\mIOUnitType$ 型としよう．ここに $\mUnitType$ は「空っぽ」の意味で，ユニット型と読む．$\mIOUnitType$ 型のアクションの例は，画面に値を出力する $\mPutStr$ アクションである．#footnote[Haskellでは $\mIOUnitType$ のことを \code{IO ()} と書く．}

キーボードからの入力を受け取るアクションもある．そのアクションを $\mReadLn$ としよう．アクション $\mReadLn$ は文字列型を返すので，その型は $\mIOStringType$ である．#footnote[Haskellでは $\mIOStringType$ のことを \code{IO String} と書く．}

アクション $\mPutStr,\mReadLn,\mRand$ は計算機の状態を変化させる．アクション $\mPutStr,\mReadLn$ はOSのシステムコールを発行して，前者ならビデオメモリの値を書き換えるし，後者ならシリアルインタフェースの入力バッファをフラッシュする．アクション $\mRand$ は呼ばれるたびに内部のカウンタ値を一つ進める．これらのアクションは参照透過性を破壊する．そのために，プログラムの他の部分から隔離されねばならない．その隔離のメカニズムを提供するのがモナドである．

$\hListConstruct{haskell.a}$ 型が $haskell.a$ 型のリストであるように，$\mIOType{a}$ 型は $haskell.a$ 型の#keyword[IO}である．そしてリストがモナドであるように，IOもまたモナドである．モナドには，バインド演算子と，アプリカティブ関手から引き継いだピュア演算子の二つが必要であった．アプリカティブ関手から引き継いだアプリカティブマップ演算子はバインド演算子とピュア演算子の二つから合成できるし，関手から引き継いだマップ演算子もまたアプリカティブマップ演算子とピュア演算子から合成できるから，アプリカティブマップ演算子とマップ演算子は改めて実装しておく必要はない．

$\mIOUnitType$ 型の場合，ピュア演算子は何も返す必要がないから
\begin{equation}
\mPureWith{\_}=()
\end{equation}
であるとする．

% ここに $\hSingleTuppleWith{}$ は空のタプルで，「ユニット」と呼ぶ．一方で
% $\mIOUnitType$ 型のバインド演算子は，処理系の奥深くに隠されている．

% 実装依存である．


% http://tnomura9.exblog.jp/12069145/

\section{do記法}

モナドを使った書き方が従来のプログラムの記法からあまりにもかけ離れていることに，Haskellの設計者は気づいていたようで，Haskellには次に述べる#keyword[do記法}という記法が用意されている．このdo記法はもちろんシンタックスシュガーで，新しいことは何もない．

例えば $\omega=\mPutStrhaskell.bind\alpha\mWhereIsEXP{\alpha}{\mRand}$ をdo記法
を用いて書き直すと
\begin{equation}
\label{eq:do-print-random}
\omega=\mDo{a\mDoEq\mRand\mDoNext\mPutStr a}
\end{equation}
となる．ここで変数 $a$ は $\{\dotsb\}$ の中でだけ参照できる変数である．バインド演算子が副作用やゼロ除算汚染を中に閉じ込めたように，do記法の括弧は副作用や汚染を閉じ込める役割を果たす．#footnote[Haskellでは \code{omega = do \{ a <- rand; putStr
a \}} と書くか，または $\mDoNext$ を改行に置き換えて
\begin{verbatim}
  omega = do
    a <- rand
    putStr a
\end{verbatim}
と書く．}

ここで，同様なことをするPythonプログラムを見てみよう．
\begin{pythoncode}
\begin{verbatim}
import random
define main:
  a = random.random() # (1)
  print(a)            # (2)
\end{verbatim}
\end{pythoncode}
コード中の \code{(1)} の行で $a\mDoEq\mRand$ を実行し，\code{(2)} の行で $\mPutStr a$ を実行していると思えば，このコードと式\eqref{eq:do-print-random}の順序はそっくり同じである．もちろんこのdo記法はバインド演算子を使った式を切り貼りして，順序を入れ替えただけである．

do記法には $\mDoEq$ の他に，我々の $\mLetKeyword$ とよく似た $\mDoLetKeyword$ という構文が用意されている．この $\mDoLetKeyword$ は局所変数の導入に用いられて，例えば
\begin{equation}
\omega=\mDo{\mDoLet{y}{\hxFunc{f}\hxVar{x}}\mDoNext\alpha y}
\end{equation}
のように使う．

以下に，do記法を使った例を示す．
\begin{gather}
\mDo{\alpha x}=\alpha x\\
\mDo{y\mDoEq\alpha x\mDoNext\beta y}=\betahaskell.bind\alpha x\\
\mDo{\alpha x\mDoNext\beta y}=(\hxLambdaSyntax{\_}{\beta y})haskell.bind \alpha x\label{eq:do-alpha-beta}\\
\mDo{\mDoLet{y}{\hxFunc{f}\hxVar{x}}\mDoNext\alpha y}=\alpha y\mWhereIsEXP{y}{\hxFunc{f}\hxVar{x}}\\
\mDo{y\mDoEq\alpha x\mDoNext\mDoLet{z}{fy}\mDoNext\beta z}
=\betahaskell.bind{}(\hxFunc{f}\mMap\alpha x)
\end{gather}
より複雑な例も挙げる．
\begin{multline}
\mDo{y\mDoEq\alpha x\mDoNext y'\mDoEq\alpha'x'\mDoNext\mDoLet{z}{fyy'}
\mDoNext\beta z}\\
=\betahaskell.bind{}(\hxFunc{f}\mMap\alpha xhaskell.appMap\alpha'x')
\end{multline}
最後にdo記法中に変数を2回以上使いまわす例を示す．
\begin{multline}
\mDo{y\mDoEq\alpha x\mDoNext y'\mDoEq\alpha'x'\mDoNext\mDoLet{z}{fyy'}\mDoNext\beta z\mDoNext\mDoLet{z'}{f'yy'}\mDoNext\beta'z'}\\
=(\mLambda yy'\mLambdaArrow{}((\hxLambdaSyntax{\_}{\mLetInEXP{z}{fyy'}{\beta z}})\\
haskell.bind{}(\mLetInEXP{z'}{f'yy'}{\beta'z'}))) (\alpha x)(\alpha'x')
\end{multline}
この例では変数 $y,y'$ が2回使われている．

% なお $\mFuncWith{f}=\hxLambdaSyntax{\_}{f}$ の関係を用いると式\eqref{eq:do-alpha-beta}はより簡潔に
% \begin{equation}
% \mDo{\alpha x\mDoNext\beta y}=\mFuncWith{\beta y}haskell.bind\alpha x
% \end{equation}
% と書ける．

我々はバインド演算子を使った通常の記法とdo記法のいずれか読みやすい方を採用すれば良い．

% main =
% do
%   r <- rand
%   print r

% http://qiita.com/saltheads/items/6025f69ba10267bbe3ee

\separator

バインド演算子には，左右の引数を入れ替えた#keyword[右バインド演算子}がある．右バインド演算子は $haskell.bindRight$ と書き，
\begin{equation}
\alpha xhaskell.bindRight\beta=\betahaskell.bind\alpha x
\end{equation}
であるとする．#footnote[Haskellでは $\alpha xhaskell.bindRight\beta$ を \code{alpha x >>= beta} と書く．}

\section{余談：関数であるということ*}

IOモナドの変数は，たとえ値を読み出すだけであっても必ず関数適用が必要である．それは，IOモナドの変数が「自分が読み出されたこと」を知る必要があるからである．IOモナドの変数は，自分が読み出されたタイミングで副作用を発生させる．これは\objectivec や\swift に見られる getter メソッドと同じ考え方である．

IOモナドの変数値を読み出すために行われる関数呼び出しはダミーである場合があり，戻り値はしばしば捨てられる．

変数をダミーの関数で包み，それをさらにIOモナドで包んだのがIOモナド変数である．

もうひとつ，アクションが関数でなければならない理由がある．Haskellはいつも遅延評価を行うことを思い出してもらいたい．Pythonであれば，式は書かれた順に評価される．しかし，例えば
\begin{align}
y_1&=\hxFunc{f} \hxVar{x}_1\\
y_2&=\hxFunc{g} \hxVar{x}_2
\end{align}
という式があった場合，関数 $\hxFunc{f}$ と $\hxFunc{g}$ のどちらが先に評価されるか，あるいは同時に評価されるかはHaskellでは未定義である．Haskellで唯一計算順序が保証されているのは，関数適用である．例えば
\begin{equation}
y=\hxFunc{g}_2(g_1x)
\end{equation}
であれば，確実に関数 $g_1$ が関数 $g_2$ よりも先に評価される．

直列に評価したい関数の戻り値が，いつも次の関数の引数の型と一致しているとは限らないし，次の関数（アクション）が引数を取らない可能性もある．もし関数 $g_2$ が引数を取らなければ
\begin{equation}
\mConstWith{g_2}(g_1x)
\end{equation}
とする．この時，関数適用 $(g_1x)$ の結果は単純に捨てられる．
#footnote[Cでは \code{void} 型を返す関数 \code{void g1(int)} を引数を取らない関数 \code{int g2(void)} に「食わせる」ことが可能で，\code{g2(g1(x))} は正しいコードである．もっともCプログラマは \code{g1(x), g2()} という書き方の方を好むであろう．}

\separator

ふたつのアクション $\alpha_1,\alpha_2$ があり，アクション $\alpha_2$ が引数を取らない場合，その二つを合成するには
\begin{equation}
\label{eq:ignore-return}
\alpha_1 xhaskell.bindRight\mConstWith{\alpha_2}
\end{equation}
とする．式\eqref{eq:ignore-return}はしばしば
% \begin{equation}
% g_2\twoheadleftarrow g_1x=\mFuncWith{g_2}(g_1x)
% \end{equation}
% または
\begin{equation}
\alpha_1 xhaskell.bindRightIgnore\alpha_2=\alpha_1xhaskell.bindRight\mConstWith{\alpha_2}
\end{equation}
なる演算子 $haskell.bindRightIgnore$ を用いて記述される．#footnote[Haskellでは $\alpha_1xhaskell.bindRightIgnore\alpha_2$ を \code{alpha1 x >> alpha2} と書く．}

\section{この章のまとめ*}

\begin{enumerate}
\item do記法．
\end{enumerate}

\chapter{データ型の定義*}
\label{ch:data-type}

\section{データ型}

我々はしばしば新しい集合を考える必要に迫られる．例えば，イチ，ニ，サン，タクサンからなる集合
\begin{equation}
\mSet{Num}\mDefEq\{\mNumOne,\mNumTwo,\mNumThree,\mNumMany\}
\end{equation}
を考えることがあるだろう．集合 $\mSet{Num}$ の元 $n\hIsTypeOf\mSet{Num}$ は $\mNumOne$, $\mNumTwo$, $\mNumThree$, $\mNumMany$ のいずれかの値を取ることになる．

数学者は新しい集合を定義するが，Haskellプログラマは新しいデータ型を定義する．集合 $\mSet{Num}$ の定義の代わりに，我々はデータ型
$\mType{Num}$ を
\begin{equation}
  \mDataType\;\mType{Num}
  =\mNumOne\mValueOr\mNumTwo\mValueOr\mNumThree\mValueOr\mNumMany
\end{equation}
のように書いて定義するものとする．式の先頭にある $\mDataType$ は，この式がデータ型の定義であることを示すタグである．部分的にアンダーラインが引かれているのは，Haskellが $\mDataType$ を \code{data} と省略してしまうからである．これは不本意なことだが，文字数節約のために仕方ない．ここに $\mSet{Num}$ は型コンストラクタ，$\mNumOne$, $\mNumTwo$, $\mNumThree$, $\mNumMany$ は値コンストラクタである．#footnote[Haskellでは \code{data Num = One | Two | Three | Many} と書
  く．}

% 値コンストラクタを列挙したデータ型を#keyword[代数型}と呼ぶ．

この節で紹介したデータ型の定義はCで言う \code{enum} に近い．他にCで言う \code{struct} や \code{union} すなわち構造体や共用体もこの $\mDataType$ 文で定義できるが，これは次節で見ることにする．

\separator

新しいデータ型がある型クラスに属すとき，$\mDataType$ 文でそれを同時に宣言できる．例えば $\mType{Num}$ 型は同値演算子 $(\hIfEq)$ を持つことが自然である．型 $\mType{Num}$ が $\haskell.Eq$ 型クラスに属すとき，
\begin{equation}
  \mDataType\;
  \mType{Num}
  =\mNumOne\mValueOr\mNumTwo\mValueOr\mNumThree\mValueOr\mNumMany
  \mDeriving\haskell.Eq
\end{equation}
のように書く．#footnote[Haskellでは \code{data Num = One | Two | Three | Many deriving Eq} と書く．}

型 $\mType{Num}$ の同値演算子 $(\hIfEq)$ の実装は\ref{sec:type-class-and-instance}節で見ることにする．

\section{レコード構文}

データ型の定義では，値コンストラクタにパラメタを与えることもできる．例えば $\mType{Rectangle}$ という型を考えよう．この型は，始点の平面座標と幅，高さで合計4個の $haskell.Float$ のパラメタを取るものとする．このとき
\begin{multline}
  \label{eq:rectangle}
  \mDataType\;
  \mType{Rectangle}\\
  =\mValueWith{Rectangle}
  {haskell.Float\,haskell.Float\,haskell.Float\,haskell.Float}
  \mDeriving\haskell.Eq
\end{multline}
という風にデータ型の定義を行う．#footnote[Haskellでは \code{data Rectangle = Rectangle Float Float Float Float} と書く．}

$\mType{Rencatngle}$ 型の変数は次のように初期化する．
\begin{equation}
  \left\{
  \begin{aligned}
    r&\hIsTypeOf\mType{Rectangle}\\
    r&=\mValueWith{Rectangle}{1\,2\,3\,4}
  \end{aligned}
  \right.
\end{equation}
これはCで言う \code{struct} と似た用法である．#footnote[Haskellでは
\begin{verbatim}
  r :: Rectangle
  r = Rectangle 1 2 3 4
\end{verbatim}
と書く．}

$\mType{Rectangle}$ 型から中身を取り出すには，次のような関数を用意しておかねばならない．
\begin{align}
  x\,\mValueWith{Rectangle}{a\,\_\,\_\,\_}
  &=a\\
  y\,\mValueWith{Rectangle}{\_\,a\,\_\,\_}
  &=a\\
  width\,\mValueWith{Rectangle}{\_\,\_\,a\,\_}
  &=a\\
  height\,\mValueWith{Rectangle}{\_\,\_\,\_\,a}
  &=a
\end{align}
この面倒は，次のシンタックスシュガーを使うことで軽減される．
#footnote[Haskellでは
\begin{verbatim}
  x      Rectangle a _ _ _ = a
  y      Rectangle _ a _ _ = a
  width  Rectangle _ _ a _ = a
  height Rectangle _ _ _ a = a
\end{verbatim}
と書く．}

型 $\mType{Rectangle}$ のようにパラメタが多いときは，パラメタに名前があると便利である．そこで利用できるのが#keyword[レコード構文}である．レコード構文を使うと，式\eqref{eq:rectangle}は
\begin{multline}
  \mDataType\;\mType{Rectangle}\\
  =\mValueRecordBeginWith{Rectangle}
  x\hIsTypeOfhaskell.Float,
  y\hIsTypeOfhaskell.Float,
  width\hIsTypeOfhaskell.Float,
  height\hIsTypeOfhaskell.Float
  \mValueRecordEnd\\
  \mDeriving\haskell.Eq
\end{multline}
のように書き直すことができる．#footnote[Haskellでは
\begin{verbatim}
  data Rectangle = Rectangle {
      x      :: Float,
      y      :: Float,
      width  :: Float,
      height :: Float
    }
    deriving Eq
\end{verbatim}
と書く．}

レコード構文を用いると，型から中身を取り出す関数は自動的に定義される．また
\begin{equation}
  r=
  \mValueRecordWith{Rectangle}{
    x=1,
    y=2,
    width=3,
    height=4
  }
\end{equation}
のようなレコード構文専用の初期化を行っても良いし，従来の初期化方法を用いても良い．#footnote[Haskellでは\code{r = Rectangle \{ x = 1, y = 2, width = 3, height = 4 \}} と書く．}

\separator

データ型の定義には，複数の値コンストラクタを指定できる．そのため
\begin{multline}
\mDataType\;\mType{Shape}
=\mValueWith{Circle}{haskell.Float\,haskell.Float}\\
\mValueOr
\mValueWith{Triangle}{haskell.Float\,haskell.Float\,haskell.Float}
\end{multline}
のようなデータ型の定義も可能である．この例では型 $\mType{Shape}$ は値コンストラクタ $\mValueConstructor{Circle}$ または $\mValueConstructor{Triangle}$ によって初期化され，それぞれ2個または3個の $haskell.Float$ 型のパラメタを取る．#footnote[Haskellでは \code{data Shape = Circle Float Float | Triangle Float Float Float} と書く．}

\section{型クラスとインスタンス化}
\label{sec:type-class-and-instance}

型クラスとは，複数の型が持つ共通のインタフェースである．その複数の型をいま $haskell.a$ で表すこととして，型 $haskell.a$ が型クラス$\haskell.Eq$ に属すとしよう．型クラス $\haskell.Eq$ は等号$(\hIfEq)$ と不等号 $(\neq)$ をインタフェースとして持つ．このことを
\begin{equation}
  \mTypeClassDeclhaskell.athop{\haskell.Eq}\hHasElementsOfhaskell.a\mWhere{}
  \left\{
  \begin{aligned}
    &(\hIfEq)\hIsTypeOf\mProjEXP{haskell.a }{\mProjEXP{haskell.a }{haskell.Bool}}\\
    &(\neq)\hIsTypeOf\mProjEXP{haskell.a }{\mProjEXP{haskell.a }{haskell.Bool}}\\
    &x\hIfEq y=\neg(x\neq y)\\
    &x\neq y=\neg(x\hIfEq y)
  \end{aligned}
  \right.
\end{equation}
と書く．#footnote[Haskellでは$\mTypeClassDecl$ を \code{class} と書く．また $\hHasElementsOf$ を省略して，
\begin{verbatim}
  class Eq a where
    (==) :: a -> a -> Bool
    (/=) :: a -> a -> Bool
    x==y = not(x/=y)
    x/=y = not(x==y)
\end{verbatim}
と書く．}

\TK{$\mTypeClassDecl$ による具象型の型クラス宣言．}

ここで宣言したのは等号，不等号というインタフェースが「ある」という事だけで，その実装は未定義である．等号，不等号の実装は次に述べる $\mInstanceDecl$ 文を使う．

型クラス $\haskell.Eq$ に属す型 $haskell.a$ は等号と不等号を持つ．我々の型 $\mType{Num}$ が型クラス $\haskell.Eq$ に属すことを宣言し，型クラス $\haskell.Eq$ が備えるべき等号，不等号を実装するには
\begin{equation}
  \mInstanceDecl\;\haskell.Eq\hHasElementsOf\mType{Num}
  \mWhere{}
  \left\{
  \begin{aligned}
    \mNumOne\hIfEq\mNumOne&=haskell.True\\
    \mNumTwo\hIfEq\mNumTwo&=haskell.True\\
    \mNumThree\hIfEq\mNumThree&=haskell.True\\
    \mNumMany\hIfEq\mNumMany&=haskell.True\\
    \_\hIfEq\_&=haskell.False
  \end{aligned}
  \right.
\end{equation}
とする．これを#keyword[型クラスのインスタンス化}と呼ぶ．
#footnote[Haskellでは
\begin{verbatim}
  instance Eq Num where
    One==One     = True
    Two==Two     = True
    Three==Three = True
    Many==Many   = True
    _==_         = False
\end{verbatim}
と書く．}

\TK{$\mInstanceDecl$ による具象型のインスタンス宣言．}

型クラスは#keyword[継承関係}を持てる．型クラス $haskell.Ord$ は型クラス $\haskell.Eq$ から等号，不等号を継承し「小なりイコール」 $(\le)$ を追加する．
\begin{equation}
  \mTypeClassDecl\;\haskell.Eq\hHasElementsOfhaskell.a
  \hAndThenhaskell.athop{haskell.Ord}\hHasElementsOfhaskell.a
  \mWhere{}(\le)\hIsTypeOf\mProjEXP{haskell.a }{\mProjEXP{haskell.a }{haskell.Bool}}
\end{equation}
型クラス $haskell.Ord$ に属する型は，等号，不等号，小なりイコールと，それらから派生させることのできる大なり $(>)$，大なりイコール $(\ge)$，小なり $(<)$，および最大値をとる関数 $haskell.ax$ と最小値をとる関数 $\hIsTypeOf$を持つ．#footnote[Haskellでは
\begin{verbatim}
  class (Eq a) => Ord a where (<=) :: a -> a -> Bool
\end{verbatim}
と書く．}

\separator

型は複数の型クラスに同時に属すことができる．例えば型 $\mType{Num}$ は型クラス $\haskell.Eq$ と同時に型クラス $haskell.Ord$ に属すこともできる．それには
\begin{equation}
\mDataType\;\mType{Num}
=\mNumOne\mValueOr\mNumTwo\mValueOr\mNumThree\mValueOr\mNumMany
\mDeriving{}(\haskell.Eq,haskell.Ord)
\end{equation}
とする．#footnote[Haskellでは
\begin{verbatim}
  data Num = One | Two | Three | Many deriving (Eq, Ord)
\end{verbatim}
と書く．}

型クラス $haskell.Ord$ のインスタンスは小なりイコール演算子 $(\le)$ が定義されていなければならない．我々は
\begin{equation}
  \mInstanceDecl\;haskell.Ord\hHasElementsOf\mType{Num}
  \mWhere{}
  \left\{
  \begin{aligned}
    \mNumOne\le\mNumOne&=haskell.True\\
    \mNumOne\le\mNumTwo&=haskell.True\\
    \mNumOne\le\mNumThree&=haskell.True\\
    \mNumOne\le\mNumMany&=haskell.True\\
    \mNumTwo\le\mNumTwo&=haskell.True\\
    \mNumTwo\le\mNumThree&=haskell.True\\
    \mNumTwo\le\mNumMany&=haskell.True\\
    \mNumThree\le\mNumThree&=haskell.True\\
    \mNumThree\le\mNumMany&=haskell.True\\
    \mNumMany\le\mNumMany&=haskell.True\\
    \_\le\_&=haskell.False
  \end{aligned}
  \right.
\end{equation}
のように $\mType{Num}$ の $\le$ 演算子を定義することができる．

\section{余談：レンズ*}

\TK{Lens}

% \section{余談：型シノニム*}

---

\TK{Move to 12.4}

データ型には#keyword[シノニム}（別名）がつけられる．例えば $haskell.Char$ のリスト $[haskell.Char]$ は
\begin{equation}
  \mTypeSynonymDecl\;
  \mStringType
  =[haskell.Char]
\end{equation}
とすることで，別名 $\mStringType$ を与えることができる．Haskellでは$\mTypeSynonymDecl$ を \code{type} と省略してしまう．これは残念なことだが，Cの \code{typedef} のようなものだと思って割り切るしかない．#footnote[Haskellでは \code{type String = [Char]} と書く．}

\section{この章のまとめ*}

\begin{enumerate}
\item ...
\end{enumerate}

\begin{note}{メタクラス}
オブジェクト指向言語の多くが「クラス」と呼ぶものを，Haskellは「型」と呼ぶ．

% クラスのクラスをメタクラスと言う．

% メタクラスのクラスはメタメタクラスである．全てのメタクラスはメタメタクラスに属す．それ故，メタメタクラスもまたメタメタクラスに属す．
\end{note}


\chapter{多相型の定義*}
\label{ch:polymorphic-data-type}
...

\section{多相型}

Maybeのように型パラメタを取る型を#keyword[多相型}と呼ぶ．多相型はどのように定義されるかと言うと，
\begin{equation}
  \mDataTypePolymorphic\;
  \hMaybe\,haskell.a
  =\hJustWith{haskell.a}\mValueOrhaskell.Nothing
\end{equation}
のように，やはり $\mDataType$ を使って定義される．念のため型パラメタを取る場合は $\mDataTypePolymorphic$ と区別しておこう．#footnote[Haskellは $\mDataType$ と $\mDataTypePolymorphic$ を区別せず，$\mDataTypePolymorphic\;\hMaybehaskell.a=\hJustWith{haskell.a }\mValueOrhaskell.Nothing$ を \code{data Maybe a = Just a | Nothing} と書く．}
% この $\hJustWith{haskell.a}$ は $haskell.a$ のMaybe型 $(\hMaybeConstruct{haskell.a})$ という
% 意味ではなく，$haskell.a$ 型の変数を型コンストラクタ $\hJustWith{\dotsb}$
% に入れなさいという意味．

Maybeが型クラス $\haskell.Eq$ に属すものとして，$\haskell.Eq$ からのインスタンス化をしておこう．ここでも型パラメタ付きの $\mInstanceDecl$ を仮に $\mInstanceDeclPolymorphic$ とすると次のように書けそうである．
\begin{equation}
  \mInstanceDeclPolymorphic\;
  \haskell.Eq\hHasElementsOf{}(\hMaybe\,haskell.a)
  \mWhere
  \left\{
  \begin{aligned}
    \hJustWith{\hxVar{x}}\hIfEq\hJustWith{y}
    &=x\hIfEq y\\
    haskell.Nothing\hIfEqhaskell.Nothing
    &=haskell.True\\
    \_\hIfEq\_
    &=haskell.False
  \end{aligned}
  \right.
\end{equation}
残念ながら，この式は $haskell.a$ 型の変数 $\hxVar{x},\hxVar{y}$ の間に等号 $(\hIfEq)$ が定義されていることが隠れた前提になっているため，正しくない．我々は $haskell.a$ が型クラス $\haskell.Eq$ に属すことを要求するので，次のように言い換える．
\begin{multline}
\mInstanceDeclPolymorphic\;
\haskell.Eq\hHasElementsOfhaskell.a
\hAndThen
\haskell.Eq\hHasElementsOf{}(\hMaybe\,haskell.a )\\
\mWhere
\left\{
\begin{aligned}
\hJustWith{\hxVar{x}}\hIfEq\hJustWith{y}&=x\hIfEq y\\
haskell.Nothing\hIfEqhaskell.Nothing&=haskell.True\\
\_\hIfEq\_&=haskell.False
\end{aligned}
\right.
\end{multline}
この $\haskell.Eq\hHasElementsOfhaskell.a \hAndThen$ の部分が「以下 $haskell.a$ 型は $\haskell.Eq$ 型クラスに属すものとして」という意味になる．#footnote[Haskellでは
\begin{verbatim}
  instance Eq a => Eq (Maybe a) where
    Just x == Just y = x==y
    Nothing==Nothing = True
    _==_             = False
\end{verbatim}
と書く．}

Maybeの間に新たに定義された等号 $(\hIfEq)$ は次の型を持つ．
\begin{equation}
(\hIfEq)
\hIsTypeOf{}\haskell.Eq\hHasElementsOfhaskell.a
\hAndThen\mProjEXP{\hMaybeConstruct{haskell.a}}{\mProjEXP{\hMaybeConstruct{haskell.a}}{haskell.Bool}}
\end{equation}

\separator

多相型を定義するとき，型パラメタは2個以上与えられても良い．例えばEitherは次のように定義できる．
\begin{equation}
\mDataTypePolymorphic\;\hEither\,haskell.a \,haskell.b
=\hLeftWith{haskell.a }
\mValueOr
\hRightWith{haskell.b }
\end{equation}

\section{自己参照型}

型の定義中に自分自身を参照する型を#keyword[自己参照型}または
#keyword[再帰型}と呼ぶ．例えばリストは
\begin{equation}
\mDataTypePolymorphic\;\mListTypeConstructor\,haskell.a ={\hEmptyList}\mValueOrhaskell.a :\mListTypeConstructor\,haskell.a
\end{equation}
のように定義できる．

\section{関手の拡張}

\TK{Writing.}

\begin{equation}
  \mTypeClassDeclPolymorphic\;
  \hFunctor\hHasElementsOf\mTypeConstructor{f}
  \mWhere{}
  (\mMap)
  \hIsTypeOf{}(haskell.a\hFunctionArrowhaskell.b)
  \hFunctionArrow\mPolymorphicTypeAssemble{f}{a}
  \hFunctionArrow\mPolymorphicTypeAssemble{f}{b}
\end{equation}

\TK{$\mTypeClassDeclPolymorphic$ による型コンストラクタの型クラス宣言．}

型クラス $\hFunctor$ はマップ演算子 $(\mMap)$ を提供する．リ
スト型は $\hFunctor$ 型クラスのインスタンスなので，
\begin{equation}
  \mInstanceDeclPolymorphic\;
  \hFunctor\hHasElementsOf\mListTypeConstructor{}
  \mWhere{}
  (\mMap)
  =(\hMap)
\end{equation}
と定義する．#footnote[Haskellでは
\begin{verbatim}
  instance Functor [] where fmap = map
\end{verbatim}
と書く．}

\TK{$\mInstanceDeclPolymorphic$ による型コンストラクタのインスタンス宣言．}

\TK{Follow:} That's it! Notice how we didn't write instance Functor
   [a] where, because from fmap :: (a $haskell.apsto$ b) $haskell.apsto$ f a
   $haskell.apsto$ f b, we see that the f has to be a type constructor that
   takes one type. [a] is already a concrete type (of a list with any
   type inside it), while [] is a type constructor that takes one type
   and can produce types such as [Int], [String] or even [[String]].

Maybe型の場合は
\begin{equation}
  \mInstanceDeclPolymorphic\;
  \hFunctor\hHasElementsOf\hMaybe
  \mWhere\left\{
  \begin{aligned}
    \hxFunc{f}\mMap{}\hJustWith{\hxVar{x}}&=\hJustWith{\hxFunc{f}\hxVar{x}}\\
    \hxFunc{f}\mMaphaskell.Nothing&=haskell.Nothing
  \end{aligned}
  \right.
\end{equation}
となる．#footnote[Haskellでは
\begin{verbatim}
  instance Functor Maybe where
    fmap f (Maybe x) = Maybe (f x)
    fmap f Nothing = Nothing
\end{verbatim}
と書く．}

Either型の場合は
\begin{equation}
  \mInstanceDeclPolymorphic\;
  \hFunctor\hHasElementsOf{}(\hEither\,haskell.a)
  \mWhere{}
  \left\{
  \begin{aligned}
    \hxFunc{f}\mMap{}\hRightWith{x}&=\hRightWith{\hxFunc{f}\hxVar{x}}\\
    \hxFunc{f}\mMap{}\hLeftWith{x}&=\hLeftWith{x}
  \end{aligned}
  \right.
\end{equation}
となる．#footnote[Haskellでは
\begin{verbatim}
  instance Functor (Either a) where
    fmap f (Right x) = Right (f x)
    fmap f (Left x)  = Left x
\end{verbatim}
と書く．}

\TK{Multiple parameter extension.}

\section{余談: \code{newtype}*}

リストに新しいマップ演算子 $\mZip$ を定義したいとしよう．この演算子 $\mZip$ は
\begin{equation}
  [\hxFunc{f},\hxFunc{g},\mHFunc]\mZip[x,\hxVar{y},\hxVar{z}]
  =[\hxFunc{f}\hxVar{x},gy,hz]
\end{equation}
のように働くとする．新しいマップ演算子 $\mZip$ のことを我々は#keyword[ジップ演算子}と呼ぶことにする．

ジップ演算子を定義するにはどうしたら良いだろうか．汎用性を考えると，ジップ演算子もまたリストのアプリカティブマップ演算子であって欲しい．ところが，リストには既に $haskell.appMapList$ というアプリカティブマップ演算子が定義されている．念のためにアプリカティブマップ演算子を用いると
\begin{equation}
  [\hxFunc{f},\hxFunc{g},\mHFunc]haskell.appMapList[x,\hxVar{y},\hxVar{z}]
  =[\hxFunc{f}\hxVar{x},\hxFunc{f}\hxVar{y},\hxFunc{f}\hxVar{z},\hxFunc{g}\hxVar{x},\hxFunc{g}\hxVar{y},\hxFunc{g}\hxVar{z},\mHFunc\hxVar{x},\mHFunc\hxVar{y},\mHFunc\hxVar{z}]
\end{equation}
である．ある型のインスタンス化は一種類しか行えないので，リスト型に新しいアプリカティブマップ演算子を追加することは出来ない．

そこで $\mDataTypePolymorphic$ を使ってリスト型をラップした新しい型を作る．例えば新しい型を $\mZipListType{a}$ とすると
\begin{equation}
  \label{eq:data-type-ziplist}
  \mDataTypePolymorphic\;
  haskell.athop{\mZipListTypeConstructor}haskell.a
  =\mValueRecordWith{ZipList}{\mGetList\hIsTypeOf{}\hListConstruct{haskell.a}}
\end{equation}
のように定義することになる．念のため，左辺の $\mZipListTypeConstructor$ は型コンストラクタ，右辺の $\mValueConstructor{ZipList}$ は値コンストラクタである．すなわち
\begin{equation}
  \mZipListType{a}
  =\mZipListTypeConstructorhaskell.a
\end{equation}
である．

こうしておいて，あとは
\begin{multline}
  \mInstanceDeclPolymorphic\;
  \hFunctor\hHasElementsOf\mZipListTypeConstructor\\
  \mWhere
  \hxFunc{f}\mMap{}\mZipListWith{\hListVar{x}}=\mZipListWith{\hxFunc{f}\hMap\hListVar{x}}
\end{multline}
および
\begin{multline}
  \mInstanceDeclPolymorphic\;
  haskell.applicativeTypeClass\hHasElementsOf\mZipListTypeConstructor\\
  \mWhere
  \left\{
  \begin{aligned}
    \mPureWith{x}
    &=\mZipListWith{\mRepeat x}\\
    \mZipListWith{\hListVar{f}}haskell.appMap\mZipListWith{\hListVar{x}}
    &=\mZipListWith{\hListVar{f}\mZip\hListVar{x}}
  \end{aligned}
  \right.
\end{multline}
と定義する．ここで
\begin{equation}
  \label{eq:zip}
  \left\{
  \begin{aligned}
    (\mZip)\_{\hEmptyList}&={\hEmptyList}\\
    (\mZip){\hEmptyList}\_&={\hEmptyList}\\
    (\mZip)(\hxVar{x}:\hListVar{x})(y:\hListVar{y})&=(x\hApply y):\hListVar{x}\mZip\hListVar{y}
  \end{aligned}
  \right.
\end{equation}
であると定義する．

関数 $\mRepeat$ は引数を無限回繰り返すリストを返す関数である．念のため関数 $\mRepeat$ の実装方法を書いておくと
\begin{equation}
  \left\{
  \begin{aligned}
    &\mRepeat\hIsTypeOf{}\mProjEXP{\hListConstruct{haskell.a}}{\hListConstruct{haskell.a}}\\
    &\mRepeat x=\hxVar{x}:\mRepeat x
  \end{aligned}
  \right.
\end{equation}
である．

任意のリスト $\hListVar{x}$ と任意の関数リスト $\hListVar{f}$ ただし
\begin{align}
\hListVar{x}&=[\hxVar{x}_0,\hxVar{x}_1,\dotsb]\\
\hListVar{f}&=[\hxFunc{f}_0,\hxFunc{f},\dotsb]
\end{align}
の両方をそれぞれ値コンストラクタで包んでアプリカティブマップ演算子を適用すると
\begin{equation}
  \mZipListWith{\hListVar{f}}haskell.appMap\mZipListWith{\hListVar{x}}
  =[\hxFunc{f}_0\hxVar{x}_0,\hxFunc{f} \hxVar{x}_1,\dotsb]
\end{equation}
のようにジップ演算子を適用できる．

このままでも問題はないのだが，式\eqref{eq:data-type-ziplist}を次のように書き換えることがより好ましい．
\begin{equation}
  \mNewTypeDeclPolymorphic\;
  \mZipListTypeConstructorhaskell.a
  =\mZipListRecordWith{\mGetList\hIsTypeOf{}\hListConstruct{haskell.a}}
\end{equation}
やったことはキーワード $\mDataTypePolymorphic$ を
$\mNewTypeDeclPolymorphic$ に置き換えたことである．これは，字面に反して，型 $\mZipListType{a}$ が何一つ「新しくない」ことをHaskellコンパイラに伝えるためである．その結果Haskellコンパイラは型 $\mZipListType{a}$ に対する最適化の機会を得る．

\separator

式\eqref{eq:zip}にもう一段の抽象化をしておこう．関数 $\mZipWith$ を
\begin{equation}
  \left\{
  \begin{aligned}
    {}&\mZipWith\hIsTypeOf{}\mProjEXP{\mProjEXP{\mProjEXP{(\mProjEXP{haskell.a }
          {\mProjEXP{haskell.b }{\mC }})}
        {\hListConstruct{haskell.a}}}{[haskell.b]}}{[\mC]}\\
    {}&\left\{\begin{aligned}
    \mZipWith\_{\hEmptyList}\_
    &={\hEmptyList}\\
    \mZipWith\_\_{\hEmptyList}
    &={\hEmptyList}\\
    \mZipWith f(\hxVar{x}:\hListVar{x})(y:\hListVar{y})
    &=\hxFunc{f}\hxVar{x}\hxVar{y}:\mZipWith f\hListVar{x}\hListVar{y}
    \end{aligned}
    \right.
  \end{aligned}
  \right.
\end{equation}
と定義する．こうすれば，演算子 $\mZip$ は
\begin{equation}
  (\mZip)
  =\mZipWith(\hApply)
\end{equation}
と関数 $\mZipWith$ から定義できる．

関数 $\mZipWith$ を再帰的に定義したが，再帰をリストのマップ演算子に押し込むこともできる．それには
\begin{equation}
  \mZipWith f(\hxVar{x}:\hListVar{x})(y:\hListVar{y})
  =\hxFunc{f}'\hMap\hListVar{z}
  \mWhere
  \left\{
  \begin{aligned}
    f'
    &\mLetEq\hUncurry f\\
    \hListVar{z}
    &\mLetEq\mZipFunc\hListVar{x}\hListVar{y}
  \end{aligned}
  \right.
\end{equation}
と，先に $\mZipFunc$ 関数を定義しておいて，その後 $\mZipWith$ 関数を定義する．ここに $\mZipFunc$ 関数は
\begin{equation}
  \left\{
  \begin{aligned}
    {}&\mZipFunc\hIsTypeOf{}\mProjEXP{\hListConstruct{haskell.a}}
    {\mProjEXP{[haskell.b]}
      {(\hListConstruct{haskell.a},[haskell.b])}}\\
    {}&\mZipFunc \hxVar{x}\hxVar{y}=(x,y)
  \end{aligned}
  \right.
\end{equation}
であり，$\hUncurry$ 関数は
\begin{equation}
  \left\{
  \begin{aligned}
    {}&\hUncurry\hIsTypeOf{}
    \mProjEXP{(\mProjEXP{haskell.a }{\mProjEXP{haskell.b }{\mC }})}
          {\mProjEXP{(haskell.a ,haskell.b )}{\mC }}\\
          {}&\hUncurry f\hxVar{x}\hxVar{y}=\hxFunc{f}(x,y)
  \end{aligned}
  \right.
\end{equation}
である．#footnote[Haskellでは $\mZipWith$ 関数を
\begin{verbatim}
  zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
  zipWith f (\hxVar{x}:x_"s") (y:y_"s") = f' `map` zs where
    f' = uncurry f
    zs = zip x_"s" y_"s"
\end{verbatim}
と書ける．ただし \code{zipWith} は \filename{Prelude} から提供される．}

% http://haskell.g.hatena.ne.jp/hyuki/20060603/zipwith

\section{この章のまとめ*}

\begin{enumerate}
\item ...
\end{enumerate}

\chapter{カテゴリ*}
\label{ch:category}

\section{多値*}

Haskellの関数の引数は常にひとつであり，戻り値も常にひとつである．しか
し，複数の戻り値を返したい場合もある．例えば実数 $\hxVar{x}$ の平方根は
$\sqrt{x}$ および $-\sqrt{x}$ のふたつである．そこで次のような関数
$\mSqrts$ ただし
\begin{equation}
  \left\{
  \begin{aligned}
    &\mSqrts\hIsTypeOf{}haskell.Real\hHasElementsOfhaskell.a \hAndThen
    haskell.a\hFunctionArrow\hListConstruct{haskell.a}\\
    &\mSqrts x=[\mSqrt x,(-\mSqrt x)]
  \end{aligned}
  \right.
\end{equation}
を考えてみる．#footnote[Haskellでは
\begin{verbatim}
  sqrts :: Real a => a -> [a]
  sqrts = [sqrt x, (-sqrt x)]
\end{verbatim}
と書く．}

ここで型 $haskell.a\hFunctionArrow\hListConstruct{haskell.a}$ に別名を与えよう．別名を与えるには型シノニ
ムを定義する方法と，$\mNewTypeDecl$ を用いる方法とがある．前者は単に読
みやすさの向上のためだけであるが，後者は第\ref{ch:polymorphic-data-type}章
で見たように特定の型クラスの新しいインスタンスとしてその型を定義するた
めである．我々は後者を選択することにして
\begin{equation}
  \mNewTypeDecl\;
  \mTypeConstructor{NonDet}\,haskell.a\,haskell.b
  =\mValueRecordWith{NonDet}{\mRun\hIsTypeOfhaskell.a\hFunctionArrow[haskell.b]}
\end{equation}
とする．#footnote[Haskellでは
\begin{verbatim}
  newtype NonDet a b = NonDet { run :: a -> [b] }
\end{verbatim}
と書く．}

型コンストラクタ $\mTypeConstructor{NonDet}$ によって作られる型
$\mTypeAssemble{NonDet}{haskell.a\,haskell.b}$ は型 $haskell.a\hFunctionArrow\hListConstruct{haskell.a}$ とは異な
る型であるため，関数 $\mSqrts$ の新しいバージョンが必要になる．そこで
\begin{equation}
  \left\{
  \begin{aligned}
    &\mSqrts'
    \hIsTypeOfhaskell.Real\hHasElementsOfhaskell.a
    \hAndThen\mTypeAssemble{NonDet}{haskell.a\,haskell.a}\\
    &\mSqrts'
    =\mValueWith{NonDet}{\mSqrts}
  \end{aligned}
  \right.
\end{equation}
のように定義しよう．#footnote[Haskellでは
\begin{verbatim}
  sqrts' :: Real a => NonDet a a
  sqrts' = NonDet sqrts
\end{verbatim}
と書く．}

関数 $\mSqrts'$ はコンテナ $\mValueWith{NonDet}{\dotsb}$ に包まれ
ているので，
\begin{equation}
  y=\mRun\mSqrts'x
\end{equation}
のようにして呼び出さねばならない．#footnote[Haskellでは
\begin{verbatim}
  y = run sqrts' x
\end{verbatim}
と書く．}

次節から，多値を返す関数の適用と合成を一般化する．その前に用語の説明を
しておこう．複数の値を返す関数のうち，返す値の数が定まらないような関数
を#keyword[非決定的}な関数と呼ぶ．リストは一般に長さが定まらないので，
リストを返す関数は非決定的な関数である．

% https://practical-scheme.net/wiliki/wiliki.cgi?Scheme%3A多値

\section{カテゴリ*}

\TK{Writing.}

$\hFunctor$ は一般マップ演算子 $(\mMap)$ を共通のインタフェー
スとして持つ型を抽象化した型クラス．インスタンスであるリストの実装は
$\hMap$ を使う．

---

非決定的な関数 $\mDuplicate$ と $\mTriplicate$ を
\begin{equation}
  \left\{
  \begin{aligned}
    &\mDuplicate,\mTriplicate
    \hIsTypeOfhaskell.a\hFunctionArrow\hListConstruct{haskell.a}\\
    &\mDuplicate x
    =[x,x]\\
    &\mTriplicate x
    =[x,x,x]
  \end{aligned}
  \right.
\end{equation}
のように定義しよう．#footnote[Haskellでは
\begin{verbatim}
  duplicate, triplicate :: a -> [a]
  duplicate x = [x, x]
  triplicate x = [x, x, x]
\end{verbatim}
と書く．}

このふたつの関数 $\mDuplicate$ と $\mTriplicate$ をもし合成できるとし
たら，合成された関数は $\hxVar{x}$ を引数に取り $[x,x,x,x,x,x]$ を返すものと考
えるのが自然であろう．しかし，どのように合成したら良いだろうか．

いま欲しいのは，
\begin{equation}
  y
  =(\mTriplicate\mSomeOp\mDuplicate)x
\end{equation}
としたときに $y=[x,x,x,x,x,x]$ となるような合成演算子 $\mSomeOp$ であ
る．ここで関数合成演算子 $(\hCompose)$ が使えないことは明らかである．と言
うのも，関数 $\mTriplicate$ はリストを引数に取らないため
\begin{equation}
  \mTriplicate\hCompose\mDuplicate x
  =\mTriplicate[x,x]
  \dots\text{型エラー!}
\end{equation}
となってしまうからである．リストのマップ演算子 $(\hMap)$ を使うと
\begin{align}
  \mTriplicate\hMap{}(\mDuplicate x)
  &=\mTriplicate\hMap{}[x,x]\\
  &=[[x,x,x],[x,x,x]]
\end{align}
であるから，型エラーは回避できる．

このように検討していくと，このふたつの関数 $\mDuplicate$ と
$\mTriplicate$ は
\begin{equation}
  y
  =\mJoinList(\mTriplicate\hMap{}(\mDuplicate x))
\end{equation}
のように合成できることがわかる．これを関数合成演算子を使って分解すると
\begin{equation}
  \label{eq:triplicate-duplicate}
  y
  =\mJoinList\hCompose{}(\mTriplicate\hMap)\hCompose\mDuplicate\hApply x
\end{equation}
となり，少しは読みやすくなる．しかし，合成のたびに平坦化演算子
$(\mJoinList)$ やマップ演算子 $(\hMap)$ を書くのは煩雑であるし，3段以
上の合成になると手に負えなくなる．

そこで，関数合成をオーバーライドする方法が欲しくなる．関手のマップ演算
子 $(\mMap)$ は各々のインスタンスで独自にオーバーライドされていた．リ
ストのマップ演算子 $(\hMap)$ や Maybe のマップ演算子
$(\hFunctorMap)$ がそれらである．同じように，関数合成 $(\hCompose)$ も
一般化したものが欲しい．

それが#keyword[カテゴリ}の合成演算子 $(\mCompCat)$ である．カテゴリは
$\mCatTypeClass$ で表される型クラスである．

カテゴリ型クラスの定義に立ち入る前に，新しい表記を導入しておこう．これ
まで型 $haskell.a$ の引数をひとつ取り，型 $haskell.b$ の戻り値を返す関数の型を
$haskell.a\hFunctionArrowhaskell.b$ または $(\hFunctionArrow)haskell.ahaskell.b$ と書いてきた．これか
ら導入する型は，やはり型 $haskell.a$ の引数を取り，型 $haskell.b$ の戻り値を返す．
この新しい型を $haskell.a\mCatArrowChaskell.b$ または $(\mCatArrowC)haskell.ahaskell.b$ と書こ
う．ここに $\mTypeConstructor{c}$ は型コンストラクタであり，
カテゴリ型クラスのインスタンスである．型 $(\mCatArrowC)haskell.ahaskell.b$ の値は
関数ではなく#keyword[射}と呼ぶ．#footnote[Haskellでは
  $(\mCatArrowC)haskell.ahaskell.b$ を \code{c a b} と書く．}

カテゴリ型クラス $(\mCatTypeClass)$ は次のように定義されている．
\begin{equation}
  \mTypeClassDeclPolymorphic\;
  \mCatTypeClass\hHasElementsOf\mTypeConstructor{c}
  \mWhere\left\{
  \begin{aligned}
    \mIdCat
    &\hIsTypeOf\mX\mCatArrowC\mY\\
    (\mCompCat)
    &\hIsTypeOf{}(\mX\mCatArrowC\mY)\hFunctionArrow(\mX\mCatArrowC\mY)\hFunctionArrow(\mX\mCatArrowC\mY)
  \end{aligned}
  \right.
\end{equation}

---

\begin{equation}
  \mCatArrow{\mTypeConstructor{NonDet}}{}
  =haskell.a\hFunctionArrow\hListConstruct{haskell.a}
\end{equation}
としよう．#footnote[Haskellでは
\begin{verbatim}
  newtype NonDet = NonDet a -> [a]
  instance Category NonDet where ...
\end{verbatim}
と書く．\code{...} の部分は後述する．}

---

\begin{align}
  \mIdCat
  &\hIsTypeOf{}haskell.a\mCatArrowChaskell.b\\
  (\mCompCat)
  &\hIsTypeOf{}(haskell.b\mCatArrowC\mC)
  \hFunctionArrow(haskell.a\mCatArrowChaskell.b)
  \hFunctionArrow(haskell.a\mCatArrowC\mC)
\end{align}

e.g.

\begin{equation}
  haskell.a\mCatArrowChaskell.b
  =haskell.a\hFunctionArrow\hListConstruct{haskell.a}
\end{equation}

---


このような問題を解決するのが#keyword[カテゴリ}すなわち
$\mCatTypeClass$ 型クラスである．

$\mCatTypeClass$ 型クラスは次のように定義されている．
\begin{equation}
  \mTypeClassDeclPolymorphic\;
  \mCatTypeClass\hHasElementsOf\mTypeConstructor{c}
  \mWhere\left\{
  \begin{aligned}
    \mIdCat&\hIsTypeOf\mTypeConstructor{c}\,\mX\,\mX\\
    (\mCompCat)
    &\hIsTypeOf\mTypeConstructor{c}\,\mX\,\mY
    \hFunctionArrow\mTypeConstructor{c}\,\mX\,\mY
    \hFunctionArrow\mTypeConstructor{c}\,\mX\,\mY
  \end{aligned}
  \right.
\end{equation}
型パラメタ $\mTypeConstructor{c}$ が
$\mTypeConstructor{c}=(\hFunctionArrow)$ のとき$\mIdCat=\mId$ かつ
$\mCompCat=\hCompose$ になるので，圏は関数を何やら拡張したものであること
がわかる．

---

---

我々は $\mDuplicate$ や $\mTriplicate$ の型を考えて
\begin{equation}
  \mTypeConstructor{c}\,\mX\,\mY
  =\mX\hFunctionArrow[\mY]
\end{equation}
と考えてみよう．つまり
$\mTypeConstructor{c}=((\hFunctionArrow)\hxAnonParam[\hxAnonParam])$
と考えるわけである．

そうすると，まず $\mIdCat$ は $haskell.a\hFunctionArrow\hListConstruct{haskell.a}$ 型でなければならないか
ら
\begin{equation}
  \label{eq:id-category}
  \mIdCat
  =\mLambda x\mLambdaArrow[x]
\end{equation}
となる．

次に $(\mCompCat)$ であるが，$\mX=\mY$ とすると，型は
$(\mX\hFunctionArrow[\mX])\hFunctionArrow(\mX\hFunctionArrow[\mX])\hFunctionArrow(\mX\hFunctionArrow[\mX])$
であるから，式\eqref{eq:triplicate-duplicate}から
\begin{equation}
  \mTriplicate\mCompCat\mDuplicate
  =\mJoinList\hCompose{}(\mTriplicate\hMap)\hCompose\mDuplicate
\end{equation}
をそのまま抽象化して
\begin{equation}
  \label{eq:triplicate-duplicate-comp}
  f\mCompCat g=\mJoinList\hCompose{}(\hxFunc{f}\hMap)\hCompose g
\end{equation}
とすれば，そのまま使えそうである．

これで，我々の型コンストラクタ $\mTypeConstructor{NonDet}$ を
$\mCatTypeClass$ 型クラスのインスタンスにできる．ただし，式
\eqref{eq:id-category} ならびに式 \eqref{eq:triplicate-duplicate-comp}
は型 $\mTypeAssemble{NonDet}{haskell.a\,haskell.b}$ に対応していないので，次
のように値コンストラクタで包んだ上でインスタンス化を行う．
\begin{multline}
  \label{eq:nondet-instance}
  \mInstanceDeclPolymorphic\;
  \mTypeClass{Category}\hHasElementsOf\mTypeConstructor{NonDet}\\
  \mWhere\left\{
  \begin{aligned}
    \mIdCat
    &=\mValueWith{NonDet}{\hxLambdaSyntax{x}{[x]}}\\
    \mValueWith{NonDet}{f}\mCompCat\mValueWith{NonDet}{g}
    &=\mValueWith{NonDet}{\mJoinList\hCompose{}(\hxFunc{f}\hMap)\hCompose g}
  \end{aligned}
  \right.
\end{multline}
続けて，$\mTypeAssemble{NonDet}{haskell.a\,haskell.b}$ 型バージョンの
$\mDuplicate$ と $\mTriplicate$ を定義しておこう．
\begin{align}
  &\left\{
  \begin{aligned}
    &\mDuplicate'
    \hIsTypeOf\mTypeAssemble{NonDet}{haskell.a\,haskell.a}\\
    &\mDuplicate'
    =\mValueWith{NonDet}{\mDuplicate}
  \end{aligned}
  \right.\\
  &\left\{
  \begin{aligned}
    &\mTriplicate'
    \hIsTypeOf\mTypeAssemble{NonDet}{haskell.a\,haskell.a}\\
    &\mTriplicate'
    =\mValueWith{NonDet}{\mTriplicate}
  \end{aligned}
  \right.
\end{align}

これで，式\eqref{eq:triplicate-duplicate}は
\begin{equation}
  y=\mRun(\mTriplicate'\mCompCat\mDuplicate')x
\end{equation}
のようにシンプルに書き下すことができる．念のため右辺の括弧の中身を展開
しておくと
\begin{align}
  \mTriplicate'\mCompCat\mDuplicate'
  &=\mValueWith{NonDet}{\mTriplicate}\mCompCat\mValueWith{NonDet}{\mDuplicate}\\
  &=\mValueWith{NonDet}{\mJoinList\hCompose{}(\mTriplicate\hMap)\hCompose\mDuplicate}
\end{align}
である．

\separator

$\mCatTypeClass$ 型クラスは \filename{Control.Category}で
\begin{haskellcode}
\begin{verbatim}
class Category c where
  id  :: c x x
  (.) :: c y z -> c x y -> c x z
\end{verbatim}
\end{haskellcode}
と定義されており，\filename{Prelude} の \code{id} および \code{.} と名
前が衝突している．従って \code{Category} 型クラスの \code{id} および
\code{.} を使用する際は
\begin{haskellcode}
\begin{verbatim}
import Control.Category as Cat
\end{verbatim}
\end{haskellcode}
としておき，\code{Cat.id} および \code{Cat..} として使用する．なお
\code{Cat..} は \code{<<<} とも定義されている．

インスタンス化のことまで考えると，次のようにインポートしインスタンス化
するのが良いだろう．
\begin{haskellcode}
\begin{verbatim}
-- duplicate-triplicate.hs
import qualified Control.Category as Cat

newtype NonDet a b = NonDet { run :: a -> [b] }

instance Cat.Category NonDet where
  id                      = NonDet (\x -> [x])
  (NonDet f) . (NonDet g) = NonDet (concat . map f . g)

duplicate :: a -> [a]
duplicate x = [x, x]

triplicate :: a -> [a]
triplicate x = [x, x, x]

duplicate' :: NonDet a a
duplicate' = NonDet duplicate

triplicate' :: NonDet a a
triplicate' = NonDet triplicate

x = "Hello."
y = run (triplicate' Cat.. duplicate') x
\end{verbatim}
\end{haskellcode}

ところで，リストのバインド演算子 $(haskell.bindList)$ は
\begin{equation}
  fhaskell.bindList\hListVar{x}
  =\mJoinList{}(\hxFunc{f}\hMap\hListVar{x})
  \label{eq:leftleftarrows}
\end{equation}
であった．関数 $\hxFunc{f}$, $\hxFunc{g}$ が $\mValueWith{NonDet}{f}$,
$\mValueWith{NonDet}{g}$ として与えられることを考えると，関数 $\hxFunc{f}$, $\hxFunc{g}$
の型は $haskell.a\hFunctionArrow\hListConstruct{haskell.a}$ で確定するので，式\eqref{eq:leftleftarrows}
の中のバインド演算子 $(haskell.bind)$ はリストのバインド演算子
$(haskell.bindList)$ で確定する．

そこでリストのバインド演算子を用いると
\begin{align}
  \mJoinList\hCompose{}(\hxFunc{f}\hMap)\hCompose g
  &=\mLambda x\mLambdaArrow\mJoinList{}(\hxFunc{f}\hMap(\hxFunc{g}\hxVar{x}))\\
  &=\mLambda x\mLambdaArrow fhaskell.bindList(\hxFunc{g}\hxVar{x})\\
  &=\hxFunc{f}haskell.bindComp g
\end{align}
であるから，式\eqref{eq:nondet-instance}の2行目は
\begin{equation}
  \mValueWith{NonDet}{f}\hCompose\mValueWith{NonDet}{g}
  =\mValueWith{NonDet}{fhaskell.bindComp g}
\end{equation}
とも書ける．改めて式\eqref{eq:nondet-instance}を書き直すと
% pureも説明!!
\begin{multline}
  \mInstanceDeclPolymorphic\;
  \mCatTypeClass\hHasElementsOf\mTypeConstructor{NonDet}\\
  \mWhere\left\{
  \begin{aligned}
    \mIdCat x
    &=\mValueWith{NonDet}{\mPureWith{x}}\\ % ???
    \mValueWith{NonDet}{f}\mCompCat\mValueWith{NonDet}{g}
    &=\mValueWith{NonDet}{fhaskell.bindComp g}
  \end{aligned}
  \right.
\end{multline}
である．Haskellで書けば
\begin{haskellcode}
\begin{verbatim}
instance Cat.Category NonDet where
  id                      = NonDet pure
  (NonDet f) . (NonDet g) = NonDet (f <=< g)
\end{verbatim}
\end{haskellcode}
である．

\section{カテゴリ則*}

\begin{align}
\mIdCat\mCompCat f&=\hxFunc{f}\mCompCat\mIdCat=\hxFunc{f}\\
(f\mCompCat g)\mCompCat h&=\hxFunc{f}\mCompCat(g\mCompCat h)
\end{align}

\section{余談: Kleisli型*}

\begin{equation}
  \mNewTypeDecl\;
  \mTypeConstructor{ItCouldBe}\,haskell.a\,haskell.b
  =\mValueRecordWith{ItCouldBe}{haskell.athrm{runIt}\hIsTypeOfhaskell.a\hFunctionArrow\hMaybeConstruct{b}}
\end{equation}

\begin{equation}
  \left\{
  \begin{aligned}
    &haskell.athrm{rec}
    \hIsTypeOf{}(haskell.Real\hHasElementsOfhaskell.a)
    \hAndThenhaskell.a\hFunctionArrowhaskell.a\\
    &
    \begin{aligned}
      haskell.athop{haskell.athrm{rec}}x&\hGuard{x\neq0}
      =\hJustWith{1/x}\\
      &\hGuard{\hOtherwise}
      =haskell.Nothing
    \end{aligned}
  \end{aligned}
  \right.
\end{equation}

\begin{equation}
  y
  =\sharp\hCompose(\hxFunc{f}\hFunctorMap)\hCompose g\hApply x
\end{equation}

\begin{equation}
  haskell.athrm{rec}'
  =\mValueWith{ItCouldBe}{haskell.athrm{rec}}
\end{equation}

---

\begin{align}
  \mNewTypeDecl\;
  &\mTypeConstructor{NonDet}\,haskell.a\,haskell.b
  =\mValueWith{NonDet}{haskell.a\hFunctionArrow[haskell.b]}\\
  \mNewTypeDecl\;
  &\mTypeConstructor{ItCouldBe}\,haskell.a\,haskell.b
  =\mValueWith{ItCouldBe}{haskell.a\hFunctionArrow\hMaybeConstruct{b}}
\end{align}

\begin{equation}
  \mNewTypeDecl\;
  \mTypeConstructor{Kleisli}\,\mTypeConstructor{m}\,haskell.a\,haskell.b
  =\mValueWith{Kleisli}{haskell.a\hFunctionArrow\mTypeAssemble{m}{haskell.b}}
\end{equation}

\begin{equation}
  \mTypeSynonymDecl\;
  \mTypeConstructor{ItCouldBe}\,haskell.a\,haskell.b
  =\mTypeConstructor{Kleisli}\,haskell.a\,haskell.b
\end{equation}

\chapter{アロー*}
\label{ch:arrow}

\begin{leader}
  カテゴリが抽象化したのは関数の合成すなわち関数の分解方法である．モナ
  ドもカテゴリの一種である．% *** CHECK!!! ***
  ただし関数 $\hxFunc{g}$ の値が関数 $\hxFunc{f}$ の引数に依存する場合は
  $\hxFunc{g}\mCompCat \hxFunc{f}$ のように両者を合成できない．そこで考えられたのが
  アローである．
\end{leader}

\section{アロー*}

数値のリスト $\hListVar{x}$ の平均をとる関数 $\mMean$ を考えてみよう．実装は単純で
\begin{equation}
  \mMean\hListVar{x}
  =\hSum\hListVar{x}/\mLength\hListVar{x}
\end{equation}
である．

問題はここからである．関数 $\mMean$ を関数 $\hSum$ と関数 $\mLength$ の合成の形にできるだろうか．つまり
\begin{equation}
  \mMean\hListVar{x}
  =(\hSum\mSomeOp\mLength)\hListVar{x}
\end{equation}
あるいは
\begin{equation}
  \mMean
  =\hSum\mSomeOp\mLength
\end{equation}
の形に分解するような関数合成演算子は存在するだろうか．

残念なことに関数 $\hSum$ も $\mLength$ も同じ引数 $(\hListVar{x})$ をとる必要がある．そのため従来の方法では関数を合成出来ない．しかし次のように演算の結果をペアに収めることが出来れば何とかなりそうである．
\begin{equation}
  \label{eq:mean}
  \mMean\hListVar{x}
  =
  \left(\mLambda\hPairWith{\hxVar{x}}{\hxVar{y}}\mLambdaArrow x/y\right)\hPairWith{\hSum\hListVar{x}}{\mLength\hListVar{x}}
\end{equation}
幸いカリー化された2引数関数をペアを引数にとる関数へ変換する
$\hUncurry$ 関数があり，
\begin{equation}
  \hUncurry(\hAnyBinOp)
  =\mLambda\hPairWith{\hxVar{x}}{\hxVar{y}}\mLambdaArrow x\hAnyBinOp y
\end{equation}
であるから，式\eqref{eq:mean}の第1項（前半の括弧）は $\hUncurry(/)$ と
できる．

式\eqref{eq:mean}の第2項（後半の括弧）は
\begin{equation}
  \hPairWith{\hSum\hListVar{x}}{\mLength\hListVar{x}}
  =\begin{bmatrix}
  \hSum\\
  \mLength
  \end{bmatrix}
  % haskell.athop{\square}{}
  \hPairWith{\hListVar{x}}{\hListVar{x}}
\end{equation}
という形にしたい．そうすれば
\begin{equation}
  \mSplit x
  =\hPairWith{x}{x}
\end{equation}
なる関数 $\mSplit$ を用意すると，後は新しく導入したブラケット
$\begin{bmatrix}\vdots\end{bmatrix}$ だけの問題になる．

問題を整理すると，式\eqref{eq:mean}を
\begin{equation}
  \mMean\hListVar{x}
  =\hUncurry(/)
  \hCompose
  \begin{bmatrix}
    \hSum\\
    \mLength
  \end{bmatrix}
  \hCompose{}
  \mSplit
  \hApply
  \hListVar{x}
\end{equation}
という形に持っていきたい．それには
\begin{equation}
  \hPairWith{\hxFunc{f}\hxVar{x}}{gy}
  =
  \begin{bmatrix}
    f\\
    g
  \end{bmatrix}
  % haskell.athop{\square}{}
  \hPairWith{\hxVar{x}}{\hxVar{y}}
\end{equation}
となるような関数 $\hxFunc{f}$ と関数 $\hxFunc{g}$ の合成
$\begin{bmatrix}\vdots\end{bmatrix}$ が是非とも必要である．この特殊な
  関数合成を仮に#keyword[ブラケット}と呼ぶことにしよう．

そして，関数の合成を考える以上
\begin{equation}
  \begin{bmatrix}
    f\hCompose f'\\
    \hxFunc{g}\hCompose g'
  \end{bmatrix}
  =
  \begin{bmatrix}
    f\\
    g
  \end{bmatrix}
  \mCompCat
  \begin{bmatrix}
    f'\\
    g'
  \end{bmatrix}
\end{equation}
なる合成演算子 $(\mCompCat)$ も同時に考えておく必要がある．と言うのも，
ブラケットの合成が自由にできるようになると
\begin{equation}
  \hPairWith{\hxFunc{f}\hxVar{x}}{y}
  =
  \begin{bmatrix}
    f\\
    \mId
  \end{bmatrix}
  \hPairWith{\hxVar{x}}{\hxVar{y}}
\end{equation}
のようにペアの片側だけに作用するブラケットだけを考えておけば良くなるか
らである．

\separator

カテゴリは関数の合成演算子をオーバーライドする仕組みであった．いま欲し
いのは，関数をオーバーライドし，かつブラケットを生成できる仕組みである．

そのような型全体が所属する型クラスを#keyword[アロー型クラス}と呼ぶ．ア
ロー型クラスは $haskell.arrowTypeClass$ と表記する．アロー型クラスのインスタ
ンスを $\mTypeConstructor{a}$ で表すとしよう．もちろん
$\mTypeConstructor{a}$ は型コンストラクタである．

$\mTypeConstructor{a}$ 型コンストラクタによって作られる値を
#keyword[アロー}と呼ぶ．アローは関数から作られるものとする．関数 $\hxFunc{f}$
が $haskell.b\hFunctionArrow\mC$ という型を持つとき，関数 $\hxFunc{f}$ から作られたアロー
を $haskell.arrow{f}$ と書き，アロー $haskell.arrow{f}$ は
$haskell.bhaskell.arrowArrow{\mTypeConstructor{a}}\mC$ という型を持つとす
る．

型 $haskell.b\hFunctionArrow\mC$ は $(\hFunctionArrow)haskell.b\mC$ の中置記法バージョンで
あった．我々の $haskell.bhaskell.arrowArrow{\mTypeConstructor{a}}\mC$ も
$(haskell.arrowArrow{\mTypeConstructor{a}})haskell.b\mC$ の中置記法バージョ
ンである．ただし $(haskell.arrowArrow{\mTypeConstructor{a}})$ は単
純に $\mTypeConstructor{a}$ と書いて良い．

\separator

関数 $\hxFunc{f}$ をアロー $haskell.arrow{f}$ にする演算子（アロー演算子）を用意しよ
う．これを
\begin{equation}
  haskell.arrow{f}
  =haskell.arrowWith{f}
\end{equation}
とする．

アロー $haskell.arrow{f}$ からブラケットを作る演算子 $\mFirst$ ただし
\begin{equation}
  \begin{bmatrix}
    f\\
    \mId
  \end{bmatrix}
  =
  \mFirsthaskell.arrow{f}
\end{equation}
を用意する．左辺のブラケットもまたアローであるとする．

ふたつのアローを合成する演算子を
\begin{equation}
  haskell.arrow{\hxFunc{f}}\mCompCathaskell.arrow{\hxFunc{g}}
  =
  \begin{bmatrix}
    f_{\hxConstant{1},\hxConstant{1}}\hCompose f_{2,1}\\
    f_{1,2}\hCompose f_{2,2}
  \end{bmatrix}
\end{equation}
と定義する．

最後にアローのid関数を改めて定義しておこう．アロー $haskell.arrow{\mIdCat}$
は
\begin{equation}
  haskell.arrow{\mIdCat}\mCompCathaskell.arrow{f}
  =haskell.arrow{f}\mCompCathaskell.arrow{\mIdCat}
  =haskell.arrow{f}
\end{equation}
とする．

これらの実装を与える．アロー型クラスは次のように定義されている．
\begin{multline}
  \mTypeClassDeclPolymorphic\;
  \mCatTypeClass\hHasElementsOf\mTypeConstructor{a}
  \hAndThen
  haskell.arrowTypeClass\hHasElementsOf\mTypeConstructor{a}\\
  \mWhere{}
  \left\{
  \begin{aligned}
    haskell.arrowWith{}
    &\hIsTypeOf{}(haskell.b\hFunctionArrow\mC)
    \hFunctionArrow(haskell.bhaskell.arrowArrow{\mTypeConstructor{a}}\mC)\\
    \mFirst
    &\hIsTypeOf{}(haskell.bhaskell.arrowArrow{\mTypeConstructor{a}}\mC)
    \hFunctionArrow\left(\hPairWith{haskell.b}{\mD}
    haskell.arrowArrow{\mTypeConstructor{a}}\hPairWith{\mC}{\mD}\right)
  \end{aligned}
  \right.
\end{multline}
つまり値コンストラクタ $haskell.arrowWith{f}$ と関数 $\mFirst$ を実装した新
しい型を用意すればよいことになる．いや，アロー型クラスはカテゴリ型クラ
スから派生しているので，カテゴリ型クラスが備える関数合成 $(\mCompCat)$
とid関数 $(\mIdCat)$ の実装も必要である．

これらを踏まえて，新しい型コンストラクタ
$\mTypeConstructor{SimpleFunc}$ を考えてみる．
\begin{equation}
  \mNewTypeDecl\;
  \mTypeConstructor{SimpleFunc}\,haskell.a\,haskell.b
  =\mValueRecordWith{SimlpeFunc}{\mFuncall\hIsTypeOfhaskell.a\hFunctionArrowhaskell.b}
\end{equation}
型 $\mTypeConstructor{SimpleFunc}\,haskell.a\,haskell.b$ は $haskell.a\hFunctionArrowhaskell.b$ 型
の変数を唯一のメンバに持つ型で，つまりは1引数1戻値の関数をラップしただ
けのものである．

この型コンストラクタ $\mTypeConstructor{SimpleFunc}$ を型クラス
$haskell.arrowTypeClass$ のインスタンスにしてみよう．
\begin{multline}
  \mInstanceDeclPolymorphic\;
  haskell.arrowTypeClass\hHasElementsOf\mTypeConstructor{SimpleFunc}\\
  \mWhere{}
  \left\{
  \begin{aligned}
    haskell.arrowWith{f}
    &=\mValueWith{SimpleFunc}{f}\\
    \mFirst\mValueWith{SimpleFunc}{f}
    &=\mValueWith{SimpleFunc}{\mLambda\hPairWith{\hxVar{x}}{\hxVar{y}}\mLambdaArrow\hPairWith{\hxFunc{f}\hxVar{x}}{y}}
  \end{aligned}
  \right.
\end{multline}
これがブラケットの正体である．
\TK{...}

型コンストラクタ $\mTypeConstructor{SimpleFunc}$ はまた型クラス
$haskell.arrowTypeClass$ のインスタンスでもなければならないので，
\begin{multline}
  \mInstanceDeclPolymorphic\;
  \mCatTypeClass\hHasElementsOf\mTypeConstructor{SimpleFunc}\\
  \mWhere{}
  \left\{
  \begin{aligned}
    \mIdCat
    &=haskell.arrowWith{\mId}\\
    \mValueWith{SimpleFunc}{f}\mCompCat\mValueWith{SimpleFunc}{g}
    &=\mValueWith{SimpleFunc}{f\hCompose g}
  \end{aligned}
  \right.
\end{multline}
のように $\mIdCat$ と $\mCompCat$ の実装を与える．

ユーティリティとして，関数 $\mSplit$ と関数 $\mUnsplit$ のアローバージョ
ンを用意しておく．
\begin{align}
  &\left\{
  \begin{aligned}
    &\mSplit'
    \hIsTypeOfhaskell.arrowTypeClass\hHasElementsOf\mTypeConstructor{a}
    \hAndThenhaskell.bhaskell.arrowArrow{\mTypeConstructor{a}}(haskell.b,haskell.b)\\
    &\mSplit'
    =haskell.arrowWith{\mSplit}
  \end{aligned}
  \right.\\
  &\left\{
  \begin{aligned}
    &\mUnsplit'
    \hIsTypeOfhaskell.arrowTypeClass\hHasElementsOf\mTypeConstructor{a}
    \hAndThen{}(haskell.b\hFunctionArrow\mC\hFunctionArrow\mD)
    \hFunctionArrow\left(\hPairWith{haskell.b}{\mC}haskell.arrowArrow{\mTypeConstructor{a}}\mD\right)\\
    &\mUnsplit'
    =haskell.arrowWith{\mUnsplit}
  \end{aligned}
  \right.
\end{align}

型クラス $haskell.arrowTypeClass$ には関数 $\mSecond$ のデフォルト実装
\begin{equation}
  \mSecond
  =haskell.arrowWith{\mSwap}\mCompCat\mFirst
  \mWhere\mSwap\hPairWith{\hxVar{x}}{\hxVar{y}}\mLetEq\hPairWith{y}{x}
\end{equation}
が与えられており，この $\mSecond$ を使ってブラケットの定義
\begin{equation}
  \begin{bmatrix}
    f\\
    g
  \end{bmatrix}
  =\mSecond g\mCompCat\mFirst f
\end{equation}
が与えられている．Haskellではこのブラケットを \code{f***g} と表現す
る．

もう一つ便利なユーティリティ関数 $\mLiftATwo$ が定義されており，
\begin{equation}
  \mLiftATwo\hAnyBinOp fg
  =haskell.arrowWith{\mUnsplit\hAnyBinOp}\mCompCat\mSecond g\mCompCat\mFirst f\mCompCat{}haskell.arrowWith{\mSplit}
\end{equation}
である．

使ってみる．

\begin{align}
  f,g&\hIsTypeOf\mValueWith{SimpleFunc}{haskell.Int\,haskell.Int}\\
  f&=haskell.arrowWith{(/2)}\\
  g&=haskell.arrowWith{\mLambda x\mLambdaArrow x*3+1}\\
  h&=\mLiftATwo(+)fg\\
%  &=(\mUnsplit(+))\mCompCat\mSecond g\mCompCat\mFirst f\mCompCat\mSplit\\
  z&=(\mFuncall h)8
\end{align}

結果として $\hxVar{z}=29$ を得る．

\begin{align}
  \hSum'
  &=\mValueWith{SimpleFunc}{\hSum}\\
  \mLength'
  &=\mValueWith{SimpleFunc}{\mLength}
\end{align}

\begin{equation}
  \mMean'
  =\mLiftATwo(/)\hSum'\mLength'
\end{equation}

\begin{align}
  \mMean'
  &=\mUnsplit'(/)\mCompCat\mSecond\hSum'\mCompCat\mFirst\mLength'\mCompCat\mSplit'\\
  &=\mUnsplit'(/)\mCompCat\begin{bmatrix}\mLength'\\\hSum'\end{bmatrix}\mCompCat\mSplit'
\end{align}

\begin{equation}
  m
  =\mFuncall\mMean'\hListVar{x}
\end{equation}


---

\begin{equation}
  \begin{pmatrix}
    \hxFunc{f}\hxVar{x}\\
    gy
  \end{pmatrix}
  =
  \left(
  \begin{bmatrix}
    f\\
    \mId
  \end{bmatrix}
  \mCompCat
  \begin{bmatrix}
    \mId\\
    g
  \end{bmatrix}
  \right)
  \begin{pmatrix}
    x\\
    y
  \end{pmatrix}
\end{equation}

---

\begin{equation}
  haskell.arrowWith{f}=haskell.arrow{f}
\end{equation}

\begin{equation}
  \mFirsthaskell.arrow{f}=\begin{bmatrix}f\\\mId\end{bmatrix}
\end{equation}

\begin{equation}
  haskell.arrow{f}\mCompCathaskell.arrow{g}
  =
  \begin{bmatrix}
    \hxFunc{f}\hCompose g_1\\
    \hxFunc{g}\hCompose g_2
  \end{bmatrix}
  \mWhere...
\end{equation}

---

議論を簡単にするために
\begin{equation}
  \hPairWith{\hxFunc{f}\hxVar{x}}{y}
  =\begin{bmatrix}
  f\\
  \mId
  \end{bmatrix}
  % haskell.athop{\square}{}
  \hPairWith{\hxVar{x}}{\hxVar{y}}
\end{equation}
と
\begin{equation}
  \hPairWith{x}{gy}
  =\begin{bmatrix}
  \mId\\
  g
  \end{bmatrix}
  \hPairWith{\hxVar{x}}{\hxVar{y}}
\end{equation}
を考えよう．この二つを合成すると
\begin{equation}
  \begin{bmatrix}
    \hxFunc{f}\hxVar{x}\\
    gy
  \end{bmatrix}
  =
  \begin{bmatrix}
    \mId\\
    g
  \end{bmatrix}
  \mCompCat
  \begin{bmatrix}
    f\\
    \mId
  \end{bmatrix}
  \hPairWith{\hxVar{x}}{\hxVar{y}}
\end{equation}
であるとする．つまり，合成則も一緒に考えておくのである．

合成と言えばカテゴリである．つまりブラケットは，カテゴリのインスタンス
でなくてはならない．

---

\begin{equation}
  \mIdCat
  =
  \begin{bmatrix}
    \mId\\
    \mId
  \end{bmatrix}
\end{equation}

---

ブラケットの型をカプラと呼ぶことにしよう．

いま関数 $\mFirst$ があり，
\begin{equation}
  \begin{bmatrix}
    f\\
    \mId
  \end{bmatrix}
  =\mFirst f
\end{equation}


であるならば嬉しい．

あとはブラケットとペアの間の関数適用さえ定義できればいい．

いや，ちょっと待った．ブラケットの合成はどうなるのだろう．

---

\begin{equation}
  f
  \xrightarrow{\mFirst}
  \begin{bmatrix}
    f\\
    \mId
  \end{bmatrix}
\end{equation}

このブラケットは関数だろうか．

これをアローと呼ぶ．

ならば $\hxFunc{f}$ もアローであるべきだ．

これまでの関数の型は $haskell.a\hFunctionArrowhaskell.b$ であった．
これから新しい「関数風」の型 $haskell.a\mCatArrowChaskell.b$ を考える．

\begin{equation}
  \Vec{f}
  =haskell.arrowWith{f}
\end{equation}

\begin{equation}
  \mFirst\Vec{f}
  =\mLambda{\hPairWith{x}{z}}\mLambdaArrow\hPairWith{\hxFunc{f}\hxVar{x}}{z}
\end{equation}

\begin{equation}
  \begin{bmatrix}
    f\\
    \mId
  \end{bmatrix}
  =\mFirst\Vec{f}
\end{equation}

\begin{equation}
  \begin{bmatrix}
    f\\g
  \end{bmatrix}
  =\mFirst\Vec{f}\mCompCat\mSecond\Vec{g}
\end{equation}

---

より抽象度の高い議論を行うと
\begin{equation}
  \hPairWith{\hxFunc{f}\hxVar{x}}{y}
  =\begin{bmatrix}f\\g\end{bmatrix}
  \hPairWith{\hxVar{x}}{\hxVar{y}}
\end{equation}
さえあれば良いことがわかる．


ただし $\Vec{\hxFunc{f}}$, $\Vec{\hxFunc{g}}$ はもはや関数ではなく，
$\Vec{\hxFunc{f}}***\Vec{\hxFunc{g}}$ も関数ではない．

---

\newcommand{\mFirstFunc}{haskell.athop{haskell.athrm{first}}}

\begin{multline}
  \mTypeClassDeclPolymorphic\;
  (\mCatTypeClass\hHasElementsOf\mTypeConstructor{c})
  \hAndThen(haskell.arrowTypeClass\hHasElementsOf\mTypeConstructor{c})\\
  \mWhere{}\left\{
  \begin{aligned}
    haskell.arrowWith{\dotsb}
    &\hIsTypeOf{}(\mX\hFunctionArrow\mY)\hFunctionArrow\mTypeConstructor{c}\,\mX\,\mY\\
    \mFirstFunc
    &\hIsTypeOf{}\mTypeConstructor{c}\,\mX\,\mY
    \hFunctionArrow\mTypeConstructor{c}\,\hPairWith{\mX}{\mZ}\,\hPairWith{\mY}{\mZ}
  \end{aligned}
  \right.
\end{multline}

\begin{equation}
  \hxVar{z}=\hxFunc{g}\hCompose \hxFunc{f} x
\end{equation}

\begin{equation}
  \hxVar{z}=haskell.athop{haskell.athrm{app}}\hPairWith{haskell.arrowWith{\hUncurry \hxFunc{g}}\mCompCat\mFirstFunchaskell.arrowWith{\hxFunc{f}}\mCompCat{}haskell.arrowWith{\left(\mLambda x\mLambdaArrow\hPairWith{x}{x}\right)}}{x}
\end{equation}

---

% from haskell wiki

\newcommand{\mUncircuit}{haskell.athop{haskell.athrm{uncircuit}}}
\newcommand{\mCircuitType}{\mTypeConstructor{Circ}}
\newcommand{\mCircuitWith}[1]{\mValueWith{Circ}{#1}}

\begin{equation}
  \mNewTypeDecl\;
  \mCircuitType\,haskell.a\,haskell.b
  =\mCircuitWith{\mUncircuit\hIsTypeOfhaskell.a\hFunctionArrow(\mCircuitType\,haskell.a\,haskell.b,haskell.b)}
\end{equation}

\begin{multline}
  \mInstanceDecl\;
  \mTypeClass{Category}\hHasElementsOf\mCircuitType\\
  \mWhere
  \left\{
  \begin{aligned}
    \mIdCat
    &=\mCircuitWith{\mLambda x\mLambdaArrow(\mIdCat,x)}\\
    \mCircuitWith{\hxFunc{g}}\mCompCat\mCircuitWith{\hxFunc{f}}
    &={}^{\textrm{Circ}}[[\mLambda x\mLambdaArrow(\hxFunc{g}'\mCompCat \hxFunc{f}',z)\\
    &\quad\mWhere{}\left\{
    \hPairWith{\hxFunc{f}'}{y}\mLetEq \hxFunc{f} x;
    \hPairWith{\hxFunc{g}'}{z}\mLetEq \hxFunc{g} y\right\}]]
  \end{aligned}
  \right.
\end{multline}

\begin{multline}
  \mInstanceDecl\;
  \mTypeClass{Arrow}\hHasElementsOf\mCircuitType\\
  \mWhere\left\{
  \begin{aligned}
    haskell.arrowWith{f}
    &=\mCircuitWith{\mLambda x\mLambdaArrow\hPairWith{haskell.arrowWith{f}}{\hxFunc{f}\hxVar{x}}}\\
    \mFirstFunc\mCircuitWith{f}
    &={}^{haskell.athrm{Circ}}\[\mLambda \hxVar{x}\hxVar{y}\mLambdaArrow\hPairWith{\mFirstFunc f'}{\hPairWith{z}{y}}
    \mWhere{}\hPairWith{f'}{z}\mLetEq \hxFunc{f}\hxVar{x}\]
  \end{aligned}
  \right.
\end{multline}

\newcommand{\mRunCircuit}{haskell.athop{haskell.athrm{runCircuit}}}

\begin{align}
  \mRunCircuit&\hIsTypeOf\mCircuitType\,haskell.a\,haskell.b\hFunctionArrow\hListConstruct{haskell.a}\hFunctionArrow[haskell.b]\\
  \mRunCircuit\_{\hEmptyList}&={\hEmptyList}\\
  \mRunCircuit c(\hxVar{x}:\hListVar{x})&=x':\mRunCircuit c'\hListVar{x}\\
  &\quad\mWhere{}(c',x')\mLetEq\mUncircuit cx
\end{align}

\newcommand{\mAccum}{\mathop{\mathrm{accum}}}

\begin{align}
  \mAccum a\hAnyBinOp
  &=\mCircuitWith{\mLambda x\mLambdaArrow(\mAccum a'\hAnyBinOp,y)
    \mWhere{}(y',a')\mLetEq x\hAnyBinOp a}\\
  {\mAccum}' a\hAnyBinOp
  &=\mAccum a(\mLambda \hxVar{x}\hxVar{y}\mLambdaArrow(y',y')
  \mWhere y'\mLetEq x\hAnyBinOp y)
\end{align}

\newcommand{\mTotal}{haskell.athop{haskell.athrm{total}}}

\begin{align}
  \mTotal&\hIsTypeOf\mCircuitType\,haskell.a\,haskell.a\\
  \mTotal&={\mAccum}'0(+)
\end{align}

% \newcommand{\mMean}{haskell.athop{haskell.athrm{mean}}}

\begin{align}
  \mMean&\hIsTypeOf\mCircuitType\,haskell.a\,haskell.a\\
  \mMean&=(\mTotal\mathbin{\bigvee}haskell.arrowWith{\mConst1}\Rrightarrow\mTotal)\Rrightarrowhaskell.arrowWith{\hUncurry(/)}
\end{align}

---

\newcommand{\mKleisliType}{\mType{Kleisli}}
\newcommand{\mKleisliWith}[1]{\mValueWith{Kleisli}{#1}}
\newcommand{\mRunKleisli}{haskell.athop{haskell.athrm{runKleisli}}}

\begin{equation}
  \mNewTypeDecl\;
  \mKleisliType\,\mTypeConstructor{m}\,haskell.a\,haskell.b
  =\mKleisliWith{\mRunKleisli\hIsTypeOfhaskell.a\hFunctionArrow\mTypeAssemble{m}{b}}
\end{equation}

\begin{equation}
  \mLambda x\mLambdaArrow((\mLambda y\mLambdaArrow\hJustWith{y*2})haskell.bind{}\hJustWith{x*3}))
  =(\hJustWith{\hxAnonParam}\hCompose(*2))haskell.bindComp(\hJustWith{\hxAnonParam}\hCompose(*3))
\end{equation}

\begin{multline}
  \mLambda x\mLambdaArrow((\mLambda y\mLambdaArrow\hJustWith{y*x})haskell.bind{}\hJustWith{x*2})\\
  =(\hJustWith{\hxAnonParam}\hCompose\hUncurry(*))haskell.bindComp(\hJustWith{\hxAnonParam}\hCompose{}((*2),\mId))
\end{multline}

---

\begin{equation}
  \left(f\bigvee g\right)\hPairWith{\hxVar{x}}{\hxVar{y}}=\hPairWith{\hxFunc{f}\hxVar{x}}{gy}
\end{equation}

\begin{equation}
  \left(f\bigwedge g\right)x=\hPairWith{\hxFunc{f}\hxVar{x}}{\hxFunc{g}\hxVar{x}}
\end{equation}

---


% http://qiita.com/CyLomw/items/a618b7c7326d9abede63
% http://qiita.com/CyLomw/items/ff1e5d1600291c952c5e
% http://qiita.com/CyLomw/items/a874cee33c69653f53c6
% http://qiita.com/CyLomw/items/688942f19a5bc3a25037
% http://www.kotha.net/ghcguide_ja/7.6.2/arrow-notation.html
% http://d.hatena.ne.jp/haxis_\hxFunc{f}\hxVar{x}/20110720/1311149995
% http://d.hatena.ne.jp/r-west/20070720/1184946510
% http://d.hatena.ne.jp/r-west/20070531/1180630841
% http://d.hatena.ne.jp/r-west/20070604/1180976373
% http://d.hatena.ne.jp/r-west/20070529/1180455881
% https://wiki.haskell.org/Arrow_tutorial

% http://qiita.com/CyLomw/items/688942f19a5bc3a25037
% http://d.hatena.ne.jp/r-west/20070720/1184946510
% https://www.haskell.org/arrows/
% https://wiki.haskell.org/Arrow_tutorial

\chapter{プログラム}
\label{ch:program}

\begin{leader}
A...
\end{leader}

\section{文字セットとコメント}

Haskellコンパイラを含む多くのコンパイラがUnicode文字セットに対応して
いるものの，従来からの習慣や英語圏での使いやすさを考慮してか，ASCII文
字セットだけでプログラムを書けるようにしているし，またそれを推奨してい
る．

Haskellプログラムもまた，文字定数を除いてはASCII文字セットの範囲で書
くことが普通である．そこで我々もその習慣に従うことにしよう．例えば円周
率を代入する変数を $\pi$ と書きたいところだが，我々は \code{pi} と書く．

数学記号のほとんども，ASCII文字セットの中から記号を組み合わせるか，さ
もなくば言葉で表現する．例えばHaskellでは $\mFrom$ の代わりに
\code{<-} を使うし，$\neg$ の代わりに \code{not} を使う．

また計算機科学者たちの絶えざる努力にもかかわらず，プログラム中の文字の
装飾はこれまでほとんど受け入れられていない．我々は本書で \textrm{f},
\textit{f}, \textsl{f}, \textbf{f}, \textbf{\textit{f}}, $\hxFunc{f}$,
$haskell.athfrak{f}$ を使い分けてきたが，Haskellプログラム中では全て
\code{f} と書く．

以上のような制約にもかかわらず，Haskellプログラムと我々が見えきた
「カリー風の」数学記法は本質的に差がない．本書を読み進めてきた読者なら，
Haskellプログラムを読むのに苦労はいらないだろう．

Haskellでは \code{--} から行の終わりまでがコメントとして扱われる．ま
た \code{\{-} で始まり \code{-\}} で終わる文字列もコメントとして扱われ
る．

\separator

習慣的にHaskellプログラムのファイルには拡張子 \filename{.hs} を付け
る．

\section{main関数と一般の関数定義}

Pythonインタプリタはプログラムを頭から実行していくので，main関数は書
かなくてもよいが，アプリケーションプログラマにとっての一番の関心事は
main関数（Haskellでは $\mMain$ アクション）の書き方だろう．iOSアプリ
ケーション開発のように，基本的にはmain関数をプログラマが触れないという
スタイルもあるが，それでもデバッグの時にはmain関数から辿ることになるの
で，main関数のありかを知っておくことはいつでも重要だ．

Haskellコンパイラも $\mMain$ アクションをアプリケーションプログラム
のエントリポイントとして認識する．というよりも，Haskellプログラムと
は $\mMain$ という一つのアクションである．$\mMain$ を含む一般の関数や
アクションはこれまで通り
\begin{equation}
\mMain=\dots
\end{equation}
のように関数名のあとに等号 $(=)$ を置いて定義する．

Cでmain関数の型がOSの都合で \code{int main(void)} または
\code{int main(int, const char *const *)} と決められているように，
Haskellでも $\mMain$ アクションの型はあらかじめ決められている．その
型は $\mIOIntType$ である．

UNIXおよびUNIXに影響を受けたOSでは，プログラムは終了時に整数値をOSへ返
すことになっている．プログラムが $\hxConstant{0}$ を返せば，そのプログラムは正常終
了したとみなされる．例えばUNIXシェル（\filename{sh} や \filename{csh}
  のこと）で，
\begin{verbatim}
$ program1 && program2
\end{verbatim}
としたとき，\filename{program1} の戻り値が $\hxConstant{0}$ のときに限って
\filename{program2} が実行される．

何もせずにOSに $\hxConstant{0}$ を返すプログラムすなわち
\begin{equation}
\left\{
\begin{aligned}
\mMain&\hIsTypeOf{}\mIOIntType\\
\mMain&=\mPureWith{0}
\end{aligned}
\right.
\end{equation}
をHaskellで書くと，
\begin{haskellcode}
\begin{verbatim}
-- do-nothing.hs
main :: IO Int
main = pure 0
\end{verbatim}
\end{haskellcode}
または
\begin{haskellcode}
\begin{verbatim}
-- do-nothing.hs
main :: IO Int
main = return 0
\end{verbatim}
\end{haskellcode}
のようになる．ここに \code{return} はモナドのピュア演算子の別名で，特
別に#keyword[ユニット演算子}と呼ぶ．#footnote[GHC v7.8 以前はモナドに
  ピュア演算子が定義されず，モナド独自のユニット演算子が定義されていた．}

このプログラムはCの
\begin{ccode}
\begin{verbatim}
/* do-nothing.c */
int main(void) {
  return 0;
}
\end{verbatim}
\end{ccode}
と等しい．

\section{プログラミングの本質}

副作用のないプログラムはひとつの関数で書ける．その関数を $\mMainFunc$
と呼ぶことにすると，この $\mMainFunc$ 関数を
\begin{equation}
\mMainFunc=\hxFunc{f}_n\hCompose f_{n-1}\hCompose\dotsb\hCompose \hxFunc{f}
\end{equation}
と部分関数に分解することがプログラマの能力である．副作用のないプログラ
ムとは，コマンドラインから引数 $\hxVar{x}$ を受け取り，なんらかの処理を行い，
OSに終了値を返すだけのプログラムである．このようなプログラムは普通役に
立たないが，議論が簡単になるので少し見てみよう．

副作用のない関数を合成するのはわけのないことだ．もしPythonならば
\begin{pythoncode}
\begin{verbatim}
y = f2(f1(x))
\end{verbatim}
\end{pythoncode}
のように関数を入れ子にしても良いし，読みづらければ途中経過を一時変数に
して
\begin{pythoncode}
\begin{verbatim}
y1 = f1(x)
y2 = f2(y1)
\end{verbatim}
\end{pythoncode}
としてもよい．副作用のない関数の場合，これが関数合成の規則である．

プログラムが副作用を持つ場合は，プログラム自身がIOモナドであるため，関
数へと分解できないのであった．副作用を持つプログラムはアクションであり，
そのアクションを $\mMain$ アクションと名付けると，その $\mMain$ アクショ
ンを
\begin{equation}
\mMain=\alpha_nhaskell.bind\alpha_{n-1}haskell.bind\dotsbhaskell.bind\alpha_0
\end{equation}
と部分アクションに分解することがプログラマの能力となる．

% How to unwrap w?

\separator

ここで，プログラマの「サバイバルキット」を用意しておこう．次のプログラ
ムで定数 \code{x} と関数 \code{f} の部分を埋めれば，関数適用の結果つま
り \code{f x} の値を画面に出力する．
\begin{haskellcode}
\begin{verbatim}
-- survivalkit.hs
x :: Double
x = {- Value -}
f :: Double -> Double
f = {- Function -}
main :: IO Int
main = print (f x) >> pure 0
\end{verbatim}
\end{haskellcode}
ファイル名を \filename{survivalkit.hs} とすると，コンパイルと実行は次
のようにする．
\begin{verbatim}
$ ghc survivalkit.hs
$ ./sample
\end{verbatim}%$

プログラム \filename{survivalkit.hs} を数式で書くと
\begin{align}
  {}&\left\{
    \begin{aligned}
      x&\hIsTypeOfhaskell.Double\\
      x&=\dots\\
    \end{aligned}
    \right.\\
  {}&\left\{
    \begin{aligned}
      f&\hIsTypeOf{}\mProjEXP{haskell.Double}{haskell.Double}\\
      f&=\dots\\
    \end{aligned}
    \right.\\
  {}&\left\{
    \begin{aligned}
      \mMain&\hIsTypeOf{}\mIODoubleType\\
      \mMain&=\mPrint(\hxFunc{f}\hxVar{x})haskell.bindRightIgnore\mPureWith{0}
    \end{aligned}
    \right.
\end{align}
である．この式は $\mPrint(\hxFunc{f}\hxVar{x})$ がいかなる値を返そうとも，アクション
$\mMain$ の値は $\hxConstant{0}$ になることを示している．

\section{余談：インタープリタ*}

\section{この章のまとめ*}

\begin{note}{...}
...
\end{note}

% 2023
% https://enakai00.hatenablog.com/entry/20130912/1378970253
% https://r-west.hatenablog.com/entry/20070720/1184946510
% https://r-west.hatenablog.com/entry/20070529/1180455881
% https://blog.jle.im/entry/auto-as-category-applicative-arrow-intro-to-machines
% https://blog.jle.im/entry/intro-to-machines-arrows-part-1-stream-and
% https://qiita.com/CyLomw/items/a618b7c7326d9abede63
% https://qiita.com/CyLomw/items/ff1e5d1600291c952c5e
% https://qiita.com/CyLomw/items/a874cee33c69653f53c6
% https://qiita.com/CyLomw/items/688942f19a5bc3a25037
% https://qiita.com/kanatatsu64/items/d5bfe07a6c9a8f839df5
% https://qiita.com/Lugendre/items/6b4a8c8a9c85fcdcb292
% https://elvishjerricco.github.io/2017/08/22/monadfix-is-time-travel.html
% https://qiita.com/lotz/items/0894079a44e87dc8b73e

\TK{TO DO}
\begin{itemize}
\item state monad
\item fix
\item category
\item kleisli class
\item arrow
\item continuation
\item 文字セットとコメント
\item 代数的構造
\item ラムダ
\end{itemize}

\part{執筆用メモ*}



\chapter{演算*}
\label{ch:arithmetic}

\begin{leader}
演算の例を挙げる．
\end{leader}


\section{名前と予約語*}

表\ref{tab:reserved-symbols}および表\ref{tab:reserved-keywords}に
Haskellで予約されている記号と名前を掲げる．これらの記号，名前は演算
子，関数，定数として使うことが出来ない．

もちろんこれら以外に \code{+} や \code{map} など慣例的に使われている語
の再定義は避けるべきである．特に \filename{Prelude} モジュールは特段の
事情がない限り必ず読み込まれるモジュールなので，\filename{Prelude} で
定義される記号と名前の再定義は避けるべきであろう．\filename{Prelude}
で定義される記号と名前は膨大な数になるので，リファレンスを参考にしても
らいたい．

Haskellで演算子に使える記号は
\begin{verbatim}
 ! @ # $ % ^ & * - + = . \ | / < : > ? ~
\end{verbatim}%$
である．ただし \code{:} ではじまる記号は予約されている．

% *** リファレンス ***
% http://www.sampou.org/haskell/report-revised-j/basic.html
% http://mew.org/~kazu/academic/2013/miyazaki-u/syntax.html

\begin{table*}
\caption{Haskellの予約済み演算子と記号}
\label{tab:reserved-symbols}
\begin{center}
\begin{tabular}{||c|c||}
\hline
\code{--}&行コメント\\
\code{\{-} \code{-\}}&コメント\\
\hline
\code{'}&文字リテラル\\
\code{"}&文字列リテラル\\%{\textquotedblright}\\
\code{`}&関数の中置\\
\code{(} \code{)}&括弧\\
\code{\{} \code{\}}&レコード構文 $(\{\dotsb\})$，ブロック\\
\code{;}&ステートメントセパレータ\\
\hline
% \code{-}&単項マイナス $(-)$\\
\code{\textbackslash}&ラムダ $(\mLambda)$，行分割\\
\code{:}&結合演算子\\
\code{::}&型の宣言 $(\hIsTypeOf)$\\
\code{..}&等差数列\\
\code{=}&定義 $(=)$\\
\code{=>}&インスタンス定義 $(\hAndThen)$\\
\code{->}&関数型コンストラクタ $(haskell.apsto)$，ラムダ式の矢印 $(\rightarrow)$，\\
&case式の矢印 $(\hIfSo)$\\
\code{<-}&リスト内包表記 $(\mFrom)$，do記法中の代入 $(\mDoEq)$\\
\code{@}&asパタン $(@)$\\
\code{|}&ガード $(\hGuard{})$，リスト内包 $(\mListComp)$，データ型の和演算 $(\mValueOr)$\\
\code{,}&リストの値の区切り，リスト内包表記の区切り，\\
&タプルの値の区切り\\
% \code{-<}&（アロー表記用）\\
% \code{-<<}&（アロー表記用）\\
% \code{[|}, \code{|]}&（テンプレート）\\
% \code{?}&（暗黙パラメタ）\\
% \code{\#}&（マジックハッシュ）\\
% \code{*}\\
\hline
\code{!}&正格評価\\
\code{\textasciitilde}&XYZ\\
\hline
\end{tabular}
\end{center}
\end{table*}

% http://www.nslabs.jp/haskell-keywords.rhtml

\begin{table*}
\caption{Haskellの予約語}
\label{tab:reserved-keywords}
\begin{center}
\begin{tabular}{||l|l||}
\hline
分岐 (1)&\code{case}, \code{of}\\
分岐 (2)&\code{if}, \code{then}, \code{else}\\
型定義&\code{class}, \code{data}, \code{deriving}, \code{instance},\\
&\code{newtype}, \code{type}\\
do記法&\code{do}\\
局所変数 (1)&\code{let}, \code{in}\\
局所変数 (2)&\code{where}\\
演算子定義&\code{infix}, \code{infixl}, \code{infixr}\\
モジュール関係&\code{foreign}, \code{import}, \code{module}\\
ワイルドカード引数&\code{\_}\\
\hline
\end{tabular}
\end{center}
\end{table*}

% http://www.imada.sdu.dk/~rolf/Edu/DM22/F06/haskell-operatorer.pdf
% https://wiki.haskell.org/Keywords

% \begin{table*}
% \caption{\code{Prelude} モジュールの予約語と記号}
% \begin{center}
% \begin{tabular}{||l||}
% \hline
% \code{Bool}, \code{\&\&}, \code{||}, \code{otherwise}\\
% \code{Bounded}, \code{minBoud}, \code{maxBound}\\
% \code{Enum}, \code{succ}, \code{pred}, \code{toEnum}, \code{fromEnum}, \code{enumFrom}, \code{enumFromThen}, \code{enumFromTo}, \code{enumFromThenTo}\\
% \code{Eq}, \code{==}, \code{/=}\\
% \code{Data}, \code{gfoldl}, \code{gunfold}, \code{toConstr}, \code{dataTypeOf}, \code{dataCast1}, \code{dataCast2}, \code{gmapT}, \code{gmapQl}, \code{gmapQr}, \code{gmapQ}\\
% ~~\code{gmapQi}, \code{gmapM}, \code{gmapMp}, \code{gmapMo}\\
% \code{Ord}, \code{<}, \code{<=}, \code{>}, \code{>=}, \code{max}, \code{min}\\
% \code{Read}, \code{readsPrec}, \code{readList}, \code{readPrec}, \code{readListPrec}\\
% \code{Show}, \code{showsPrec}, \code{show}, \code{showList}\\
% \code{Ix}, \code{range}, \code{index}, \code{unsafeIndex}, \code{inRange}, \code{rangeSize}, \code{unsafeRangeSize}\\
% \code{Generic}, \code{Rep}, \code{from}, \code{to}\\
% \code{FiniteBits}, \code{finiteBitSize}, \code{countLeadingZeros}, \code{countTailingZeros}\\
% \code{Bits}, \code{.\&.}, \code{.|.}, \code{xor}, \code{complement}, % \code{shift}, \code{rotate}, \code{zeroBits}, \code{bit}, \code{setBit}, \code{clearBit}, \code{complementBit},\\
% ~~\code{testBit}, \code{bitSizeMaybe}, \code{bitSize}, \code{isSigned}, \code{shiftL}, \code{unsafeShiftL}, \code{shiftR}, \code{unsafeShiftR},\\
% ~~\code{rotateL}, \code{rotateR}, \code{popCount}\\
% \code{Storable}, \code{sizeOf}, \code{alignment}, \code{peekElemOff}, \code{pokeElemOff}, \code{peekByteOff}, \code{pokeByteOff}, \code{peek}, \code{poke}\\
% \code{Maybe}, \code{Just}, \code{Nothing}\\
% \code{Monad}, \code{>>=}, \code{>>}, \code{return}, \code{fail}\\
% \code{Functor}, \code{fmap}, \code{<\$}\\
% \code{MonadFix}, \code{mfix}\\
% \code{MonadFail}\\
% \code{Applicative}, \code{pure}, \code{<*>}, \code{liftA2}, \code{*>},  \code{<*}\\
% \code{Foldable}, \code{fold}, \code{foldMap}, \code{fordr}, \code{foldr'}, \code{foldl}, \code{foldl'}, \code{foldr1}, \code{foldl1}, \code{toList}, \code{null}, \code{length},\\
% ~~\code{elem}, \code{maximum}, \code{minimum}, \code{sum}, \code{product}\\
% \code{Traversable}, \code{traverse}, \code{sequenceA}, \code{mapM}, \code{sequence}\\
% \code{MonadPlus}, \code{mzero}, \code{mplus}\\
% \code{Alternative}, \code{empty}, \code{<|>}, \code{some}, \code{many}\\
% \code{MonadZip}, \code{mzip}, \code{mzipWith}, \code{munzip}\\
% \code{Show1}, \code{liftShowsPrec}, \code{liftShowList}\\
% \code{Read1}, \code{liftReadsSec}, \code{liftReadList}, \code{liftReadPrec}, \code{liftReadListPrec}\\
% \code{Ord1}, \code{liftCompare}\\
% \code{Eq1}, \code{liftEq}\\
% \code{Either}\\
% \code{Show2}, \code{liftShowsPrec2}, \code{liftShowList2}\\
% \code{Read2}, ...\\
% \hline
% \end{tabular}
% \end{center}
% \end{table*}

\section{2次方程式の解*}

2次方程式の解とは，定数 $a,b,c$ が既知の式
\begin{equation}
\hxVar{a}*\hxVar{x}^2+b*x+c=0
\end{equation}
において定数 $\hxVar{x}$ が取り得る値のことである．なお $\hxVar{x}^2$ はHaskellでは
\code{x**2} と書く．

2次方程式の解法は知られており，
\begin{multline}
  (\hxVar{x}_0,\hxVar{x}_1)=(q/a,c/q)\\
  \mWhere q\mLetEq\frac{\left(b+(\sgn b)*\sqrt{\mSq b-4*a*c}\right)}{2}
\end{multline}
である．ここに関数 $\mSq$ は
\begin{equation}
  \mSq x=x^2
\end{equation}
である．わざわざ関数にしたのは，単純な \code{x**2} よりも高速な実装
\begin{equation}
  \left\{
  \begin{aligned}
    &\mSq\hIsTypeOfhaskell.Real\hHasElementsOfhaskell.a
    \hAndThen\mProjEXP{haskell.a}{haskell.a}\\
    &\mSq x=x*x
  \end{aligned}
  \right.
\end{equation}
を後で与えるためである．平方根 $\sqrt{x}$ はHaskellでは \code{sqrt
  x} と書く．

また関数 $\sgn$ は
\begin{equation}
  \left\{
  \begin{aligned}
    {}&\sgn\hIsTypeOf{}haskell.Real\hHasElementsOfhaskell.a
    \hAndThen\mProjEXP{haskell.a }{haskell.a }\\
    {}&
    \begin{aligned}
      \sgn x&\hGuard{x<0}=-1\\
      &\hGuard{\hOtherwise}=1
    \end{aligned}
  \end{aligned}
  \right.
\end{equation}
である．

最後にタプル $(\hxVar{x}_0,\hxVar{x}_1)$ を画面に表示すれば完了なので
\begin{equation}
  \left\{
  \begin{aligned}
    {}&\mMain\hIsTypeOf\mIOIntType\\
    {}&\mMain=\mPrint(\hxVar{x}_0,\hxVar{x}_1)haskell.bindRightIgnore\mPureWith{0}
  \end{aligned}
  \right.
\end{equation}
とする．

これをそのままHaskellで実装すれば，2次方程式の解が求まる．
\begin{haskellcode}
\begin{verbatim}
-- quadratic.hs
a = {- ... -}
b = {- ... -}
c = {- ... -}
sgn :: Real a => a -> a
sgn x | x<0       = -1
      | otherwise = 1
sq :: Real a => a -> a
sq x = x*x
(x0, x1) = (q/a, c/q) where
  q = (b+sgn(b)*sqrt(sq b - 4*a*c))/2.0
main :: IO Int
main = print (x0, x1) >> pure 0
\end{verbatim}
\end{haskellcode}

なお，2次方程式のよく知られた解法，すなわち
\begin{equation}
  (\hxVar{x}_0,\hxVar{x}_1)=\left(\frac{-b+d}{2*a},\frac{-b-d}{2*a}\right)
  \mWhereIsEXP{d}{\sqrt{b^2-4*a*c}}
\end{equation}
は定数 $a$ または $c$ の値が小さい場合には計算誤差が大きくなるため，推
奨されない．

\section{複素数*}

% Numerical Recipe in C

2次方程式の定数 $a,b,c$ が複素数だとしよう．それぞれの実部を添え字 $r$
で，虚部を添え字 $i$ で区別することにすると
\begin{align}
a&=a_r\mComplexPlus a_i\\
b&=b_r\mComplexPlus b_i\\
c&=c_r\mComplexPlus c_i
\end{align}
となる．ここに $\mComplexPlus$ は複素数を合成する演算子で，第1引数（左
  引数）が実部，第2引数（右引数）が虚部からなる複素数を合成するものと
する．Haskellでは
\begin{haskellcode}
\begin{verbatim}
import Data.Complex
a :: Complex Double
a = ar :+ ai
\end{verbatim}
\end{haskellcode}
のように \code{:+} 演算子を使って複素数をコンストラクトする．

このようにHaskellでは複素数を
\begin{equation}
  \mCompFunclexType{a}=haskell.athop{\mTypeConstructor{Complex}}haskell.a
\end{equation}
の型パラメタ $haskell.a$ に $haskell.Float$ 型または $haskell.Double$ 型を
当てはめて構築した型を用いる．$haskell.Float$ 型および $haskell.Double$ 型
は $\mRealFloatTypeClass$ 型クラスに属する．

複素数の場合の2次方程式の解は，実数の場合とほぼ同じで
\begin{equation}
  (\hxVar{x}_0,\hxVar{x}_1)=(q/a,c/q)\mWhere\left\{
  \begin{aligned}
    &q\mLetEq\left(b+\sgn'abc*r\right)/2\\
    &r\mLetEq\mSqrt'{(\mSq'b-4*a*c)}
  \end{aligned}
  \right.
\end{equation}
である．実数の場合との違いは $\mSq$ 関数と $\sgn$ 関数をそれぞれ
$\mSq'$ 関数と $\sgn'$ 関数に置き換えたことで，
\begin{equation}
  \left\{
  \begin{aligned}
    &\mSq'
    \hIsTypeOf\mRealFloatTypeClass\hHasElementsOfhaskell.a
    \hAndThenhaskell.a
    \hFunctionArrow\mCompFunclexType{a}
    \hFunctionArrow\mCompFunclexType{a}\\
    &\mSq'x
    =x*x
  \end{aligned}
  \right.
\end{equation}
および
\begin{equation}
  \left\{
  \begin{aligned}
    &\begin{aligned}
       \sgn'
       &\hIsTypeOf\mRealFloatTypeClass\hHasElementsOfhaskell.a\\
       &\quad\hAndThen\mCompFunclexType{a}
       \hFunctionArrow\mCompFunclexType{a}
       \hFunctionArrow\mCompFunclexType{a}
       \hFunctionArrowhaskell.a
     \end{aligned}\\
    &\begin{aligned}
       \sgn'abc
       &\hGuard{\mRealPart((\mConjugate b)*\mSqrt'{(\mSq' b-4\mComplexTimes a*c)})<0}
       =-1\\
       &\hGuard{\hOtherwise}
       =1
     \end{aligned}
  \end{aligned}
  \right.
\end{equation}
である．

この $\sgn'$ 関数の中で複素数の平方根および複素数の実数倍を計算する必
要がある．そこで，複素数の平方根を
\begin{equation}
  \left\{
  \begin{aligned}
    &\mSqrt'\hIsTypeOf\mRealFloatTypeClass\hHasElementsOfhaskell.a
    \hAndThen\mProjEXP{haskell.a }{haskell.a }\\
    &\begin{aligned}
       \mSqrt'(x\mComplexPlus y)
       &=\frac{\sqrt{2}}{2}*\left(\sqrt{d+x}\mComplexPlus(\sgn y)*\sqrt{d-x}\right)\\
       &\quad\mWhereIsEXP{d}{\sqrt{\mSq x+\mSq y}}
     \end{aligned}
  \end{aligned}
  \right.
\end{equation}
と定義し，複素数の実数倍は演算子 $\mComplexTimes$ で表すとして
\begin{equation}
  \left\{
  \begin{aligned}
    &(\mComplexTimes)\hIsTypeOf\mRealFloatTypeClass\hHasElementsOfhaskell.a \hAndThen
    \mProjEXP{haskell.a }{\mProjEXP{\mCompFunclexType{a}}{\mCompFunclexType{a}}}\\
    &(\mComplexTimes)a(x\mComplexPlus y)=\hxVar{a}*\hxVar{x}\mComplexPlus a*y
  \end{aligned}
  \right.
\end{equation}
とした．（演算子 $\mComplexTimes$ は \code{*.} と書くことにする．）

Haskellは複素数の実数倍のための演算子を標準では用意していないため，
このように独自の演算子を定義するか，あるいは複素数掛ける複素数の形にし
て演算を行うかのいずれかが必要である．

% 効率を考えなければ，次のような型変換関数を作ることも手である．
% \begin{haskellcode}
% \begin{verbatim}
% toComplex :: RealFloat a => a -> Complex a
% toComplex x = x :+ 0
% \end{verbatim}
% \end{haskellcode}

なお，$\mConjugate$ は共役複素数を求める関数，$\Re$ は実部を求める関数
である．$\Re$ はHaskellでは \code{realPart} と書く．

まとめると次のようになる．

\begin{haskellcode}
\begin{verbatim}
-- complex.hs
import Data.Complex

a, b, c :: Complex Double
a = {- ... -} :+ {- ... -}
b = {- ... -} :+ {- ... -}
c = {- ... -} :+ {- ... -}

sq :: Real a => a -> a
sq x = x*x

sq' :: RealFloat a => Complex a -> Complex a
sq' x = x*x

sgn :: Real a => a -> a
sgn x | x < 0     = (-1)
      | otherwise = 1

sgn' :: RealFloat a =>
  Complex a -> Complex a -> Complex a -> Complex a
sgn' a b c
  | realPart((conjugate b)*sqrt'(sq' b-4*.(a*c)))<0 = (-1):+0
  | otherwise                                       = 1:+0

sqrt' :: RealFloat a => Complex a -> Complex a
sqrt' (\hxVar{x}:+y) = (sqrt 2)/2*((sqrt(d+x)):+sgn(y)*(sqrt(d-x)))
  where d = sqrt(sq x + sq y)

(*.) :: Real a => a -> Complex a -> Complex a
(*.) a (\hxVar{x}:+y) = a*\hxVar{x}:+a*y

(x0, x1) = (q/a, c/q) where
  q = (b + sgn' a b c * r) / 2
  r = sqrt'(sq' b - 4*.(a*c))

main :: IO Int
main = print a >> pure 0
\end{verbatim}
\end{haskellcode}

\section{余談：正格評価*}

% https://blog.miz-ar.info/2016/06/writing-efficient-program-with-haskell/


\chapter{より複雑な演算}
\label{ch:more-arithmetic}

\section{数学関数の演算*}

$y=\hxFunc{f}\hxVar{x}$ ただし
\begin{equation}
\begin{aligned}
\hxFunc{f}\hxVar{x}&\hGuard{x\hIfEq0}=1\\
&\hGuard{\hOtherwise}=(\sin x)/x
\end{aligned}
\end{equation}
とする．ここで $\hxConstant{0}\le x\le\pi$ の範囲で $\hxVar{y}$ の値を求めたいとしよう．$\hxVar{x}$
の範囲を $n+1$ 分割するとする．

まず $n$ に具体的な型と値を与えておこう．これは次のようにする．
\begin{equation}
\left\{
\begin{aligned}
n&\hIsTypeOfhaskell.Int\\
n&=100
\end{aligned}
\right.
\end{equation}

次に，関数 $\hxFunc{f}$ を定義しておこう．
\begin{equation}
\left\{
\begin{aligned}
f&\hIsTypeOf\mProjEXP{haskell.Double}{haskell.Double}\\
\hxFunc{f}\hxVar{x}&\hGuard{x\hIfEq0}=1\\
&\hGuard{\hOtherwise}=(\sin x)/x
\end{aligned}
\right.
\end{equation}

関数 $\hxFunc{f}$ に与える引数 $\hxVar{x}$ のリストを定義する．
\begin{equation*}
  \left\{
  \begin{aligned}
    \hListVar{x}
    &\hIsTypeOf{}[haskell.Double]\\
    \hListVar{x}
    &=[i/n*\pi\mListComp i\mFrom[0\dotsb n]]
  \end{aligned}
  \right.
\end{equation*}
実はこのままではまずい．変数 $i$ も変数 $n$ も $haskell.Int$ 型なので，
割り算が出来ないのだ．そこで型変換のための関数 $\hFromIntegral$ を使お
う．関数 $\hFromIntegral$ は $haskell.Integral$ 型クラスの型の変数
を，任意の型へと変換する．関数 $\hFromIntegral$ を使って書き直すと
\begin{equation}
  \left\{
  \begin{aligned}
    \hListVar{x}
    &\hIsTypeOf{}[haskell.Double]\\
    \hListVar{x}
    &=[(\hFromIntegral i)/(\hFromIntegral n)*\pi\mListComp i\mFrom[0\dotsb n]]
  \end{aligned}
  \right.
\end{equation}
となる．この結果，リスト $\hListVar{x}$ は
\begin{equation}
  \hListVar{x}
  =[0,(1/n)*\pi,(2/n)*\pi,\dotsb,\pi]
\end{equation}
となる．

最後に，関数 $\hxFunc{f}$ をリスト $\hListVar{x}$ に適用して結果を得る．
\begin{equation}
  \left\{
  \begin{aligned}
    y
    &\hIsTypeOf{}[haskell.Double]\\
    y
    &=\hxFunc{f}\hMap\hListVar{x}
  \end{aligned}
  \right.
\end{equation}

結果 $\hListVar{y}$ はプログラム
\begin{equation}
\mMain=\mPrint yhaskell.bindRightIgnore\mPureWith{0}
\end{equation}
によって出力できる．

これをそのままHaskellプログラムにすると次のようになる．
\begin{haskellcode}
\begin{verbatim}
-- sample.hs
n :: Int
n = 100
f :: Double -> Double
f x | x == 0    = 1
    | otherwise = (sin x)/x
x_"s" :: [Double]
x_"s" = [(fromIntegral i) / (fromIntegral n)
  * pi | i <- [0..n]]
y_"s" :: [Double]
y_"s" = f `map` x_"s"
main = print y_"s" >> pure 0
\end{verbatim}
\end{haskellcode}

なお，円周率 $\pi$ はそのまま定数 \code{pi} として \filename{Prelude}
で定義されている．

\begin{table}
\caption{\filename{Prelude} のデータ型}
\label{tab:data-types}
\begin{center}
\begin{tabular}{||c|c||}
\hline
名前&型名\\
\hline\hline
\code{Bool}&論理型 $(haskell.Bool)$\\
\code{Char}&文字型 $(haskell.Char)$\\
\code{Int}&整数型 $(haskell.Int)$\\
\code{Integer}&整数型 $(haskell.Integer)$\\
\code{Float}&単精度浮動小数点型 $(haskell.Float)$\\
\code{Double}&倍精度浮動小数点型 $(haskell.Double)$\\
\code{String}&\code{[Char]} の型シノニム\\
\hline
\end{tabular}
\end{center}
\end{table}

\begin{table}
\caption{\filename{Prelude} の多相型}
\label{tab:data-types-polymorphic}
\begin{center}
\begin{tabular}{||c|c||}
\hline
名前&型名\\
\hline\hline
\code{[a]}&リスト $(\hListConstruct{haskell.a})$\\
\code{Maybe a}&Maybe $\left(\hMaybeConstruct{haskell.a}\right)$\\
\code{Either a b}&Either $\left(\hEitherConstruct{a}{b}\right)$\\
\code{((->)r)a}&関数 $\left(\mFuncType{a}{r}\right)$\\
\hline
\end{tabular}
\end{center}
\end{table}

% \section{コンボリューション演算*}

---

\begin{equation}
(f\circledcirc g)t=\sum_x\hxFunc{f}\hxVar{x}*g(t-x)
\end{equation}

\begin{equation}
\begin{aligned}
yt&=\sum(\hxLambdaSyntax{x}{\mFst x*\mSnd x})\hMap\hListVar{h}\\
&\quad\mWhere\\
&\qquad\hListVar{h}\mLetEq{}\mZipFunc\hListVar{f}\hListVar{g}\\
&\qquad\hListVar{f}\mLetEq[\hxFunc{f}\hxVar{x}\mListComp x\mFrom[\hxConstant{0},\hxConstant{1}\dotsb n]]\\
&\qquad\hListVar{g}\mLetEq[g(t-x)\mListComp x\mFrom[\hxConstant{0},\hxConstant{1}\dotsb n]]
\end{aligned}
\end{equation}

効率悪い．

---

\begin{equation}
(\circledcirc)\hIsTypeOf{}(haskell.Num\hHasElementsOfhaskell.a )\hAndThen{}
\mProjEXP{
  (\mProjEXP{haskell.a }{haskell.a })
}
{
  \mProjEXP{(\mProjEXP{haskell.a }{haskell.a })}
  {\mProjEXP{haskell.a }{haskell.a }}
}
\end{equation}

\begin{equation}
f\circledcirc g=\hxLambdaSyntax{t}{\sum \hxFunc{f}\hxVar{x}*g(t-x)}
\end{equation}


$$
yt=(f\circledcirc g)t
$$


$$
yt=\sum_x\hxFunc{f}\hxVar{x}*g(t-x)
$$

$$
y=\sum_x\hxFunc{f}\hxVar{x}*g(\hxAnonParam-x)
$$

\section{行列演算*}

\TK{Data.Vector}

% http://qiita.com/lotz/items/2c932b45f78f6fc70e9c
% http://itpro.nikkeibp.co.jp/article/COLUMN/20120605/400424/

\section{余談：アンボックス化}

\TK{Unboxed}

% Haskellだけでイメージ（画像）を効率的に扱おうとすると非常な困難に出
% 会う．これはHaskellがイメージデータを効率的に保存するデータ構造を持
% たないからである．一つの解決策は OpenCV というイメージ演算ライブラリの
% Haskellバインディングを用いることである．

% http://qiita.com/ma-oshita/items/2a66d8818664f2936afe
% http://nebuta.hatenablog.com/entry/2013/06/15/154259

---

% \section{余談：複素数*}

\begin{equation}
\hxVar{z}={}!x{}\mComplexPlus{}!y
\end{equation}

\begin{haskellcode}
\begin{verbatim}
import Data.Complex
z :: Complex Double
z = !x :+ !y
\end{verbatim}
\end{haskellcode}

% ベクトル

\chapter{IO*}
\label{ch:more-io}

\section{書き出し*}
\section{読み込み*}
\section{IOモナド*}
% \section{余談：ダークサイド*}

\section{余談：コマンドライン引数*}

コマンドライン引数はアクション \code{getArgs} で読み出すことができる．
例えば
\begin{haskellcode}
\begin{verbatim}
-- args.hs
import Sy_"s"tem.Environment (getArgs)
main :: IO Int
main = do
  args <- getArgs
  {- do something -}
  return 0
\end{verbatim}
\end{haskellcode}
とすると，リスト \code{args} にコマンドライン引数が渡される．アクショ
ン \code{getArgs} の戻り値の型は \code{[String]} である．

\begin{equation}
\mMain=(\dotsb\mWhere{}\hListVar{a}=haskell.action{getArgs})haskell.bindRightIgnore\mPureWith{0}
\end{equation}

\section{この章のまとめ*}



\chapter{モジュール*}
\label{ch:module}

\chapter{代数的構造}
\label{ch:algebra}

\begin{leader}
この章では「代数的構造」を見ていくことにする．代数的構造とは，四則演算
のような数に関する基本的な性質を抽象化していくことで，数の背後にある基
本的なメカニズムを抽出したものである．代数的構造はあらゆるプログラミン
グ言語に明示的，あるいは非明示的に見られる要素である．
\end{leader}

\section{数}

これから各種の#keyword[代数的構造}を見ていくことにする．代数的構造と言っ
ても，身構える必要はない．それは，我々プログラマが日々接している概念に，
共通した名前を与えたにすぎない．

まず最初に，我々にとって一番身近な代数的構造である#keyword[数}を見てみ
よう．数の代表例は#keyword[実数}であるから，実数を例にとって考えてみよ
う．実数全体の集合を $\mRSet$ で表すことにする．また任意の実数を
$\hxVar{x},\hxVar{y},\hxVar{z}$ で表すこととする．このことを数学者は $\hxVar{x},\hxVar{y},\hxVar{z}\in\mRSet$ と書くが，
本書ではこれまで通り
\begin{equation}
x,\hxVar{y},\hxVar{z}\hIsTypeOf\mRSet
\end{equation}
と表すことにする．

以下に実数の備える代数的性質を列挙する．どれも当たり前のことに見えるが，
ひとつひとつ見ていこう．ここで $\hxVar{x},\hxVar{y},\hxVar{z}\hIsTypeOf\mRSet$ とする．
\begin{description}
\item[実数の性質1. 加法の全域性] 任意の $\hxVar{x}$ と任意の $\hxVar{y}$ の#keyword[加
法}（足し算）の結果すなわち#keyword[和} $\hxVar{x}+y$ は $\mRSet$ の元すなわ
ち実数である．演算の結果が同じ集合の元になることを#keyword[全域性}と
呼ぶ．
\item[実数の性質2. 加法の結合性] 任意の $\hxVar{x},\hxVar{y},\hxVar{z}$ について
\begin{equation}
(\hxVar{x}+\hxVar{y})+\hxVar{z}=x+(y+z)
\end{equation}
である．これを加法の#keyword[結合性}（結合律）と呼ぶ．
\item[実数の性質3. 零元（加法単位元）の存在] 特別な実数 $0\hIsTypeOf\mRSet$ があり
\begin{equation}
0+x=x+0=x
\end{equation}
である．この $\hxConstant{0}$ は足し算の#keyword[単位元}である．#keyword[零元}また
は#keyword[加法単位元}と呼ぶこともある．単位元が存在することを単位律と
呼ぶこともある．
\item[実数の性質4. 負元（加法逆元）の存在] 任意の $\hxVar{x}$ に対して
$-x\hIsTypeOf\mRSet$ があり
\begin{equation}
-x+x=0
\end{equation}
である．この $-x$ は $\hxVar{x}$ の加法の#keyword[逆元}である．#keyword[負元}
または#keyword[加法逆元}と呼ぶこともある．逆元が存在することを消約律と
呼ぶこともある．
\item[実数の性質5. 加法の可換性] 任意の $\hxVar{x},\hxVar{y}$ について
\begin{equation}
\hxVar{x}+\hxVar{y}=y+x
\end{equation}
である．このことを加法の#keyword[可換性}（可換律）と呼ぶ．
\item[実数の性質6. 乗法] 任意の $\hxVar{x}$ と任意の $\hxVar{y}$ の#keyword[乗法}（掛
け算）の結果すなわち#keyword[積} $\hxVar{x}*y$ は $\mRSet$ の元すなわち実数
である．
\item[実数の性質7. 乗法の結合性] 任意の $\hxVar{x},\hxVar{y},\hxVar{z}$ について
\begin{equation}
(x*y)*\hxVar{z}=x*(y*z)
\end{equation}
である．
\item[実数の性質8. 単位元の存在] 特別な実数 $1\hIsTypeOf\mRSet$ があり
\begin{equation}
1*x=x*1=x
\end{equation}
である．この $\hxConstant{1}$ を乗法の単位元または#keyword[乗法単位元}と呼ぶ．
\item[実数の性質9. 逆元の存在] 任意の $\hxVar{x}$ に対して $\hxVar{x}^{-1}\hIsTypeOf\mRSet$
があり
\begin{equation}
x^{-1}*x=1
\end{equation}
である．この $\hxVar{x}^{-1}$ は $\hxVar{x}$ の乗法の逆元である．#keyword[乗法逆元}と
呼ぶこともある．ただし性質11で述べる通り，加法単位元については逆元がな
くても良い．
\item[実数の性質10. 乗法の可換性] 任意の $\hxVar{x},\hxVar{y}$ について
\begin{equation}
x*y=y*x
\end{equation}
である．このことを乗法の可換性と呼ぶ．
\item[実数の性質11. 加法単位元の乗法逆元] 加法単位元に対する乗法の逆元
は存在しなくても良い．（つまり $0^{-1}$ のことは考えなくて良い．）
\item[実数の性質12. 分配律] 加法と乗法が混在する場合
\begin{equation}
(\hxVar{x}+\hxVar{y})*\hxVar{z}=(x*z)+(y*z)
\end{equation}
と乗法を#keyword[分配}する．
\end{description}
以上が実数の代数的性質の全てである．我々がよく使う引き算，割り算は数学
上はシンタックスシュガーである．

上述の12個の条件が当てはまる数には#keyword[有理数}や#keyword[複素数}が
ある．この12個の性質をまとめて，数学では#keyword[体}と呼ぶ．

体の要素は，集合 $\mKSet$，二項演算子 $+$，二項演算子 $+$ の単位元 $\hxConstant{0}$，
二項演算子 $+$ の逆元生成演算子 $-$，もう一つの二項演算子 $*$，二項演
算子 $*$ の単位元 $\hxConstant{1}$，二項演算子 $*$ の逆元生成演算子 ${}^{-1}$ であ
るから，体はそれらを列挙して $\hSingleTuppleWith{\mKSet,+,0,-,*,1,{}^{-1}}$
と表現する．

体の性質から言えることを一つ紹介しよう．これから
\begin{equation}
z\uparrow n=\underbrace{z*\dotsb*z}_n
\end{equation}
なる二項演算子 $\uparrow$（#keyword[クヌースの矢印}）を使う．ここに
$\hxVar{z}$ を体の元，$n$ を自然数とした．さて $z\uparrow2$ は
\begin{equation}
z\uparrow2=z*z
\end{equation}
であるから，いま $\hxVar{z}=\hxVar{x}+\hxVar{y}$ とすると
\begin{align}
z\uparrow2&=z*z\\
&=z*(\hxVar{x}+\hxVar{y})\\
&=z*x+z*y\;\text{---分配律}\\
&=(\hxVar{x}+\hxVar{y})*x+(\hxVar{x}+\hxVar{y})*y\\
&=x*\hxVar{x}+\hxVar{y}*x+x*y+y*y\;\text{---分配律}\\
&=x\uparrow2+x*y+y*\hxVar{x}+\hxVar{y}\uparrow2
\end{align}
となり
\begin{equation}
\label{eq:xy_"s"q}
(\hxVar{x}+\hxVar{y})\uparrow2=x\uparrow2+x*y+y*\hxVar{x}+\hxVar{y}\uparrow2
\end{equation}
を得る．式\eqref{eq:xy_"s"q}は体の性質だけを使って導いた関係なので，実数
だけでなく有理数や複素数にもそのまま使える．実際には式\eqref{eq:xy_"s"q}
は体の性質のうち分配律だけを使っているので，体以外にも応用が利く式でも
ある．#footnote[Knuthの矢印 $(\uparrow)$ はHaskellでは演算子
\code{\^} として提供されている．}

\begin{table*}
\caption{代表的な代数的構造の性質(1)}
\label{tab:field-and-ring}
\begin{center}
\begin{tabular}{||c||c|c|c|c|c|c||}
\hline
代数的構造&$+$&$+$ の単位元&$+$ の逆元&$*$&$*$ の単位元&$*$ の逆元\\
\hline\hline
体&可換&あり&あり&可換&あり&あり\\
環&可換&あり&あり&非可換&あり&なし\\
\hline
\end{tabular}
\end{center}
\end{table*}

\section{群}

体の性質を若干緩めたい場合がある．さもなければ，#keyword[整数}，
#keyword[正方行列}，#keyword[クォータニオン}（四元数），#keyword[論理
値}，#keyword[ベクトル}，ベクトルの#keyword[変換}，集合から集合への
#keyword[写像}と言った重要な概念が数の概念からこぼれてしまうからである．
例えば整数の掛け算の逆元は（単位元の逆元を除いて）整数の中には存在しな
いし，正則行列やクォータニオンの場合は掛け算が可換ではない．

だいたいどの辺まで制約を緩めたものを数の仲間に入れるかというのは見解の
分かれるところでもあるが，体から性質9（乗法の逆元），性質10（乗法の可
換性），性質11（加法単位元の乗法逆元）を取り除いたものを#keyword[環}
と呼び，環の性質を持つものを数の仲間に入れることが一般的である．環の性
質を持つものは，体である実数，有理数，複素数に加えて，整数，正方行列，
クォータニオン，論理値などがある．

制約を少しずつ緩める代わりに，制約をその構成要素に分解するほうがさらな
る応用が利きそうである．体には二つの二項演算子 $+$ と $*$ が登場した．
その片方にのみ注目してみたらどうなるだろう．それがこの節で取り上げる
#keyword[群}である．

形式的に体と環の性質を並べたものが表\ref{tab:field-and-ring}である．こ
れを見ると，各演算子について「可換・単位元あり・逆元あり」の組み合わせ
が二つペアになったもの（体）か，「可換・単位元あり・逆元あり」の組み合
わせと「非可換・単位元あり・逆元なし」の組み合わせがペアになったもの
（環）があることがわかる．

いま集合 $\mSet{G}$ があり，$\hxVar{x},\hxVar{y},\hxVar{z}\hIsTypeOf\mSet{G}$ であるとし，二項演算子
を $\hAnyBinOp$ と書くことにして，体の性質の前半分を書き下してみよう．
\begin{description}
\item[性質1.] 任意の $\hxVar{x}$ と任意の $\hxVar{y}$ の演算の結果 $\hxVar{x}\hAnyBinOp y$ は
$\mSet{G}$ の元である．
\item[性質2.] 任意の $\hxVar{x},\hxVar{y},\hxVar{z}$ について
\begin{equation}
(x\hAnyBinOp y)\hAnyBinOp \hxVar{z}=x\hAnyBinOp(y\hAnyBinOp z)
\end{equation}
である．
\item[性質3.] 特別な元 $\mZero\hIsTypeOf\mSet{G}$ があり
\begin{equation}
\mZero\hAnyBinOp x=x\hAnyBinOp\mZero=x
\end{equation}
である．
\item[性質4.] 任意の $\hxVar{x}$ に対して $\mMinus x\hIsTypeOf\mSet{G}$ があり
\begin{equation}
\mMinus x\hAnyBinOp x=\mZero
\end{equation}
である．
\item[性質5.] 任意の $\hxVar{x},\hxVar{y}$ について
\begin{equation}
x\hAnyBinOp y=y\hAnyBinOp x
\end{equation}
である．
\end{description}
このような性質が満たされる時，組み合わせ
$\hSingleTuppleWith{\mSet{G},\hAnyBinOp,\mZero,\mMinus}$ を#keyword[可換群}また
は#keyword[加群}と呼ぶ．この可換群が最初の構成要素「可換・単位元あり・
逆元あり」の正体である．

例えば $\hSingleTuppleWith{\mRSet,+,0,-}$ は可換群である．整数全体の集合を
$\hSet{Z}$ とすると $\hSingleTuppleWith{\hSet{Z},+,0,-}$ も可換群である．また，集
合 $\mRSet$ から $\hxConstant{0}$ だけを取り除いた集合を $\mRSet\setminus0$ とする
とき $\hSingleTuppleWith{\mRSet\setminus0,*,1,{}^{-1}}$ も可換群である．

可換群は代表的な代数的構造のひとつであり，他にも数学のあちこちに顔を出
している．例えば回転角を $t$ とする二次元の回転変換を $R_t$ として，回
転変換 $R_t$ すべてからなる集合 $\mSet{R}$ を考えてみよう．回転の合成
を $\mCompRot$ で表すとすると
\begin{equation}
\label{eq:rotation}
R_{t_1}\mCompRot R_{t_2}=R_{(t_1+t_2)}
\end{equation}
であるから，回転を合成した結果も回転である．また式\eqref{eq:rotation}
から
\begin{equation}
  R_{t_1}\mCompRot\left(R_{t_2}\mCompRot R_{t_3}\right)
  =\left(R_{t_1}\mCompRot R_{t_2}\right)\mCompRot R_{t_3}
\end{equation}
であるから，回転変換は結合性も満たしている．

次にに回転変換に単位元があるかどうか調べてみよう．回転しない変換は
#keyword[恒等変換}とも言い，しばしば $I$ で表す．何もしない回転変換は
$\hxConstant{0}$ 度の回転であるから $I=R_0$ である．このとき式\eqref{eq:rotation}か
ら
\begin{equation}
I\mCompRot R_t=R_t\mCompRot I=R_t
\end{equation}
であるから，$I$ は回転変換の単位元であると言える．

最後に回転変換に逆元があるかも調べてみよう．$t$ 回転の逆は明らかに
$-t$ であるから
\begin{equation}
R_{-t}\mCompRot R_t=R_t\mCompRot R_{-t}=I
\end{equation}
が成り立つ．そこで
\begin{equation}
{R_t}^{-1}=R_{-t}
\end{equation}
として $R_t$ の逆元 ${R_t}^{-1}$ を定義することができる．

このように，組み合わせ $\hSingleTuppleWith{\mRSet,\mCompRot,I,{}^{-1}}$ も可
換群である．（回転 $R_t$ 全体の集合 $\mSet{R}$ が群を形成することは，
パラメタ $t$ が所属する実数全体の集合 $\mRSet$ が群を形成することに
大いに頼っている．この部分を詳細に調べるとリー群という美しい代数的構
造が見つかる．）

回転されるものをベクトルと呼ぶ．ベクトルや回転変換の実装方法はいくつか
あり，例えば第1座標値を $u$，第2座標値を $v$ としたときにベクトル
$\mVec{p}$ を
\begin{equation}
\mVec{p}=\begin{bmatrix}u\\v\end{bmatrix}
\end{equation}
と表すことにしよう．矢印は変数 $p$ がベクトルであることを忘れないよう
にするための飾りである．このとき，回転変換は
\begin{equation}
R_t=\begin{bmatrix}\cos t&-\sin t\\\sin t&\cos t\end{bmatrix}
\end{equation}
と行列で表すことになり，回転後のベクトル $\mVec{p'}$ は
\begin{equation}
\mVec{p'}=R_t*\mVec{p}
\end{equation}
となる．ここに演算子 $*$ は行列の積である．また，この場合変換の合成
$\mCompRot$ は行列積 $*$ となる．

他にもベクトルを複素数で表現する方法もある．いま $\mVec{p}$ を
\begin{equation}
\mVec{p}=u+I v
\end{equation}
と表して，回転変換 $R_t$ を
\begin{equation}
R_t=\cos t+I\sin t
\end{equation}
とすると，回転後の $\mVec{p'}$ はやはり
\begin{equation}
\mVec{p'}=R_t*\mVec{p}
\end{equation}
と書ける．ここに演算子 $*$ は複素数の積である．また，この場合変換の合
成 $\mCompRot$ も複素数積 $*$ となる．

任意次元のベクトル全体からなる集合を $\mSet{V}$ として，零ベクトルを
$\mVec{0}$ で表すことにしよう．ここでも矢印はベクトルであることを忘れ
ないようにするための飾りである．ベクトル同士の加算を二項演算子 $+$ で
表し，向きを反転させた逆ベクトル作る演算子を $-$ とすると，組み合わせ
$\hSingleTuppleWith{\mSet{V},+,\mVec{0},-}$ もまた可換群である．

可換群の性質のうち最初の4項目だけを満たすものを群と呼ぶ．可換群は群の
特別な場合である．現代の数学では $\hxVar{x}\hAnyBinOp y\neq y\hAnyBinOp x$ のように
演算子の前後を入れ替えると結果が異なるような演算をよく取り扱うので，一
般の群は可換群よりもよく取り上げられ，それ故より短い名前が付けられてい
る．

もう一度組み合わせ $\hSingleTuppleWith{\mSet{G},\hAnyBinOp,O,\mMinus}$ が群であ
る条件を少し緩め，逆元が存在しなくても良い「緩やかな群」を考えてみる．
この「緩やかな群」のことを#keyword[単位的半群}または#keyword[モノイド}
と呼ぶ．これが構成要素「非可換・単位元あり・逆元なし」の正体である．

\begin{table}
\caption{代表的な代数的構造の性質 (2)}
\label{tab:group-and-monoid}
\begin{center}
\begin{tabular}{||c||c|c|c||}
\hline
代数的構造&$\hAnyBinOp$&$\hAnyBinOp$の単位元&$\hAnyBinOp$の逆元\\
\hline\hline
可換群&可換&あり&あり\\
群&非可換&あり&あり\\
単位的半群&非可換&あり&なし\\
半群&非可換&なし&なし\\
\hline
\end{tabular}
\end{center}
\end{table}

単位的半群の性質は次の三つである．ただし $\hxVar{x},\hxVar{y},\hxVar{z}$ が集合 $\mSet{M}$ の
元であるとする．
\begin{description}
\item[単位的半群の性質1.] 任意の $\hxVar{x}$ と任意の $\hxVar{y}$ の演算の結果
$\hxVar{x}\hAnyBinOp y$ は $\mSet{M}$ の元である．
\item[単位的半群の性質2. 結合性] 任意の $\hxVar{x},\hxVar{y},\hxVar{z}$ について
\begin{equation}
(x\hAnyBinOp y)\hAnyBinOp \hxVar{z}=x\hAnyBinOp(y\hAnyBinOp z)
\end{equation}
である．
\item[単位的半群の性質3. 単位元の存在] 特別な元 $\mZero\hIsTypeOf\mSet{M}$ があり
\begin{equation}
\mZero\hAnyBinOp x=x\hAnyBinOp\mZero=x
\end{equation}
である．
\end{description}
このとき，組み合わせ $\hSingleTuppleWith{\mSet{M},\hAnyBinOp,\mZero}$ が単位的半
群である．可換群とこの単位的半群を組み合わせたのが環，可換群二つを組み
合わせたのが体であった．

なお，これまで単位元の定義として
\begin{equation}
\mZero\hAnyBinOp x=x\hAnyBinOp\mZero=x
\end{equation}
を掲げているが，厳密には単位元は
\begin{equation}
\mZero_\mLeft\hAnyBinOp x=x\hAnyBinOp\mZero_\mRight=x
\end{equation}
のように，#keyword[左単位元}と#keyword[右単位元}を区別しても良い．

単位的半群の性質からさらに性質3を消したものを#keyword[半群}と呼ぶ．可
換群，群，単位的半群，半群を一覧にしたものを表
\ref{tab:group-and-monoid}に掲げる．

\section{圏}

これまでは集合の元同士に対する二項演算を考えてきた．集合$\mSet{M}$が単
位的半群であるとき，集合$\mSet{M}$の元$\hxVar{x},y\hIsTypeOf\mSet{M}$に対して
$\hxVar{x}\hAnyBinOp y\hIsTypeOf\mSet{M}$であった．見方を変えると，演算子$\hAnyBinOp$とは
集合$\mSet{M}$の元2個から出発して，集合$\mSet{M}$の元1個へとジャンプさ
せる#keyword[写像}であると言える．これを
\begin{equation}
\hAnyBinOp\hIsTypeOf{}\mMorph{(\mSet{M}\mSetTimes\mSet{M})}{\mSet{M}}
\end{equation}
と書く．ここに $\mSet{X}\mSetTimes\mSet{Y}$ は集合 $\mSet{X}$ と集合
$\mSet{Y}$ の#keyword[直積集合}である．直積集合と元の集合はもはや別な
集合であることに注意しよう．

写像は $\mMorph{\mSet{M}\mSetTimes\mSet{M}}{\mSet{M}}$ に限ったもの出
はなく，集合 $\mSet{M}$ から集合 $\mSet{M}$ への写像 $\mUnOp$ ただし
\begin{equation}
\mUnOp\hIsTypeOf\mMorph{\mSet{M}}{\mSet{M}}
\end{equation}
があっても良い．実はこれまでにも登場した逆元を作る演算子はまさに
$\mMorph{\mSet{M}}{\mSet{M}}$ という写像である．

またベクトルには，実数倍や回転といった写像がある．これらは実数のパラメ
タを一つとるので，ベクトル全体の集合を $\mSet{V}$，実数全体の集合を
$\mRSet$ として，実数のパラメタを $r$ としたときに
\begin{equation}
\mUnOp_r\hIsTypeOf{}\mMorph{(\mRSet\mSetTimes\mSet{V})}{\mSet{V}}
\end{equation}
と書ける．例えば回転の場合は $\mUnOp_r=R_r$ である．

このようにとある集合（例えば $\mSet{M}\mSetTimes\mSet{M}$ や
$\mRSet\mSetTimes\mSet{V}$）から異なる別な集合（例えば $\mSet{M}$ や
$\mSet{V}$）へという写像を一般化するとどうなるだろうか．いま，集合
$\mSet{X}$ から集合 $\mSet{Y}$ への写像 $\hxFunc{f}$ があり，集合 $\mSet{Y}$ か
ら集合 $\mSet{Z}$ への写像 $\hxFunc{g}$ があるとする．すなわち
\begin{align}
f&\hIsTypeOf\mMorph{\mSet{X}}{\mSet{Y}}\\
g&\hIsTypeOf\mMorph{\mSet{Y}}{\mSet{Z}}
\end{align}
があるとする．また写像同士を二項演算子 $\mCompProj$ で#keyword[合成}で
きるものとする．例えば $\hxFunc{f}$ と $\hxFunc{g}$ の合成写像は $\mSet{X}$ を出発点に
$\mSet{Y}$ を経由して $\mSet{Z}$ へと行くので
\begin{equation}
f\mCompProj g\hIsTypeOf\mMorph{\mSet{X}}{\mSet{Z}}
\end{equation}
と書ける．ここで合成演算子は結合性を満たすものとしておこう．

さらに
\begin{equation}
I_\mSet{X}\hIsTypeOf\mMorph{\mSet{X}}{\mSet{X}},\;
I_\mSet{Y}\hIsTypeOf\mMorph{\mSet{Y}}{\mSet{Y}},\;
I_\mSet{Z}\hIsTypeOf\mMorph{\mSet{Z}}{\mSet{Z}}
\end{equation}
という写像もあるとしよう．ここで
\begin{equation}
I_\mSet{Y}\mCompProj f=\hxFunc{f}\mCompProj I_\mSet{X}
\end{equation}
とすると，写像 $I_\mSet{X}$ と写像 $I_\mSet{Y}$ はそれぞれ写像の合成演
算子 $\mCompProj$ に対して単位元のように振る舞う．写像 $\hxFunc{g}$ については
\begin{equation}
I_\mSet{Z}\mCompProj g=\hxFunc{g}\mCompProj I_\mSet{Y}
\end{equation}
であるとする．このような写像 $I_\mSet{X},I_\mSet{Y},I_\mSet{Z}$ を
#keyword[恒等写像}と呼ぶ．

集合 $\mSet{X}$，集合 $\mSet{Y}$，集合 $\mSet{Z}$ の集合
$\mSet{C}=\{\mSet{X},\mSet{Y},\mSet{Z}\}$ と，写像 $\hxFunc{f}$ と写像
$\hxFunc{g}$ の集合 $\mSet{P}=\{f,g\}$ と，写像合成演算子 $\mCompProj$
と，恒等写像の集合 $\mSet{I}$ の組み合わせ
$\hSingleTuppleWith{\mSet{C},\mSet{P},\mCompProj,\mSet{I}}$ を#keyword[圏}と
呼ぶ．写像合成演算子 $(\mCompProj)$ と恒等写像の集合 $(\mSet{I})$ は自
明であるためしばしば省略され，組み合わせ
$\hSingleTuppleWith{\mSet{C},\mSet{P}}$ を圏とする書き方もよくされる．

圏を考えるとき，変換や写像は全て#keyword[射}と呼ぶ決まりである．

いまある単位的半群 $\hSingleTuppleWith{\mSet{M},\hAnyBinOp,O}$ があるとする．集
合 $\mSet{C}$ を $\mSet{M}$ 及び $\mSet{M}\mSetTimes\mSet{M}$ を元とす
る集合すなわち
\begin{equation}
\mSet{C}=\{\mSet{M},\mSet{M}\mSetTimes\mSet{M}\}
\end{equation}
とし，集合 $\mSet{P}$ を $\hAnyBinOp$ のみを元とする集合すなわち
\begin{equation}
\mSet{P}=\{\hAnyBinOp\}
\end{equation}
とすると，組み合わせ $\hSingleTuppleWith{\mSet{C},\mSet{P}}$ は圏になっている．

---

圏の構造．

カリー化された加算．カリー化されたmin.

対象，射，射の合成．

対象は整数集合．

射は整数から整数への関数．

恒等射．

射の合成．関数の合成．

単位律．結合律．

モノイドとは対象がひとつだけ存在する圏である．四則演算は対象がひとつだけなので，モノイドである．

関手．カリー化した圏から中置演算子への圏への写像．

% http://bitterharvest.hatenablog.com/entry/2015/02/12/155738

\section{余談：束*}

\section{この章のまとめ}

% http://bitterharvest.hatenablog.com/entry/2015/02/12/155738

\begin{table*}
\begin{center}
\begin{tabular}{||c||c|c|c|c|c||}
\hline
&Totality&Associativity&Identity&Divisibility&Commutativity\\
\hline\hline
Semicategory&&$\checkmark$&&&\\
Category&&$\checkmark$&$\checkmark$&&\\
Groupoid&&$\checkmark$&$\checkmark$&$\checkmark$&\\
Magma&$\checkmark$&&&&\\
Quasigroup&$\checkmark$&&&$\checkmark$&\\
Loop&$\checkmark$&&$\checkmark$&$\checkmark$&\\
Semigroup&$\checkmark$&$\checkmark$&&&\\
Monoid&$\checkmark$&$\checkmark$&$\checkmark$&&\\
Group&$\checkmark$&$\checkmark$&$\checkmark$&$\checkmark$&\\
Abelian Group&$\checkmark$&$\checkmark$&$\checkmark$&$\checkmark$&$\checkmark$\\
\hline
\end{tabular}
\end{center}
\end{table*}

\begin{table*}
\caption{代数的構造}
\label{tab:algebraicstrcture}
\begin{center}
\begin{tabular}{||c||c|c|c|c|c||}
\hline
&全域性&結合性&単位律&消約律&可換性\\
\hline\hline
半圏(semicategory)&&$\checkmark$&&&\\
圏(category)&&$\checkmark$&$\checkmark$&&\\
亜群(groupoid)&&$\checkmark$&$\checkmark$&$\checkmark$&\\
マグマ(magma)&$\checkmark$&&&&\\
擬群(quasigroup)&$\checkmark$&&&$\checkmark$&\\
ループ(loop)&$\checkmark$&&$\checkmark$&$\checkmark$&\\
半群(semigroup)&$\checkmark$&$\checkmark$&&&\\
モノイド(monoid)&$\checkmark$&$\checkmark$&$\checkmark$&&\\
群(group)&$\checkmark$&$\checkmark$&$\checkmark$&$\checkmark$&\\
可換群(Abelian group)&$\checkmark$&$\checkmark$&$\checkmark$&$\checkmark$&$\checkmark$\\
\hline
\end{tabular}
\end{center}
\end{table*}

% 亜群(groupoid)を中国語では「廣（広）群」と書く．亜群はかつてはマグマの訳語として我が国で用いられていた．
% 擬群のことを準群と呼ぶこともある．この場合ループを擬群と呼ぶこともある．


\chapter{モナドとプログラミング言語*}
\label{ch:monad-and-programming-lang}
\section{ジョイン*}
\section{クライスリ・トリプル*}
\section{*}
\section{余談：計算可能性*}
% https://ja.wikipedia.org/wiki/計算可能関数
$\mu$再帰関数
% https://ja.wikipedia.org/wiki/Μ再帰関数
\section{この章のまとめ*}


\chapter{ラムダ*}
\label{ch:lambda}

\section{条件式}

条件式は一種のシンタックスシュガーである．次のように関数
$t,f,\mIfFunc$ を定義すると，それぞれ真，偽，条件分岐のように振る舞う．
\begin{align}
t&=\hxLambdaSyntax{\hxVar{x}\hxVar{y}}{x}\\
f&=\hxLambdaSyntax{\hxVar{x}\hxVar{y}}{y}\\
\mIfFunc p\hxVar{x}\hxVar{y}&=p\hxVar{x}\hxVar{y}
\end{align}
本当かどうか試してみよう．
\begin{align}
\mIfFunc t\hxVar{x}\hxVar{y}&=t\hxVar{x}\hxVar{y}\\
&=(\hxLambdaSyntax{\hxVar{x}\hxVar{y}}{x})\hxVar{x}\hxVar{y}\\
&=x\\
\mIfFunc f\hxVar{x}\hxVar{y}&=\hxFunc{f}\hxVar{x}\hxVar{y}\\
&=(\hxLambdaSyntax{\hxVar{x}\hxVar{y}}{y})\hxVar{x}\hxVar{y}\\
&=y
\end{align}
確かに $\mIfFunc t$ は1番目の引数だけを，$\mIfFunc f$ は2番目の引数だ
けを残す．これは条件分岐そのものである．

\section{整数*}
\section{Yコンビネータ*}


\section{余談：冗談言語*}

% http://qiita.com/7shi/items/1345bf32003faff435cb#%E4%B8%8D%E5%8B%95%E7%82%B9%E3%82%B3%E3%83%B3%E3%83%93%E3%83%8D%E3%83%BC%E3%82%BF

\section{この章のまとめ*}

\chapter{型付きラムダ*}
\label{ch:typed-lambda}
\section{型付きラムダ*}
\section{カリー＝ハワード同型対応*}
\section{*}
\section{*}

Cは公式にはラムダ式を採用していない．しかしCにラムダ式を持
たせる拡張はいくつか提案されている．その一つがApple社が自社OSの Grand
Central Dispatch 機能のために行った「ブロック拡張」である．このブロッ
ク拡張を用いたクロージャの例を見てみよう．
\begin{ccode}
\begin{verbatim}
#include <Block.h>
#include <stdio.h>
typedef int (^int_to_int)(int);
int_to_int make_plus_n(int n) {
  return Block_copy(^(int x) {
      return n+x;
    });
}
int main(void) {
  int_to_int make_plus_10
    = make_plus_n(10);
  int x = make_plus_10(1);
  printf("x = %d\n", x);
  return 0;
}
\end{verbatim}
\end{ccode}
コード中の \code{\textasciicircum(int x) \{ return n+x; \}} がブロック
（クロージャ）である．Cのブロック拡張はオープンソースコミュニティ
に還元されているため，GCCやclangで使用可能である．

\section{この章のまとめ*}

% https://ja.wikipedia.org/wiki/ホーア論理

\chapter{マクロ*}
\label{ch:macro}

\section{\commonlisp のマクロ}

\section{\scheme のハイジェニックマクロ}

\section{\cxx のテンプレート}

% \section{基本関数*}
% \section{分岐と再帰*}
% \section{継続*}
% \section{余談：ハイジェニックマクロ*}
% \section{この章のまとめ*}

% \chapter{\cxx}

% \section{クラスとテンプレート*}
% \section{ラムダ式*}


\cxxfourteen
\begin{verbatim}
auto lambda_exp
  = [](auto x, auto y) { return \hxVar{x}+\hxVar{y}; };
\end{verbatim}

\begin{verbatim}
auto lambda_exp = [u = 1] { return u; };
\end{verbatim}


% \section{オブジェクト指向*}

複雑な構造に対する単純な操作について考える．

オブジェクト指向（クラス指向と呼ぶべきだが歴史はそうはならなかった）は，
複雑な構造に対する単純な操作をうまく抽象化する．

例えば，複素数（実数に比べれば複雑だ）の足し算（単純だ）は，C89/90なら
ば以下のようになる．

%\begin{verbatim}
%double x_re = 1.0;
%double x_im = 2.0;
%double y_re = 3.0;
%double y_im = 4.0;
%double \hxVar{z}_re = x_re + y_re;
%double \hxVar{z}_im = x_im + y_im;
%printf(“%f, %fn”, \hxVar{z}_re, \hxVar{z}_im);
%\end{verbatim}

優秀なCプログラマならすぐに構造体と関数を導入するだろう．しかし，より
よい方法がある．C++を使うことだ．（C99ならば複素数を扱えるが，言語の抽
  象度がC89/90よりも高いわけではない．）C++98ならば次のようにする．

%\begin{verbatim}
%std::complex<double> x(1.0, 2.0), y(3.0, 4.0);
%std::complex<double> z = x + y;
%std::cout << z << std::endl;
%\end{verbatim}

複素数はあらかじめ用意されていたが，プログラマは独自の複雑な構造（行列
だとか）を自前で作っておくことができる．複雑な構造に対する単純な操作
を陽に扱えることは，特にGUIの設計，実装にとっては決定的となる．近代的
なGUIは，複雑な構造（ビュー，コントローラ，モデルのそれぞれに当てはま
る）の間をメッセージが単純に行き交うモデルであるからである．

（いま述べたのはオブジェクト指向のうちカプセル化についてだけである．オ
ブジェクト指向の本当の力はポリモーフィズムにある．それについては後半
で触れる．）

次は，単純な構造に対する複雑な操作について考える．

C++のような素朴なオブジェクト指向機能だけでは，単純な構造に対する複雑
な操作をうまく抽象化できない．次のSchemeのコードを見てもらいたい．

%\begin{verbatim}
%(define (make-plus-n n)
% (lambda (x) (+ n x)))
%\end{verbatim}

関数（Schemeでは手続きと呼ぶ）make-plus-nは「引数にnを足す」という操作
を作る．

%\begin{verbatim}
%(define plus2 (make-plus-n 2))
%(print (plus2 3))
%\end{verbatim}

とすると5が印刷される．数値（単純だ）に対する，飢えた足し算演算子（複
  雑な気分になる）を作ったのだ．C++98でmake-plus-nを作ることは可能であ
るが，簡潔とは言い難い．準備段階として標準関数オブジェクトクラステンプ
レートstd::plusを使ってみる．

%\begin{verbatim}
%std::binder1st<std::plus<double>>
%plus2(std::plus<double>(), 2);
%\end{verbatim}

として作ったオブジェクトplus2は関数風に使える．例えば

%\begin{{verbatim}
%std::cout << plus2(3) << std::endl;
%\end{verbatim}

は5を印字する．（あるいはより簡単に

%\begin{verbatim}
%std::cout << std::bind1st(std::plus<double>(), 2)(3) << std::endl;
%\end{verbatim}

と書いても同じことである．）もう一段の抽象化がC++版のmake-plus-nである．

%\begin{verbatim}
%template <typename T> std::binder1st< std::plus<T> > make_plus_n(T n) {
% return std::binder1st< std::plus<T> >(std::plus<T>(), n);
%}
%std::binder1st< std::plus<double> > plus2 = make_plus_n(2);
%std::cout << plus2(3) << std::endl;
%\end{verbatim}

は5を印字する．驚くべきことに，優れたC++プログラマは上のコードをさらさ
らと書く．

C++0xやアップルの Grand Central Dispatch (GCD) 対応版C言語では不格好な
がらラムダ抽象が導入される．例えばC++0xではmake\_plus\_nは次のように書
けるようになるはずである．

%\begin{verbatim}
%template <typename T> auto make_plus_n(T n) {
% return [=](T x) { return n + x; }
%}
%\end{verbatim}

GCDでは同様のラムダ式をこう書く．

%\begin{verbatim}
%^(T x) { return n + x; }
%\end{verbatim}

さて，もう一度複雑な構造に対する単純な操作を振り返ってみよう．

オブジェクト指向の本質は関数のディスパッチである．メジャーなオブジェク
ト指向言語（C++を含む）は単一ディスパッチ（第1引数が指す型ポインタによっ
て実際の呼び出し先関数が決定される）であるが，LISP用オブジェクトシス
テムCLOS（これはLISP上に構築されている）は複数ディスパッチをサポートす
る．Clojureにおける例は「Closer to Clojure: ポリモーフィズム」から見て
もらいたい．

もし，オブジェクト指向かクロージャ指向かのどちらかの言語を選べと言われ
たら，クロージャ指向を取ろう．どちらの言語でも，その言語の上にもう一方
のパラダイムを築くことはできる．ただし，オブジェクト指向言語でクロージャ
指向をサポートするのは骨の折れることだ．それに対し，クロージャ指向の言
語でオブジェクト指向をサポートするのはたやすい．

---

\section{余談：Template \haskell*}

\begin{verbatim}
import Record
import Record.Lens

type Java = [r| { power :: Integer, url :: String } |]
type Link = [r| { title :: String, url :: String } |]

example :: Link
example = [r|{ title = "example", url = "http://www.example.org" }|]
\end{verbatim}
% https://wiki.haskell.org/Template_Haskell
% https://ja.stackoverflow.com/questions/5278/haskell-の-レコード構文record-syntaxにて-簡潔なフィールド名を定義すると重複しやすい問題の解決方法

---

Lens

---

\section*{余談：Cによるクロージャの実装*}

簡単なクロージャの例として，引数に $n$ を足す関数を生成する関数を
C言語で考える．
%まずはお約束の\#includeから．
%\begin{verbatim}
%#include <stdio.h>
%#include <stdlib.h>
%\end{verbatim}
やりたいことは\scheme で言えば
\begin{schemecode}
\begin{verbatim}
(define (make-plus-n n) (lambda (x) (+ n x)))
\end{verbatim}
\end{schemecode}
なのだが，レキシカルクロージャを持たないC言語では自前で変数をラッ
プする必要がある．そこで，こんな構造体を作ってみる．
\begin{ccode}
\begin{verbatim}
struct make_plus_n_context_t {
  int _n;
  int (*_func)
    (const struct make_plus_n_context_t *,
    int);
};
typedef struct make_plus_n_context_t
  MAKE_PLUS_N_CONTEXT_T;
\end{verbatim}
\end{ccode}

次に，足し算関数の実体を用意しておく．
\begin{ccode}
\begin{verbatim}
static int plus_n(
  const MAKE_PLUS_N_CONTEXT_T *context,
  int x) {
    return context->_n + x;
}
\end{verbatim}
\end{ccode}

最後に，関数 \code{make\_plus\_n} を定義する．
\begin{ccode}
\begin{verbatim}
MAKE_PLUS_N_CONTEXT_T *make_plus_n(int n) {
  MAKE_PLUS_N_CONTEXT_T *context;
  context = (MAKE_PLUS_N_CONTEXT_T *)
    malloc(sizeof(MAKE_PLUS_N_CONTEXT_T));
  context->_n = n;
  context->_func = plus_n;
  return context;
}
\end{verbatim}
\end{ccode}
この関数は \code{make\_plus\_n\_context\_t} 構造体をメモリを新たに確保
して返す．この構造体から \code{\_func} を呼んでやるのは，次のようなマ
クロを用意すると便利である．
\begin{ccode}
\begin{verbatim}
#define FUNC_CALL(context, param)
  ((context)->_func((context), (param)))
\end{verbatim}
\end{ccode}
本マクロは次のように使う．
\begin{ccode}
\begin{verbatim}
int main(void) {
  MAKE_PLUS_N_CONTEXT_T *plus_2
    = make_plus_n(2);
  int y = FUNC_CALL(plus_2, 1);
  printf("%dn", y);
  free(plus_2);
  return 0;
}
\end{verbatim}
\end{ccode}
これがC版クロージャの一例である．驚くべきことにCウィザードはこのようなことは朝飯前にやってしまう．
%（いや，もっといいコードを書くだろう．）

%僕は上記のようなコードを一瞬で書くことはできないので，Cウィザードではないのだろう．ただし，C++版の次のコードならすらすらと出てくる．（標準テンプレートライブラリがstd::plusを用意してくれたおかげであるが．）
%\begin{verbatim}
%template <typename T> std::binder1st< std::plus<T> > make_plus_n(T n) {
%  return std::binder1st< std::plus<T> %>(std::plus<T>(), n);
%}
%std::binder1st< std::plus<int> > plus_2 = make_plus_n(2);
%std::cout << plus_2(3) << std::endl;
%\end{verbatim}
%Scheme版の
%\begin{verbatim}
%(define (make-plus-n n) (lambda (x) (+ n x)))
%\end{verbatim}
%ならもっとたやすく書ける．（ウィザードじゃなくても書けるでしょ？）

\section{この章のまとめ*}

\begin{note}{オブジェクト指向とクロージャ}
...
\end{note}

% 述語論理

*/

= RENEW

= 変数・関数・型

#tk

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

ここで関数 $f$ は整数型の引数をひとつとり，整数型の値を返す．#footnote[正確には `->` は型コンストラクタである．無名の型引数を $lozenge.filled.medium$ で表すと `->` は $chevron.l lozenge.filled.medium -> lozenge.filled.medium chevron.r$ という，ふたつの型引数を取る型コンストラクタである．]

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

$ f = haskell.kwcase x haskell.kwof cases(1 --> 1, rect.stroked.h --> 0) $
この場合 $x equiv 1$ ならば $f$ は $1$ を，そうでなければ $f$ は $0$ を返す．ここに $rect.stroked.h$ はすべてのパターンに一致する記号である．パターンマッチは上から順に行われる．条件分岐の代わりに以下のような#keyword[パターンマッチ]も使える．#footnote[Haskellでは以下のように書くのが一般的である．
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
  f rect.stroked.h &= 0 $

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

関数は再帰的に呼び出せる．$n>=0$ を前提とすると，$n$ 番目のフィボナッチ数を計算する関数 $haskell.fib$ を次のように定義できる．#footnote[Haskellでは次のように書く．ただしHaskellには符号なし整数型がないために `n` が正であることを別に担保する必要がある．またこのコードは無駄な再帰呼び出しを行っており実用的ではない．
```haskell
      fib 0 = 0
      fib 1 = 1
      fib n = fib (n-1) + fib (n-2)
```]
$ haskell.fib 0 &= 0\
  haskell.fib 1 &= 1\
  haskell.fib n &= haskell.fib (n-1) + haskell.fib (n-2) $

== タプル

複数の変数をまとめてひとつの#keyword[タプル]にすることができる．例を挙げる．#footnote[Haskellでは `z = (x, y)` と書く．]
$ z = (x, y) $

タプルの型は，要素の型をタプルにしたものである．例えば $haskell.Int$ が2個からなるタプルの型は次のようになる．#footnote[Haskellでは `z :: (Int, Int)` と書く．]
$ z colon.double (haskell.Int, haskell.Int) $

要素を含まないタプルを#keyword[ユニット]と呼ぶ．ユニットは次のように書く．#footnote[Haskellでは `z = ()` と書く．]
$ z = emptyset.rev $

ユニットの型は#keyword[ユニット型]で，型注釈を次のように書く．#footnote[Haskellでは `z :: ()` と書く．]
$ z colon.double haskell.Unit $

= リスト

== リスト

任意の型について，その型の要素を並べた列を#keyword[リスト]と呼ぶ．

ある変数がリストであるとき，その変数がリストであることを忘れないように $x_"s"$ と小さく $"s"$ を付けることにする．

#keyword[空リスト]は次のように定義する．#footnote[Haskellでは `x_"s" = []` と書く．]
$ x_"s" = emptyset $

任意のリストは次のように#keyword[リスト構築演算子] $:$ を用いて構成する．
$ x_"s" = x_0:x_1:x_2:...:emptyset $

リストの型はその構成要素の型をブラケットで包んで表現する．#footnote[Haskell では `x_"s" :: [Int]` と書く．]
$ x_"s" colon.double [haskell.Int] $

リストは次のように構成することもできる．#footnote[Haskellでは `x_"s" = [1, 2..100]` と書く．ピリオドの数に注意しよう．]
$ x_"s" = [1, 2...100] $

なお次のような#keyword[無限リスト]を構成しても良い．#footnote[Haskellでは `x_"s" = [1, 2..]` と書く．]
$ x_"s" = [1, 2...] $

リストとリストをつなぐ場合は#keyword[リスト結合演算子] $smash$ を用いる．#footnote[Haskellでは `zs = x_"s" ++ y_"s"` と書く．]
$ z_"s" = x_"s" smash haskell.y_"s" $

関数はリストを受け取ることができる．次の書き方では，関数 $f$ は整数リストの最初の要素 $x$ と残りの要素 $x_"s"$ を別々に受け取り，先頭要素だけを返す．#footnote[この関数 $f$ の実装はHaskellの `head` 関数と同じである．Haskellでは `head` 関数の使用は非推奨となっており，代わりに `headMaybe` 関数が推奨されている．]
$ &f colon.double [haskell.Int] -> haskell.Int\
  &f (x : x_"s") = x $<list-head>

ただし，引数のリストが空リストである可能性を考慮して，@list-head は次のように書き直すべきである．
$ &f colon.double [haskell.Int] -> haskell.Int\
  &f emptyset = 0\
  &f (x : x_"s") = x $

$f emptyset$ が $0$ を返すのは不自然だが，関数$f$の戻り型を整数型としているためこれは仕方がない．エラーを考慮する場合は@maybe で述べるMaybeを使う必要がある．

リストのリストは次のように構成できる．#footnote[Haskellでは `x_"s" = [[1,2],[3,4]]` と書く．]
$ x_"s"s = [[1,2],[3,4]] $

== 内包表記

リストの構成には#keyword[内包表記]が使える．例を挙げる．#footnote[Haskellでは次のように書く．
```haskell
      x_"s" = [x^2 | x <- [1, 2..100], x > 50]
```]
$ x_"s" = [x^2 | x in [1,2...100], haskell.even x] $

関数 $haskell.even$ は引数が偶数の場合にだけ $haskell.True$ を返す関数である．この例では数列 $[1,2...100]$ のうち偶数だけを2乗したリストを作っている．

== 文字列

文字型のリストを文字列型と呼び $haskell.String$ で表す．$haskell.String$ 型は次のように予約語 $haskell.kwtype$ を用いて，#keyword[型シノニム]すなわち型の別名として次のように定義される．
$ haskell.kwtype haskell.String = [haskell.Char] $

文字列型のリテラルは次のように書く．#footnote[Haskell では `x_"s" = "Hello, World!"` と書く．]
$ s = haskell.constantstring("Hello, World!") $

リストに対するすべての演算は文字列にも適用可能である．

== マップと畳み込み

リスト $x_"s"$ の各要素に関数 $f$ を適用して，その結果をリスト $z_"s"$ に格納するためには次のように#keyword[マップ演算子] $*$ を用いる．#footnote[Haskellでは `zs = f <$> x_"s"` と書く．]
$ z_"s" = f * x_"s" $<map>

@map は次の式と同じである．#footnote[Haskell では `zs = [f x | x <- x_"s"]` と書く．]
$ z_"s" = [f x | x in x_"s"] $

リスト $x_"s"$ の各要素を先頭から順番に二項演算子を適用して，その結果を得るには畳み込み演算子を用いる．たとえば整数リストの和は次のように書ける．#footnote[Haskellでは `z = foldl 0 (+) x_"s"` と書く．]
$ z &= union.big_0^(lozenge.stroked.medium+lozenge.stroked.medium) x_"s"\
&= a + x_0 + x_1 + ... + x_n $

Haskellでは $sum = union_0^(lozenge.stroked.medium+lozenge.stroked.medium)$ として関数 $sum$ が定義されている．#footnote[Haskellでは $sum$ 関数を `sum` と書く．]

リスト $x_"s"$ が $x_"s"=[x_0,x_1,...,x_n]$ のとき，一般に $union_a^(lozenge.stroked.medium haskell.anyop lozenge.stroked.medium) x_"s" = a haskell.anyop x_0 haskell.anyop x_1 haskell.anyop ... haskell.anyop x_n$ が成り立つ．ここに $haskell.anyop$ は任意の二項演算子である．

畳み込み演算子には次の右結合バージョンが存在する．#footnote[Haskellでは `foldr` を用いる．]
$ z &= union.sq.big_0^(lozenge.stroked.medium haskell.anyop lozenge.stroked.medium) x_"s"\
&= a haskell.anyop (x_0 haskell.anyop (x_1 haskell.anyop ... haskell.anyop (x_(n-2) haskell.anyop (x_(n-1) haskell.anyop x_n))...)) $

== IOサバイバルキット2

1行ごとに3次元ベクトルが並べられた，以下の入力ファイルがあるとする．
#sourcecode[```text
1.0 2.0 3.0
4.5 5.5 6.5
```]
このようなファイル形式は計算機科学者にとって見慣れたものである．

各行つまり各ベクトルごとに，そのノルムを計算して出力するプログラムを書きたいとしよう．まず数列を受け取ってそのノルムを返す関数 $haskell.norm$ を次のように定義する．#footnote[Haskell では次のように書く．
```haskell
      norm :: [haskell.Double] -> haskell.Double
      norm [] = 0.0
      norm x_"s" = sqrt (sum [x * x | x <- xs])
```]
$ &haskell.norm colon.double [haskell.Double] -> haskell.Double\
 &haskell.norm emptyset = 0.0\
 &haskell.norm x_"s" = haskell.sqrt (sum [x * x | x in x_"s"]) $

入力ファイル全体を受け取るにはアクション $haskell.getContents$ を用いる．入力ファイルを1行毎のリストにするには関数 $haskell.lines$ を用いる．各行を空白で区切ってリストに格納するには関数 $haskell.words$ を用いる．

各文字列を数に変換するには次の関数 $haskell.readDouble colon.double haskell.String -> haskell.Double$ を用いる．#footnote[Haskellでは次のように書く．
```
      readDouble :: String -> Double
      readDouble = read
```]
$ &haskell.readDouble colon.double haskell.String -> haskell.Double\
  &haskell.readDouble = haskell.read $
関数 $haskell.readDouble$ は標準関数 $haskell.read$ に型注釈を付けたものである．

入力ファイルの各行に書かれたベクトルを対象に関数 $norm$ を適用して，結果を書き出すには次のように書く．#footnote[Haskell では次のように書く．
```haskell
      main = print 
        . (norm <$>) 
        . ((readDouble <$>) <$>) 
        . (words <$>) 
        . lines 
        =<< getContents
```]
$ haskell.main
  = haskell.print
    compose (norm *)
    compose ((haskell.readDouble *) *)
    compose (haskell.words *)
    compose haskell.lines
    haskell.bind haskell.getContents $

アクション $haskell.print$ に代えて次の $haskell.printEach$ を用いると，入力と出力を同じ形式にできる．#footnote[Haskell では `printEach x_"s" = mapM print x_"s"` と書く．]
$ haskell.printEach x_"s" = haskell.print *M x_"s" $

演算子 $*M$ はアクション版のマップ演算子である．


= 関手とモナド

== Maybe
<maybe>

計算は失敗する可能性がある．たとえば
$ z = y / x $
のときに $x = 0$ であったとしたら，この計算は失敗する．プログラムが計算を失敗した場合，たいていのプログラマは大域ジャンプを試みる．しかし大域ジャンプは変数の書き換えを行うことであるから，別の方法が望まれる．Haskellでは失敗する可能性がある場合にはMaybeという機構が使える．

いま関数 $f$ が引数 $x$ と $y$ を取り，$x != 0$ であるならば $frac(y, x, style: "skewed")$ を返すとする．もし $x!=0$ であれば失敗を意味する $haskell.Nothing$ （ナッシング）を返すとする．すると関数 $f$ の定義は次のようになる．
$ f x y = haskell.kwif x != 0 haskell.kwthen y / x haskell.kwelse haskell.Nothing ... "不完全な定義" $
残念ながら上式は不完全である．なぜならば $x != 0$ のときの戻り値は数であるのに対して， $x != 0$ のときの戻り値は数ではないからである．そこで
$ f x y = haskell.kwif x != 0 haskell.kwthen haskell.Just((frac(y, x, style: "horizontal"))) haskell.kwelse haskell.Nothing $
とする．ここに $haskell.Just((frac(y, x, style: "horizontal")))$ は数 $frac(y, x, style: "skewed")$ から作られる，Maybeで包まれた数である．#footnote[Haskell では `f x y = if x /= 0 then Just y / x else Nothing` と書く．]

整数型 $haskell.Int$ をMaybeで包む場合は $haskell.MaybeType(haskell.Int)$ と書く．Maybeで包まれた型を持つ変数は $x_*$ のように小さく $?$ をつける．例を挙げる．#footnote[Haskellでは `xm :: Maybe Int` と書く．]
$ x_* colon.double haskell.MaybeType(haskell.Int) $

Maybeで包まれた型を持つ変数は，値を持つか $haskell.Nothing$ （ナッシング）であるかのいずれかである．値をもつ場合は $x_* = haskell.Just(1)$ のように書く．#footnote[Haskellでは `xm = Just 1` と書く．]

Maybe変数が値を持たない場合は $x_* = haskell.Nothing$ のように書く．#footnote[Haskellでは `xm = Nothing` と書く．]

一度Maybeになった変数を非Maybeに戻すことは出来ない．

== Maybeに対する計算

Maybe変数に，非Maybe変数を受け取る関数を適用することは出来ない．そこで特別な演算子 $ast.op.o$ を用いて，次のように計算する．#footnote[Haskellでは `zm = (+1) <$> xm` と書く．]
$ z_* = f ast.op.o x_* $

ここに関数$f$は1引数関数で，演算子 $ast.op.o$ は次のように定義される．
$ haskell.Just((f x)) &= f ast.op.o haskell.Just(x) \
haskell.Nothing &= f ast.op.o haskell.Nothing $

== Maybeの中のリスト

リストがMaybeの中に入っている場合は，リストの各要素に関数を適用することができる．例を挙げる．

$x_* = haskell.Just([1,2...100])$ のとき，リストの各要素に関数 $f colon.double haskell.Int -> haskell.Int$ を適用するには次のように書く．#footnote[Haskellでは `zm = (f <$>) <$> xm` と書く．最初の `<$>` はリストの各要素に関数 `f` を適用する演算子，2番目の `<$>` はMaybeの中のリストの各要素に関数 `f` を適用する演算子である．]
$ z_* = (f *) ast.op.o x_* $

== 型パラメタと型クラス

型をパラメタとして扱うことができる．任意の型を $haskell.a$ と，ボールド体小文字で書く．ある型 $haskell.a$の引数を取り，同じ型を返す関数の型は次のように書ける．#footnote[Haskellでは `f :: a -> a` と書く．]
$ f colon.double haskell.a -> haskell.a $

#keyword[型パラメタ]には制約をつけることができる．型の集合を#keyword[型クラス]と呼び，フラクチュール体で書く．たとえば数を表す型クラスは $haskell.Num$ である．型パラメタ $haskell.a$ が型クラス $haskell.Num$ に属するとき，上述の関数 $f$ の型注釈は次のようになる．#footnote[Haskellでは `f :: Num a => a -> a` と書く．]
$ f colon.double haskell.Num supset haskell.a ==> haskell.a -> haskell.a $

ここに $haskell.Num$ 型クラスには，整数型 $haskell.Int$，浮動小数点型 $haskell.Double$ が含まれる一方，論理型 $haskell.Bool$ は含まれない．

型クラスは型に制約を与える．

== 関手

型 $haskell.a$ のリストの変数は $x_"s" colon.double [haskell.a]$ という型注釈を持つ．これは $x_"s" colon.double haskell.typeconstructor1([], haskell.a)$ のシンタックスシュガーである．#footnote[Haskellでは `x_"s" :: [] a` と書く．]

型 $haskell.a$ のMaybeの変数は $x_* colon.double haskell.MaybeType(haskell.a)$ という型注釈を持つ．

普段遣いの関数 $f colon.double haskell.a -> haskell.a$ をリスト変数 $x_"s" colon.double [haskell.a]$ に適用する場合は次のように書く．#footnote[Haskellでは `zs = f `map` x_"s"` と書く．]
$ z_"s" = f * x_"s" $

同じく関数 $f colon.double haskell.a -> haskell.a$ をMaybe変数 $x_* colon.double haskell.MaybeType(haskell.a)$ に適用する場合は次のように書く．
$ z_* = f ast.op.o x_* $

リストもMaybeも元の型 $haskell.a$ から派生しており，関数適用のための特別な演算子を持つことになる．そこで，リストやMaybeは#keyword[関手]という型クラスに属する，型パラメタを伴う型であるとする．関手の型クラスを $haskell.Functor$ で表す．関手型クラスの $haskell.a$ 型の変数を次のように型注釈する．#footnote[Haskellでは `xm :: Functor f => f a` と書く．]
$ x_* colon.double haskell.Functor supset haskell.f ==> haskell.typeconstructor1(haskell.f, haskell.a) $

型 $haskell.typeconstructor1([], haskell.a)$ や型 $haskell.MaybeType(haskell.a)$ は型 $haskell.a$ のところに $haskell.Int$ や $haskell.Double$ を代入すると具体的な型となる抽象的な型であった．今度は $[]$ や $haskell.Maybe$ のほうも $haskell.f$ と抽象化するのである．この $haskell.f$ は#keyword[型コンストラクタ]と呼ぶ．型コンストラクタには，具体的な引数，例えば $haskell.Int$ や $haskell.Double$ を与えると具体的な型になる．

型クラス $haskell.Functor$ に属する型は $ast.op.o$ 演算子を必ず持つ．演算子 $ast.op.o$ は次の形を持つ．#footnote[Haskellでは `zm = f <$> xm` と書く．]
$ z_* = f ast.op.o x_* $

演算子 $ast.op.o$ の型は次のとおりである．
$ lozenge.stroked.medium ast.op.o lozenge.stroked.medium
  colon.double haskell.Functor supset haskell.f
  ==> (haskell.a -> haskell.b)
  -> haskell.fa
  -> haskell.fb $

もし変数 $x_*$ の型がリストであれば $ast.op.o = *$ であると解釈する．

== 関手としての関数

$ f colon.double haskell.r -> haskell.q $

$ f colon.double chevron.l haskell.r -> lozenge.filled.medium chevron.r_haskell.q $

$ f colon.double chevron.l (->) haskell.r lozenge.filled.medium chevron.r_haskell.q $

```haskell
f :: ((->) r) q
```

$ f_2 compose f_1 = f_2 ast.op.o f_1 $

$ haskell.id compose f = id compose f = f \
  (h compose g) compose f = h compose (g compose f) $

= アプリカティブ関手

== アプリカティブ関手

演算子 $ast.op.o$ は関手型クラスの型の値に1引数関数を適用することを可能にした．一方で2引数関数を適用するのは若干面倒である．いま関数 $f$ が2引数をとるとし，関手型クラスの型の変数 $x_*$ と $y_*$ があるとする．関数 $f$ に変数 $x_*$ を部分適用して関数 $f' = f ast.op.o x_*$ を作ると，定義によって関数 $f'$ は関手型クラスの型の変数になる．そこで，関手型クラスの型の関数を関手型クラスの型の変数に適用する新しい演算子が必要になる．このような演算子を#keyword[アプリカティブマップ演算子]と呼び $haskell.amap$ で表す．アプリカティブマップ演算子を用いると2引数の関数適用は次のように書ける．
$ z_* &= f' haskell.amap y_* \
  &= f ast.op.o x_* haskell.amap y_* $<fmap-and-amap>

任意の変数または関数を関手型クラスの型に入れる#keyword[ピュア演算子]があり，次のように書く．#footnote[Haskellでは `z = pure x` と書く．]
$ z_* = shell.l x shell.r $

なおピュア演算子の名称は「純粋(pure)」であるが，意味合いはむしろ「不純(impure)」のほうが近い．

ピュア演算子を用いると，@fmap-and-amap は次のように書ける．#footnote[Haskell では `zm = (pure f) <*> xm <*> ym` と書く．]

$ z_* = shell.l f shell.r haskell.amap x_* haskell.amap y_* $<applicative-style>


@applicative-style はかつて次のように書くことが提案されたが，却下された．#footnote[現在のHaskellでは `z = liftA2 f x y` と書くことで代用されている．元の提案は `z = [|f x y|]` であった．]
$ z_* = [| f x_* y_* |] ... "採用されなかった文法" $

ピュア演算子とアプリカティブマップ演算子を必ず持つ関手のことを#keyword[アプリカティブ関手]と呼び $haskell.Applicative$ で表す．

いま関数 $f colon.double haskell.a -> haskell.b$ に対して，新たな関数 $haskell.fc$ ただし $haskell.fc = shell.l f shell.r $ を作ったとすると，関数 $haskell.fc$ は次の型を持つ．
$ haskell.fc colon.double haskell.Applicative supset haskell.f
  ==> haskell.f_(haskell.a -> haskell.b) $

アプリカティブマップ演算子は変数 $x_* colon.double haskell.Applicative supset haskell.f ==> haskell.f_haskell.a $ に対して，関数 $haskell.fc$ を $z_* = haskell.fc haskell.amap x_*$ のように作用させる．変数 $z_*$ の型は $z_* colon.double haskell.Applicative supset haskell.f ==> haskell.f_haskell.b$ である．

== モナド

== 種

== Data

== 型クラスとインスタンス

== IOモナド

== Do構文

#tk

#sourcecode[```haskell
z = do { x' <- x; y' <- y; f x'; g y' }
```]

== モノイド則

#tk

$(ZZ, +, 0)$ はモノイドである．

同じ型を持つ関数を集めた関数の集合 $FF$ があるとする．任意の関数 $f in FF$ について $haskell.id f = f$ なる関数 $haskell.id$ があり，かつ任意の関数 $f, g, h in FF$ に対して $(h compose g) compose f) = h compose (g compose f)$ が成り立つとする．このとき組み合わせ $(FF, compose, haskell.id)$ は#keyword[モノイド]であるという．

- 単位元の存在
- 結合律

== 関手則

#tk

$ haskell.id ast.op.o x_* &= haskell.id x_* \
  (g compose f) ast.op.o x_* &= ((g ast.op.o) compose (f ast.op.o)) x_* $

== アプリカティブ関手則

#tk

$ shell.l haskell.id shell.r haskell.amap x_* &= x_* \
  shell.l f shell.r haskell.amap shell.l x shell.r 
  &= shell.l lozenge.stroked.medium haskell.apply x shell.r haskell.amap shell.l f shell.r \
  &= shell.l f x shell.r \
  shell.l lozenge.stroked.medium compose lozenge.stroked.medium shell.r haskell.amap h_* haskell.amap g_* haskell.amap haskell.fc
  &= h_* haskell.amap (g_* haskell.amap haskell.fc) $

== モナド則

#tk

$ mu haskell.bind shell.l.stroked x shell.r.stroked &= mu x \
  shell.l.stroked lozenge.stroked.medium shell.r.stroked haskell.bind x_*
  &= x_* \
  nu haskell.bind mu haskell.bind x_*
  &= nu haskell.bind (mu haskell.bind x_*) $

$(MM, haskell.bind, shell.l.stroked lozenge.stroked.medium shell.r.stroked)$ はモノイドである．

関数 $mu$ に作用する#keyword[クライスリスター]演算子 $star.stroked$ を $mu^star.stroked = (mu haskell.bind lozenge.stroked.medium)$ と定義する．クライスリスターを用いると，モナド則は次のように書き直せる．
$ mu^star.stroked shell.l x shell.r &= mu x \
  shell.l lozenge.stroked.medium shell.r^star.stroked x_* &= x_* \
  (nu^star.stroked mu)^star.stroked x_* &= nu^star.stroked (mu^star.stroked x_*) $

== クラスの定義

#pagebreak()

= Test Part

== Function application
$ z = f x $

#sourcecode[```haskell
z = f x
```]

== List map
$ z_"s" = f * x_"s" $

#sourcecode[```Haskell
zs = map f x_"s"
```]
or
#sourcecode[```Haskell
zs = f `map` x_"s"
```]

== Maybe map
$ z_* = f ast.op.o x_* $

#sourcecode[```haskell
zm =  fmap f xm
```]
or
#sourcecode[```haskell
zm =  f <$> xm
```]

== Functor map
$ z_* = f ast.op.o x_* $

#sourcecode[```haskell
zm = f <$> xm
```]

== Applicative map
$ z_* = haskell.ctxt(f) haskell.amap x_* $

#sourcecode[```Haskell
zm = fm <*> xm
```]

== Apllicative map 2
$ z_* = haskell.ctxt(g) haskell.amap x_* haskell.amap y_* $

#sourcecode[```haskell
zm = gm <*> xm <*> ym
```]

Or,

$ z_* = g ast.op.o x_* haskell.amap y_* $

#sourcecode[```haskell
zm = g <$> xm <*> ym
```]

== Monadic function application
$ z_* = haskell.monadic(f) x $

#sourcecode[```Haskell
zm = f x
```]

== Bind
$ z_* = haskell.monadic(f) haskell.bind x_* $

#sourcecode[```Haskell
zm = f =<< xm
```]

== Double bind
$ z_* = haskell.monadic(g) haskell.bind haskell.monadic(f) haskell.bind x_* $

#sourcecode[```haskell
zm = g =<< f =<< xm
```]

== Contextual map
$ haskell.action("printEach") = haskell.action("print") *M x_"s" $

#sourcecode[```haskell
printEach = print `mapM` x_"s"
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
$ z_"s" = f ast.op.o x_"s" $

#sourcecode[```haskell
zs = f `map` x_"s"
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

