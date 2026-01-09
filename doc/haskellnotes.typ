// Typst
#import "@preview/in-dexter:0.7.2": *
#import "@preview/codelst:2.0.2": sourcecode

#import "@preview/theorion:0.4.1": *
#import cosmos.fancy: *
#show: show-theorion

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

// From: https://forum.typst.app/t/why-does-a-display-equation-break-a-paragraph/403/3
// #set par(hanging-indent: 3em)
#let par-equation(eq) = {
  linebreak()
  box(inset: (y: 0.5em), width: 1fr, eq)
  linebreak()
}

#let pb = [ #align(center, $suit.club.filled$) ]
#let tk = [ #emoji.pin.round *TK* ]
#let keyword(x) = [#highlight(fill: gradient.linear(white, yellow, angle: 90deg), top-edge: "x-height")[#x]]

#let uparrow = $class("binary", arrow.t)$
#let uparrow2 = $class("binary", arrow.t arrow.t)$

#import "haskell.typ"

#title()

#outline()
#pagebreak()

#figure(
  caption: "凡例1",
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: center,
    table.header([*種類*], [*字体・表記法*], [*例*]),
    [変数・関数], [イタリック（1文字）], $x, f$,
    [有名な変数・関数・定数], [ローマン・小文字], $haskell.first, id, haskell.otherwise$,
    [文脈に入れる関数（アクション）], [ギリシア文字（1文字）], $alpha, phi$,
    [有名なアクション], [ボールド・小文字], $haskell.main, haskell.print$,
    [リスト変数], [変数名にsをつける], $x_"s"$,
    [Maybe変数], [変数名に $?$ をつける], $x_?$,
    [Either変数], [変数名に $!$ をつける], $x_!$,
    [一般のコンテナ変数], [変数名に $*$ をつける], $x_*$,
    [値コンストラクタ（引数なし）], [ローマン（大文字）], $haskell.True, haskell.Nothing$,
    [値コンストラクタ（引数あり）], [ローマン（大文字）], $haskell.Just(x)$,
    [有名な値コンストラクタ1], [数学記号], $emptyset, nothing.rev$,
    [有名な値コンストラクタ2], [特別な括弧で包む], $[x], chevron.l y chevron.r, paren.l.stroked u, v paren.r.stroked$,
    [型（引数なし）], [ボールドイタリック（1文字）], $haskell.a$,
    [型（引数あり）], [ボールドイタリック（1文字）], $haskell.typename1(m, a)$,
    [有名な型（引数なし）], [ボールド・大文字], $haskell.Int$,
    [有名な型（引数あり）], [特別な括弧で包む], $[haskell.a], [haskell.Int]$,
    [ユニット型], [括弧], $haskell.unittype$,
    [型クラス], [サンセリフ], $haskell.Num$,
    [カインド], [星，フラクチュール], $star.stroked, haskell.Type, haskell.kk$,
    [キーワード], [固定幅], $haskell.kwlet$,
    [無名パラメタ], [ひし形（白）], $lozenge.stroked.medium$,
    [無名型パラメタ], [ひし形（黒）], $lozenge.filled.filled.medium$,
  )
)

#figure(
  caption: "凡例2",
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: center,
    table.header([*種類*], [*字体・表記法*], [*例*]),
    [集合（数学）], [ブラックボード（1文字）], $ZZ$,
    [関手（数学）], [スクリプト（1文字）], $scr(F)$,
    [圏（数学）], [カリグラフィ（1文字）], $cal(C)$
  )
)


= Haskell入門

本書はプログラミング言語Haskellの入門書である．それと同時に，本書はプログラミング言語を用いた代数構造の入門書でもある．プログラミングと代数構造の間には密接な関係があるが，とくに#keyword[関数型プログラミング]を実践する時にはその関係を意識する必要が出てくる．本書はその両者を同時に解説することを試みる．

== Haskellについて
<about-haskell>

これからのプログラマにとってHaskellを無視することはできない．Haskellの「欠点をあげつらうことも，攻撃することもできるが，無視することだけはできない」のだ．それはHaskellがプログラミングの本質に深く関わっているからである．

=== Haskellという森

Haskellというプログラミング言語を知ろうとすると，従来のプログラミング言語の知識が邪魔をする．モダンで，人気があって，Haskellから影響を受けた言語，たとえばRubyやSwiftの知識さえ，Haskellを学ぶ障害になり得る．ではどのようにしてHaskellの深みに到達すればいいのだろうか．

その答えは，一見遠回りに見えるが，一度抽象数学の高みに登ることである．

と言っても，あわてる必要はない．

近代的なプログラミング言語を知っていれば，すでにある程度抽象数学に足を踏み入れているからである．そこで，本書では近代的なプログラマを対象に，プログラミング言語を登山口に抽象数学の山を登り，その高みからHaskellという森を見下ろすことにする．

さて，登山口にどのプログラミング言語を選ぶのが適当であろうか．TIOBE Index 2025年12月版によると「ビッグ5」としてPython，C，C++，Java，C\#が挙げられている．#footnote[https://www.tiobe.com/tiobe-index/]順位の変動はあるが，他の調査でもビッグ5は過去何年も変動していないので，当座は妥当な統計であろう．このうちCは「多くのプログラマが読める」以外にメリットが無く，その唯一のメリットさえ最近は怪しくなっているため，登山口候補から外す．残るはC++，Java，C\#グループとPythonということになるが，シンプルであり，かつHaskellと対極にある言語であるPythonを登山口に選ぶことにした．

本書ではPythonコードはこのように登場する．
#sourcecode[```python
# Python
print("Hello, world.")
```]

本書に示すコードは擬似コードではなく，すべて実行可能な本物のコードである．

一部の章でどうしても型に触れないといけない部分がある．Pythonは動的型付け言語であり，型の説明には不適切であるため，この部分だけ理解の助けとしてC++によるコードを例示した．この部分はコードを読まなくても先に進める．

ところで，プログラムのソースコードは現代でもASCII文字セットの範囲で書くことが標準的である．Unicodeを利用したり，まして文字にカラーを指定したり，書体や装飾を指定することは一般的ではない．たとえば変数 `a` のことを $a$ と書いたり $bold(a)$ と書いたり $tilde(a)$ と書いたりして区別することはない．

Haskellプログラマもまた，多くの異なる概念を同じ貧弱な文字セットで表現しなければならない．これは，はじめてHaskellコードを読むときに大きな問題になりえる．たとえばHaskellでは ```haskell [a]``` という表記をよく扱う．この ```haskell [a]``` は ```haskell a``` という変数1要素からなるリストのこともあるし，```haskell a``` 型という仮の型から作ったリスト型の場合もあるが，字面からでは判断できない．もし変数はイタリック体，型はボールドイタリック体と決まっていれば，それぞれ $[a]$ および $[haskell.typeparameter(a)]$ と区別できたところである．

本書は，異なる性質のものには異なる書体を割り当てるようにしている．ただし，どの表現もいつでもHaskellに翻訳できるように配慮している．実際，本書執筆の最大の困難点は，数学的に妥当で，かつHaskellの記法とも矛盾しない記法を見つけることであった．

=== 関数型プログラミング

プログラマはなぜHaskellを習得しなければならないのだろう．それはHaskellと#keyword[関数型プログラミング]の間に密接な関係があるからである．

関数型プログラミングとはプログラミングにおける一種のスローガンのようなもので，どの言語を用いたから関数型でどの言語を用いたから関数型ではない，というものではない．しかし，関数型プログラミングを強くサポートする言語と，そうでない言語とがある．ここら辺の事情はオブジェクト指向プログラミングとプログラミング言語の関係と似ている．Haskellは関数型プログラミングを強くサポートし，Pythonはほとんどサポートしない．

関数型プログラミングの特徴を一言で言えば，プログラム中の#keyword[破壊的代入]を禁止することである．変数 $x$ に $1$ という数値が一度代入されたら，変数 $x$ の値をプログラム中に書き換える，すなわち破壊的代入をすることはできない．この結果，変数の値はプログラムのどこでも，どの時点で読み出しても同じであることが保証される．これを変数の#keyword[参照透過性]と呼ぶ．#footnote[変数の値が常に同じなことに加えて，関数に同じ引数を与えた場合に常に同じ結果が得られることを参照透過性と呼ぶ．]

プログラム全体に参照透過性があると，そのプログラムはブロックに分割しやすく，各々のブロックは再利用しやすい．またプログラムのどの断片から読み始めても，全体の構造を見失いにくい．これが関数型プログラミングとそれを強くサポートするHaskellを習得する理由である．

参照透過性がもたらすもう一つのボーナスは変数の#keyword[遅延評価]である．変数はいつ評価しても値が変わらないのだから，コンパイラは変数をできるだけ遅く評価してよい．この遅延評価によって，Haskellコンパイラは他の言語に見られない#keyword[無限リスト]を扱う能力を獲得している．

ここで数学とプログラミングの関係について述べておこう．ある方程式を解くためにコンピュータによって数値シミュレーションを行うとか，非常に複雑な微分を機械的に行うとか，プログラミングによって数学をサポートすることは計算機科学の主たる分野の一つであるが，ここではもっと根源的な話をする．

数学者もプログラマも#keyword[関数]をよく使う．数学者が使う関数とは，引数がいくつかあって，その結果決まる戻り値があるようなものだ．一方でプログラマが使う関数というのは，引数と戻り値はだいたい同じとして，中身に条件分岐があったり，ループがあったり，外部変数を書き換えたり，入出力をしたりする．

どちらも同じ関数であるのに，なぜこうもイメージが違うのだろうか．

もし，我々が関数型プログラミングの原則を忠実に守り，プログラム中のいかなる破壊的代入をも禁止するとすると，両者の関数は全く同じ性格になる．逐次実行も条件分岐もループも，それどころか定数さえ，#keyword[ラムダ式]という式だけで書けるようになる．あらゆるプログラムが，最終的には単一のラムダ式で書ける．

ところが，入出力，状態変数，例外など，プログラミングに使われる多くのテクニックは関数の副作用を前提としている．参照透過性と副作用を統一的に扱うためには#keyword[モナド]という数学概念が必要である．Haskellはモナドを陽に扱うプログラミング言語である．

#pb

関数型プログラミングという考え方自体は，プログラミングに必ずしも束縛されるものではない．

たとえばいま，ある英文テキストファイルから，単語を出現頻度順に取り出したいとしよう．こんなとき，プログラマならば次のように考えるのではないだろうか．

「まずは英文テキスト中の大文字を全部小文字にしよう」「それからアルファベットと空白以外を全部捨ててしまおう」「空白を改行に置き換えると，1行に1単語になるな」「ここまで来たら出現頻度順に並べ直すのはわけないことだ」……

これらの言葉をUNIXの言葉に置き換えてみる．ここでは英文テキストを `the-great-gatsby.txt` としておこう．中身はフィッツジェラルドの名作「The Great Gatsby」（華麗なるギャッツビー）だ．最初の「まずは英文テキスト中の大文字を全部小文字にしよう」はUNIXコマンドの `tr` を使って次のように実現できる．

#sourcecode[```shell-unix-generic
$ cat the-great-gatsby.txt | tr '[A-Z]' '[a-z]'
```]

この出力を適当なファイルにリダイレクトすれば，大文字がすべて小文字に置き換わったテキストファイルになる．

次にするのは「それからアルファベットと空白以外を全部捨ててしまおう」だ．これもUNIXコマンド `tr` を使って次のように実現できる．

#sourcecode[```shell-unix-generic
$ cat the-great-gatsby.txt | tr '[A-Z]' '[a-z]' | tr -C -d ‘[a-z ]'
```]

これで単語だけのテキストファイルが出来る．次に空白をすべて改行に置き換えてしまおう．もう一度 `tr` を使う．

#sourcecode[```shell-unix-generic
$ cat the-great-gatsby.txt | tr '[A-Z]' '[a-z]' | tr -C -d ‘[a-z ]' | tr ' ' '\n'
```]

これで1行に1単語ずつ並べられたテキストファイルがこれで手に入ることになる．空行もあるが，それは問題ない．このファイルの中身をアルファベット順にソートする．それには `sort` コマンドを使う．

#sourcecode[```shell-unix-generic
$ cat the-great-gatsby.txt | tr '[A-Z]' '[a-z]' | tr -C -d ‘[a-z ]' | tr ' ' '\n' | sort
```]

ソートできれば，同一の連続する行を数え上げて，一つの行にすればいい．それには `uniq` コマンドを `-c` オプション付きで使う．

#sourcecode[```shell-unix-generic
$ cat the-great-gatsby.txt | tr '[A-Z]' '[a-z]' | tr -C -d ‘[a-z ]' | tr ' ' '\n' | sort | uniq -c
```]

最後に，出現頻度順に逆順ソートをかけると「出現頻度順」になる．それには `sort` コマンドに `-n` と `-r` オプションを付けて以下のようにする．

#sourcecode[```shell-unix-generic
$ cat the-great-gatsby.txt | tr '[A-Z]' '[a-z]' | tr -C -d ‘[a-z ]' | tr ' ' '\n' | sort | uniq -c | sort -n -r
```]

この出力の先頭10行は，そのまま出現頻度上位10傑の単語となる．

#pb

さて，上述の出現頻度上位単語の抽出のどこが「関数型プログラミング」の考え方だったのだろうか．

実はこんな風に考えることが出来る．入力を $x$ とする．いまの例では $x$ がファイル `the-great-gatsby.txt` である．出力を $y$ とする．ここに $y$ は出現頻度順に並んだ出現頻度と単語のリストである．我々が欲しいのは
#par-equation($ y = f(x) $)
となるようなプログラム $f$ だった．プログラム $f$ は簡単には手に入らないので，我々はUNIXコマンドの `tr` とか `sort` とか `uniq` とかをつなぎ合わせて作った．それらを「数学風」に書くと次のようになる．

$ f_1 &= "tr"_([A...Z]->[a...z])\
  f_2 &= "tr"_(overline([a...z, square])->emptyset)\
  f_3 &= "tr"_(square->arrow.bl.hook)\
  f_4 &= "sort"\
  f_5 &= "uniq"_c\
  f_6 &= "sort"_(n, r) $

そして $x$ から $y$ を得るために
#par-equation($ y = f_6(f_5(f_4(f_3(f_2(f_1(x)))))) $)
という計算を行った．括弧が多すぎるので，この式を
#par-equation($ y = f_6 compose f_5 compose f_4 compose f_3 compose f_2 compose f_1(x) $)
と書き直そう．ここに演算子 $compose$ は「#keyword[関数合成演算子]」だ．

関数合成演算子を使うと，プログラム $f$ を
#par-equation($ f = f_6 compose f_5 compose f_4 compose f_3 compose f_2 compose f_1 $)
と定義することも出来る．これが何を意味しているかと言うと，プログラム $f$ を小さな部分プログラム $f_1, f_2, f_3, f_4, f_5, f_6$ に分解したということだ．

分解したなら，合成する方法が必要になる．この例では，プログラムの各部分が他の部分に依存していないために，合成は数学的な関数合成と同じ方法が使える．

上記の例のように，数学における関数合成をそのままプログラミングに持ち込めれば，部分プログラムの合成も見通しが良いものになる．このような考え方が「関数型プログラミング」のエッセンスなのである．

=== Haskellコンパイラの準備

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

#pb

Windows (Intel)の場合は https://docs.haskellstack.org/en/stable/ からWindows版インストーラをダウンロードできる．

#pb

Haskell Stackをインストールしたら，次のコマンドで新規プロジェクトを作成する．

#sourcecode[```shell-unix-generic
$ stack new myProject
```]

自分の関数は `myProject/src/Lib.hs` に書かれている以下のソースコードのうち ```haskell someFunc``` の定義を書き換えることになる．

#sourcecode[```haskell
-- Lib.hs
module Lib
    ( someFunc
    ) where

someFunc :: IO ()
someFunc = putStrLn "someFunc"
```]

あるいは `myProject/app/Main.hs` に書かれている ```haskell main``` の定義を直接書き換えても良い．`Main.hs` は次のようなファイルである．

#sourcecode[```haskell
-- Main.hs
module Main (main) where
import Lib

main :: IO ()
main = someFunc
```]

計算機科学の習慣に従って "Hello, World!" と表示するプログラムを書いておこう．それには `Lib.hs` を書き換えて次のようにする．

#sourcecode[```haskell
-- Lib.hs
module Lib
    ( someFunc
    ) where

someFunc :: IO ()
someFunc = putStrLn "Hello, World!"
```]

`Lib.hs`（または `Main.hs`）を書き換えた後は次のコマンドで実行する．最初のビルド時には，必要なHaskellコンパイラやライブラリがダウンロードされるので少々の時間がかかる．

#sourcecode[```shell-unix-generic
$ stack build
$ stack run
```]


=== 余談：本書の構成

#tk 本書の構成．#footnote[脚注は読まなくて良い．]

=== この章のまとめ

#tk この章のまとめ．

== カリー風な書き方
<curry-style>

本書では一般の数学書やプログラミングの教科書からは少し異なった記法を用いる．ある概念が発明されてからずっと後になって正しい記法が見つかり，それがきっかけとなって正しく理解されるという現象は歴史上よくあることである．本書でも様々な新しい記号，記法を導入するが，この章ではHaskellに近い記法から始めることにする．

数学やプログラミミング言語には書き方に一定の決まりがある．この章ではまず「カリー風の」数式記述方式を見てみることにする．「カリー風」というのは，数学者ハスケル・カリーから名前を借りた言い方で，筆者が勝手に命名したものだ．

カリー風の書き方は数学の教科書やプログラミングの教科書で見かけるものとは若干違うが，圧倒的にシンプルでHaskellとの親和性も高く，慣れてくると非常に読みやすいものなので，本書でも全面的に採用する．

=== 変数と関数

変数 $x$ に値 $1$ を代入するには次のようにする．#footnote[Haskellでは `x = 1` と書く．]

$ x = 1 $<binding>

変数という呼び名に反して，変数の値は一度代入したら変えられない．そこで変数に値を代入するとは呼ばずに，変数に値を#keyword[束縛]するという． @binding の右辺のように数式にハードコードされた値を#keyword[リテラル]と呼ぶ．

リテラルや変数には#keyword[型]がある．型は数学者の#keyword[集合]と似た意味で，整数全体の集合 $ZZ$ に相当する#keyword[整数型]や，実数全体の集合 $RR$ に相当する#keyword[浮動小数点型]がある．整数と整数型，実数と浮動小数点型は異なるため，整数型を $haskell.Int$ で，浮動小数点型を $haskell.Double$ で表すことにする．#footnote[Haskellでは `Int` および `Double` と書く．]

型については@types で詳しく述べる．

数学者は変数 $x$ が整数であることを $x in ZZ$ と書くが，本書では $x colon.double haskell.Int$ と書く．これは記号 $in$ を別の用途に用いるためである．また型の注釈と代入をまとめて $x colon.double haskell.Int = 1$ と書く事もできる．#footnote[Haskellでは $x colon.double haskell.Int$ を ```haskell x :: Int``` と書き $x colon.double haskell.Int = 1$ を ```haskell x :: Int = 1 ``` と書く．]

本書では変数名を原則1文字として，イタリック体で表し $w,x,y,z$ のような $n$ 以降のアルファベットを使う．

#pb

変数の値がいつでも変化しないことを#keyword[参照透過性]と呼ぶ．プログラマが変数の値を変化させたい，つまり#keyword[破壊的代入]を行いたい理由はユーザ入力，ループ，例外，内部状態の変化，大域ジャンプ，継続を扱いたいからであろう．しかし，後に見るようにループ，例外，内部状態の変化，大域ジャンプ，継続に変数の破壊的代入は必要ない．ユーザ入力に関しても章を改めて取り上げる．参照透過性を強くサポートするプログラミング言語をを#keyword[関数型プログラミング言語]と呼ぶ．

#pb

整数 $x$ に $1$ を足す#keyword[関数] $f$ は次のように定義できる．
#par-equation($ f x = x + 1 $)
ここに $x$ は関数 $f$ の#keyword[引数]である．引数は括弧でくるまない．#footnote[Haskellでは `f x = x + 1` と書く．]

Pythonや一般的な数学書では引数 $x$ をとる関数 $f$ を $f(x)$ と書くが，括弧は冗長なので今後は $f x$ と書くことにする．#footnote[Haskell では関数 ```haskell f``` に引数 ```haskell x``` を適用させることを ```haskell f x``` と書く．数学や物理学では $x$ をパラメタとする関数を $f(x)$ と書く場合もあるし，$f$ のようにパラメタを省略する場合もある．数学や物理学でパラメタを省略した場合は，$f(x_0)$ の意味で $f|_(x=x_0)$ と書くことがある．]

本書では関数名を原則1文字として，イタリック体で表し，$f,g,h$ のようにアルファベットの $f$ 以降の文字を使う．ただし有名な関数についてはローマン体で表し，文字数も2文字以上とする．たとえば $sin$ などの三角関数や指数関数がそれにあたる．

関数 $f$ に引数 $x$を「食わせる」ことを#keyword[適用]と呼ぶ．もし $f x$ と書いてあったら，それは $f$ と $x$ の積，つまり $f times x$ ではなく，従来の $f(x)$ すなわち関数 $f$ に引数 $x$ を与えているものと解釈する．高校生向けの数学書でも $sin x$ のように三角関数に限ってはカリー風に書くことになっているので，まるで馴染みがないということもないだろう．なお，関数はいつも引数の左側に書くことにする．これを「関数 $f$ が変数 $x$ の左から作用する」と言い，また関数 $f$ のことを#keyword[左作用素]とも呼ぶ．

変数 $x$ に関数 $f$ を適用して $z$ を得る場合は次のように書く．#footnote[Haskellでは `z = f x` と書く．]

$ z = f x $

#pb

複数引数をとる関数をPythonや一般的な数学の教科書では $g(x, y)$ と書くが，これも括弧が冗長なので今後は $g x y$ と書く．この場合式 $g x y$ は左を優先して結合する．つまり $g x y = (g x) y$ である．これは引数 $y$ に関数 $(g x)$ が左から作用していると解釈する．関数 $(g x)$ は引数 $x$ に関数 $g$ を作用させて作った関数である．引数に「飢えた」関数 $(g x)$ を#keyword[部分適用]された関数と呼ぶ．

関数 $f$ が引数をふたつ取る場合は，次のように書く．#footnote[Haskellでは `z = f x y` と書く．]

$ z = f x y $

なお $f x y$ は $(f x)y$ と解釈される．前半の $(f x)$ は1引数の関数とみなせる．2引数関数を連続した1引数関数の適用とみなす考え方を，関数の#keyword[カリー化]と呼ぶ．

このように式の左側を優先的に演算していくことを#keyword[左結合]と呼ぶ．Haskellの場合，関数適用はいつも左結合である．

部分適用の例を見てみよう．例えばふたつの引数のうち大きい方を返す関数 $max$ は $max x y$ として使われるが，関数適用は左結合であるから $(max x) y$ としても同じである．そこで $(max x)$ だけ取り出すと，これは「引数が $x$ よりも小さければ $x$ を，そうでなければ引数を返す関数」とみなすことができる．#footnote[Haskellでは $max x y$ を ```haskell max x y``` と書く．なお関数 $(max x)$ のことを $max_x$ と書く教科書も多い．関数引数を添え字で表す記法は，本書でも後に採用する．]

=== ラムダ式

関数の正体は#keyword[ラムダ式]である．ラムダ式とは，仮の引数をとり，その値をもとになにがしかの演算を行い，その結果を返す式である．ラムダ式は名前のない関数のようなものだ．それゆえ，無名関数と呼ばれることもある．

例えば引数 $x$ をとり値 $1+x$ を返すラムダ式をPythonでは次のように書く．

#sourcecode[```python
# Python
lambda x: 1 + x
```]

一方，我々はより簡潔に
#par-equation($ backslash x |-> 1 + x $)
と書くことにする．

この式は多くの書物で $lambda x class("binary", .) 1 + x$ と記述されるところである．しかし我々はすべてのギリシア文字を変数名のために予約しておきたいのと，ピリオド記号 $(.)$ が今後登場する二項演算子と紛らわしいため，上述の記法を用いる．#footnote[Haskellではラムダ式 $backslash x |-> 1 + x$ を ```haskell \x -> 1 + x``` と書く．ラムダ式は元々は $hat(x) class("binary", .) 1 + x$ のように書かれていた．これが次第に $hat x class("binary", .) 1 + x$ となり，$Lambda x class("binary", .) 1 + x$ そして $lambda x class("binary", .) 1 + x$ に変化していったと言われている．Haskell が $lambda$ の代わりに $backslash$ 記号を使うのは，その形が似ているからである．]

ラムダ式は関数である．ラムダ式を適用するには，ラムダ式を括弧で包む必要がある．例を挙げる．
#par-equation($ (backslash x |-> 1 + x) space 2 $)
この式は結果として $3$ を返す．

複数引数をとるラムダ式は例えば $backslash x y |-> x + y$ のように引数を並べて書く．

#pb

本書では新たに，次のラムダ式記法も導入する．式中に記号 $lozenge.stroked.medium$ が現れた場合，その式全体がラムダ式であるとみなす．記号 $lozenge.stroked.medium$ の部分には引数が入る．第 $n$ 番目の $lozenge.stroked.medium$ には第 $n$ 番目の引数が入る．例えばラムダ式 $backslash x y |-> x + y$ は $lozenge.stroked.medium + lozenge.stroked.medium$  と書いても良い．式を左から読んで1番目の $lozenge.stroked.medium$ が元々の $x$ すなわち第1引数を，2番目の $lozenge.stroked.medium$ が元々の $y$ すなわち第2引数を意味する．この省略記法はプログラミング言語Schemeにおける `cut` プロシジャに由来する．#footnote[Haskellでは，中置演算子に限ってこの表現が使える．例えば $(lozenge.stroked.medium + lozenge.stroked.medium)$ は単に ```haskell (+)``` と表現できる．ただしSchemeにおける `cut` プロシジャの `<>` はHaskellにはないため，Schemeでいう `(cut f <> y)` に相当するコードを直接は書けない．]

#pb

数式が長く続くとき，読みやすさのために#keyword[局所変数]を導入すると便利である．例えば
#par-equation($ y = f(1 + x) $)
という式のうち，先に $1 + x$ を計算して $x'$ のように名前をつけておきたいこともある．そんなときは次のように書く．#footnote[Haskellでは ```haskell y = let x' = 1 + x in f x'``` と書く．]

$ y = haskell.kwlet x' eq.delta 1 + x haskell.kwin f x' $<let-in>

なお，局所変数を後ろに回して
#par-equation($ y = f x' haskell.kwwhere x' eq.delta 1 + x $)
と書いても良い．#footnote[Haskellでは ```haskell y = f x' where x' = 1 + x``` と書く．]

局所変数はラムダ式を用いたシンタックスシュガーである．@let-in は次の式と等価である．

$ z = (backslash x' |-> f x') (1 + x) $<let-in-alternative>

=== パタンマッチとガード

関数の定義は，基本的にはラムダ式の変数への代入である．引数 $x$ をとり値 $2 times x$ を返す関数 $f$ は
#par-equation($ f = backslash x |-> 2 times x $)
と定義できる．ただし，この省略形として
#par-equation($ f x = 2 times x $)
と書いても良い．#footnote[Haskellでは $f = backslash x |-> 2 times x$ を ```haskell f = \ x -> 2 * x``` と書き，一方 $f x = 2 times x$ を ```haskell f x = 2 * x``` と書く．]

関数に#keyword[スペシャルバージョン]がある場合はそれらを列挙する．例えば引数が $0$ の場合は特別に戻り値が $1$ であり，その他の場合は $2 times x$ を返す関数 $f'$ を考える．このとき $f'$ は以下のように定義できる．これを関数の#keyword[パタンマッチ]と呼ぶ．#footnote[Haskellでは ```haskell f' 0 = 1; f' x = 2 * x``` と書く．]
$ f' space 0 &= 1 \
  f' x &= 2 times x $

関数のパタンマッチは，関数の内部に書いても良い．関数内部にパタンマッチを書きたい場合は次のように書く．
$ f' x = haskell.kwcase x haskell.kwof cases(0 arrow.r.dotted 1,
rect.stroked.h arrow.r.dotted 2 times x) $

ここに $rect.stroked.h$ は任意の値の意味である．パタンマッチは上から順番にマッチングしていくため，この場合は $0$ 以外を意味する．#footnote[Haskellでは ```haskell f' x = case x of { 0 -> 1; _ -> 2 * x }``` と書く．]

一部のプログラミング言語では#keyword[デフォルト引数]という，引数を省略できるメカニズムがあるが，我々は引数をいつも省略しないことにする．#footnote[Haskellにもデフォルト引数はない．]

関数定義にパタンマッチではなく#keyword[場合分け]が必要な場合は#keyword[ガード]を用いる．例えば引数の値が負の場合は $0$ を，$0$ の場合は $1$ を，それ以外の場合は $2 times x$ を返す関数 $f''$ は以下のように定義する．#footnote[Haskellでは ```haskell f'' x | x < 0 = 0  | x == 0 = 1  | otherwise = 2 * x ``` と書く．もっとも，この記法を使う場合は改行を適度に入れたほうが読みやすい．]

$ f'' x&|_(x < 0) = 0 \
  &|_(x equiv 0) = 1 \
  &|_haskell.otherwise = 2 * x $

ガードは上から順にマッチされる．

=== 余談：条件式

関数定義の場合分けを駆使すれば#keyword[条件式]はなくても構わないが，条件式の記法があるのは便利である．Pythonには次のような#keyword[制御構造]としての条件文がある．

#sourcecode[```python
# Python
def fppp(x):
  if x == 0:
    return 1
  else:
    return sin(x) / x
```]

一方，我々は値を持つ#keyword[条件式]を考える．我々の条件式とは 
#par-equation($ f''' x = haskell.kwif x equiv 0 haskell.kwthen 1 haskell.kwelse frac(sin x, x, style: "skewed") $)
のように $haskell.kwif$ 節，$haskell.kwthen$ 節，及び $haskell.kwelse$ 節からなるものであって，$haskell.kwthen$ 節も $haskell.kwelse$ 節も省略できないものとする．$haskell.kwif$ 節の式の値が真 $(haskell.True)$ であれば $haskell.kwthen$ 節の式が評価され，偽 $(haskell.False)$ であれば $haskell.kwelse$ 節の式が評価される．我々の条件式はCにおける条件演算子（三項演算子）と等しく見えるが，Haskellの場合は遅延評価が行われるため，結果として条件式の#keyword[短絡評価]が行われる点が異なる．#footnote[Haskellでは $f x = haskell.kwif x equiv 0 haskell.kwthen 0 haskell.kwelse frac((sin x), x, style: "skewed")$ を ```haskell f x = if x == 0 then 1 else (sin x) / x``` と書く．]

=== この章のまとめ

#tk この章のまとめ．

== さらにカリー風な書き方
<more-curry-style>

我々は関数とラムダ式の「カリー風」な書き方を見てきた．この章ではさらに演算子，関数合成についても「カリー風」な書き方を見ていく．

=== 演算子

#keyword[演算子]は関数の特別な姿である．演算子は#keyword[作用素]と呼んでも良い．どちらも英語のoperatorの和訳である．演算子は普通アルファベット以外のシンボル1個で表現し，変数や関数の前に置いて直後の変数や関数に作用させるか，2個の変数や関数の中間に置いてその両者に作用させる．例えば $-x$ のマイナス記号 $(-)$ は変数の前に置いて直後の変数 $x$ に作用する演算子であり，$x+y$ のプラス記号 $(+)$ は2個の変数の間に置いてその両者 $(x, y)$ に作用する．

1個の変数または関数に作用する演算子を#keyword[単項演算子]と呼び，2個の変数または関数に作用する演算子を#keyword[二項演算子]と呼ぶ．本書では単項演算子はすべて変数の前に置く，すなわち#keyword[前置]する．前置する演算子のことを#keyword[前置演算子]と呼ぶが，数学者は同じものを左作用素と呼ぶ．

Haskellには単項マイナス $(-)$ を除いて他に単項演算子はない．今後，誤解を避けるために数式中の $-x$ はすべて $(-x)$ と書く．

二項演算子のうちよく使われるものは和 $(+)$，積 $(times)$，論理和 $(or)$，論理積 $(and)$，同値 $(equiv)$，大なり$(>)$，小なり $(<)$ 等である．二項演算子はたとえ積記号であっても省略できない．二項演算子は多数あるので，その都度説明する．#footnote[Haskellでは $and$ を ```haskell &&``` と書き，$or$ を ```haskell ||``` と書く．]

二項演算子は#keyword[中置]することが基本であるが，括弧で包むことで前置することも可能である．任意の二項演算子 $haskell.anyop$ について $x class("binary",haskell.anyop) y$ 及び $(haskell.anyop) x y$ は全く同じ意味である．すなわち
#par-equation($ (haskell.anyop) x y = x class("binary", haskell.anyop) y $)
である．従って，二項演算子と2引数関数に本質的な差はない．本書では演算子と関数という用語は全く同じ意味で用いる．#footnote[Haskellでは任意の二項演算子を括弧で包むことで前置演算子として使うことができる．例えば `x + y` と `(+) x y` は同じ結果を返す．]

一般の関数が左結合であることを思い出すと，二項演算子を関数に見立てた $(haskell.anyop)$ についても
#par-equation($ (haskell.anyop) x y = ((haskell.anyop) x) y $)
であるから，部分適用が可能である．この式から第2引数 $y$ を取り除いて $((haskell.anyop) x)$ という「餓えた」1引数関数を取り出せる．例えば関数 $((+)1)$ は引数に $1$ を加える関数である．#footnote[Haskellでは $((+)1)$ を ```haskell ((+)1)``` と書く．]

前置される二項演算子 $(haskell.anyop)$ は，ラムダ式 $(lozenge.stroked.medium class("binary", haskell.anyop) lozenge.stroked.medium)$ の無名パラメタ $lozenge.stroked.medium$ を省略したものと考えても良い．また $(lozenge.stroked.medium haskell.anyop x)$ や $(x haskell.anyop lozenge.stroked.medium)$ から無名パラメタを省略した $(haskell.anyop x)$ と $(x haskell.anyop)$ も有効な表現であり，特別に#keyword[セクション]と呼ばれる．

二項演算子 $haskell.anyop$ に対して $(haskell.anyop x)$ および $(x haskell.anyop)$ はそれぞれ以下の通りである．

$ (haskell.anyop x) &= (lozenge.stroked.medium haskell.anyop x) \
 (x haskell.anyop) &= (x haskell.anyop lozenge.stroked.medium)
 = ((haskell.anyop) x) $

例えば $(1+)$ は $((+)1)$ と等価であり，これは $(+1)$ とも等価である．ただし，マイナス演算子 $(-)$ だけは例外で，$(-1)$ はマイナス $1$ を表す．負の数をいつも括弧で包んでおくのは良いアイディアである．#footnote[Haskell は $(1+)$ を ```haskell (1+)``` と書く．また ```haskell (-1)``` はセクションではなくマイナス $1$ を表す（```haskell -1``` というリテラルとみなされる）．ただし ```haskell (- 1)``` のように空白を挟んでも同じくマイナス $1$ とみなされる（```haskell 1``` というリテラルに単項マイナス演算子が適用される）．]

なお，二項演算子の結合性，すなわち左結合か右結合かは，演算子によって異なる．また演算の優先順位を明示的に与えるために括弧が用いられる．

一般の関数 $f$ を中置演算子に変換する記号 $haskell.infix(f)$ を今後用いる．この記号を用いると値 $f x y$ のことを $x haskell.infix(f) y$ と書くことができる．#footnote[Haskellでは $x haskell.infix(f) y$ を ```haskell x `f` y``` と書く．]

=== 関数合成と関数適用

ある変数に複数の関数を順に適用することはよくあることである．例えば次のようにしたいことがある．

#sourcecode[```python
# Python
y = f(x)
z = g(y)
```]

あるいは同じことであるが次のようにしたいことがある．
#sourcecode[```python
# Python
z = g(f(x))
```]

このコードを本書の記法で書けば $z = g(f x)$ である．この式から括弧を省略して $z = g f x$ としてしまうと，関数適用は左結合するから $z = (g f) x$ の意味になってしまう．関数 $g$ が引数に関数を取るので無い限り $(g f)$ は無意味なので，$ z = g(f x)$ の括弧は省略できない．

ここで，引数のことは忘れて，関数 $f$ と関数 $g$ を先に#keyword[合成]しておきたいとしよう．その合成を $g compose f$ と書く．演算子 $compose$ は#keyword[関数合成演算子]と呼ぶ．合成はラムダ式を使って $g compose f = g(f lozenge.stroked.medium)$ と定義できる．関数合成演算子 $compose$ は関数適用よりも優先順位が高く，$(g compose f)x$ は単に $g compose f x$ と書いても良い．この記法は括弧の数を減らすためにしばしば用いられる．#footnote[Haskellでは関数 ```haskell g``` と関数 ```haskell f``` の合成は ```haskell g.f``` である．式 $z = g compose f x$ は ```haskell z = g.f x``` と書く．]

関数合成演算子は，連続して用いることができる．関数合成演算子は左結合するので，関数 $f, g, h$ について $h compose g compose f = (h compose g) compose f$ であるが，これを展開すると以下のようになる．
$ (h compose g) compose f &= (h compose g)(f lozenge.stroked.medium) \
  &= h(g(f lozenge.stroked.medium)) \
  &= h compose (g compose f) $

そのため $h compose g compose f = h compose (g compose f)$ である．つまり，関数合成は順序に依存しない．

#pb

#tk 関数合成則

#theorem-box(title: "恒等関数の存在", outlined: false)[
任意の関数 $f$ に対して恒等関数 $id$ ただし $id compose f = f$ が存在する．
]

#theorem-box(title: "結合則", outlined: false)[
任意の関数 $f, g, h$ について $(h compose g) compose f = h compose (g compose f)$ が成り立つ．
]

#pb

関数合成演算子とは逆に，結合の優先順位の低い#keyword[関数適用演算子]も考えておくと便利なこともある．関数適用演算子 $haskell.apply$ を次のように定義しておく．
$ f haskell.apply x = f x $

演算子 $haskell.apply$ の優先順位は関数適用も含めあらゆる演算子よりも低いものとする．関数適用演算子を用いて $z = g(f x)$ を書き直すと $z = g haskell.apply f x$ となる．演算子 $haskell.apply$ の優先順位は足し算よりも低いので $f(x + 1)$ は $f haskell.apply x + 1$ と書くこともできる．演算子 $haskell.apply$ を閉じ括弧のいらない開き括弧と考えてもよい．#footnote[Haskellでは $g haskell.apply f x$ を ```haskell g $ f x``` と書く．]

関数適用演算子のもう一つの興味深い使い方は，関数適用演算子の部分適用である．セクション $(lozenge.stroked.medium haskell.apply x)$ を用いると $(lozenge.stroked.medium haskell.apply x)f = f haskell.apply x$ であるから，関数適用演算子を用いて引数を関数に渡すことができる．#footnote[Haskell では $(lozenge.stroked.medium haskell.apply x)f$ を ```haskell ($x)f``` と書く．]

=== 高階関数

関数を引数に取ったり，あるいは関数を返す関数のことを#keyword[高階関数]と呼ぶことがある．関数合成演算子と関数適用演算子は高階関数の好例である．

他に例えば，引数として整数 $a$ を取り，関数 $f x = a + x$ を返すような関数 $g$ を次のように定義することが出来る．
$ g a = a + lozenge.stroked.medium $

このとき，
$ f &= g space 100 \
  x &= f space 1 $
とすれば $x = 101$ を得る．#footnote[Haskell では $g a = a + lozenge.stroked.medium$ を $g a = backslash x |-> a + x$ と展開しておいて ```hsakell g a = \ x -> a + x``` と書く．]

高階関数は今後度々顔をだすことになる．後で登場する#keyword[マップ演算子]や#keyword[畳込み演算子]は高階関数の一種である．

#pb

ラムダ式をサポートするほとんどのプログラミング言語は，#keyword[レキシカルクロージャ]をサポートする．レキシカルクロージャとは，ラムダ式が定義された時点での，周囲の環境をラムダ式に埋め込む機構である．例えば
$ a &= 100 \
  f &= a + lozenge.stroked.medium $
というラムダ式があるとする．当然我々は関数 $f$ がいつも $f = 100 + lozenge.stroked.medium$ であることを期待するし，Haskellにおいてはいつも保証される．#footnote[Haskellでは ```haskell a = 100; f = \x -> a + x``` と書く．]

ところが，参照透過性のない言語，言い換えると変数への破壊的代入が許されている言語では，変数 $a$ の値がいつ変わっても不思議ではない．そこで，それらの言語では関数 $f$ が定義された時点での $a$ の値を，関数 $f$ の定義に含めておく．これがレキシカルクロージャの考え方である．

Haskellではそもそも変数への破壊的代入がないので，関数 $f$ がレキシカルクロージャであるかどうか悩む必要はない．あえて言えば，Haskellではラムダ式はいつもレキシカルクロージャである．もしあなたのそばのC++プログラマが「え？　Haskellにはレキシカルクロージャが無いの？」などと聞いてきたら，「ええ，Haskellには破壊的代入すらありませんから」と答えておこう．

=== 余談：IOサバイバルキット1

ここで，実用的なHaskellプログラムについて触れておきたいと思う．

プログラムとは合成された関数である．多くのプログラミング言語では，プログラムそのものにmainという名前をつける．本書では#keyword[IOモナド]の章で述べる理由によって，main関数をボールド体で $haskell.main$ と書く．

実用的なプログラムはユーザからの入力を受け取り，関数を適用し，ユーザへ出力する．Haskellではユーザからの1行の入力を $haskell.getLine$ で受け取り，変数の値を $haskell.print$ で書き出せる．ここに $haskell.getLine$ と $haskell.print$ は関数（ファンクション）ではあるが，特別に#keyword[アクション]とも呼ぶ．関数 $haskell.main$ もアクションである．

ユーザ入力をただ受け取り，そのままユーザへ出力するプログラムをHaskellで書くと次のようになる．#footnote[Haskellでは ```haskell main = print =<< getLine ``` と書く．]

$ haskell.main = haskell.print haskell.bind haskell.getLine $
<first-bind>

新しい演算子 $haskell.bind$ は新たな関数合成演算子で，アクションとアクションを合成するための特別な演算子である．詳細は#keyword[モナド]の章で述べる．

#pb

何らかの数値計算を行うプログラムは，ユーザ入力を数値として読み取り，数値に作用する関数を適用し，結果をユーザへ出力する．つまり @first-bind の $haskell.print$ と $haskell.getLine$ の間に数値計算を行う任意の関数 $f$ を挿入すれば良いことになる．ただし関数 $f$ は数値を受け取って数値を返すものだから，ユーザ入力すなわち#keyword[文字列]を数値に#[変換]する必要がある．幸いHaskellは型の違いを吸収する $haskell.read$ 関数を提供している．

いま，任意の関数として引数 $x$ の2乗を求める関数 $f$ を次のように定義しよう．

$ &f colon.double haskell.Double -> haskell.Double\
  &f x = x times x $
<double-function>

@double-function の1行目は関数 $f$ の#keyword[型]を表している．型に関しては後述する．

ユーザからの入力に関数 $f$ を適用してユーザへ出力するプログラムをHaskellで書くと次のようになる．

$ haskell.main = haskell.print compose f compose haskell.read haskell.bind haskell.getLine $<first-main>

@double-function と@first-main に対応するHaskellコードは次のようになる．

#sourcecode[```haskell
-- Haskell
f :: Double -> Double
f x = x * x
main = print . f . read =<< getLine
```]

Haskell Stackを使う場合は `Main.hs` を次のように書き換えると良いだろう．

#sourcecode[```haskell
-- Main.hs
module Main (main) where
f :: Double -> Double
f x = x * x
main :: IO ()
main = print . f . read =<< getLine
```]

我々はひとまずこれで，最低限の入出力と数値計算を行うプログラムが書けたわけである．いま，以下のような数値だけを記述したファイル `input.txt` があるとしよう．

#sourcecode[```plain-text
4
```]

ここで，シェルで次のように実行する．
#sourcecode[```shell-unix-generic
$ stack run < input.txt
```]

すると，次のような出力が得られる．

#sourcecode[```shell-unix-generic
16.0
```]

このように，Haskellではプログラムの実行によってユーザ入力を受け取り，ユーザへ出力を行うことができる．

いまはまだ「ベイビー・プログラム」であるが，今後はより実用度を増していく．


=== この章のまとめ

#tk この章のまとめ．

== 型
<types>

Haskellの変数，関数にはすべて型がある．プログラマの言う型とは，数学者の言う集合のことである．本章では，Haskellが扱う基本的な型であるデータ型と，パラメトリックな型である多相型，および型の型である型クラスについて述べる．また関数のカリー化についても述べる．

=== データ型

Haskellのすべての変数，関数には#keyword[型]がある．代表的な型には整数型，浮動小数点型，ブール型，文字型がある．整数型を $haskell.Int$ で，浮動小数点型を $haskell.Double$ で表すことはすでに述べたとおりである．


型とは変数が取りうる値に言語処理系が与えた制約のことである．Haskellを含む多くのコンパイラ言語は#keyword[静的型付け]と言って，コンパイル時までに変数の型が決まっていることをプログラマに要求する．一方，Pythonのようなインタプリタ言語はたいてい#keyword[動的型付け]と言って，プログラムの実行時まで変数の型を決めない．

変数に型の制約を設ける理由は，プログラム上のエラーが減ることを期待するためである．例えば真理値が必要とされるところに整数値の変数が来ることは悪い予兆である．一方でC17までのC言語のように全ての変数にいちいち型を明記していくのも骨が折れる．

数学者や物理学者は変数に型の制約を求める一方，新しい変数の型は明記せず読者に推論させる方法をしばしばとる．例えば物理学では，質量 $m$ は「スカラー」という型を持つし，速度 $v$ は「3次元ベクトル」という型を持つ．スカラーと3次元ベクトルの間に足し算は定義されていないため，例えば $m+v$ という表記を見たときに，両者の型を知っていれば直ちにエラーであることがわかる．

Haskellはコンパイラが型推論を行うことで，型が自明の場合は型を省略することができる．#footnote[C23およびC++11以降は```c auto```キーワードを導入し，Haskellと同様の型推論を行うようになった．]

Haskellにはよく使う型が予め用意されている．

Haskellには2種類の整数型があり，ひとつは#keyword[固定長整数型]で，もうひとつは#keyword[多倍長整数型]である．Haskellでは前者を `Int` で，後者を `Integer` で表す．多倍長整数型はメモリの許す限り巨大な整数を扱えるので，整数全体の集合に近いのであるが，本書では主に固定長整数型を用いる．この $haskell.Int$ はCの ```c int``` と似た「計算機にとって都合の良い整数」である．計算機にとって都合の良い整数とは，例えば64ビット計算機の場合 $-2^(63)$ から $2^(63)-1$ の間の整数という意味である．#footnote[Haskellでは $haskell.Int$ を ```haskell Int``` で表す．]

変数 $x$ の型が $haskell.Int$のとき，以下のように#keyword[型注釈]を書く．#footnote[Haskellでは `x :: Int` と書く．]
$ x colon.double haskell.Int $

計算機は残念ながら無限精度の実数を扱えない．そこで標準精度（単精度）の#keyword[浮動小数点数型]である $haskell.Float$ と，#keyword[倍精度浮動小数点型]である $haskell.Double$ が提供される．#footnote[Haskellでは $haskell.Float$, $haskell.Double$ をそれぞれ ```haskell Float``` と ```haskell Double``` で表す．]

#keyword[論理型]は論理値 $haskell.True$ または $haskell.False$ のいずれかしか値をとれない型である．論理型のことを $haskell.Bool$と書く．#footnote[Haskellではブール型を `Bool` と書く．]

もう一つ，計算機ならではの型がある．それは $haskell.Int$ とよく似ているが，特別に文字を扱うために考えられた#keyword[文字型] $haskell.Char$ である．文字といってもその中身は整数である．整数ではあるが，わざわざ別な型とするのには理由がある．#footnote[Haskellでは $haskell.Char$ を ```haskell Char``` で表す．]

理由の第一は，文字が小さな整数であるため，文字型を独立して定義しておくことでメモリを節約できるのである．特にメモリが高価であった時代はこれが唯一の理由であった．現在でも，整数が一般に64ビットを消費するのに対し，UTF-8文字エンコードを用いている場合，アルファベットは8ビットしか消費しない．

理由の第二は，単純に整数と文字が異なるからである．文字を表す変数に整数を代入するのは悪い兆しである．

理由の第三は，文字が数値にエンコードされる方式が可変長である場合に備えて，整数と区別しておくためである．例えばUTF-8文字エンコードは可変長エンコーディングを行う．

これらのような基本的な型を#keyword[データ型]と呼ぶ．

#pb

関数にも型がある．例えば整数引数を一つ取り，整数を返す関数 $f$ は
#par-equation($ f colon.double haskell.Int -> haskell.Int $)
という型を持つ．この型は
#par-equation($ f colon.double underbrace(haskell.Int, x) -> underbrace(haskell.Int, f x) $)
のようにイメージすると良い．これは関数 $f$ が集合 $haskell.Int$ から集合 $haskell.Int$ への#keyword[写像]であると読む．#footnote[Haskellでは ```haskell f :: Int -> Int``` と書く．なお正確には矢印記号 $(->)$ は型コンストラクタである．無名の型引数を $lozenge.filled.medium$ で表すと $->$ は $chevron.l lozenge.filled.medium -> lozenge.filled.medium chevron.r$ という，ふたつの型引数を取る型コンストラクタである．
]

2引数関数の型は次のように注釈できる．#footnote[Haskellでは `f :: Int -> Int -> Int` と書く．]
$ f colon.double haskell.Int -> haskell.Int -> haskell.Int $

ここで関数 $f$ は整数型の引数をふたつとり，整数型の値を返す．型 $haskell.Int -> haskell.Int -> haskell.Int$ は $haskell.Int -> (haskell.Int -> haskell.Int)$ と解釈される．

$(haskell.Int -> haskell.Int)$ 型の関数を受け取り $(haskell.Int -> haskell.Int)$ 型の関数を返す関数は次の型を持つ．#footnote[Haskellでは `f :: (Int -> Int) -> (Int -> Int)` と書く．]
$ f colon.double (haskell.Int -> haskell.Int) -> (haskell.Int -> haskell.Int) $

なお後半の括弧は省略可能なので次のように書いても良い．
$ f colon.double (haskell.Int -> haskell.Int) -> haskell.Int -> haskell.Int $

Haskellではすべての変数，関数に型があり，型はコンパイル時に決定されていなければならない．ただし，式から#keyword[型推論]が行える場合は型注釈を省略できる．

=== カリー化

Haskellでは，どのような関数であれ引数は1個しかとらない．引数が2個あるように見える関数として，例えば $g x y$ があったとしよう．ここに $g$ は関数，$x$ と $y$ は変数である．関数適用は左結合であるから，これは　$(g x)y$ である．ここに $(g x)$ は引数 $y$ をとる関数であると見ることができる．つまり，関数 $g$ とは引数 $x$ をとり「引数 $y$ をとって値を返す関数 $(g x)$ を返す」関数であると言える．

二項演算 $x + y$ は $(+)x y$ とも書けたことを思い出そう．これも左結合を思い出すと $(+)x y = ((+)x)y$ であるから，$y$ という引数を $((+)x)$ という関数に食わせていると解釈できる．

ラムダ式の場合は話はもっと単純で，形式的に
#par-equation($ backslash x y |-> x + y = backslash x |-> (backslash y |-> x + y) $)
のように展開すれば1引数にできる．矢印 $|->$ は#keyword[右結合]である．そこでこのラムダ式は括弧を省略して
#par-equation($ backslash x y |-> x + y = backslash x |-> backslash y |-> x + y $)
とも書かれる．

複数引数をとる関数を1引数関数に分解することを#keyword[カリー化]と呼ぶ．これはこの分野の先駆者であるハスケル・カリーの名前に由来する．

整数引数を二つ取り，整数を返す関数 $g$ は
#par-equation($ g colon.double haskell.Int -> haskell.Int -> haskell.Int $)
という型を持つ．写像の矢印記号は右結合するので，これは
#par-equation($ g colon.double haskell.Int -> (haskell.Int -> haskell.Int) $)
と同じ意味である．上式は
#par-equation($ g colon.double underbrace(haskell.Int, x) -> underbrace(overbrace(haskell.Int, y) -> overbrace(haskell.Int, (g x)y), g x) $)
のようにイメージすると良い．

自然言語で考えると $haskell.Int$ 型の引数を一つ取り，$haskell.Int$ 型の引数を一つ取って $haskell.Int$ 型の値を返す関数を返す，と読める．#footnote[関数の型に出てくる $->$ は2引数をとる型コンストラクタである．型コンストラクタに関しては〜〜〜で詳しく述べる．例えば $haskell.a -> haskell.b$ という型は $(->)haskell.a haskell.b$ の別名であり，型コンストラクタ $(->)$ に引数 $haskell.a$ と $haskell.b$ を与えたものと読む．]

#pb

Haskellには#keyword[タプル]という型がある．タプルとは，複数の変数を組み合わせたもので，例えば変数 $x$ と $y$ をひとまとめにした $paren.l.stroked x, y paren.r.stroked$ はタプルである．変数 $x$, $y$ の型は同じでも良いし，異なっても良い．#footnote[Haskellでは $paren.l.stroked x, y paren.r.stroked$ を ```haskell (x, y)``` と書く．]

タプルの型は，要素の型をタプルにしたものである．例えば $haskell.Int$ が2個からなるタプルの型は次のようになる．#footnote[Haskellでは ```haskell z :: (Int, Int)``` と書く．]

$ z colon.double paren.l.stroked haskell.Int, haskell.Int paren.r.stroked $

いまタプルを引数に取る関数 $f paren.l.stroked x, y paren.r.stroked = x + y$ があったとしよう．Haskellにはタプルをとる関数をカリー化する関数 $haskell.curry$ があり，$(haskell.curry f) x y$ は $x + y$ になる．

逆に，カリー化された関数 $f' x y = x + y$ に関しては $(haskell.uncurry f')paren.l.stroked x, y paren.r.stroked$ のように#keyword[アンカリー化]することで，タプルに適用することができる．

タプルの中身の個数は0個または2個以上でなければならず，上限は処理系によって定められている．2個の変数からなるタプルを特別にペア，3個の変数からなるタプルを特別にトリプルと呼ぶ．中身が0個のタプルを $nothing.rev$ で表し，特別に#keyword[ユニット]と呼ぶ．#footnote[GHC v8.2.1 は最大62個の変数からなるタプルまで生成できる．]

ユニット $nothing.rev$ の型は#keyword[ユニット型]で，変数 $x$ がユニット型の場合は次のように書く．#footnote[Haskellでは ```haskell x :: ()``` と書く．]

$ x colon.double haskell.Unit $

=== 多相型と型クラス

整数型 $(haskell.Int)$ と浮動小数点型 $(haskell.Float)$ はよく似ている．どちらも値同士を比較可能で，それ故どちらにも等値演算子が定義されている．

整数型の等値演算子は 
#par-equation($ (equiv) colon.double haskell.Int -> haskell.Int -> haskell.Bool $)
であり，浮動小数点型の等値演算子は
#par-equation($ (equiv) colon.double haskell.Double -> haskell.Double -> haskell.Bool $)
である．

このように型が異なっても（だいたい）同じ意味で定義されている演算子のことを#keyword[多相的]な演算子と呼ぶ．等値演算子は多相的な演算子の例である．

具体的な型を指定せずに，仮の変数で表したものを#keyword[型パラメタ]と呼ぶ．我々は型パラメタをボールドイタリック体で表す．いま型を表す仮の変数を $haskell.a$ として，等値演算子の型を次のように表現してみよう．

$ (equiv) colon.double haskell.a -> haskell.a -> haskell.Bool $<equiv>

このような型パラメタを用いた型を総称して#keyword[多相型]と呼ぶ．

実は@equiv は不完全なものである．このままでは型 $haskell.a$ に何の制約もないため，等値演算の定義されていない型が来るかもしれないからである．そこで，型自身が所属する，より大きな型があるとしよう．そのような型を我々は#keyword[型クラス]と呼ぶ．例えば型 $haskell.Bool, haskell.Int,haskell.Integer, haskell.Float, haskell.Double$ は全て等値演算が定義できるので，型クラス $haskell.Eq$ に属すとする．この関係を我々は
#par-equation($ haskell.Eq supset haskell.Bool, haskell.Int, haskell.Integer, haskell.Float, haskell.Double $)
と書く．ここに $haskell.Eq supset haskell.a$ と書いて「型 $haskell.a$ は型クラス $haskell.Eq$ の#keyword[インスタンス]である」と読む．

@equiv に型クラスの制約を加えてみよう．型 $haskell.a$ は型クラス $haskell.Eq$ に属さなければならないから，新たな記号 $arrow.r.stroked$ を使って
#par-equation($ (equiv) colon.double haskell.Eq supset haskell.a arrow.r.stroked haskell.a -> haskell.a -> haskell.Bool $)
と書くことにする．#footnote[Haskellでは ```haskell (==) :: Eq a => a -> a -> Bool``` と書く．記号 $supset$ は省略する．]

型 $haskell.a$ の変数同士の間で大小関係が定義されている場合，かつその型が型クラス $haskell.Eq$ に属する場合，その型は型クラス $haskell.Ord$ にも属する．型クラス $haskell.Ord$ に属する型は比較演算子 $<, <=, >=, >$ を提供する．例えば型 $haskell.Int$ は型クラス $haskell.Ord$ に属すが，型 $haskell.Bool$ は型クラス $haskell.Ord$ に属さない．

型 $haskell.a$ の変数同士の間で四則演算関係が定義されている場合，かつその型が型クラス $haskell.Eq$ に属する場合，その型は型クラス $haskell.Num$ にも属する．型クラス $haskell.Num$ に属する型は二項演算子 $+, -, *, slash$ を提供する．ここに $-$ は二項演算子のマイナスである．

型 $haskell.a$ が型クラス $haskell.Ord$ 及び型クラス$haskell.Num$ に属しているとき，かつそのときに限り，型 $haskell.a$は型クラス $haskell.Real$ にも属する．

型 $haskell.a$ の変数について，一つ小さい値を返す関数 $haskell.pred$ と一つ大きい値を返す関数 $haskell.succ$ が定義されているとき，かつそのときに限り，型 $haskell.a$ は型クラス $haskell.Enum$ に属する．

型 $haskell.a$ が型クラス $haskell.Real$ 及び型クラス$haskell.Enum$ に属しているとき，かつそのときに限り，型 $haskell.a$ は型クラス $haskell.Integral$ にも属する．

便利な型変換演算子をひとつ紹介しておこう．型変換演関数 $haskell.fromIntegral$ は
#par-equation($ haskell.fromIntegral colon.double haskell.Integral supset haskell.a
  arrow.r.stroked haskell.a -> haskell.b $)
という型を持ち，$haskell.Integral$ 型クラスの型の変数を任意の型へ変換する．例えば，
#par-equation($ x colon.double haskell.Double = haskell.fromIntegral 1 colon.double haskell.Int $)
とすることで，$haskell.Double$ 型の変数 $x$ に $haskell.Int$ 型の定数を代入できる．#footnote[Haskellでは ```haskell x :: Double = fromIntegral 1 :: Int``` と書く．]

=== 余談：全称量化子

型 $haskell.a$ の変数を引数に取り，型 $haskell.a$ の戻り値を返す関数 $f$ の型注釈は
#par-equation($ f colon.double haskell.a -> haskell.a $)
であった．この記法は実はシンタックスシュガーで，本来は次のように書くべきものである．#footnote[Haskellでは ```haskell f :: forall a . a -> a``` と書く．記号 $forall$ が ```haskell forall``` であり，記号 $|=>$ が ```haskell .``` である．]
#par-equation($ f colon.double forall haskell.a |=> haskell.a -> haskell.a $)
ここに $forall$ は#keyword[全称量化子]という記号で，型の世界でのラムダ $(backslash)$ に相当する．

#tk 型に対する演算

=== この章のまとめ

#tk この章のまとめ

== リスト
<list>

型から作る型を#keyword[コンテナ型]と呼ぶ．代表的なコンテナはある型のホモジニアスな配列であるリストである．この章ではリストと，リストに対する重要な演算である畳み込み，マップを取り扱う．

=== リスト

同じ型の値を一列に並べたもの，つまり#keyword[ホモジニアスな配列]のことを#keyword[リスト]と呼ぶ．Pythonではリスト ```python xs``` を次のように定義できる．

#sourcecode[```python
# Python
xs = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```]

我々も $0$ から始まり $9$ まで続く整数のリストを $[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]$ と書くことにしよう．ただし，これでは冗長なので#keyword[等差数列]に限って簡略化した書き方を許す．例えば $0$ から $9$ までのリストは $[0, 1, ..., 9]$ と書いても良い．#footnote[Haskellでは ```haskell [0, 1..9]``` と書く．ピリオドの数に注意しよう．]

リストの中身の一つ一つの値のことを#keyword[要素]と呼ぶ．要素のことは元と呼んでも良いが，本書では要素と呼ぶことにする．要素も元も英語のelementの和訳である．

複数の型の要素が混在してもよい配列のことを#keyword[ヘテロジニアスな配列]と呼び，ホモジニアスな配列とは区別する．

今後，リストを指す変数は，リストであることを忘れないように変数名にsをつけて
#par-equation($ x_"s" = [0, 1, ..., 9] $)
と書くことにする．なお，変数 $x$ とリスト変数 $x_"s"$ は異なる変数であるとする．#footnote[Haskellでは `s` を変数名にくっつけて ```haskell xs = [0, 1..9]``` のように書く習慣がある．なおピリオドの数に注意しよう．]

#pb

リストは空でもよい．#keyword[空リスト]は $emptyset$ で表す．#footnote[Haskellでは空リストを ```haskell []``` で表す．]

関数 $haskell.null$ はリストが空リストかどうかを判定する．リスト $x_"s"$ が空リストの場合 $haskell.null x_"s"$ は $haskell.True$ を，そうでなければ $haskell.False$ を返す．関数 $haskell.null$ は
#par-equation($ haskell.null colon.double [haskell.a] -> haskell.Bool $)
である．

#pb

Pythonでは#keyword[リスト内包表記]が使える．例えば $0$ から $9$ までの倍数のリストは次のように作った．

#sourcecode[```python
# Python
xs = [x * 2 for x in range(0, 10)]
```]

ここに ```python range(a, b)``` は ```python a``` から増加する方向に連続する ```python b``` 個の整数からなるリストを返すPythonの関数である．

我々も内包表記を
#par-equation($ x_"s" = [x times 2 | x in [0, 1, ..., 9]] $)
のように書こう．ここに右辺のリストから一つずつ要素を取り出して左辺に代入する演算子 $in$ を用いた．#footnote[Haskellでは $x_"s" = [x times 2 | x in [0, 1, ..., 9]]$ を ```haskell xs = [x * 2 | x <- [0, 1..9]]``` と書く．]

内包表記の式は複数あっても良い．例えば
#par-equation($ x_"s" = [x + y | x in [0, 1, ..., 9], y in [0, 1, ..., 5], x + y > 3] $)
は $0 <= x <= 9$ かつ $0 <= y <= 5$ の範囲で $x + y > 3$ となる $x$ 及び $y$ から $x + y$ を並べたリストである．#footnote[Haskellでは ```haskell xs = [x + y | x <- [0, 1..9], y <- [0, 1..5], x + y > 3]``` と書く．]

同じことをPythonで書くと次のようになる．

#sourcecode[```python
# Python
xs = [x + y for x in range(0, 10) for y in range(0, 6) if x + y > 3]
```]

#pb

整数型 $(haskell.Int)$ のリストは $[haskell.Int]$ と書き，整数のリスト型と呼ぶ．一般に $haskell.a$ 型のリストを $[haskell.a]$ と書く．仮の型である $haskell.a$ の事を #keyword[型パラメタ]と呼ぶ．

型 $haskell.a$ から型 $[haskell.a]$ を生成する演算子を#keyword[リスト型コンストラクタ]と呼んで $[]$ と書く．型 $[haskell.a]$ は $haskell.typeconstructor1([], haskell.a)$ のシンタックスシュガーである．#footnote[Haskellでは $haskell.typeconstructor1([], haskell.a)$ を ```haskell [] a``` と書く．これは ```haskell [a]``` と同じことである．]

型コンストラクタの概念はPythonには無い（必要無い）が，静的型付け言語であるC++のクラステンプレートが相当する．

#pb

$[x]$ のように $haskell.a$ 型の変数 $x$ を入れた $[haskell.a]$ 型の変数を作る演算子を#keyword[リスト値コンストラクタ]と呼ぶ．$[haskell.a]$ 型の変数のことを#keyword[リスト変数]とも呼ぶ．$haskell.a$ 型の変数 $x$ からリスト値コンストラクタを使ってリスト$x_"s"$ を作ることは 
#par-equation($ x_"s" = [x] $)
と書く．#footnote[Haskellでは ```haskell xs = [x]``` と書く．]

リスト型を表す $[haskell.a]$ と，1要素のリストである $[x]$ の違いにはいつも気をつけておこう．本書では中身がボールド体ならばリスト型，中身がイタリック体ならリスト値である．

ある型を包み込んだ別の型を一般にコンテナと呼ぶのであった．コンテナ型は多相型の一種である．また，コンテナ型の変数を#keyword[コンテナ変数]と呼ぶ．

#pb

リストは#keyword[結合]できる．例えばリスト $x_"s"$ とリスト $y_"s"$ を結合したリストは $x_"s" smash y_"s"$ と表現する．リストの結合演算子の型は
#par-equation($ (smash) colon.double [haskell.a] -> [haskell.a] -> [haskell.a] $)
である．#footnote[Haskellでは $x_"s" smash haskell.y_"s"$ を ```haskell xs ++ ys``` と書く．]

#pb

我々は無限リストを持つことができる．例えば自然数を表すリスト $n_"s"$ は $n_"s" = [1, 2, ...]$ と書くことができる．#footnote[Haskellでは ```haskell ns = [1, 2..]``` と書く．]

無限リストを扱えるのは，我々がいつも遅延評価を行うからである．遅延評価とは，本当の計算は必要になるまで行わないという方式のことである．

もし本当に無限リストを計算機の上で再現する必要があったなら，計算機には無限のメモリが必要になってしまう．しかし我々は，計算が必要になるまで評価を行わないので，無限リストの中から有限個の要素が取り出されるのを待つことができるのである．例えば関数 $haskell.take m space n_"s"$ はリスト $n_"s"$ から最初の $m$ 個の要素からなるリストを返す．いま
#par-equation($ x_"s" = haskell.take 5 space n_"s" $)
とすると，リスト $x_"s"$ は $x_"s" = [1, 2, ..., 5]$ という値を持つ．#footnote[Haskellでは ```haskell xs = take 5 ns``` と書く．]

関数 $haskell.take$ の型は
#par-equation($ haskell.take colon.double haskell.Int -> [haskell.a] -> [haskell.a] $)
である．

リスト $x_"s"$ の $n$ 番目の要素には $x_"s" haskell.bangbang n$ とすることでアクセスできる．#footnote[Haskellでは ```haskell xs !! n``` と書く．]

#pb

#keyword[文字列]は $haskell.Char$ 型のリストである．実際 $haskell.String$ 型は
#par-equation($ haskell.kwtype haskell.String = [haskell.Char] $)
と定義されている．#footnote[Haskellでは ```haskell type String = [Char]``` と書く．]

ここにキーワード $haskell.kwtype$ はデータ型の別名，つまり#keyword[型シノニム]を定義するためのキーワードである．

文字列型のリテラルは次のように書く．#footnote[Haskell では ```haskell xs = "Hello, World!"``` と書く．]

$ s = haskell.constantstring("Hello, World!") $

リストに対するすべての演算は文字列にも適用可能である．

#pb

リストの構成には#keyword[内包表記]が使える．例を挙げる．#footnote[Haskellでは ```haskell xs = [x ^ 2 | x <- [1, 2..100], x > 50]``` と書く．]

$ x_"s" = [x^2 | x in [1,2...100], haskell.even x] $

関数 $haskell.even$ は引数が偶数の場合にだけ $haskell.True$ を返す関数である．この例では数列 $[1,2...100]$ のうち偶数だけを2乗したリストを作っている．

マップと畳み込み

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

=== 畳み込み

我々はよくリストの総和を表現するために総和演算子 $(sum)$ を使う．総和演算子とはリスト $[x_0, x_1, ..., x_n]$ に対して
#par-equation($ sum [x_0, x_1, ..., x_n] = x_0 + x_1 + ... + x_n $)
で定義される演算子である．

この表現を一般化してみよう．リスト $[x_0, x_1, ..., x_n]$ が与えられたとき，任意の二項演算子を $haskell.anyop$ として
#par-equation($ haskell.fold_a^haskell.anyop [x_0, x_1, ..., x_n]
  = a haskell.anyop x_1 haskell.anyop ... haskell.anyop x_n $)
であると定義する．

この新しい演算子 $haskell.fold$ は#keyword[畳み込み演算子]と呼ばれる．変数 $a$ を#keyword[アキュムレータ]と呼ぶ．アキュムレータは右側の引数が空であった場合のデフォルト値と考えても良い．#footnote[Haskellでは $haskell.fold_a^+ x_"s"$ を ```haskell foldl (+)) a xs``` と書く．]

Python 2.7 には畳み込み演算子に相当する ```python reduce``` 関数があり，リスト ```python ls``` の総和 ```python s``` を次のように求めることが出来た．

#sourcecode[```python
# Python 2.7
ls = [0, 1, 2, 3, 4, 5]
s = reduce(lambda x, y: x + y, ls, 0)
```]

この ```python reduce``` 関数はPythonバージョン3では非推奨になっているが，Rubyには受け継がれていて，Rubyでは次のように書ける．

#sourcecode[```ruby
# Ruby
ls = [0, 1, 2, 3, 4, 5]
s = ls.inject(0) { |x, y| x + y }
```]

#pb

リストの総和をとる演算子 $sum$ は
#par-equation($ sum x_"s" = haskell.fold_0^+ x_"s" $)
とすれば得られる．この式は両辺の $x_"s"$ を省略して
#par-equation($ sum = haskell.fold_0^+ $)
とも書く．

リストの要素のすべての積をとる演算子 $product$ は
#par-equation($ product = haskell.fold_1^times $)
とすれば得られる．

畳み込み演算子は第1（上）引数に $haskell.a$ 型と $haskell.b$ 型の引数を取り $haskell.a$ 型の戻り値を返す二項演算子，第2（下）引数に $haskell.a$ 型，第3（右）引数に $haskell.b$ 型のリストすなわち $[haskell.b]$ 型を取り，$haskell.a$ 型の値を返す．従って畳み込み演算子の型は
#par-equation($ haskell.fold colon.double (haskell.a -> haskell.b -> haskell.a
  -> haskell.a -> [haskell.b] -> haskell.a $)
である．

畳み込み演算子には次のようなもう一つのバリエーションがある．
#par-equation($ haskell.foldright_a^haskell.anyop [x_0, x_1, ..., x_n]
  = (x_0 haskell.anyop (x_1 haskell.anyop ... haskell.anyop (x_n haskell.anyop a))) $)
これは#keyword[右畳み込み]と呼ばれる演算子である．#footnote[Haskellでは `foldr (+) xs a` と書く．引数の順序に注意しよう．]

畳み込み演算子の面白い応用例を示そう．リストの結合演算子 $(smash)$ を使うと
#par-equation($ haskell.fold_emptyset^smash [[0, 1, 2], [3, 4, 5], ...] = [0, 1, 2, 3, 4, 5, ...] $)
であるから，演算子 $haskell.fold_emptyset^smash$ はリストを平坦化する#keyword[平坦化演算子]である．平坦化演算子はconcat演算子とも呼ばれることもあるが，基本的な演算子であるため特別な記号をつけておこう．我々は
#par-equation($ haskell.flat = haskell.fold_emptyset^smash $)
と定義することにする．#footnote[Haskellでは演算子 $haskell.flat$ の代わりに ```haskell concat``` 関数（または ```haskell join``` 関数）を使う．]

=== マップ

リストの各要素に決まった関数を適用したい場合がある．Pythonではリスト ```python xs``` に関数 ```python f``` を適用するときには次のように書く．

#sourcecode[```python
# Python
f = lambda x: 100 + x
xs = [1, 2, 3, 4, 5]
ys = map(f, xs)
```]

このコードは結果として ```python ys``` に ```python [101, 102, 103, 104, 105]``` を入れる．

このように引数として任意の関数 $f$ と任意のリスト $[x_0, x_1, ..., x_n]$ を取り，戻り値として $[f x_0, f x_1, ..., f x_n]$ を返す演算子 $*$ を考えよう．このとき
#par-equation($ f * [x_0, x_1, ..., x_n] = [f x_0, f x_1, ..., f x_n] $)
であると定義する．この演算子 $*$ をリストの#keyword[マップ演算子]と呼ぶ．#footnote[Haskellでは ```haskell map f xs``` または ```haskell f <$> xs``` と書く．演算子 ```haskell <$>``` は ```haskell fmap``` 演算子の中置バージョンである．]

リストのマップ演算子の型は
#par-equation($ (*) colon.double (haskell.a -> haskell.b) -> [haskell.a] -> [haskell.b] $)
である．矢印 $->$ は右結合なので，これは
#par-equation($ (*) colon.double (haskell.a -> haskell.b) -> ([haskell.a] -> [haskell.b]) $)
の意味でもある．念のため上式に注釈を加えると
#par-equation($ (*) colon.double underbrace((haskell.a -> haskell.b), f)
  -> (underbrace([haskell.a], [x_0, x_1, ..., x_n]) -> underbrace([haskell.b], [f x_0, f x_1, ..., f x_n])) $)
である．

ここで $f$ と $(f*)$ の型を並べてみると
#par-equation($ f &colon.double haskell.a -> haskell.b \
  (f *) &colon.double [haskell.a] -> [haskell.b] $)
となり，マップ演算子が何をしているのか一目瞭然になる．

具体例を見てみよう．先程のPythonコードの例にあわせて
#par-equation($ f &= backslash x |-> 100 + x \
  x_"s" &= [1, 2, ..., 5] \
  y_"s" &= f * x_"s" $)
とすると $y_"s"$ の値は $101, 102, 103, 104, 105]$ となる．

=== 余談：IOサバイバルキット2

1行ごとに3次元ベクトルが並べられた，以下の入力ファイルがあるとする．
#sourcecode[```plain-text
1.0 2.0 3.0
4.5 5.5 6.5
```]
このようなファイル形式は計算機科学者にとって見慣れたものである．

各行つまり各ベクトルごとに，そのノルムを計算して出力するプログラムを書きたいとしよう．まず数列を受け取ってそのノルムを返す関数 $haskell.norm$ を次のように定義する．

$ &haskell.norm colon.double [haskell.Double] -> haskell.Double\
 &haskell.norm emptyset = 0.0\
 &haskell.norm x_"s" = haskell.sqrt (sum [x * x | x in x_"s"]) $<norm>

 @norm の1行目に出てくる型 $[haskell.Double]$ は $haskell.Double$ のリストである．

 @norm は関数のパタンマッチングを使っている．引数が空リストつまり $emptyset$ の場合，関数は $0.0$ を返す．それ以外の場合は，リスト内包表記を使ってノルムを計算して返す．

入力ファイル全体を受け取るにはアクション $haskell.getContents$ を用いる．

入力ファイルを1行毎のリストにするには関数 $haskell.lines$ を用いる．関数 $haskell.lines$ の型は
#par-equation($ haskell.lines colon.double haskell.String -> [haskell.String] $)
である．関数 $haskell.lines$ を用いると，入力
```haskell "1.0 2.0 3.0\n 4.5 5.5 6.5"```が ```haskell ["1.0 2.0 3.0", "4.5 5.5 6.5"]``` になる．

各行を空白で区切ってリストに格納するには関数 $haskell.words$ を用いる．関数 $haskell.words$ の型は
#par-equation($ haskell.words colon.double haskell.String -> [haskell.String] $)
である．関数 $haskell.words$ を用いると，入力 ```haskell "1.0 2.0 3.0"``` が ```haskell ["1.0", "2.0", "3.0"]``` になる．

文字列を浮動小数点数に変換するには次の関数 $haskell.readDouble$ を用いる．
#par-equation($ &haskell.readDouble colon.double haskell.String -> haskell.Double\
  &haskell.readDouble = haskell.read $)
この関数 $haskell.readDouble$ は標準関数 $haskell.read$ に型注釈を付けただけのものであるが，今回の目的には十分である．例えば ```haskell readDouble "1.0"``` は ```haskell 1.0``` を返す．

入力ファイルの各行に書かれたベクトルを対象に関数 $norm$ を適用して，結果を書き出すには，これまでの関数を結合して次のように書く．

$ haskell.main
  = haskell.print
    compose (norm *)
    compose ((haskell.readDouble *) *)
    compose (haskell.words *)
    compose haskell.lines
    haskell.bind haskell.getContents $<io-survival-kit-2>

@io-survival-kit-2 は，右辺の右端から次のように読むことが出来る．
1. 入力全体を $haskell.getContents$ で読み込む．
2. 読み込んだ入力を $haskell.lines$ で1行毎のリストに変換する．
3. 1行毎のリストを $haskell.words$ で空白で区切ったリストに変換する．
4. 空白で区切ったリストを $haskell.readDouble$ で浮動小数点数に変換する．
5. 浮動小数点数のリストのノルムを $norm$ で計算する．
6. ノルムのリストを $haskell.print$ で出力する．

@io-survival-kit-2 をHaskellコードで書くと次のようになる．

#sourcecode[```haskell
-- Haskell
norm :: [Double] -> Double
norm [] = 0.0
norm xs = sqrt (sum [x * x | x <- xs])

readDouble :: String -> Double
readDouble = read

main :: IO ()
main = print 
         . (norm <$>) 
         . ((readDouble <$>) <$>) 
         . (words <$>) 
         . lines 
         =<< getContents
```]

@io-survival-kit-2 において，アクション $haskell.print$ に代えて次の $haskell.printEach$ を用いると，入力と出力を同じ形式にできる．#footnote[Haskell では ```haskell printEach xs = print `mapM` xs``` と書く．]
#par-equation($ haskell.printEach x_"s" = haskell.print *_"M" x_"s" $)
演算子 $*_"M"$ はアクション版のマップ演算子である．

=== この章のまとめ

#tk この章のまとめ

== 再帰
<recursion>

#tk 再帰

=== 関数の再帰適用

自然数 $n$ の#keyword[階乗]は次のように定義される．
#par-equation($ n! = n times (n - 1) times ... times 1 $)
数学者は $0! = 1$ と定義するので，この式は
#par-equation($ 0! &= 1 \
  n! &= n times (n - 1)! $)
という風に「#keyword[再帰]的に」書き直すことが出来る．再帰とは，定義式の両辺に同じ関数名が現れることを指す．

Haskellで書きやすいように，後置演算子 $!$ のかわりに関数 $haskell.fact$ を定義しよう．関数は内部で自分自身を適用しても良いので，階乗関数 $haskell.fact$ の定義は次のようになる．
#par-equation($ haskell.fact x = haskell.kwcase x haskell.kwof cases(0 arrow.r.dotted 1,
  rect.stroked.h arrow.r.dotted x times haskell.fact(x - 1)) $)
と定義できる．関数が自分自身を適用することを関数の#keyword[再帰適用]と呼ぶ．#footnote[Haskellでは ```haskell fact x = case x of { 0 -> 1; _ -> x * fact (x - 1) }``` と書く．]

これで我々は関数の適用，変数の代入，ラムダ式，条件式，再帰の方法を学んだわけである．これだけあれば，原理的にはどのようなアルゴリズムも書くことができる．今日からはカリー風な数学であらゆるアルゴリズムを表現できるのである！

#pb

このように関数は再帰的に呼び出せる．いま $n >= 0$ を前提とすると $n$ 番目のフィボナッチ数を計算する関数 $haskell.fib$ を次のように定義できる．

$ haskell.fib 0 &= 0\
  haskell.fib 1 &= 1\
  haskell.fib n &= haskell.fib (n-1) + haskell.fib (n-2) $

=== リストと再帰

数学におけるリストは自由に考えることが出来るが，計算機上ではその実装も考えておかねばならない．我々はリストをLispにおけるリスト構造と同じ構造を持つものとする．Lispにおけるリストとは，変数 $haskell.first$ と 変数 $haskell.rest$ からなるペアの集合である．変数 $haskell.first$ がリストの要素を参照し，変数 $haskell.rest$ が次のペアを参照する．リストの最後のペアの $haskell.rest$ は空リストを参照する．

リストのための特別な表現
#par-equation($ haskell.first : haskell.rest $)
を用い，変数 $haskell.first$ はリストが保持する型，変数 $haskell.rest$ はリスト型であるとする．演算子 $:$ をLispに倣って#keyword[cons演算子]と呼ぶ．

要素 $haskell.rest$ はリストまたは空リストであるから，一般にリストは次のように展開できることになる．

$ [x_0, x_1, x_2, ..., x_n] &= x_0 : [x_1, x_2, ..., x_n] \
  &= x_0 : x_1 : [x_2, ..., x_n] \
  &= x_0: x_1 : x_2 : ... : x_n : emptyset $

cons演算子 $(:)$ は右結合する．すなわち $x_0 : x_1 : x_2 = x_0 : (x_1 : x_2)$ である．

マップ演算子 $(*)$ の実装は，リストの実装に踏み込めば簡単である．空でないリストは必ず $x : x_"s"$ という形をしているから，次のようにマップ演算子を定義できる．

$ f * emptyset &= emptyset \
  f * (x : x_"s") &= (f x) : (f * x_"s") $

#pb

Haskellでは任意のリスト $x_"s"$ に対し，次の関数が用意されている．
#par-equation($ haskell.head x_"s" &... "先頭要素" \
  haskell.tail x_"s" &... "2番目以降の要素からなるリスト" $)
これらはLispの ```Lisp car``` 関数，```Lisp cdr``` 関数と同じものであり，この二者を用いればどのようなリストの処理も可能である．#footnote[Haskellでは ```haskell head``` 関数の利用は非推奨である．これは ```haskell head []``` と書くとエラーになるからである．]

このように基本的な関数から高機能な関数を実装する方法はよく行われる．この例ではcons演算子からマップ演算子を合成した．

#pb

関数はリストを受け取ることができる．次の書き方では，関数 $f$ は整数リストの最初の要素 $x$ と残りの要素 $x_"s"$ を別々に受け取り，先頭要素だけを返す．#footnote[この関数 $f$ の実装はHaskellの ```haskell head``` 関数と同じである．Haskellでは ```haskell head``` 関数の使用は非推奨となっており，代わりに ```haskell headMaybe``` 関数が推奨されている．]

$ f &colon.double [haskell.Int] -> haskell.Int\
  f (x : x_"s") &= x $<list-head>

ただし，引数のリストが空リストである可能性を考慮して，@list-head は次のように書き直すべきである．
$ f &colon.double [haskell.Int] -> haskell.Int\
  f emptyset &= 0\
  f (x : x_"s") &= x $

$f emptyset$ が $0$ を返すのは不自然だが，関数$f$の戻り型を整数型としているためこれは仕方がない．エラーを考慮する場合は@maybe で述べるMaybeを使う必要がある．

リストの再帰を使うと，クイックソートも簡単に書くことが出来る．クイックソートは次のように定義できる．

$ haskell.quicksort emptyset &= emptyset\
  haskell.quicksort (x : x_"s") 
  &= haskell.quicksort l_"s" smash [x] smash haskell.quicksort r_"s"  \
  & space.nobreak haskell.kwwhere { l_"s" = [l | l in x_"s", l < x ]; r_"s" = [r | r in x_"s", r >= x ] } $

リストを引数にとる関数はいつでも $f (x : x_"s") = ...$ という風にパタンマッチを行えるが，式の右辺でリスト全体すなわち $(x : x_"s")$ を参照したい場合もあるであろう．そのような場合は
#par-equation($ f a_"s" haskell.at (x : x_"s") = ... $)
として，変数 $a_"s"$ でリスト全体を参照することも可能である．このような記法を#keyword[asパタン]と呼ぶ．#footnote[Haskellでは ```haskell f as @ (x : xs) = ...``` と書く．]

なお，関数は再帰させるたびに計算機のスタックメモリを消費する．これを回避するためのテクニックが，次節で述べる末尾再帰である．

=== 末尾再帰

計算機科学者は，同じ再帰でも#keyword[末尾再帰]という再帰のスタイルを好む．末尾再帰とは，関数の再帰適用を関数定義の末尾にすることである．この章に出てきた階乗関数 $haskell.fact$ を例にとろう．階乗関数 $haskell.fact$ は
#par-equation($ haskell.fact x = haskell.kwcase x haskell.kwof cases(0 arrow.r.dotted 1, rect.stroked.h arrow.r.dotted x times haskell.fact(x - 1)) $)
のような形をしていた．末尾の関数をよりはっきりさせるために演算子 $(*)$ を前置にして
#par-equation($ haskell.fact x = haskell.kwcase x haskell.kwof cases(0 arrow.r.dotted 1, rect.stroked.h arrow.r.dotted (times) x space haskell.fact(x - 1)) $)
と書いてみよう．この定義の末尾の式は $(times)x space haskell.fact(x - 1)$ である．これだと末尾の関数は $haskell.fact$ ではなく演算子 $(times)$ なので，末尾に再帰適用を行ったことにはならない．

そこで，次のように形を変えた階乗関数 $haskell.fact'$ を考えてみる．
#par-equation($ haskell.fact' a x = haskell.kwcase x haskell.kwof cases(0 arrow.r.dotted a, rect.stroked.h arrow.r.dotted haskell.fact' (a times x) space (x - 1)) $)
こうすれば末尾の関数がもとの $haskell.fact'$ と一致する．#footnote[Haskellでは ```haskell fact' a x = case x of { 0 -> 1; _ -> fact' (a*x) (x-1) }``` と書く．]

関数 $haskell.fact$ が，例えば
#par-equation($ haskell.fact 3 &= 3 times haskell.fact 2 \
  &= 3 times 2 times haskell.fact 1 \
  &= 3 times 2 times 1 times haskell.fact 0 \
  &= 3 times 2 times 1 times 1 \
  &= 6 $)
と展開されるのに対し，同じく $haskell.fact' space 3$ は
#par-equation($ haskell.fact' space 1 space 3 &= haskell.fact' (1 times 3) space (3 - 1) \
  &= haskell.fact' space 3 space 2 \
  &= haskell.fact' (3 times 2) space (2 - 1) \
  &= haskell.fact' space 6 space 1 \
  &= haskell.fact' (6 times 1) space (1 - 1) \
  &= haskell.fact' space 6 space 0 \
  &= 6 $)
であるから，関数 $haskell.fact$ が「横に伸びる」のに対して，関数 $haskell.fact'$ は「横に伸びない」ことになる．計算式が「横に伸びない」性質は，計算機のリソースを無駄に消耗しないことが期待されるため，計算機科学者が好むのである．また末尾再帰は後述する「末尾再帰最適化」のチャンスをコンパイラに与える．

Haskellを含む幾つかのプログラミング言語処理系は，コンパイル時に#keyword[末尾再帰最適化]を行う．末尾再帰最適化とは，一言で言うと再帰を計算機が扱いやすいループに置き換えることである．では最初から我々もループで関数を表現しておけば，と思われるかもしれないが，再帰以外の方法でループを表現する場合には必ず変数（ループカウンタ）への破壊的代入が必要になるため，我々は末尾再帰に慎ましくループを隠すのである．#footnote[Schemeは末尾再帰最適化を行うことが言語仕様によって決められている．]

=== 余談：遅延評価

Haskellは，意図しない限り遅延評価を行う．これは特に左畳み込み演算子 $union$ を使う場合に問題となる．いま $x_"s" = [x_0, x_1, x_2, x_3]$ とすると，左畳み込み演算 $union_0^+ x_"s"$ は
#par-equation($ haskell.fold_0^+ x_"s" &= union_0^+(x_0 : x_1 : x_2 : emptyset) \
  &= haskell.fold_(0+x_0)^+(x_1 : x_2 : x_3 : emptyset) \
  &= haskell.fold_((0 + x_0) + x_1)^+ (x_2 : x_3 : emptyset) \
  &= haskell.fold_(((0 + x_0) + x_1) + x_2)^+ (x_3 : emptyset) \
  &= haskell.fold_((((0 + x_0) + x_1) + x_2) + x_3) emptyset \
  &= (((0 + x_0) + x_1) + x_2) + x_3 $)
と展開される．遅延評価のために，Haskell処理系は値ではなく式をメモリにストアしなければならないが，左畳み込み演算は大きなメモリを必要としがちである．もし例えば予め $0 + x_0$ を先に計算しておくなど左畳み込みだけ先に評価しておけば，大いにメモリの節約になる．そのためにHaskellは「遅延評価無し」の左畳み込み演算子を用意している．#footnote[「遅延評価無し」の左畳み込み演算子をHaskellでは ```haskell foldl'``` と書く．]

=== この章のまとめ

#tk この章のまとめ

== Maybe
<maybe>

この章では計算結果が正しいかもしれないし，正しくないかもしれないという曖昧な状況を表す型を導入する．手始めにPythonでクラス `Possibly` を実装し，それがカリー風の数式で綺麗に書けることを示す．またリストとの共通点についても見ていくことにする．

=== Possibly

計算は失敗する可能性がある．たとえば
#par-equation($ z = y / x $)
のときに $x = 0$ であったとしたら，この計算は失敗する．プログラムが計算を失敗した場合，たいていのプログラマは大域ジャンプを試みる．しかし大域ジャンプは変数の書き換えを行うことであるから，別の方法が望まれる．Haskellでは失敗する可能性がある場合にはMaybeという機構が使える．

計算の途中で，計算にまつわる状態を残りの計算に引き継ぎたくなる場合がある．例えば，整数 $x, y, z$ があり $z = frac(y, x, style: "skewed")$ なる値を続く計算で利用したいとする．だが $x equiv 0$ のときには $z$ は正しく計算されない．こんなときプログラマが取れる手段はだいたい次のとおりだろう．
- $z = frac(y, x, style: "skewed") $ を計算した時点で#keyword[ゼロ除算例外]を発生させ，プログラムの制御を他の場所へ移す（大域ジャンプを行う）
- グローバル変数にゼロ除算エラーが起こったことを記録しておき，$z$ にはとりあえずの数値，例えば $0$ を代入しておいて，計算を続行させる
- $z$ にエラー状態を示す印を新たにつけておいて，計算を続行させる

大域ジャンプも，グローバル変数の書き換えも破壊的代入を伴うものであり，受け入れがたい．そこで我々は第三のエラー状態を示す印をつける方法を採用することにする．通常，変数が整数だろうが実数だろうが，計算機表現には余分なビットが残っていないので，変数をラップする次のようなクラス `Possibly` を導入することにしよう．メンバ変数 `value` が値を，メンバ変数 `valid` がエラーの有無を表す．

#sourcecode[```python
# Python
class Possibly:
  def __init__(self, a_valid, a_value = 0):
    self.valid = a_valid
    self.value = a_value
```]

例えば整数値 ```python 123``` を持つ ```python Possibly``` クラスの値 ```python p``` は次のように生成できる．

#sourcecode[```python
# Python
p = Possibly(True, 123)
```]

```python Possibly``` 値 ```python p``` が計算エラーを表す場合は次のように初期化出来る．

#sourcecode[```python
# Python
p = Possibly(False)
```]

ここで，引数に ```python 1 ``` を加えて返す関数 ```python f``` があるとしよう．関数 ```python f``` の定義は次の通りである．

#sourcecode[```python
# Python
f = lambda x: 1 + x
```]

関数 ```python f``` に直接 ```python Possibly``` 値 ```python p``` を食わせるとランタイムエラーを引き起こす．

#sourcecode[```python
# Python
q = f(p) # エラー!!
```]

これは関数 ```python f``` が引数として数値を期待していたにもかかわらず ```python Possibly``` クラスの値が渡されたからである．もし関数 ```python f``` のほうをいじりたくないとすれば，次のような関数 ```python map_over``` を使って間接的に関数適用を行う必要がある．

#sourcecode[```python
# Python
q = map_over(f, p)
```]

関数 ```python map_over(f, p)``` はもし ```python p``` がエラーを表す値でなければ中身の値を関数 ```python f``` に適用し，その結果を ```python Possibly``` クラスに包んで返す．もし ```python p``` がエラー値を表す値であれば，結果もエラー値である．関数 ```python map_over``` の実装は次のようになる．

#sourcecode[```python
# Python
def map_over(f, p):
  if p.valid == True:
    return Possibly(True, f(p.value))
  else:
    return Possibly(False)
```]
さて，次節では以上のようなことを抽象数学的に綺麗に描いてみよう．

=== Maybe

もう一度振り出しに戻る．

いま関数 $f$ が引数 $x$ と $y$ を取り，$x != 0$ であるならば $frac(y, x, style: "skewed")$ を返すとする．もし $x!=0$ であれば失敗を意味する $haskell.Nothing$ （ナッシング）を返すとする．すると関数 $f$ の定義は次のようになる．
#par-equation($ f x y = haskell.kwif x != 0 haskell.kwthen frac(y, x, style: "skewed") haskell.kwelse haskell.Nothing ... "不完全な定義" $)
残念ながら上式は不完全である．なぜならば $x != 0$ のときの戻り値は数であるのに対して， $x != 0$ のときの戻り値は数ではないからである．そこで
#par-equation($ f x y = haskell.kwif x != 0 haskell.kwthen haskell.Just((frac(y, x, style: "horizontal"))) haskell.kwelse haskell.Nothing $)
とする．ここに $haskell.Just((frac(y, x, style: "horizontal")))$ は数 $frac(y, x, style: "skewed")$ から作られる，Maybeで包まれた数である．#footnote[Haskell では `f x y = if x /= 0 then Just y / x else Nothing` と書く．]

この関数 $f$ の戻り値はもはや整数 $(haskell.Int)$ 型とは言えない．そこでこの型を $haskell.MaybeType(haskell.Int)$ と表して「Maybe整数（おそらく整数）」型と呼ぶことにする．型 $haskell.a$ から型 $haskell.MaybeType(haskell.a)$ を生成するとき，$haskell.Maybe$ を#keyword[型コンストラクタ]と呼ぶ．#footnote[Haskellでは ```haskell Maybe a``` と書く．]

Maybeで包まれた型を持つ変数は $z_?$ のように小さく $?$ をつける．例を挙げる．#footnote[Haskellでは ```haskell xm :: Maybe Int = Just 1``` と書く．]

$ z_? colon.double haskell.MaybeType(haskell.Int) = haskell.Just(1) $

Maybe変数が値を持たない場合は $x_? = haskell.Nothing$ のように書く．#footnote[Haskellでは ```haskell xm = Nothing``` と書く．]

// []に入れるという方法もある．

ここで変数 $z_?$ が取り得る値は正しく計算された値をラップしたものか，あるいはエラーを表す値 $haskell.Nothing$ である．このように計算結果に「意味付け」をすることを#keyword[文脈]に入れると言う．

一度Maybeになった変数を非Maybeに戻すことは出来ない．変数 $z$ が一度ゼロ除算の危険性に「汚染」された場合，その後ずっとMaybe変数に入れ続けなければいけない．そこで，普通の変数を引数にとる関数 $f$ にMaybe変数 $z_?$ を食わせるには，リストの時と同じようなマップ演算子が必要になる．具体的には，変数 $x$ が $haskell.Int$ 型として，Maybe変数 $w_?=haskell.Just(x)$ が与えられたとき
#par-equation($ f convolve.o_? w_? = haskell.Just(f x) $)
となるようなMaybeバージョンのマップ演算子 $convolve.o_?$ を用いる．ここに $f convolve.o_? w_?$ の型は，もし $f colon.double haskell.Int -> haskell.Float$ ならば $haskell.MaybeType(haskell.Float)$ である．#footnote[Haskellでは $f convolve.o_? w_?$ を ```haskell f <$> w``` と書く．]

実際には $w_? equiv haskell.Nothing$ の可能性も考えなければならないから，Maybeバージョンのマップ演算子は
#par-equation($ f convolve.o_? w_? = haskell.kwcase w_? haskell.kwof
  cases(haskell.Just(x) arrow.r.dotted haskell.Just(f x),
    rect.stroked.h arrow.r.dotted haskell.Nothing) $)
でなければならない．このMaybeバージョンのマップ演算子 $convolve.o_?$ は
#par-equation($ f convolve.o_? haskell.Just(x) &= haskell.Just(f x) \
  f convolve.o_? haskell.Nothing &= haskell.Nothing $)
と定義すれば得られる．#footnote[Haskellでは ```haskell f <$> Just x  = Just (f x); f <$> Nothing = Nothing``` と書く．]

今後，普通の（引数にMaybeが来ることを想定していない）関数 $f$ をMaybe型である変数 $w_?$ に適用させるときには，必ず
#par-equation($ w_? = f convolve.o_? w_? $)
のようにMaybeバージョンのマップ演算子 $convolve.o_?$ を用いることにする．これはプログラムの安全性のためである．変数が一旦ゼロ除算の可能性に汚染されたら，最後までMaybeに包んでおかねばならない．

PythonでMaybeの概念を忠実になぞることは難しい．と言うのもPythonは動的型付け言語であるため，型コンストラクタという概念が無いからだ．一方でMaybeの概念を静的型付け言語であるC++やJavaで実現することはできる．そこでC++の本物のコードで示しておこう．ただしポインタを使わないでおいたのでC++プログラマもJavaプログラマも参考にできるだろう．#footnote[C++17にはまさにこの目的のための標準テンプレート ```cpp template <typename T> std::optional<T>``` がある．]

Maybeは次の ```cpp maybe``` クラステンプレートで表現できる．（Javaプログラマへの注意：これは ```java maybe<a>``` クラスの定義と同じ意味である．）

#sourcecode[```cpp
// C++
template <typename a> class maybe {
  private:
    a value;
    bool valid;
  public:
    maybe(): value(0), valid(false) { }  // デフォルトコンストラクタ
    maybe(a a_value): value(a_value), valid(true) { }
    a get_value() const { return value; }
    bool is_valid() const { return valid; }
};
```]

デフォルトコンストラクタ ```cpp maybe()``` は例外的な状況を表す $haskell.Nothing$ を生成し，1引数コンストラクタ ```cpp maybe(a)``` は ```cpp maybe<a>``` で包んだ引数値を生成する．#footnote[このC++コードは，型 ```cpp a``` が ```cpp 0``` を持てることを前提に書かれているため，HaskellのMaybeとは厳密には異なる．]

当然我々にはMaybeバージョンのマップ演算子が必要である．ここでは関数 ```cpp map_over``` として書いてみよう．（Javaプログラマへの注意：関数 ```java map_over``` はどのクラスにも属していないが，それで正解なのである．）

#sourcecode[```cpp
// C++
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
テンプレートの3番目の引数 ```cpp fn``` は関数 ```cpp f``` を受け取るために必要である．C++はコンパイル時までにすべての変数の型が決定していないといけないが，関数 ```cpp f``` の型は関数 ```cpp map_over``` 設計時には確定できないため，このようにテンプレートにしている．

整数 $x$ からMaybe値 $u_? = haskell.Just(x)$ を作り，関数 $g x = 1 + x$ をMaybe値 $u_?$ に食わせてMaybe値 $v_?$ ただし $v_? = g convolve.o_? u_?$ を得ることをC++では次のように書くことになる．
#sourcecode[```cpp
// C++
int x = 123;
maybe<int> u(x);
auto g = [](int x) -> int { return 1 + x; };
maybe<int> v = map_over(g, u);
```]
注意してほしいのは ```cpp g(x)``` も ```cpp map_over(g, u)``` も正当なコードだが ```cpp g(u)``` は型エラーであることだ．また ```cpp g(u.get_value())``` は正当なコードだが，わざわざ ```cpp u``` が持つ文脈を捨てることになる．

#pb

リストがMaybeの中に入っている場合は，リストの各要素に関数を適用することができる．例を挙げる．

$x_? = haskell.Just([1,2...100])$ のとき，リストの各要素に関数 $f colon.double haskell.Int -> haskell.Int$ を適用するには次のように書く．#footnote[Haskellでは ```haskell zm = (f <$>) <$> xm``` と書く．最初の ```haskell <$>``` はリストの各要素に関数 ```haskell f``` を適用する演算子，2番目の ```haskell <$>``` はMaybeの中のリストの各要素に関数 ```haskell f``` を適用する演算子である．]

$ z_? = (f *) convolve.o_? x_? $

=== リストとMaybe

関数 $f$ をMayby値 $u_?$ に適用するために
#par-equation($ v_? = f convolve.o_? u_? $)
のようなMaybeバージョンのマップ演算子 $(convolve.o_?)$ を使った．一方で，同じ関数 $f$ をリスト $x_"s"$ に適用するには
#par-equation($ y_"s" = f * x_"s" $)
のようなリストバージョンのマップ演算子 $(*)$ を使った．

リストバージョンのマップ演算子 $(*)$ をもしC++で書くとしたら，次のようなコードになる．ここでリスト型としてC++の標準テンプレートライブラリ（STL）の ```cpp std::list``` クラスを流用した．

#sourcecode[```cpp
// C++
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

この関数 ```cpp map_over``` の中身部分はどうでもよろしい．それよりも，リストバージョンのマップ演算子のC++関数のインタフェースと，Maybeバージョンのマップ演算子のC++関数のインタフェースを見比べてみよう．

#sourcecode[```cpp
// C++
// リスト
template <class a, class b, class fn>
std::list<b> map_over(fn f, std::list<a> xs);
// Maybe
template <class a, class b, class fn>
maybe<b> map_over(fn f, maybe<a> w);
```]

やはりそっくりである．であるならば，うまく統一したい．C++では次のような書き方が文法的には可能である．

#sourcecode[```cpp
// C++
template <class a, class b, template<class> X, class fn>
X<b> map_over(fn f, X<a> x);
```]

これは一見上手く行きそうに見えるが，このコードは ```cpp map_over``` のインスタンス化で躓くため，次のように ```cpp b``` 型のダミー変数が必要になる．

#sourcecode[```cpp
// C++
template <class a, class b, template<class> X, class fn>
X<b> map_over(fn f, X<a> x, b dummy);
```]

残念なことに，いずれのコードにしてもリストとMaybeの本質的な抽象化にはなってない．型 ```cpp X``` がマップ可能なコンテナであることをテンプレート機構を使って保証することができないためである．この問題はC++26で導入予定の「コンセプト」機能によって解決する見込みである．

一方で，数学者たちが見つけた圏という代数的構造が，リストもMaybeも統一的に扱うことを可能にしている．これを発見したのは Eugenio Moggi を始めとする計算機科学者たちである．この人類の英知は@functor から見ていくことにしよう．

=== 余談: Either

Maybeとよく似た型にEitherがある．Maybeが $haskell.a$ 型または $haskell.Nothing$ のいずれかの値をとったように，Eitherは $haskell.a$ 型または $haskell.b$ 型のいずれかの値を取る．$haskell.a$ 型または $haskell.b$ 型を取るEither型の変数 $e_!$ があるとすると，
$ e_! colon.double haskell.EitherType(haskell.a, haskell.b) $
と書く．Either型の生成は型 $haskell.a$ および $haskell.b$ から型コンストラクタを用いて $haskell.EitherType(haskell.a, haskell.b)$ と書く．#footnote[Haskellでは ```haskell Either a b``` と書く．]

Eitherには値コンストラクタが2種類あり，それぞれ $haskell.Right(x)$ と $haskell.Left(x)$ である．値コンストラクタは
#par-equation($ e_! = haskell.Right(x) $)
または
#par-equation($ e_! = haskell.Left(x) $)
のように使う．#footnote[Haskellではそれぞれ ```haskell e = Right x``` および ```haskell e = Left x``` と書く．]

Eitherはより複雑な計算エラーが発生する場合に用いる．Maybeが単に失敗を表す $haskell.Nothing$ しか表現できなかったのに対し，Eitherは任意の型の変数で表現できる．習慣的に，正しい(right) 計算結果は $haskell.Right(x)$ 値コンストラクタで格納し，残された (left) エラーの情報は $haskell.Left(x)$ 値コンストラクタで格納する．

Either型はCの共有型 (```c union```) やC++のバリアント型 (```cpp std::variant```) に近い．

=== この章のまとめ

#tk この章のまとめ

== 関手
<functor>

#tk 関手

=== リストの世界・Maybeの世界

$haskell.a$ 型の変数 $x, y colon.double haskell.a$ について，関数 $f colon.double haskell.a -> haskell.a$ があり
#par-equation($ y = f x $)
であるとしよう．このように型 $haskell.a$ で閉じた世界を仮に $haskell.a$ 世界と呼ぶことにする．この世界では，関数 $f$ は値 $x$ を値 $y$ に変換する．

同様に $haskell.MaybeType(haskell.a)$ 型の変数 $u_?, v_? colon.double haskell.MaybeType(haskell.a)$ について，関数 $phi colon.double haskell.MaybeType(haskell.a) -> haskell.MaybeType(haskell.a)$ があり
#par-equation($ v_? = phi u_? $)
であるとしよう．このように型 $haskell.MaybeType(haskell.a)$ で閉じた世界を仮に $haskell.MaybeType(haskell.a)$ 世界と呼ぶことにする．この世界では，関数 $phi$ は値 $u_?$ を値 $v_?$ に変換する．

ここで，変数 $x, y$ とMaybe変数 $u_?, v_?$ は値コンストラクタによって
#par-equation($ u_? &= haskell.Just(x) \
  v_? &= haskell.Just(y) $)
の関係にあるとしよう．値コンストラクタは値を $haskell.a$ 世界から $haskell.MaybeType(haskell.a)$ 世界へとジャンプさせる機能を持っている．

他に $haskell.a$ 世界から $haskell.MaybeType(haskell.a)$ 世界へとジャンプさせるものがあるだろうか．よく考えてみると，マップ演算子もそうである．いま $u_? = haskell.Just(x), v_? = haskell.Just(y)$ なのだから，$haskell.a$ 世界の関数 $f$ と $haskell.MaybeType(haskell.a)$ 世界の関数 $phi$ は無関係ではなく
#par-equation($ v_? = phi u_? = f convolve.o_? u_? $)
であり，
#par-equation($ phi = f convolve.o_? $)
である．つまりマップ演算子 $convolve.o_?$ が関数 $f$ を $haskell.a$ 世界から $haskell.MaybeType(haskell.a)$ 世界へとジャンプさせているのである．ジャンプを次の表で波矢印 $(~~>)$ で表した．

#table(
  columns: (auto, auto, auto, auto, auto),
  inset: 10pt,
  table.header([世界（圏）], [値（対象）], [写像（射）], [値のジャンプ], [関数のジャンプ]),
  [$haskell.a$ 世界], $x, y$, $y = f x$, [], [],
  [$haskell.MaybeType(haskell.a)$ 世界], $u_?, v_?$, $v_? = phi u_?$, $x ~~> u_?, y ~~> v_?$, $f ~~> phi$,
)

いま「世界」と呼んだものを，数学者は#keyword[圏]と呼ぶ．圏とは#keyword[対象]と#keyword[射]の組み合わせである．本書では「対象」とは変数のことであり，射とは関数だと思えば良い．そして，圏から圏へとジャンプさせるもの $(~~>)$ を#keyword[関手]と呼ぶ．この例で言えば値コンストラク $haskell.Just(x)$ とマップ演算子 $convolve.o_?$ が関手である．値コンストラクタ $haskell.Just(x)$ は $haskell.a -> haskell.MaybeType(haskell.a)$ という型を持ち，マップ演算子 $convolve.o_?$ は $(haskell.a -> haskell.b) -> (haskell.MaybeType(haskell.a) -> haskell.MaybeType(haskell.b))$ という型を持つ．#footnote[関手は英語でファンクター(functor)と言うが，C++の関数オブジェクト （function object）もかつてはファンクター（functor）と呼ばれていた．C++のファンクターとはクロージャの代用品のことで，本書で述べる関手とは異なる概念である．混同しないように注意しよう．]

#pb

Haskellではマップ演算子が定義された型を関手型と呼ぶ．具体的には，マップ演算子が定義されたすべての型は $haskell.Functor$ 型クラスのインスタンスであるとする．つまり $haskell.Functor$ 型クラスには一般化されたマップ演算子が定義されており，そのインスタンスであるリストやMaybeは独自のマップ演算子を定義しなければならないということである．

一般化されたマップ演算子を $convolve.o$ で表そう．この $convolve.o$ 演算子は
#par-equation($ (convolve.o) colon.double haskell.Functor supset haskell.f arrow.r.stroked haskell.f_haskell.a -> haskell.f_haskell.b $)
という型を持つ．ここに $haskell.Functor supset haskell.f$ は，$haskell.f$ が $haskell.Functor$ 型クラスに属すという制約を表している．また $haskell.f$ は型コンストラクタであり，$haskell.f_haskell.a$ は $haskell.f$ 型コンストラクタと$haskell.a$ 型によって作られたコンテナ型である．

もし型コンストラクタがリスト型コンストラクタであれば，つまり $haskell.f = []$ であれば
#par-equation($ (convolve.o) colon.double (haskell.a -> haskell.b) -> [haskell.a] -> [haskell.b] = * $)
であるし，もし型コンストラクタがMaybe型コンストラクタであれば，つまり $haskell.f = haskell.Maybe$ であれば
#par-equation($ (convolve.o) colon.double (haskell.a -> haskell.b) -> haskell.MaybeType(haskell.a) -> haskell.MaybeType(haskell.b) = convolve.o_? $)
である．

#table(
  columns: (auto, auto, auto, auto),
  inset: 10pt,
  table.header([型], [型コンストラクタ], [マップ演算子], [変数の具体例]),
  $[haskell.a]$, $[]$, $*$, $[x]$,
  $haskell.MaybeType(haskell.a)$, $haskell.Maybe$, $convolve.o_?$, $haskell.Just(x)$,
  $haskell.Functor supset haskell.f arrow.r.stroked haskell.f_haskell.a$, $haskell.f$, $convolve.o$, [具体的な型による]
)

リストとMaybeは両者ともマップ演算子（と値コンストラクタ）を持つ．両者の関係をまとてみたのが表〜〜〜である．オブジェクト指向プログラマなら，リストとMaybeに共通のスーパークラスを設計したくなるであろう．それが型クラス $haskell.Functor$ である．

#pb

別の言い方をすると，我々はオブジェクト指向プログラミングよりもエレガントな方法で，リストとMaybeの共通項をくくりだすことにする．いよいよ型クラスの出番である．

リスト型 $[haskell.a]$ もMaybe型 $haskell.MaybeType(haskell.a)$ も $haskell.Functor$ 型クラスに属すのであった．そこで $haskell.Functor$ 型クラスは#keyword[一般マップ演算子] $(convolve.o)$ を持つものとする．

一般マップ演算子 $(convolve.o)$ は#keyword[多様的]である．この意味は，もし $f convolve.o x_"s"$ と書いてあれば $f * x_"s"$ のことであるし，もし $f convolve.o x_?$ と書いてあれば $f convolve.o_? x_?$ のことであると自動的に解釈することである．そして，何の飾りもつけられていない変数 $x$ がふらっと現れ，目の前に $f convolve.o x$ という式が登場しても，落ち着いて変数 $x$ の型を調べ，変数 $x$ がリストならば $convolve.o$ の部分に $*$ を，変数 $x$ がMaybeならば $convolve.o$ の部分に $convolve.o_?$ をはめ込むのだ．#footnote[Haskellでは一般マップ演算子 $(convolve.o)$ は ```haskell fmap``` である．ただしその実装は与えられず，対象とする型に応じて定義されるものとする．例えばリストに対しては ```haskell fmap = map``` と定義されている．]

#pb

型 $haskell.a$ のリストの変数は $x_"s" colon.double [haskell.a]$ という型注釈を持つ．これは $x_"s" colon.double haskell.typeconstructor1([], haskell.a)$ のシンタックスシュガーである．#footnote[Haskellでは `xs :: [] a` と書く．]

型 $haskell.a$ のMaybeの変数は $x_* colon.double haskell.MaybeType(haskell.a)$ という型注釈を持つ．

普段遣いの関数 $f colon.double haskell.a -> haskell.a$ をリスト変数 $x_"s" colon.double [haskell.a]$ に適用する場合は次のように書く．#footnote[Haskellでは `zs = f `map` xs` と書く．]

$ z_"s" = f * x_"s" $

同じく関数 $f colon.double haskell.a -> haskell.a$ をMaybe変数 $x_* colon.double haskell.MaybeType(haskell.a)$ に適用する場合は次のように書く．

$ z_? = f convolve.o_? x_? $

リストもMaybeも元の型 $haskell.a$ から派生しており，関数適用のための特別な演算子を持つことになる．そこで，リストやMaybeは#keyword[関手]という型クラスに属する，型パラメタを伴う型であるとする．関手の型クラスを $haskell.Functor$ で表す．関手型クラスの $haskell.a$ 型の変数を次のように型注釈する．#footnote[Haskellでは `xm :: Functor f => f a` と書く．]
$ x_* colon.double haskell.Functor supset haskell.f arrow.r.stroked haskell.typeconstructor1(haskell.f, haskell.a) $

型 $haskell.typeconstructor1([], haskell.a)$ や型 $haskell.MaybeType(haskell.a)$ は型 $haskell.a$ のところに $haskell.Int$ や $haskell.Double$ を代入すると具体的な型となる抽象的な型であった．今度は $[]$ や $haskell.Maybe$ のほうも $haskell.f$ と抽象化するのである．この $haskell.f$ は#keyword[型コンストラクタ]と呼ぶ．型コンストラクタには，具体的な引数，例えば $haskell.Int$ や $haskell.Double$ を与えると具体的な型になる．

型クラス $haskell.Functor$ に属する型は $convolve.o$ 演算子を必ず持つ．演算子 $convolve.o$ は次の形を持つ．#footnote[Haskellでは `zm = f <$> xm` と書く．]
$ z_* = f convolve.o x_* $

演算子 $convolve.o$ の型は次のとおりである．
#par-equation($ (convolve.o) colon.double haskell.Functor supset haskell.f
  arrow.r.stroked (haskell.a -> haskell.b)
  -> haskell.fa
  -> haskell.fb $)
もし変数 $x_*$ の型がリストであれば $convolve.o = *$ であると解釈する．

=== 関手則

関手すなわち $haskell.Functor$ 型クラスに求められるのは，マップ演算子 $(convolve.o)$ を持つことだけではない．関手のマップ演算子は，次のふたつの規則を満たす必要がある．

#theorem-box(title: "恒等射の存在", outlined: false)[
関手は恒等射 $(id convolve.o)$ ただし $id convolve.o x_* = x_*$ を持つ．
]

#theorem-box(title: "結合則", outlined: false)[
マップ演算子 $(convolve.o)$ は結合則 $(g compose f) convolve.o x_* = (g convolve.o) compose (f convolve.o) x_*$ を満たす．
]

このふたつをまとめて#keyword[関手則]と呼ぶ．

まず関数 $id$ を定義しておくと，これは引数をそのまま返す関数で
#par-equation($ id x = x $)
である．引数 $x$ は変数でも関数でも良いので，ラムダ式を使って
#par-equation($ id &= lozenge.stroked.medium \
  &= backslash x |-> x $)
と書いたほうがわかり良いかもしれない．

恒等射の存在 $id convolve.o x_* = x_*$ とは $id convolve.o x_* = id x_*$ ということであるから，両辺の $x_*$ を削除して
#par-equation($ id convolve.o = id $)
となる．一言で言うと，関数 $id convolve.o$ は関数 $id$ と同じで，引数をそのまま返す．この法則は任意の型クラス $haskell.f$ について $haskell.Functor supset haskell.f$ であるならば，任意の型 $haskell.f_haskell.a$ に対して $(id convolve.o) colon.double $...

#tk 関手則の説明



=== アプリカティブ関手

#tk アプリカティブ関手

マップ演算子をさらに汎用性のあるものにするために新しく考え出された演算子が#keyword[アプリカティブマップ演算子]である．

#tk

$ [f, g, h] ast.square [x, y, z] = [f x, f y, f z, g x, g y, g z, h x, h y, h z] $

リストのアプリカティブマップ演算子 $ast.square$ の型は
$ [haskell.a  -> haskell.b] -> [haskell.a] -> [haskell.b]$ である．

これは
$ ast.square colon.double underbrace([haskell.a -> haskell.b], [f, g, h]) -> underbrace([haskell.a], [x_0, x_1, ...]) -> underbrace([haskell.b], [f x_0, f x_1, ...]) $
と解釈すれば良い．

リストバージョンのアプリカティブマップ演算子 $(ast.square)$ の特別な場合として，左引数のリストの要素数が1の場合を考えると
$ [f] ast.square [x, y, z] = [f x, f y, f z] $
であり，通常のマップ演算子 $(*)$ を使ったマップすなわち
$ [f] * [x, y, z] = [f x, f y, f z] $
と右辺が一致する．つまり，マップ演算子はアプリカティブマップ演算子の特別な場合と考えることができる．実際，リストマップ演算子はアプリカティブマップ演算子から
$ f * x_"s" = [f] ast.square x_"s" $
と定義できる．

Maybeバージョンについても考えてみよう．Maybeに包まれた関数 $f_?$ をMaybeな変数 $x_?$ にマップするアプリカティブマップ演算子 $ast.square_?$ を
$ f_? ast.square x_? = haskell.kwcase x_"s" haskell.kwof 
  cases(haskell.Just(x) arrow.r.dotted x convolve.o_? x_?,
  rect.stroked.h arrow.r.dotted haskell.Nothing) $
で定義する．このMaybeバージョンのアプリカティブマップ演算子 $(ast.square_?)$ からMaybeバージョンのマップ演算子 $(convolve.o_?)$ は
$ f convolve.o_? x_? = haskell.Just(f) ast.square_? x_? $
のように導出できる．

これらの関係を一般化して
$ f ast.square x_* = chevron.l f chevron.r convolve.o x_* $
となるような#keyword[一般アプリカティブマップ演算子] $(ast.square)$ を考える．ここに $f$ は関数，$x_*$ はリストやMaybeといったコンテナ型の変数すなわち#keyword[コンテナ変数]である．一般アプリカティブマップ演算子 $(ast.square)$ から一般マップ演算子 $(*)$ を導き出すには，式〜〜〜のように値コンストラクタが必要である．この一般化された値コンストラクタを#keyword[ピュア演算子]と呼ぶ．アプリカティブマップ演算子とピュア演算子を持つ型クラスを#keyword[アプリカティブ関手]と呼び，$haskell.Applicative$ 型クラスと定義する．#footnote[Haskellでは一般アプリカティブマップ演算子を ```haskell <*>``` と書く．]

ピュア演算子をピュア値コンストラクタと呼ばないのは，単純に「ピュア値」というものがないからである．$haskell.Functor$ 型クラスはリスト型やMaybe型を抽象化したものであって，直接変数を生成できない．型クラスは，C++の用語で言えば純粋仮想クラスのようなものであるし，Objective-Cの用語で言えばメタクラスであるからである．もちろんリストのピュア演算子は $[x]$ であるし，Maybeのピュア演算子は $haskell.Maybe_x$ であり，それぞれ具体的な変数を生成する．しかし変数 $x$ にピュア演算子を適用した $chevron.l x chevron.r$ は抽象的な概念であり，そのような変数は実在しない．#footnote[Haskellは一般のピュア演算子の実装を与えていない．変数の型に応じて対応する関数が適用される．]

一般アプリカティブマップ演算子 $(ast.square)$ は多様性によってそれぞれリストバージョンのアプリカティブマップ演算子 $(...)$ やMaybeバージョンのアプリカティブマップ演算子 $(ast.square_?)$ にオーバーライドされ，それぞれリスト値コンストラクタ $([x])$, Maybe値コンストラクタ $(haskell.Maybe_x)$ を用いることでリストバージョンのマップ演算子 $(*)$, Maybeバージョンのマップ演算子 $(convolve.o_?)$ を生成することができる．リスト値コンストラクタ，Maybe値コンストラクタはそれぞれピュア演算子 $chevron.l x chevron.r$ をオーバーライドしたものであるから，結局，一般アプリカティブマップ演算子とピュア演算子のふたつがあれば，任意のクラスのマップ演算子を生成することができる．

アプリカティブマップ演算子，ピュア演算子に一般化されたバージョンがあるように，リストの $emptyset$ やMaybeの $haskell.Nothing$ を一般化した値が必要である．それを $nothing.rev$ とする．$nothing.rev$ には特段名前が無いので，本書では単に「空」と呼ぶことにしよう．

この節の最後に#keyword[アプリカティブスタイル]という記法を紹介しておこう．アプリカティブマップ演算子は連続して
$ chevron.l f chevron.r ast.square x_* ast.square y_* $
このようにアプリカティブマップ演算子を並べる書き方をアプリカティブスタイルと呼ぶ．

#tk マージ


演算子 $convolve.o$ は関手型クラスの型の値に1引数関数を適用することを可能にした．一方で2引数関数を適用するのは若干面倒である．いま関数 $f$ が2引数をとるとし，関手型クラスの型の変数 $x_*$ と $y_*$ があるとする．関数 $f$ に変数 $x_*$ を部分適用して関数 $f' = f convolve.o x_*$ を作ると，定義によって関数 $f'$ は関手型クラスの型の変数になる．そこで，関手型クラスの型の関数を関手型クラスの型の変数に適用する新しい演算子が必要になる．このような演算子を#keyword[アプリカティブマップ演算子]と呼び $haskell.amap$ で表す．アプリカティブマップ演算子を用いると2引数の関数適用は次のように書ける．
$ z_* &= f' haskell.amap y_* \
  &= f convolve.o x_* haskell.amap y_* $<fmap-and-amap>

任意の変数または関数を関手型クラスの型に入れる#keyword[ピュア演算子]があり，次のように書く．#footnote[Haskellでは `z = pure x` と書く．]
$ z_* = chevron.l x chevron.r $

なおピュア演算子の名称は「純粋(pure)」であるが，意味合いはむしろ「不純(impure)」のほうが近い．

ピュア演算子を用いると，@fmap-and-amap は次のように書ける．#footnote[Haskell では `zm = (pure f) <*> xm <*> ym` と書く．]

$ z_* = chevron.l f chevron.r haskell.amap x_* haskell.amap y_* $<applicative-style>


@applicative-style はかつて次のように書くことが提案されたが，却下された．#footnote[現在のHaskellでは `z = liftA2 f x y` と書くことで代用されている．元の提案は `z = [|f x y|]` であった．]
$ z_* = [| f x_* y_* |] ... "採用されなかった文法" $

ピュア演算子とアプリカティブマップ演算子を必ず持つ関手のことを#keyword[アプリカティブ関手]と呼び $haskell.Applicative$ で表す．

いま関数 $f colon.double haskell.a -> haskell.b$ に対して，新たな関数 $f_*$ ただし $f_* = chevron.l f chevron.r $ を作ったとすると，関数 $f_*$ は次の型を持つ．
$ f_* colon.double haskell.Applicative supset haskell.f
  arrow.r.stroked haskell.f_(haskell.a -> haskell.b) $

アプリカティブマップ演算子は変数 $x_* colon.double haskell.Applicative supset haskell.f arrow.r.stroked haskell.f_haskell.a $ に対して，関数 $f_*$ を $z_* = f_* haskell.amap x_*$ のように作用させる．変数 $z_*$ の型は $z_* colon.double haskell.Applicative supset haskell.f arrow.r.stroked haskell.f_haskell.b$ である．

#tk マージ


#theorem-box(title: "恒等射の存在", outlined: false)[
アプリカティブ関手は恒等射 $id$ ただし $chevron.l id chevron.r haskell.amap x_* = x_*$ を持つ．
]

#theorem-box(title: "Homomorphism", outlined: false)[
$chevron.l f chevron.r haskell.amap chevron.l x chevron.r = chevron.l f x chevron.r$
]

#theorem-box(title: "Interchange", outlined: false)[
$chevron.l f chevron.r haskell.amap chevron.l x chevron.r = chevron.l lozenge.stroked.medium dollar x chevron.r haskell.amap f$
]

#theorem-box(title: "Composition", outlined: false)[
$h_* haskell.amap (g_* haskell.amap f_*) = chevron.l lozenge.stroked.medium compose lozenge.stroked.medium chevron.r haskell.amap h_* haskell.amap g_* haskell.amap f_*$
]


=== 余談：関数と関手

#tk 関数と関手

Function laws.

$ f compose id &= id compose f = f \
  (h compose g) compose f &= h compose (g compose f) $

Functor laws.

$ id convolve.o &= id \
  (g compose f) convolve.o &= (g convolve.o) compose (f convolve.o) $

#tk リライト


関数は関手である．関手とはマップ演算子を持つ型クラスのことであった．そこで，関数がどのようなマップ演算子を持つのか考えてみる．

いま関数 $f$ が $f colon.double haskell.r -> haskell.q$ という型を持っているとする．この式は $->$ を二項演算子，すなわち2引数関数とみなせば $f colon.double (->)haskell.r haskell.q$ と等価である．全く形式的に，$((->)haskell.r)$ なる型コンストラクタがあるとして
$ haskell.r -> haskell.q = ((->)haskell.r)_haskell.q $
であると考えてみる．型 $haskell.q$ から型コンストラクタ $((->)haskell.r)$ によって型 $(haskell.r -> haskell.q)$ が作られると考えるのだ．#footnote[Haskellでは $((->)haskell.r)$ を ```haskell ((->)r)``` と書く．]

マップ演算子の型．

関数のマップ演算子 $(convolve.o_(((->)haskell.r)))$ と関数の合成演算子 $(compose)$ は同じ型を持つ．

幸い，我々は関数のマップ演算子の実装に関しては，型さえ守っていれば（そして第〜〜〜章で述べる#keyword[関手則]さえ守っていれば）自由に選べる．そこで
$ convolve.o_(((->)haskell.r)) = compose $
としておこう．これがHaskellにおける関数のマップ演算子の定義である．

#pb

関数はアプリカティブ関手でもある．アプリカティブ関手には，アプリカティブマップ演算子とピュア演算子が定義されるのであった．そこで，関数版のアプリカティブマップ演算子を $ast.square_(((->)haskell.r))$ とし，関数版のピュア演算子を $chevron.l x chevron.r_(((->)haskell.r))$ と書くことにしよう．

ピュア演算子は $haskell.q -> (haskell.r -> haskell.q)$ 型を持たなければならない．従って関数版のピュア演算子は変数から関数を作るとも考えられる．我々は関数版のピュア演算子として
$ chevron.l x chevron.r_(((->)haskell.r)) = backslash rect.stroked.h |-> x $
を採用する．#footnote[Haskellでは $chevron.l x chevron.r_(((->)haskell.r))$ を ```haskell const x``` と書く．]

関数版のアプリカティブマップ演算子を $ast.square_(((->)haskell.r))$ とすると，その型は
$ ast.square_(((->)haskell.r)) colon.double ((->)haskell.r)_(haskell.a -> haskell.b) -> ((->)haskell.r)_haskell.a -> ((->)haskell.r)_haskell.b $
つまり
$ ast.square_(((->)haskell.r)) = (haskell.r -> haskell.a -> haskell.b) -> (haskell.r -> haskell.a) -> (haskell.r -> haskell.b) $
である．

我々は関数版アプリカティブマップ演算子として
$ g ast.square_(((->)haskell.r)) f = backslash x |-> g x (f x) $
とする．これは，関数版のピュア演算子の定義と，一般マップ演算子と一般アプリカティブマップ演算子の関係 $f convolve.o x_* = chevron.l f chevron.r ast.square x_*$ から導かれる．すなわち
$ chevron.l g chevron.r ast.square f &= backslash x |-> chevron.l g chevron.r x (f x) \
  &= backslash x |-> (backslash rect.stroked.h |-> g) x (f x) \
  &= backslash x |-> g (f x) \
  &= g compose f $
であるからである．

#tk マージ

$ f colon.double haskell.r -> haskell.q $

$ f colon.double chevron.l haskell.r -> lozenge.filled.medium chevron.r_haskell.q $

$ f colon.double chevron.l (->) haskell.r lozenge.filled.medium chevron.r_haskell.q $

```haskell
f :: ((->) r) q
```

$ f_2 compose f_1 = f_2 convolve.o f_1 $

$ id compose f = id compose f = f \
  (h compose g) compose f = h compose (g compose f) $


=== この章のまとめ

#tk この章のまとめ．

== モナド
<monad>

=== バインド演算子

#tk バインド演算子

一般マップ演算子をピュア演算子と一般アプリカティブマップ演算子に分解することで，式の見通しを良くすることができるアプリカティブスタイルという記法を採用できた．アプリカティブスタイルでは
$ f convolve.o x_* ast.square y_* ast.square z_* $
という風にコンテナ変数 $x_*, y_*, z_*$ に関数 $f$ を適用させることができる．コンテナ変数 $x_*, y_*, z_*$ のいずれかが $nothing.rev$ であれば式全体の値が $nothing.rev$ になる．これは3個の計算を並列に行って，その結果をそれぞれ $x'_*, y'_*, z'_*$ に入れておき，最後に関数 $f$ に投げるという#keyword[計算構造]を具現化したものである．（関数 $f$ はCで言えば `main` 関数に相当するであろう．）

しかしながら，アプリカティブスタイルでは変数に文脈を与えるタイミングがコンテナ変数を作るときのそれぞれ1回に限られている．そこで，任意のタイミングで変数に文脈を与えられるように，別な方法で一般マップ演算子を分解してみよう．

Maybeの例を思い出そう．Maybe型の変数 $x_?$ はラップされた値 $haskell.Just(x)$ を持つのか，エラーを表す $haskell.Nothing$ を持つのかを選べる．そこで，引数 $x$ をとり何らかの計算をする関数 $phi$ を考えよう．この関数 $phi$ は引数 $x$ の値次第ではエラーを表す $haskell.Nothing$ を返す．例えば
$ g x &|_(x != 0) = haskell.Just(x) \
  &|_haskell.otherwise = haskell.Nothing $
といった関数が考えられる．変数 $x$ は文脈を持っていないが，関数 $phi$ を適用した結果である $phi x$ は文脈を持っていることに注意しよう．いま $phi x$ はMaybeという文脈を持っているから，我々は
$ z_? = phi x $
という風に結果をMaybe変数に保存しなければならない．今まで見てきた $y = f x$ や $y_* = f convolve.o x_*$ の関係とは異なることに注意しよう．

=== モナド則

#tk モナド則

// https://qiita.com/mandel59/items/87aebbd964ca82f74904

$ mu haskell.bind chevron.l x chevron.r &= mu x \
  chevron.l lozenge.stroked.medium chevron.r haskell.bind x_*
  &= x_* \
  nu haskell.bind mu haskell.bind x_*
  &= nu haskell.bind (mu haskell.bind x_*) $

$(MM, haskell.bind, chevron.l lozenge.stroked.medium chevron.r)$ はモノイドである．

関数 $mu$ に作用する#keyword[クライスリスター]演算子 $star.filled$ を $mu^star.filled = (mu haskell.bind lozenge.stroked.medium)$ と定義する．クライスリスターを用いると，モナド則は次のように書き直せる．
$ mu^star.filled chevron.l x chevron.r &= mu x \
  chevron.l lozenge.stroked.medium chevron.r^star.filled x_* &= x_* \
  (nu^star.filled mu)^star.filled x_* &= nu^star.filled (mu^star.filled x_*) $


#theorem-box(title: "Right Identity", outlined: false)[
$phi haskell.bind chevron.l x chevron.r = phi x$
]

#theorem-box(title: "Left Identity", outlined: false)[
$chevron.l lozenge.stroked.medium chevron.r haskell.bind x_* = x_*$
]

#theorem-box(title: "Associativity", outlined: false)[
$phi haskell.bind (psi haskell.bind x_*) = (backslash y |-> phi haskell.bind (psi y)) haskell.bind x_*$
]

=== モノイド

#tk

整数全てからなる#keyword[集合]を $ZZ$ で表すことにする．計算機科学で整数と言うと，本当の整数と，例えば $-2^(63)$ から $2^(63)-1$ までの間の整数の意味と両方あるが，今は前者の意味である．

集合 $ZZ$ の任意の#keyword[元]（#keyword[要素]）$z$ を $z in ZZ$ と書く．

二つの整数 $z_1, z_2 in ZZ$ があるとしよう．両者の間には#keyword[足し算] $(+)$ が定義されており，その結果すなわち#keyword[和]もまた整数である．ここで $z_1 + z_2 in ZZ$ であるとき，演算子 $+$ が集合 $ZZ$ に対して#keyword[全域性]を持つと言う．

一般に集合 $AA$ の元に対して二項演算子 $haskell.anyop$ が定義されていて，$a_1, a_2 in AA$ のときに
#par-equation($ a_1 haskell.anyop a_2 in AA $)
である場合，つまり演算子 $haskell.anyop$ が集合 $AA$ に対して全域性を持つ場合，組み合わせ $(AA, haskell.anyop)$ を#keyword[マグマ]と呼ぶ．組み合わせ $(ZZ, +)$ はマグマの例であり，$(ZZ, times)$ もマグマの例である．

他に#keyword[論理集合] $BB = \{tack.b, tack.t\}$ に対して，#keyword[論理和] $(or)$ は全域性を持つから，組み合わせ $(BB, or)$ はマグマであるし，同様に#keyword[論理積] $(and)$ も全域性を持つから，組み合わせ $(BB, and)$ もマグマである．論理集合 $BB$ とは論理型 $haskell.Bool$ を数学風に言い換えたものである．#footnote[記号 $tack.b$ は $haskell.True$ を，記号 $tack.t$ は $haskell.False$ を抽象化したものである．記号 $and$ はandと読み，記号 $or$ はorと読む．]

マグマのうち，演算を2回続ける場合，その順序によって結果が異ならない，つまり
#par-equation($ a_1 haskell.anyop (a_2 haskell.anyop a_3) = (a_1 haskell.anyop a_2) haskell.anyop a_3 $)
ただし $a_1, a_2, a_3 in AA$ のとき，組み合わせ $(AA, haskell.anyop)$ のことを#keyword[半群]と呼ぶ．この〜〜〜で表される性質を#keyword[結合性]と呼ぶ．組み合わせ $(ZZ, +), (ZZ, times), (BB, or), (BB, and)$ はすべて半群である．

ところで，整数全体の集合 $ZZ$ には特別な元 $0 in ZZ$ がある．この元 $0$ は $z in ZZ$ のとき
#par-equation($ 0 + z = z + 0 = z $)
という性質を持つ．この $0$ を演算 $+$ における#keyword[単位元]と呼ぶ．足し算のことを#keyword[加法]とも言うので $0$ のことは#keyword[加法単位元]と呼ぶこともあるし，文字通り#keyword[零元]と呼ぶこともある．

一般に，$a in AA$ として
#par-equation($ 0 haskell.anyop a = a haskell.anyop 0 = a $)
であるとき，元 $0$ を単位元と呼ぶ．#footnote[厳密には $0_"left" haskell.anyop a = a$ のとき $0_"left"$ を#keyword[左単位元]と呼び，$a haskell.anyop 0_"right" = a$ のとき $0_"right"$ を#keyword[右単位元]と呼ぶが，本書では両者を区別せず単位元と呼ぶ．]

組み合わせ $(AA, haskell.anyop)$ が半群のとき，集合 $AA$ の単位元 $0$ との組み合わせ $(AA, haskell.anyop, 0)$ のことを#keyword[モノイド]または#keyword[単位的半群]と呼ぶ．例えば $(ZZ, +, 0)$ はモノイドであるし，$(ZZ, times, 1), (BB, or, tack.t)$, $(BB, and, tack.b)$ もモノイドである．

このように，数学者は数の性質を抽象化し，集合とその集合に対する演算というものの見方をよく行う．プログラミングの言葉で言えば，複数のクラスに共通のインタフェースを定義するようなものである．


型 $haskell.a$ を任意の型としたとき，型 $haskell.a -> haskell.a$ の関数もまたモノイドとなる．まず「何もしない」関数 $id$ を次のように定義する．
#par-equation($ id = lozenge.stroked.medium $)
これはもちろん $id = backslash x |-> x$ の意味で，引数をそのまま返す関数である．

我々は関数を合成できる．そこで $haskell.a -> haskell.a$ 型の関数 $f$ と関数 $id$ の合成を考えると $id compose f = f compose id = f$ であり，また関数 $f, g, h colon.double haskell.a -> haskell.a$ について $(h compose g) compose f = h compose (g compose f)$ でるから，組み合わせ $(haskell.a -> haskell.a, compose, id)$ はモノイドであることがわかる．

#tk

$(ZZ, +, 0)$ はモノイドである．

同じ型を持つ関数を集めた関数の集合 $FF$ があるとする．任意の関数 $f in FF$ について $id f = f$ なる関数 $id$ があり，かつ任意の関数 $f, g, h in FF$ に対して $(h compose g) compose f) = h compose (g compose f)$ が成り立つとする．このとき組み合わせ $(FF, compose, id)$ は#keyword[モノイド]であるという．

- 単位元の存在
- 結合律




=== 余談：IOサバイバルキット3

=== この章のまとめ

== IO
<io>

$ haskell.main &colon.double haskell.IO_haskell.Int \
  haskell.main &= chevron.l 0 chevron.r $

=== IO

#tk IO

=== IOモナド

=== 制御構造

=== 余談：do記法

#tk

#sourcecode[```haskell
-- Haskell
z = do { x' <- x; y' <- y; f x'; g y' }
```]


=== この章のまとめ

= Haskellプログラミング

= プログラミングと代数構造

== 整数

== 条件式

== Yコンビネータ

= Haskellの深い部分

== 型と種

=== 型の計算

=== 種

#tk 種

$ haskell.kk arrow.r.filled haskell.Type $

// 具体的な型を $star.stroked$ で表す．例えば $haskell.Int$ や $haskell.a$ の種は $star.stroked$ である．

// 一方，型を作る型，つまり型コンストラクタの種は $star.stroked -> star.stroked$ である．

See https://zenn.dev/mod_poppo/books/haskell-type-level-programming/viewer/types-and-kinds

== マクロとTemplate Haskell

#tk マクロ


= 執筆ノート

#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  table.header([*項目*], [*内容*], [*Haskellコード*]),
  [Function application], $z = f x$, [```haskell z = f x ```],
  [List map], $z_"s" = f * x_"s"$, [```haskell zs = f `map` xs ```],
  [Maybe map], $z_? = f convolve.o_? x_?$, [```haskell zm = f <$> xm ```],
  [Functor map], $z_* = f convolve.o x_*$, [```haskell zm = f <$> xm ```],
  [Applicative map], $z_* = f_* haskell.amap x_*$, [```haskell zm = fm <*> xm ```],
  [Applicative map with 2 arguments], $z_* = g_* haskell.amap x_* haskell.amap y_*$, [```haskell zm = gm <*> xm <*> ym ```],
  [Applicative map with 2 arguments], $ z_* &= g convolve.o x_* haskell.amap y_* \ &= [| g x_* y_* |]$, [```haskell zm = gm <$> xm <*> ym ```],
  [Monadic function application], $z_* = phi x$, [```haskell zm = phi x ```],
  [Bind], $z_* = phi haskell.bind x_*$, [```haskell zm = phi =<< xm ```],
  [Double bind（右結合）], $z_* = psi haskell.bind phi haskell.bind x_*$, [```haskell zm = psi =<< phi =<< xm ```],
)

$ haskell.kwclass &haskell.Eq supset haskell.a haskell.kwwhere \
  &(equiv) colon.double haskell.a -> haskell.a -> haskell.Bool \
  &(equiv.not) colon.double haskell.a -> haskell.a -> haskell.Bool \
  &(equiv) = not (x equiv.not y) \
  &(equiv.not) = not (x equiv y) $

$ haskell.kwdata "TrafficLight" = "Red" or.curly "Yellow" or.curly "Green" $

$ haskell.instance & haskell.Eq supset "TrafficLight" haskell.kwwhere\
  &"Red" equiv "Red" = haskell.True \
  &"Yellow" equiv "Yellow" = haskell.True \
  &"Green" equiv "Green" = haskell.True \
  &rect.stroked.h equiv rect.stroked.h = haskell.False $