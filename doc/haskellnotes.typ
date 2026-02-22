// Typst
#import "@preview/in-dexter:0.7.2": *
#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/showybox:2.0.4": showybox

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
#let keyword(x) = [#highlight[#x]]

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
    [アクション], [ギリシア文字], $phi$,
    [有名な変数・関数・定数], [ローマン・小文字], $haskell.first, id, haskell.otherwise$,
    // [文脈に入れる関数（アクション）], [], $caron(f)$,
    [有名なアクション], [ボールド・小文字], $haskell.main, haskell.print$,
    [リスト変数], [変数名にsをつける], $x_"s"$,
    [Maybe変数], [変数名に $?$ をつける], $x_?$,
    [Either変数], [変数名に $!$ をつける], $x_!$,
    [一般のコンテナ変数], [変数名に $*$ をつける], $x_*$,
    [値コンストラクタ（引数なし）], [ローマン（大文字）], $haskell.True, haskell.Nothing$,
    [値コンストラクタ（引数あり）], [ローマン（大文字）], $haskell.Just(x)$,
    [有名な値コンストラクタ1], [数学記号], $haskell.emptylist, nothing.rev$,
    [有名な値コンストラクタ2], [特別な括弧で包む], $[x], chevron.l y chevron.r, paren.l.stroked u, v paren.r.stroked$,
    [有名な値コンストラクタ3], [コロン $(:)$ を含む記号], $x : x_"s"$,
    [型（引数なし）], [ボールドイタリック（1文字）], $haskell.a$,
    [型（引数あり）], [ボールドイタリック（1文字）], $haskell.typeconstructor1(m, a)$,
    [有名な型（引数なし）], [ボールド・大文字], $haskell.Int$,
    [有名な型（引数あり）], [特別な括弧で包む], $[haskell.a], [haskell.Int]$,
    [ユニット型], [括弧], $haskell.Unit$,
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
    [圏論的関手（数学）], [スクリプト（1文字）], $scr(F)$,
    [圏（数学）], [カリグラフィ（1文字）], $cal(C)$
  )
)


= Haskell入門
<introduction-to-haskell>

本書はプログラミング言語Haskellの入門書である．それと同時に，本書はプログラミング言語を用いた代数構造の入門書でもある．プログラミングと代数構造の間には密接な関係があるが，とくに#keyword[関数型プログラミング]を実践する時にはその関係を意識する必要が出てくる．本書はその両者を同時に解説することを試みる．

== Haskellについて
<about-haskell>

これからのプログラマにとってHaskellを無視することはできない．Haskellの「欠点をあげつらうことも，攻撃することもできるが，無視することだけはできない」のだ．それはHaskellがプログラミングの本質に深く関わっているからである．@apple-think-different

=== Haskellという森

Haskellというプログラミング言語を知ろうとすると，従来のプログラミング言語の知識が邪魔をする．モダンで，人気があって，Haskellから影響を受けた言語，たとえばRubyやSwiftの知識さえ，Haskellを学ぶ障害になり得る．ではどのようにしてHaskellの深みに到達すればいいのだろうか．

その答えは，一見遠回りに見えるが，一度抽象数学の高みに登ることである．

と言っても，あわてる必要はない．

近代的なプログラミング言語を知っていれば，すでにある程度抽象数学に足を踏み入れているからである．そこで，本書では近代的なプログラマを対象に，プログラミング言語を登山口に抽象数学の山を登り，その高みからHaskellという森を見下ろすことにする．

さて，登山口にどのプログラミング言語を選ぶのが適当であろうか．TIOBE Index 2025年12月版によると「ビッグ5」としてPython，C，C++，Java，C\#が挙げられている．@tiobe-index

順位の変動はあるが，他の調査でもビッグ5は過去何年も変動していないので，当座は妥当な統計であろう．このうちCは「多くのプログラマが読める」以外にメリットが無く，その唯一のメリットさえ最近は怪しくなっているため，登山口候補から外す．残るはC++，Java，C\#グループとPythonということになるが，シンプルであり，かつHaskellと対極にある言語であるPythonを登山口に選ぶことにした．

本書ではPythonコードはこのように登場する．
#sourcecode[```python
# Python
print("Hello, world.")
```]

本書に示すコードは擬似コードではなく，すべて実行可能な本物のコードである．

一部の章でどうしても型に触れないといけない部分がある．Pythonは動的型付け言語であり，型の説明には不適切であるため，この部分だけ理解の助けとしてC++によるコードを例示した．この部分はコードを読まなくても先に進める．

ところで，プログラムのソースコードは現代でもASCII文字セットの範囲で書くことが標準的である．Unicodeを利用したり，まして文字にカラーを指定したり，書体や装飾を指定することは一般的ではない．たとえば変数 `a` のことを $a$ と書いたり $bold(a)$ と書いたり $caron(a)$ と書いたりして区別することはない．

Haskellプログラマもまた，多くの異なる概念を同じ貧弱な文字セットで表現しなければならない．これは，はじめてHaskellコードを読むときに大きな問題になりえる．たとえばHaskellでは ```haskell [a]``` という表記をよく扱う．この ```haskell [a]``` は ```haskell a``` という変数1要素からなるリストのこともあるし，```haskell a``` 型という仮の型から作ったリスト型の場合もあるが，字面からでは判断できない．もし変数はイタリック体，型はボールドイタリック体と決まっていれば，それぞれ $[a]$ および $[haskell.typeparameter(a)]$ と区別できたところである．

本書は，異なる性質のものには異なる書体を割り当てるようにしている．ただし，どの表現もいつでもHaskellに翻訳できるように配慮している．実際，本書執筆の最大の困難点は，数学的に妥当で，かつHaskellの記法とも矛盾しない記法を見つけることであった．

=== 関数型プログラミング

プログラマはなぜHaskellを習得しなければならないのだろう．それはHaskellと#keyword[関数型プログラミング]の間に密接な関係があるからである．

関数型プログラミングとはプログラミングにおける一種のスローガンのようなもので，どの言語を用いたから関数型でどの言語を用いたから関数型ではない，というものではない．しかし，関数型プログラミングを強くサポートする言語と，そうでない言語とがある．この事情はオブジェクト指向プログラミングとプログラミング言語の関係と似ている．Haskellは関数型プログラミングを強くサポートし，Pythonはほとんどサポートしない．

関数型プログラミングの特徴を一言で言えば，プログラム中の#keyword[破壊的代入]を禁止することである．変数 $x$ に $1$ という数値が一度代入されたら，変数 $x$ の値をプログラム中に書き換える，すなわち破壊的代入をすることはできない．この結果，変数の値はプログラムのどこでも，どの時点で読み出しても同じであることが保証される．これを変数の#keyword[参照透過性]と呼ぶ．#footnote[変数の値が常に同じなことに加えて，関数に同じ引数を与えた場合に常に同じ結果が得られることを参照透過性と呼ぶ．]

プログラム全体に参照透過性があると，そのプログラムはブロックに分割しやすく，各々のブロックは再利用しやすい．またプログラムのどの断片から読み始めても，全体の構造を見失いにくい．これが関数型プログラミングとそれを強くサポートするHaskellを習得する理由である．

参照透過性がもたらすもう一つのボーナスは変数の#keyword[遅延評価]である．変数はいつ評価しても値が変わらないのだから，コンパイラは変数をできるだけ遅く評価してよい．この遅延評価によって，Haskellコンパイラは他の言語に見られない#keyword[無限リスト]を扱う能力を獲得している．

ここで数学とプログラミングの関係について述べておこう．ある方程式を解くためにコンピュータによって数値シミュレーションを行うとか，非常に複雑な微分を機械的に行うとか，プログラミングによって数学をサポートすることは計算機科学の主たる分野の一つであるが，ここではもっと根源的な話をする．

数学者もプログラマも#keyword[関数]をよく使う．数学者が使う関数とは，引数がいくつかあって，その結果決まる戻り値があるようなものだ．一方でプログラマが使う関数というのは，引数と戻り値があるという点はだいたい同じとして，中身に条件分岐があったり，ループがあったり，外部変数を書き換えたり，入出力をしたりする．

どちらも同じ関数であるのに，なぜこうもイメージが違うのだろうか．

もし，我々が関数型プログラミングの原則を忠実に守り，プログラム中のいかなる破壊的代入をも禁止するとすると，両者の関数は全く同じ性格になる．逐次実行も条件分岐もループも，それどころか定数さえ，#keyword[ラムダ式]という式だけで書けるようになる．あらゆるプログラムが，最終的には単一のラムダ式で書ける．

ところが，入出力，状態変数，例外など，プログラミングに使われる多くのテクニックは関数の副作用を前提としている．参照透過性と副作用を統一的に扱うためには#keyword[モナド]という概念が必要である．Haskellはモナドを陽に扱うプログラミング言語である．

#pb

関数型プログラミングという考え方自体は，プログラミングに必ずしも束縛されるものではない．

例えばいま，ある英文テキストファイルから，単語を出現頻度順に取り出したいとしよう．こんなとき，プログラマならば次のように考えるのではないだろうか．

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
#par-equation($ y = (f_6 compose f_5 compose f_4 compose f_3 compose f_2 compose f_1)(x) $)
と書き直そう．ここに演算子 $compose$ は「#keyword[関数合成演算子]」だ．

関数合成演算子を使うと，プログラム $f$ を
#par-equation($ f = f_6 compose f_5 compose f_4 compose f_3 compose f_2 compose f_1 $)
と定義することも出来る．これが何を意味しているかと言うと，プログラム $f$ を小さな部分プログラム $f_1, f_2, f_3, f_4, f_5, f_6$ に分解したということだ．

分解したなら，合成する方法が必要になる．この例では，プログラムの各部分が他の部分に依存していないために，合成は数学的な関数合成と同じ方法が使える．

上記の例のように，数学における関数合成をそのままプログラミングに持ち込めれば，部分プログラムの合成も見通しが良いものになる．このような考え方が「関数型プログラミング」のエッセンスなのである．@graham-hutton @miran-lipovaca @richard-bird @will-kurt

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

画面に次のように表示されたら成功である．

#sourcecode[```shell-unix-generic
Hello, World!
```]

=== 余談：本書の構成

本書の構成を「余談」として記述する．#footnote[なお本書は脚注も多用している．脚注は読まなくて良い．]

本書の第1部は抽象数学からプログラミングを俯瞰することにする．俯瞰と言っても，登場する数式はすべてHaskellに翻訳可能である．第1部はまず本書で使う記法「カリー風な書き方」を紹介する．またプログラミングの基本要素である条件分岐についても説明する．その後，型と型クラスの基本的な概念を説明し，リストの扱いを説明する．またリストを用いた再帰，畳み込み，マップを説明する．第1部の後半ではMaybeを紹介し，リストとMaybeの共通点から関手型クラスというHaskellに独特な概念を説明する．ついで関手型クラスを拡張したアプリカティブ関手型クラス，モナド型クラスを紹介し，入出力（IO）をモナド型クラスで扱う方法を示す．第1部では途中途中に「IOサバイバルキット」と称して，プログラマにとってどうしても必要となる知識を「とりあえず使える形」で紹介した．

=== この章のまとめ

- プログラミング言語Haskellは「関数型プログラミング」スタイルを強くサポートする．
- 関数型プログラミングとは，数学における関数と関数合成の概念をプログラミングに持ち込んだものである．
- 関数型プログラミングでは「参照透過性」が重視される．参照透過性とは，変数が破壊的に代入されないこと，関数が同じ引数を与えられた場合には同じ値を返すことを言う．
- プログラミング言語Haskellを学ぶには，従来のプログラミング言語の知識から一旦離れて，抽象数学の高みに登るほうが近道である．
- 関数型プログラミングのエッセンスはプログラミングのみならず，日常的なUNIXコマンドにも見て取れる．

#showybox(title: "関数")[日本語の「関数」は中国語の「函数（hánshù）」に由来する．教科書によっては日本でも関数のことを函数と書いている．この中国語の函数であるが，箱（函）に入れられた数という意味と，英語のファンクション（function)とと発音が似ているため訳語として採用されたという説がある．

なお英語のファンクションのほうには日本語の「関数」の意味と「機能」の意味の両方がある．C言語の関数（function）はどちらかと言えば「機能」の意味である．

違う概念には違う単語を割り当てたいものである．]

== カリー風な書き方
<curry-style>

本書では一般の数学書やプログラミングの教科書からは少し異なった記法を用いる．ある概念が発明されてからずっと後になって正しい記法が見つかり，それがきっかけとなって正しく理解されるという現象は歴史上よくあることである．本書でも様々な新しい記号，記法を導入する．

数学やプログラミミング言語には書き方に一定の決まりがある．この章ではまず「カリー風の」数式記述方式を見てみることにする．「カリー風」というのは，数学者ハスケル・カリーから名前を借りた言い方で，筆者が勝手に命名したものだ．

カリー風の書き方は数学の教科書やプログラミングの教科書で見かけるものとは若干違うが，圧倒的にシンプルでHaskellとの親和性も高く，慣れてくると非常に読みやすいものなので，本書でも全面的に採用する．

=== 変数と関数

変数 $x$ に値 $1$ を代入するには次のようにする．#footnote[Haskellでは ```haskell x = 1``` と書く．]

$ x = 1 $<binding>

変数という呼び名に反して，変数の値は一度代入したら変えられない．そこで変数に値を代入するとは呼ばずに，変数に値を#keyword[束縛]するという． @binding の右辺のように数式にハードコードされた値を#keyword[リテラル]と呼ぶ．

リテラルや変数には#keyword[型]がある．型は数学者の#keyword[集合]と似た意味で，整数全体の集合 $ZZ$ に相当する#keyword[整数型]や，実数全体の集合 $RR$ に相当する#keyword[浮動小数点型]がある．整数と整数型，実数と浮動小数点型は異なるため，整数型を $haskell.Int$ で，浮動小数点型を $haskell.Float$ と $haskell.Double$ で表すことにする．ここで $haskell.Float$ と $haskell.Double$ の違いは有効数字だけである．#footnote[Haskellでは ```haskell Int``` および ```haskell Float``` と ```haskell Double``` と書く．]

型については@types で詳しく述べる．数学者は変数 $x$ が整数であることを $x in ZZ$ と書くが，本書では $x colon.double haskell.Int$ と書く．これは記号 $in$ を別の用途に用いるためである．また型の#keyword[注釈]と束縛をまとめて $x colon.double haskell.Int = 1$ と書く事もできる．#footnote[Haskellでは $x colon.double haskell.Int$ を ```haskell x :: Int``` と書き $x colon.double haskell.Int = 1$ を ```haskell x :: Int = 1 ``` と書く．]

本書では変数名を原則1文字として，イタリック体で表し $a$ および $w,x,y,z$ のような $n$ 以降のアルファベットを使う．

#pb

変数の値がいつでも変化しないことを#keyword[参照透過性]と呼ぶ．#footnote[関数に同じ引数を与えた場合，同じ値がいつも返ることも参照透過性の条件である．ただし，関数が内部状態を持つためには，どこかで破壊的代入が必要である．]  // 本当???

プログラマが変数の値を変化させたい，つまり#keyword[破壊的代入]を行いたい理由はユーザ入力，ループ，例外，内部状態の変化，大域ジャンプ，継続を扱いたいからであろう．しかし，後に見るようにループ，例外，大域ジャンプに相当する操作に変数の破壊的代入は必要ない．ユーザ入力，内部状態の変化，継続に関しても章を改めて取り上げる．参照透過性を強くサポートするプログラミング言語をを#keyword[関数型プログラミング言語]と呼ぶ．

#pb

整数 $x$ に $1$ を足す#keyword[関数] $f$ は次のように定義できる．
#par-equation($ f x = 1 + x $)
ここに $x$ は関数 $f$ の#keyword[引数]である．引数は括弧でくるまない．このような書き方を本書では「カリー風」と呼ぶことにする．#footnote[Haskellでは ```haskell f x = x + 1``` と書く．]

なお同じ関数をPythonでは次のように書くことになる．

#sourcecode[```python
# Python
def f(x):
  return 1 + x
```]

Pythonや一般的な数学書では引数 $x$ をとる関数 $f$ を $f(x)$ と書くが，括弧は冗長なので今後は $f x$ と書くことにする．#footnote[Haskell では関数 ```haskell f``` に引数 ```haskell x``` を適用させることを ```haskell f x``` と書く．数学や物理学では $x$ をパラメタとする関数を $f(x)$ と書く場合もあるし，$f$ のようにパラメタを省略する場合もある．数学や物理学でパラメタを省略した場合は，$f(x_0)$ の意味で $f|_(x=x_0)$ と書くことがある．]

本書では関数名を原則1文字として，イタリック体で表し，$f,g,h$ のようにアルファベットの $f$ 以降の文字を使う．ただし有名な関数についてはローマン体で表し，文字数も2文字以上とする．たとえば $sin$ などの三角関数や指数関数がそれにあたる．

関数 $f$ に引数 $x$を「食わせる」ことを#keyword[適用]と呼ぶ．もし $f x$ と書いてあったら，それは $f$ と $x$ の積，つまり $f times x$ ではなく，従来の $f(x)$ すなわち関数 $f$ に引数 $x$ を与えているものと解釈する．高校生向けの数学書でも $sin x$ のように三角関数に限っては括弧を取って書くことになっているので，まるで馴染みがないということもないだろう．なお，関数はいつも引数の左側に書くことにする．これを「関数 $f$ が変数 $x$ の左から作用する」と言い，また関数 $f$ のことを#keyword[左作用素]とも呼ぶ．

変数 $x$ に関数 $f$ を適用して $z$ を得る場合は次のように書く．#footnote[Haskellでは ```haskell z = f x``` と書く．]

$ z = f x $

#pb

複数引数をとる関数をPythonや一般的な数学の教科書では $g(x, y)$ と書くが，これも括弧が冗長なので今後は $g x y$ と書く．この場合式 $g x y$ は左を優先して結合する．つまり $g x y = (g x) y$ である．これは引数 $y$ に関数 $(g x)$ が左から作用していると解釈する．関数 $(g x)$ は引数 $x$ に関数 $g$ を作用させて作った関数である．引数に「飢えた」関数 $(g x)$ を#keyword[部分適用]された関数と呼ぶ．このように式の左側を優先的に演算していくことを#keyword[左結合]と呼ぶ．Haskellの場合，関数適用はいつも左結合である．

部分適用の例を見てみよう．例えばふたつの引数のうち大きい方を返す関数 $max$ は $max x y$ として使われるが，関数適用は左結合であるから $(max x) y$ としても同じである．そこで $(max x)$ だけ取り出すと，これは「引数が $x$ よりも小さければ $x$ を，そうでなければ引数を返す関数」とみなすことができる．#footnote[Haskellでは $max x y$ を ```haskell max x y``` と書く．なお関数 $(max x)$ のことを $max_x$ と書く教科書も多い．関数引数を添え字で表す記法は，本書でも後に採用する．]

もし関数 $max x$ と同じものをPythonで作りたければ，次のようなテクニックを用いることになる．

#sourcecode[```python
# Python
def create_max(x):
  return lambda y: max(x, y)
```]

このPython関数 ```python create_max(x)``` は我々の $max x$ と同じ用に，1引数を取る関数として振る舞う．そのため ```python create_max(10)(20)``` は ```python 20``` を返す．このような仕組みは#keyword[クロージャ]または#keyword[関数閉包]と呼ばれる．

=== ラムダ式

関数の正体は#keyword[ラムダ式]である．ラムダ式とは，仮の引数をとり，その値をもとになにがしかの演算を行い，その結果を返す式である．ラムダ式は名前のない関数のようなものだ．それゆえ，無名関数と呼ばれることもある．

例えば引数 $x$ をとり値 $1+x$ を返すラムダ式を変数 $f$ に代入したい場合，Pythonでは次のように書く．

#sourcecode[```python
# Python
f = lambda x: 1 + x
```]

一方，我々はより簡潔に
#par-equation($ f = backslash x |-> 1+x $)
と書くことにする．この式の右辺 $backslash x |-> 1+x$ は多くの書物で $lambda x class("binary", .) 1+x$ と記述されるところである．しかし我々はすべてのギリシア文字を変数名のために予約しておきたいのと，ピリオド記号 $(.)$ が今後登場する二項演算子と紛らわしいため，上述の記法を用いる．#footnote[Haskellではラムダ式 $backslash x |-> 1+x$ を ```haskell \x -> 1 + x``` と書く．]

ラムダ式は関数である．ラムダ式を適用するには，ラムダ式を括弧で包む必要がある．例を挙げる．
#par-equation($ (backslash x |-> 1+x) space 2 $)
この式は結果として $3$ を返す．

複数引数をとるラムダ式は例えば $backslash x y |-> x + y$ のように引数を並べて書く．

#pb

本書では新たに，次のラムダ式記法も導入する．式中に記号 $lozenge.stroked.medium$ が現れた場合，その式全体がラムダ式であるとみなす．記号 $lozenge.stroked.medium$ の部分には引数が入る．第 $n$ 番目の $lozenge.stroked.medium$ には第 $n$ 番目の引数が入る．例えばラムダ式 $backslash x y |-> x + y$ は $lozenge.stroked.medium + lozenge.stroked.medium$  と書いても良い．式を左から読んで1番目の $lozenge.stroked.medium$ が元々の $x$ すなわち第1引数を，2番目の $lozenge.stroked.medium$ が元々の $y$ すなわち第2引数を意味する．この省略記法はプログラミング言語Schemeにおける `cut` プロシジャに由来する．#footnote[Haskellでは，中置演算子に限ってこの表現が使える．例えば $(lozenge.stroked.medium + lozenge.stroked.medium)$ は単に ```haskell (+)``` と表現できる．]

#pb

数式が長く続くとき，読みやすさのために#keyword[局所変数]を導入すると便利である．例えば
#par-equation($ z = f(1+x) $)
という式のうち，先に $1+x$ を計算して $x'$ のように名前をつけておきたいこともある．そんなときは次のように書く．#footnote[Haskellでは ```haskell z = let x' = 1+x in f x'``` と書く．]

$ z = haskell.kwlet x' eq.delta 1+x haskell.kwin f x' $<let-in>

なお，局所変数を後ろに回して
#par-equation($ z = f x' haskell.kwwhere x' eq.delta 1+x $)
と書いても良い．#footnote[Haskellでは ```haskell y = f x' where x' = 1 + x``` と書く．]

局所変数はラムダ式を用いたシンタックスシュガーである．@let-in は次の式と等価である．

$ z = (backslash x' |-> f x') (1+x) $<let-in-alternative>

#pb

関数の定義は，基本的にはラムダ式の変数への束縛である．引数 $x$ をとり値 $1+x$ を返す関数 $f$ は
#par-equation($ f = backslash x |-> 1+x $)
と定義できる．ただし，この省略形として
#par-equation($ f x = 1+x $)
と書いても良い．#footnote[Haskellでは $f = backslash x |-> 1+x$ を ```haskell f = \ x -> 1 + x``` と書き，一方 $f x = 1+x$ を ```haskell f x = 1 + x``` と書く．]

=== パタンマッチとガード

関数に#keyword[スペシャルバージョン]がある場合はそれらを列挙する．例えば引数が $0$ の場合は特別に戻り値が $-1$ であり，その他の場合は $1+x$ を返す関数 $f$ を考える．このとき $f$ は以下のように定義できる．これを関数の#keyword[パタンマッチ]と呼ぶ．#footnote[Haskellでは ```haskell f 0 = -1; f x = 1 + x``` と書く．]

$ f 0 &= -1 \
  f x &= 1+x $

関数のパタンマッチは，関数の内部に書いても良い．関数内部にパタンマッチを書きたい場合は次のように書く．

$ f x = haskell.kwcase x haskell.kwof cases(0 arrow.r.dotted -1,
square.stroked.dotted arrow.r.dotted 1+x) $<pattern-matching>

ここに $square.stroked.dotted$ は任意の値の意味である．パタンマッチは上から順番にマッチングしていくため，この場合は $0$ 以外を意味する．#footnote[Haskellでは ```haskell f x = case x of { 0 -> 100; _ -> 1 + x }``` と書く．]

@pattern-matching は次のような Python コードと等しい．#footnote[この構文「構造的パタンマッチング」と呼ばれ Python 3.10 で導入された．]

#sourcecode[```python
# Python
def f(x):
  match x:
    case 0:
      return -1
    case _:
      return 1 + x
```]

一部のプログラミング言語では#keyword[デフォルト引数]という，引数を省略できるメカニズムがあるが，我々は引数をいつも省略しないことにする．#footnote[Haskellにもデフォルト引数はない．]

関数定義にパタンマッチではなく#keyword[場合分け]が必要な場合は#keyword[ガード]を用いる．例えば引数の値が負の場合は $0$ を，$0$ の場合は $-1$ を，それ以外の場合は $1+x$ を返す関数 $f'$ は以下のように定義する．#footnote[Haskellでは ```haskell f' x | x < 0 = 0  | x == 0 = 100  | otherwise = x + 1 ``` と書く．もっとも，この記法を使う場合は改行を適度に入れたほうが読みやすい．]

$ f' x&|_(x < 0) = 0 \
  &|_(x equiv 0) = -1 \
  &|_haskell.otherwise = 1+x $

ガードは上から順にマッチされる．

=== 余談：条件式

関数定義の場合分けを駆使すれば#keyword[条件式]はなくても構わないが，条件式の記法があるのは便利である．Pythonには次のような#keyword[制御構造]としての条件文がある．

#sourcecode[```python
# Python
def f(x):
  if x == 0.0:
    return 1.0
  else:
    return sin(x) / x
```]

一方，我々は値を持つ#keyword[条件式]を考える．我々の条件式とは 
#par-equation($ f x = haskell.kwif x equiv 0.0 haskell.kwthen 1.0 haskell.kwelse frac(sin x, x) $)
のように $haskell.kwif$ 節，$haskell.kwthen$ 節，及び $haskell.kwelse$ 節からなるものであって，$haskell.kwthen$ 節も $haskell.kwelse$ 節も省略できないものとする．$haskell.kwif$ 節の式の値が真 $(haskell.True)$ であれば $haskell.kwthen$ 節の式が評価され，偽 $(haskell.False)$ であれば $haskell.kwelse$ 節の式が評価される．我々の条件式はCにおける条件演算子（三項演算子）と等しく見えるが，Haskellの場合は遅延評価が行われるため，結果として条件式の#keyword[短絡評価]が行われる点が異なる．#footnote[Haskellでは $f x = haskell.kwif x equiv 0.0 haskell.kwthen 1.0 haskell.kwelse frac((sin x), x, style: "skewed")$ を ```haskell f x = if x == 0.0 then 1.0 else (sin x) / x``` と書く．]

=== この章のまとめ

- 変数への値の代入は $x = 1$ のように書く．一度代入された変数は値を変えない．代入は正しくは「束縛」と呼ぶ．
- 関数定義は $f x = 1+x$ のように書く．関数の引数に括弧はつけない．
- 関数適用は $z = f x$ のように書く．この場合も関数の引数に括弧は付けない．
- 2引数関数 $f'$ に引数 $x, y$ を与えるときは $z' = f' x y$ のように書く．関数適用は左結合するので $f' x y = (f' x)y$ である．引数に「飢えた」関数 $f' x$ を「部分適用された関数」と呼ぶ．
- 関数の正体はラムダ式である．関数 $f x = 1+x$ はラムダ式を使った記法 $f = backslash x |-> 1+x$ の略記である．
- 本書では無名パラメタ $(lozenge.stroked.medium)$ を用いたラムダ式も用いる．無名パラメタを使う場合は $f = 1+lozenge.stroked.medium$ のように書く．
- 式には局所変数を導入できる．例えば $z = f(1+x)$ は $z = haskell.kwlet x' eq.delta 1+x haskell.kwin f x'$ のように書いても良く，また $z = f x' haskell.kwwhere x' eq.delta 1+x$ のように書いても良い．
- 関数定義にはスペシャルバージョンを含めることが出来る．例えば引数が $0$ の場合は特別な値を返すときは $f 0 = -1$ のように書く．
- 関数定義にはガードを含めることが出来る．例えば引数が負の場合は特別な値を返すときは $f|_(x < 0) = 0$ のように書く．
- 式にはパタンマッチを導入できる．
- 条件式は $haskell.kwif p haskell.kwthen x haskell.kwelse y$ のように書く．もし $p$ が $haskell.True$ であれば $x$ が式の値になり，そうでなければ $y$ が式の値になる．

#showybox(title: "ラムダの理由")[我々のラムダ式 $backslash x |-> x + 1$ は，かつては $hat(x) . x + 1$ のように書かれていた．その後 $Lambda x . x + 1$ に変化し $lambda x . x + 1$ のように変化したらしい．多くの教科書はこの $lambda$ を使う記法を採用している．$hat(x)$ が $Lambda x$ に変化したのは形が似ているからである．Haskellが $backslash$ を使うのは，その形が $lambda$ と似ているからである．

近代的なプログラミング言語はラムダ式を陽に記述できる．C++11では ```cpp [](int x, int y) { return x + y; }``` のようにラムダ式を書くことが出来る．C++のように歴史の長い言語では既存のソースコードに干渉しないように，新しい文法の導入には制約がある．記号 ```cpp []``` はもともとリテラル，変数名またはキーワード ```cpp operator``` の後にしかこないため，ラムダ式を表す記号として流用された．@cppreference-member-access-operators

LispやSchemeはラムダ式がそのプログラミングの本質であるにも関わらず ```scheme lambda``` という長いキーワードを用いている．例えば $backslash x y |-> x + y$ は ```sceme (lambda (x y) (+ x y))``` と書かれる．もっともLispプログラマ，Schemeプログラマは ```scheme lamda``` が1文字あるいは空気に見えている可能性はある．]

== さらにカリー風な書き方
<more-curry-style>

我々は関数とラムダ式の「カリー風」な書き方を見てきた．この章ではさらに演算子，関数合成についても「カリー風」な書き方を見ていく．

=== 演算子

#keyword[演算子]は関数の特別な姿である．演算子は#keyword[作用素]と呼んでも良い．どちらも英語のoperatorの和訳である．演算子は普通アルファベット以外のシンボル1個で表現し，変数や関数の前に置いて直後の変数や関数に作用させるか，2個の変数や関数の中間に置いてその両者に作用させる．例えば $-x$ のマイナス記号 $(-)$ は変数の前に置いて直後の変数 $x$ に作用する演算子であり，$x+y$ のプラス記号 $(+)$ は2個の変数の間に置いてその両者 $(x, y)$ に作用する．

1個の変数または関数に作用する演算子を#keyword[単項演算子]と呼び，2個の変数または関数に作用する演算子を#keyword[二項演算子]と呼ぶ．本書では単項演算子はすべて変数の前に置く，すなわち#keyword[前置]する．前置する演算子のことを#keyword[前置演算子]と呼ぶが，数学者は同じものを左作用素と呼ぶ．

Haskellには単項マイナス $(-)$ を除いて他に単項演算子はない．

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

例えば $(1+)$ は $((+)1)$ と等価であり，和は#keyword[交換則]を満たすので $(+1)$ とも等価である．ただし，マイナス演算子 $(-)$ だけは例外で，$(-1)$ はマイナス $1$ を表す．#footnote[Haskell は $(1+)$ を ```haskell (1+)``` と書く．また ```haskell (-1)``` はセクションではなくマイナス $1$ を表す（```haskell -1``` というリテラルとみなされる）．ただし ```haskell (- 1)``` のように空白を挟んでも同じくマイナス $1$ とみなされる（```haskell 1``` というリテラルに単項マイナス演算子が適用される）．]

なお，二項演算子の結合性，すなわち左結合か右結合かは，演算子によって異なる．また演算の優先順位を明示的に与えるために括弧が用いられる．

一般の2引数関数 $f$ を中置演算子に変換する記号 $haskell.infix(f)$ を今後用いる．この記号を用いると値 $f x y$ のことを $x haskell.infix(f) y$ と書くことができる．#footnote[Haskellでは $x haskell.infix(f) y$ を ```haskell x `f` y``` と書く．]

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

このコードを本書の記法で書けば $z = g(f x)$ である．この式から括弧を省略して $z = g f x$ としてしまうと，関数適用は左結合するから $z = (g f) x$ の意味になってしまう．関数 $g$ が引数に関数を取るので無い限り $(g f)$ は無意味なので $ z = g(f x)$ の括弧は省略できない．

ここで，引数のことは忘れて，関数 $f$ と関数 $g$ を先に#keyword[合成]しておきたいとしよう．その合成を $g compose f$ と書く．演算子 $compose$ は#keyword[関数合成演算子]と呼ぶ．合成はラムダ式を使って
#par-equation($ g compose f = g(f lozenge.stroked.medium) $)
と定義できる．#footnote[Haskellでは関数 ```haskell g``` と関数 ```haskell f``` の合成は ```haskell g . f``` である．式 $z = (g compose f) x$ は ```haskell z = (g . f) x``` と書く．]

関数合成演算子は，連続して用いることができる．関数合成演算子は左結合するので，関数 $f, g, h$ について $h compose g compose f = (h compose g) compose f$ であるが，これを展開すると以下のようになる．
#par-equation($ (h compose g) compose f &= (h compose g)(f lozenge.stroked.medium) \
  &= h(g(f lozenge.stroked.medium)) \
  &= h compose (g compose f) $)
そのため関数合成は順序に依存せず，次の関係が成り立つ．

$ h compose g compose f = h compose (g compose f) $<composition-associativity>

@composition-associativity で示される関係を#keyword[結合則]と呼ぶ．

#pb

Haskellには「何もしない」関数 $id$ が用意されている．関数 $id$ は引数をそのまま返す関数で，
#par-equation($ id x = x $)
と定義される．関数 $id$ は#keyword[恒等関数]と呼ばれる．

恒等関数は何もしない関数なので，任意の関数 $f$ に対して以下の等式が成り立つ．

$ id compose f = f $<composition-with-identity-function>

@composition-with-identity-function と @composition-associativity をまとめて#keyword[関数の合成則]と呼ぶ．そこで，関数の合成則を箱に入れて掲載しておこう．

#theorem-box(title: "関数の合成則", outlined: false)[
1. 恒等関数の存在：任意の関数 $f$ に対して恒等関数 $id$ ただし $id compose f = f$ が存在する．
2. 結合則：任意の関数 $f, g, h$ について $(h compose g) compose f = h compose (g compose f)$ が成り立つ．
]

#pb

関数合成演算子は演算子の中で優先順位がもっとも高く，関数適用の次に優先される．一方，関数合成演算子とは逆に，結合の優先順位の低い#keyword[関数適用演算子]も考えておくと便利なこともある．関数適用演算子 $haskell.apply$ を次のように定義しておく．
$ f haskell.apply x = f x $

演算子 $haskell.apply$ の優先順位はあらゆる演算子よりも低いものとし，また右結合とする．関数適用演算子を用いて $z = g(f x)$ を書き直すと $z = g haskell.apply f x$ となる．演算子 $haskell.apply$ の優先順位は足し算よりも低いので $f(x + 1)$ は $f haskell.apply x + 1$ と書くこともできる．演算子 $haskell.apply$ を閉じ括弧のいらない開き括弧と考えてもよい．#footnote[Haskellでは $g haskell.apply f x$ を ```haskell g $ f x``` と書く．]

関数適用演算子のもう一つの興味深い使い方は，関数適用演算子の部分適用である．セクション $(haskell.apply x)$ を用いると
#par-equation($ (haskell.apply x)f = (lozenge.stroked.medium haskell.apply x)f = f haskell.apply x $)
であるから，関数適用演算子を関数と引数の順序を逆に書ける．#footnote[Haskell では $(lozenge.stroked.medium haskell.apply x)f$ を ```haskell ($x)f``` と書く．]

=== 高階関数

関数を引数に取ったり，あるいは関数を返す関数のことを#keyword[高階関数]と呼ぶことがある．関数合成演算子と関数適用演算子は高階関数の好例である．

他に例えば，引数として整数 $n$ を取り，関数 $f x = n+x$ を返すような関数 $g$ を次のように定義することが出来る．
$ g n = n+lozenge.stroked.medium $

このとき，
$ f &= g 100 \
  x &= f 1 $
とすれば $x = 101$ を得る．#footnote[Haskell では $g n = n+lozenge.stroked.medium$ を $g n = backslash x |-> n+x$ と展開しておいて ```hsakell g n = \ x -> n + x``` と書く．]

高階関数は今後度々顔をだすことになる．後で登場する#keyword[マップ演算子]や#keyword[畳込み演算子]は高階関数の一種である．

#pb

ラムダ式をサポートするほとんどのプログラミング言語は，#keyword[レキシカルクロージャ]をサポートする．レキシカルクロージャとは，ラムダ式が定義された時点での，周囲の環境をラムダ式に埋め込む機構である．例えば
#par-equation($ n &= 100 \
  g &= lozenge.stroked.medium + n $)
というラムダ式があるとする．当然我々は関数 $g$ がいつも $g = lozenge.stroked.medium + 100$ であることを期待するし，Haskellにおいてはいつも保証される．#footnote[Haskellでは ```haskell n = 100; g = \x -> x + n``` と書く．]

ところが，参照透過性のない言語，言い換えると変数への破壊的代入が許されている言語では，変数 $n$ の値がいつ変わっても不思議ではない．そこで，それらの言語では関数 $g$ が定義された時点での $n$ の値を，関数 $g$ の定義に含めておく．これがレキシカルクロージャの考え方である．

Haskellではそもそも変数への破壊的代入がないので，関数 $g$ がレキシカルクロージャであるかどうか悩む必要はない．あえて言えば，Haskellではラムダ式はいつもレキシカルクロージャである．もしあなたのそばのC++プログラマが「え？　Haskellにはレキシカルクロージャが無いの？」などと聞いてきたら，「ええ，Haskellには破壊的代入すらありませんから」と答えておこう．

=== 余談：IOサバイバルキット1

ここで，実用的なHaskellプログラムについて触れておきたいと思う．

プログラムとは合成された関数である．多くのプログラミング言語では，プログラムそのものにmainという名前をつける．本書では#keyword[IOモナド]の章で述べる理由によって，main関数をボールド体で $haskell.main$ と書く．

実用的なプログラムはユーザからの入力を受け取り，関数を適用し，ユーザへ出力する．Haskellではユーザからの1行の入力を $haskell.getLine$ で受け取り，変数の値を $haskell.print$ で書き出せる．ここに $haskell.getLine$ と $haskell.print$ は関数（ファンクション）ではあるが，特別に#keyword[アクション]とも呼ぶ．関数 $haskell.main$ もアクションである．

ユーザ入力をただ受け取り，そのままユーザへ出力するプログラムをHaskellで書くと次のようになる．#footnote[Haskellでは ```haskell main = print =<< getLine ``` と書く．]

$ haskell.main = haskell.print haskell.bind haskell.getLine $
<first-bind>

新しい演算子 $haskell.bind$ は新たな関数合成演算子である#keyword[左バインド演算子]であり，アクションとアクションを合成するための特別な演算子である．詳細は#keyword[モナド]の章で述べる．

#pb

何らかの数値計算を行うプログラムは，ユーザ入力を数値として読み取り，数値に作用する関数を適用し，結果をユーザへ出力する．つまり @first-bind の $haskell.print$ と $haskell.getLine$ の間に数値計算を行う任意の関数 $f$ を挿入すれば良いことになる．ただし関数 $f$ は数値を受け取って数値を返すものだから，ユーザ入力すなわち#keyword[文字列]を数値に#[変換]する必要がある．幸いHaskellは型の違いを吸収する $haskell.read$ 関数を提供している．

いま，任意の関数として引数 $x$ の2乗を求める関数 $f$ を次のように定義しよう．

$ &f colon.double haskell.Double -> haskell.Double\
  &f x = x times x $
<double-function>

@double-function の1行目は関数 $f$ の#keyword[型]を表している．型に関しては後述する．

ユーザからの入力に関数 $f$ を適用してユーザへ出力するプログラムをHaskellで書くと次のようになる．

$ haskell.main = haskell.print compose f compose haskell.read haskell.bind haskell.getLine $<first-main>

@double-function と@first-main に対応するHaskellコードは次のようになる．ここに ```haskell .``` は関数合成演算子 $(compose)$ であり ```haskell =<<``` は左バインド演算子 $(haskell.bind)$ である．

#sourcecode[```haskell
-- Haskell
f :: Double -> Double
f x = x * x
main = print . f . read =<< getLine
```]

Haskell Stackを使う場合は `Main.hs` を次のように書き換えると良いだろう．

#sourcecode[```haskell
-- haskell
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

- 二項演算子は2引数関数の特別な記法である．任意の二項演算 $x haskell.anyop y$ と $(haskell.anyop) x y$ は等しい．
- 任意の二項演算子 $haskell.anyop$ から $(haskell.anyop x)$ や $(x haskell.anyop)$ といった単項演算子を作ることができる．これらの単項演算子を「セクション」と呼ぶ．ただし $(-x)$ は例外的に単項マイナスである．
- 任意の2引数関数 $f$ は $haskell.infix(f)$ と書くことで中置演算子となる．例えば $f x y$ と $x haskell.infix(f) y$ は等しい．
- 適切なふたつの関数は関数合成演算子 $(compose)$ を用いて合成できる．
- 関数合成では結合則 $(h compose g) compose f = h compose (g compose f)$ が成り立つ．
- 恒等関数 $id$ が存在する．恒等関数と任意の関数との合成関数は元の関数である．
- 関数適用演算子 $haskell.apply$ を導入する．$f haskell.apply x$ と $f x$ は等しい．演算子 $haskell.apply$ はあらゆる演算子よりも優先順位が低く，右結合である．
- Haskellでは関数を返す関数を定義できる．このような関数を「高階関数」と呼ぶ．

#showybox(title: "式の評価順序")[Haskellは参照透過性を持つ言語なので，式がいつ評価されるかを考える必要はない．一方で参照透過性を持たない言語では，式の評価順序をいつも気にしておく必要がある．例えばC言語は関数引数の評価順序を定めていないので，次のコードは画面に `1 2` を出力する場合もあるし `2 1` を出力する場合もある．
#sourcecode[```c
int i = 0;
printf("%d %d\n", ++i, ++i);
```]
なおC++17では，関数引数の評価順序は未定義であるものの，逐次評価であることは保証される．すなわち，関数引数は並列には評価されないことが明記された．]

== 型
<types>

Haskellの変数，関数にはすべて型がある．プログラマの言う型とは，数学者の言う集合のことである．本章ではHaskellが扱う基本的な型であるデータ型と，パラメトリックな型である多相型，および型の型である型クラスについて述べる．また関数のカリー化についても述べる．

=== データ型

Haskellのすべての変数，関数には#keyword[型]がある．代表的な型には整数型，浮動小数点型，ブール型，文字型がある．整数型を $haskell.Int$ で，浮動小数点型を $haskell.Double$ で表すことはすでに述べたとおりである．


型とは変数が取りうる値に言語処理系が与えた制約のことである．Haskellを含む多くのコンパイラ言語は#keyword[静的型付け]と言って，コンパイル時までに変数の型が決まっていることをプログラマに要求する．一方，Pythonのようなインタプリタ言語はたいてい#keyword[動的型付け]と言って，プログラムの実行時まで変数の型を決めない．

変数に型の制約を設ける理由は，プログラム上のエラーが減ることを期待するためである．例えば真理値が必要とされるところに整数値の変数が来ることは悪い予兆である．一方でC17までのC言語のように全ての変数にいちいち型を明記していくのも骨が折れる．

数学者や物理学者は変数に型の制約を求める一方，新しい変数の型は明記せず読者に推論させる方法をしばしばとる．例えば物理学では，質量 $m$ は「スカラー」という型を持つし，速度 $v$ は「3次元ベクトル」という型を持つ．スカラーと3次元ベクトルの間に足し算は定義されていないため，例えば $m+v$ という表記を見たときに，両者の型を知っていれば直ちにエラーであることがわかる．

Haskellはコンパイラが型推論を行うことで，型が自明の場合は型を省略することができる．#footnote[C23およびC++11以降は```c auto```キーワードを導入し，Haskellと同様の型推論を行うようになった．]

#pb

Haskellにはよく使う型が予め用意されている．

Haskellには2種類の#keyword[整数型]があり，ひとつは#keyword[固定長整数型]で，もうひとつは#keyword[多倍長整数型]である．我々は前者を $haskell.Int$ で，後者を $haskell.Integer$ で表す．多倍長整数型はメモリの許す限り巨大な整数を扱えるので，整数全体の集合に近いのであるが，本書では主に固定長整数型を用いる．この $haskell.Int$ はCの ```c int``` と似た「計算機にとって都合の良い整数」である．計算機にとって都合の良い整数とは，例えば64ビット計算機の場合 $-2^(63)$ から $2^(63)-1$ の間の整数という意味である．#footnote[Haskellでは $haskell.Int$ を ```haskell Int``` で表す．]

変数 $x$ の型が $haskell.Int$のとき，以下のように#keyword[型注釈]を書く．#footnote[Haskellでは ```haskell x :: Int``` と書く．]

$ x colon.double haskell.Int $

型注釈と値の代入は同時に行える．例えば $haskell.Int$ 型の変数 $x$ に $1$ を代入することは次のように書く．#footnote[Haskellでは ```haskell x :: Int = 1``` と書く．]

$ x :: haskell.Int = 1 $

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
#par-equation($ f colon.double underparen(haskell.Int, x) -> underparen(haskell.Int, f x) $)
のようにイメージすると良い．これは関数 $f$ が集合 $haskell.Int$ から集合 $haskell.Int$ への#keyword[写像]であると読む．#footnote[Haskellでは ```haskell f :: Int -> Int``` と書く．なお正確には矢印記号 $(->)$ は型コンストラクタである．無名の型引数を $lozenge.filled.medium$ で表すと $->$ は $(lozenge.filled.medium -> lozenge.filled.medium)$ という，ふたつの型引数を取る型コンストラクタである．
]

Haskellではすべての変数，関数に型があり，型はコンパイル時に決定されていなければならない．ただし，式から#keyword[型推論]が行える場合は型注釈を省略できる．

=== カリー化

Haskellでは，どのような関数であれ引数は1個しかとらない．引数が2個あるように見える関数として，例えば $g x y$ があったとしよう．ここに $g$ は関数，$x$ と $y$ は変数である．関数適用は左結合であるから，これは $(g x)y$ である．ここに $(g x)$ は引数 $y$ をとる関数であると見ることができる．つまり，関数 $g$ とは引数 $x$ をとり「引数 $y$ をとって値を返す関数 $(g x)$ を返す」関数であると言える．

二項演算 $x + y$ は $(+)x y$ とも書けたことを思い出そう．これも左結合を思い出すと $(+)x y = ((+)x)y$ であるから，$y$ という引数を $((+)x)$ という関数に食わせていると解釈できる．

ラムダ式の場合は話はもっと単純で，形式的に
#par-equation($ backslash x y |-> x + y = backslash x |-> (backslash y |-> x + y) $)
のように展開すれば1引数にできる．矢印 $|->$ は#keyword[右結合]である．そこでこのラムダ式は括弧を省略して
#par-equation($ backslash x y |-> x + y = backslash x |-> backslash y |-> x + y $)
とも書かれる．

複数引数をとる関数を1引数関数に分解することを#keyword[カリー化]と呼ぶ．これはこの分野の先駆者である#keyword[ハスケル・カリー]の名前に由来する．

整数引数を二つ取り，整数を返す関数 $g$ は
#par-equation($ g colon.double haskell.Int -> haskell.Int -> haskell.Int $)
という型を持つ．写像の矢印記号は右結合するので，これは
#par-equation($ g colon.double haskell.Int -> (haskell.Int -> haskell.Int) $)
と同じ意味である．上式は
#par-equation($ g colon.double underparen(haskell.Int, x) -> underparen(overparen(haskell.Int, y) -> overparen(haskell.Int, (g x)y), g x) $)
のようにイメージすると良い．自然言語で考えると $haskell.Int$ 型の引数を一つ取り，$haskell.Int$ 型の引数を一つ取って $haskell.Int$ 型の値を返す関数を返す，と読める．#footnote[関数の型に出てくる $->$ は2引数をとる型コンストラクタである．型コンストラクタに関しては〜〜〜で詳しく述べる．例えば $haskell.a -> haskell.b$ という型は $haskell.typeconstructor2((->), haskell.a, haskell.b)$ の別名であり，型コンストラクタ $(->)$ に型引数 $haskell.a$ と $haskell.b$ を与えたものと読む．]

#pb

Haskellには#keyword[タプル]という型がある．タプルとは，複数の変数を組み合わせたもので，例えば変数 $x$ と $y$ をひとまとめにした $paren.l.stroked x, y paren.r.stroked$ はタプルである．変数 $x$, $y$ の型は同じでも良いし，異なっても良い．#footnote[Haskellでは $paren.l.stroked x, y paren.r.stroked$ を ```haskell (x, y)``` と書く．]

タプルの型は，要素の型をタプルにしたものである．例えば $haskell.Int$ が2個からなるタプルの型は次のようになる．#footnote[Haskellでは ```haskell z :: (Int, Int)``` と書く．]

$ z colon.double paren.l.stroked haskell.Int, haskell.Int paren.r.stroked $

いまタプルを引数に取る関数 $f paren.l.stroked x, y paren.r.stroked = x + y$ があったとしよう．Haskellにはタプルをとる関数をカリー化する関数 $haskell.curry$ があり，$(haskell.curry f) x y$ は $x + y$ になる．

逆に，カリー化された関数 $f' x y = x + y$ に関しては $(haskell.uncurry f')paren.l.stroked x, y paren.r.stroked$ のように#keyword[アンカリー化]することで，タプルに適用することができる．

タプルの中身の個数は0個または2個以上でなければならず，上限は処理系によって定められている．2個の変数からなるタプルを特別に#keyword[ペア]，3個の変数からなるタプルを特別に#keyword[トリプル]と呼ぶ．中身が0個のタプルを $emptyset$ で表し，特別に#keyword[ユニット]と呼ぶ．#footnote[GHC v8.2.1 は最大62個の変数からなるタプルまで生成できる．]

ユニット $emptyset$ の型は#keyword[ユニット型]で，変数 $x$ がユニット型の場合は次のように書く．#footnote[Haskellでは ```haskell x :: ()``` と書く．]

$ x colon.double haskell.Unit $

ユニット型の変数が取れる唯一の値は#keyword[ユニット] $(emptyset)$ である．#footnote[Haskellではユニットを ```haskell ()``` と書く．ユニットはユニット型の定数である．]

=== 多相型と型クラス

整数型 $(haskell.Int)$ と浮動小数点型 $(haskell.Double)$ はよく似ている．どちらも値同士を比較可能で，それ故どちらにも等値演算子が定義されている．

整数型の等値演算子は 
#par-equation($ (equiv) colon.double haskell.Int -> haskell.Int -> haskell.Bool $)
であり，浮動小数点型の等値演算子は
#par-equation($ (equiv) colon.double haskell.Double -> haskell.Double -> haskell.Bool $)
である．

このように型が異なっても（だいたい）同じ意味で定義されている演算子のことを#keyword[多相的]な演算子と呼ぶ．等値演算子は多相的な演算子の例である．

具体的な型を指定せずに，仮の変数で表したものを#keyword[型パラメタ]と呼ぶ．我々は型パラメタをボールドイタリック体で表す．いま型を表す仮の変数を $haskell.a$ として，等値演算子の型を次のように表現してみよう．

$ (equiv) colon.double haskell.a -> haskell.a -> haskell.Bool $<equiv>

このような型パラメタを用いた型を総称して#keyword[多相型]と呼ぶ．

実は@equiv は不完全なものである．このままでは型 $haskell.a$ に何の制約もないため，等値演算の定義されていない型が来るかもしれないからである．そこで，型自身が所属する，より大きな型があるとしよう．そのような抽象度の高い型を我々は#keyword[型クラス]と呼ぶ．例えば型 $haskell.Bool, haskell.Int,haskell.Integer, haskell.Float, haskell.Double$ は全て等値演算が定義できるので，型クラス $haskell.Eq$ に属すとする．この関係を我々は
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

便利な#keyword[型変換演算子]をひとつ紹介しておこう．型変換演関数 $haskell.fromIntegral$ は
#par-equation($ haskell.fromIntegral colon.double haskell.Integral supset haskell.a
  arrow.r.stroked haskell.a -> haskell.b $)
という型を持ち，$haskell.Integral$ 型クラスの型の変数を任意の型へ変換する．例えば，
#par-equation($ x colon.double haskell.Double = haskell.fromIntegral 1 colon.double haskell.Int $)
とすることで，$haskell.Double$ 型の変数 $x$ に $haskell.Int$ 型の定数を代入できる．#footnote[Haskellでは ```haskell x :: Double = fromIntegral 1 :: Int``` と書く．]

=== 余談：全称量化子

型 $haskell.a$ の変数を引数に取り，型 $haskell.a$ の戻り値を返す関数 $f$ の型注釈は
#par-equation($ f colon.double haskell.a -> haskell.a $)
である．この記法は実はシンタックスシュガーで，本来は次のように書くべきものである．#footnote[Haskellでは ```haskell f :: forall a . a -> a``` と書く．記号 $forall$ が ```haskell forall``` であり，記号 $|=>$ が ```haskell .``` である．]
#par-equation($ f colon.double forall haskell.a |=> haskell.a -> haskell.a $)
ここに $forall$ は#keyword[全称量化子]という記号で，ラムダ式におけるラムダ記号 $(backslash)$ に相当する．Haskellは小文字で始まる型名を型パラメタとみなすため，全称量化子を省略しても型を正しく推論できるのである．

例えば
#par-equation($ f colon.double haskell.Num supset haskell.a arrow.r.stroked haskell.a -> haskell.a $)
は，本来は
#par-equation($ f colon.double forall haskell.a |=> haskell.Num supset haskell.a arrow.r.stroked haskell.a -> haskell.a $)
と書くべきところである．#footnote[Haskellでは ```haskell f :: forall a . Num a => a -> a``` と書く．]

=== この章のまとめ

- Haskellは静的型付け言語である．Haskellの基本的な型を総称して「データ型」と呼ぶ．
- Haskellには2種類の整数型 $(haskell.Int, haskell.Integer)$ と2種類の浮動小数点型 $(haskell.Float, haskell.Double)$ がある．
- Haskellには文字型 $(haskell.Char)$ がある．文字エンコードはUTF-8である．
- Haskellには論理型 $(haskell.Bool)$ がある．論理型の値は $haskell.True$ と $haskell.False$ のみである．
- 変数，関数の型を指示することを「型注釈」と呼ぶ．型注釈は $x colon.double haskell.Int$ のように書く．
- Haskellは型推論を行うため，型注釈を省略できる．
- 関数の型は $f colon.double haskell.Int -> haskell.Int$ のように矢印 $(->)$ を使って書く．
- 複数引数を取る関数を1引数関数に分解することを「カリー化」と呼ぶ．
- 複数変数をひとまとめにする「タプル型」がある．タプルは $paren.l.stroked x, y paren.r.stroked$ のように書く．
- 中身のないタプルのことを「ユニット型」と呼ぶ．ユニット型が持てる唯一の値はユニット $(emptyset)$ である．
- 型はパラメタとして現れることもある．引数と戻り値の型が同じ関数は $haskell.a -> haskell.a$ という型を持つ．これは $forall haskell.a |=> haskell.a -> haskell.a$ のシンタックスシュガーである．
- 型クラスを用いて，型パラメタに制約を与えることが出来る．例えば型 $haskell.a$ に等値 $(equiv)$ が定義されていることを要請する場合は $haskell.Eq supset haskell.a arrow.r.stroked haskell.a$ と書く．

#showybox(title: "べき乗")[
Haskellには2種類のべき乗演算子がある．ひとつは任意の数の整数乗で $x arrow.t n$ である．ここに $x$ は $haskell.Num$ 型クラスの変数で $n$ は $haskell.Integral$ 型クラスの変数である．式 $x arrow.t n$ をHaskellでは ```haskell x ^ n``` と書く．なお演算子 $arrow.t$ は「クヌースの矢印」とも呼ばれる．

もうひとつは実数の実数乗で $x^y$ である．ここに $x, y$ は $haskell.Floating$ 型クラスの変数である．式 $x^y$ をHaskellでは ```haskell x ** y``` と書く．
]

== リスト
<list>

型から作る型を#keyword[コンテナ型]と呼ぶ．代表的なコンテナはある型の#keyword[ホモジニアスな配列]である#keyword[リスト]である．この章ではリストと，リストに対する重要な演算である畳み込み，マップを取り扱う．

=== リスト

同じ型の値を一列に並べたもの，つまりホモジニアスな配列のことをリストと呼ぶ．Pythonではリスト ```python xs``` を次のように定義できる．

#sourcecode[```python
# Python
xs = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```]

我々も $0$ から始まり $9$ まで続く整数のリストを $[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]$ と書くことにしよう．ただし，これでは冗長なので公差が正の#keyword[等差数列]に限って簡略化した書き方を許す．例えば $0$ から $9$ までのリストは $[0, 1, ..., 9]$ と書いても良い．また第2項が省略された場合は公差が $1$ であるとみなす．例えば $[0, ..., 9]$ は $[0, 1, ..., 9]$ と同じである．#footnote[Haskellでは ```haskell [0, 1..9]``` または ```haskell [0..9]``` と書く．ピリオドの数に注意しよう．]

リストの中身の一つ一つの値のことを#keyword[要素]と呼ぶ．要素のことは元と呼んでも良いが，本書では要素と呼ぶことにする．要素も元も英語のelementの和訳である．

複数の型の要素が混在してもよい配列のことを#keyword[ヘテロジニアスな配列]と呼び，ホモジニアスな配列とは区別する．

リストを指す変数は，リストであることを忘れないように変数名に $"s"$ を付けて
#par-equation($ x_"s" = [0, 1, ..., 9] $)
と書くことにする．今後 $square.filled_"s"$ の形をした変数名が出てきたら，それはリスト変数である．なお，変数 $x$ とリスト変数 $x_"s"$ は異なる変数であるとする．#footnote[Haskellでは `s` を変数名にくっつけて ```haskell xs = [0, 1..9]``` のように書く習慣がある．なおピリオドの数に注意しよう．]

#pb

リストの型名は，元の型名をブラケットで包むことで表現する．整数型 $(haskell.Int)$ のリストは $[haskell.Int]$ と書き，整数のリスト型と呼ぶ．一般に型 $haskell.a$ のリストを $[haskell.a]$ と書く．仮の型である $haskell.a$ は型パラメタである．#footnote[Haskellではリスト型 $[haskell.a]$ を ```haskell [a]``` と書く．型 $[haskell.a]$ は正しくは $forall haskell.a |=> [haskell.a]$ のことである．]

型 $haskell.a$ から型 $[haskell.a]$ を生成する演算子を#keyword[リスト型コンストラクタ]と呼んで $[space.thin]$ と書く．型 $[haskell.a]$ は $haskell.ListType(haskell.a)$ のシンタックスシュガーである．#footnote[Haskellでは $haskell.ListType(haskell.a)$ を ```haskell [] a``` と書く．これは ```haskell [a]``` と同じことである．]

型コンストラクタの概念はPythonには無い（必要無い）が，静的型付け言語であるC++のクラステンプレートが相当する．

$[x]$ のように $haskell.a$ 型の変数 $x$ を入れた $[haskell.a]$ 型の変数を作る演算子を#keyword[リスト値コンストラクタ]と呼ぶ．$[haskell.a]$ 型の変数のことを#keyword[リスト変数]とも呼ぶ．$haskell.a$ 型の変数 $x$ からリスト値コンストラクタを使ってリスト$x_"s"$ を作ることは 
#par-equation($ x_"s" = [x] $)
と書く．#footnote[Haskellでは ```haskell xs = [x]``` と書く．]

リスト型を表す $[haskell.a]$ と，1要素のリストである $[x]$ の違いにはいつも気をつけておこう．本書では中身がボールドイタリック体ならばリスト型，中身がイタリック体ならリスト値である．

ある型を包み込んだ別の型を一般にコンテナ型と呼ぶ．コンテナ型は多相型の一種である．また，コンテナ型の変数を#keyword[コンテナ変数]と呼ぶ．

#pb

リストは空でもよい．#keyword[空リスト]は $haskell.emptylist$ で表す．#footnote[Haskellでは空リストを ```haskell []``` で表す．]

関数 $haskell.null$ はリストが空リストかどうかを判定する．リスト $x_"s"$ が空リストの場合 $haskell.null x_"s"$ は $haskell.True$ を，そうでなければ $haskell.False$ を返す．関数 $haskell.null$ は
#par-equation($ haskell.null colon.double [haskell.a] -> haskell.Bool $)
である．

また，同じ要素を繰り返す演算子も用意しておこう．次の#keyword[繰り返し演算子] $haskell.replicate$ は $n$ 個の要素 $x$ を並べたリストを返す．#footnote[Haskellでは ```haskell xs = n `replicate` x``` と書く．]
#par-equation($ x_"s" = n haskell.replicate x $)
このとき，リスト変数 $x_"s"$ の中身は $underbrace([x, x, ..., x])_n$ となる．

#pb

Pythonでは#keyword[リスト内包表記]が使える．例えば $0$ から $9$ までの倍数のリストは次のように作った．

#sourcecode[```python
# Python
xs = [2 * x for x in range(0, 10)]
```]

ここに ```python range(a, b)``` は ```python a``` から増加する方向に連続する ```python b``` 個の整数からなるリストを返すPythonの関数である．

我々も内包表記を
#par-equation($ x_"s" = [2 times x | x in [0, 1, ..., 9]] $)
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

リストは#keyword[結合]できる．例えばリスト $x_"s"$ とリスト $y_"s"$ を結合したリストは $x_"s" smash y_"s"$ と表現する．リストの結合演算子の型は
#par-equation($ (smash) colon.double [haskell.a] -> [haskell.a] -> [haskell.a] $)
である．#footnote[Haskellでは $x_"s" smash y_"s"$ を ```haskell xs ++ ys``` と書く．]

#pb

我々は無限リストを持つことができる．例えば自然数を表すリスト $n_"s"$ は $n_"s" = [1, 2, ...]$ と書くことができる．#footnote[Haskellでは ```haskell ns = [1, 2..]``` と書く．]

無限リストを扱えるのは，我々がいつも遅延評価を行うからである．遅延評価とは，本当の計算は必要になるまで行わないという方式のことである．

もし本当に無限リストを計算機の上で再現する必要があったなら，計算機には無限のメモリが必要になってしまう．しかし我々は，計算が必要になるまで評価を行わないので，無限リストの中から有限個の要素が取り出されるのを待つことができるのである．演算子 $m haskell.take n_"s"$ はリスト $n_"s"$ から最初の $m$ 個の要素からなるリストを返す．いま
#par-equation($ x_"s" = 5 haskell.take n_"s" $)
とすると，リスト $x_"s"$ は $x_"s" = [1, 2, ..., 5]$ という値を持つ．#footnote[Haskellでは ```haskell xs = 5 `take` ns``` と書く．]

演算子 $haskell.take$ の型は
#par-equation($ haskell.take colon.double haskell.Int -> [haskell.a] -> [haskell.a] $)
である．

リスト $x_"s"$ の $n$ 番目の要素には $x_"s" haskell.bangbang n$ とすることでアクセスできる．#footnote[Haskellでは ```haskell xs !! n``` と書く．]

#pb

#keyword[文字列]は $haskell.Char$ 型のリストである．実際 $haskell.String$ 型は
#par-equation($ haskell.kwtype haskell.String eq.def [haskell.Char] $)
と定義されている．#footnote[Haskellでは ```haskell type String = [Char]``` と書く．]

ここにキーワード $haskell.kwtype$ はデータ型の別名，つまり#keyword[型シノニム]を定義するためのキーワードである．

文字列型のリテラルは次のようにダブルクオートで囲んで書く．#footnote[Haskell では ```haskell ts = "Hello, World!"``` と書く．]

$ t_"s" = haskell.constantstring("Hello, World!") $

リストに対するすべての演算は文字列にも適用可能である．

=== 畳み込み

我々はよくリストの総和を表現するために総和演算子 $(sum)$ を使う．総和演算子とはリスト $[x_0, x_1, ..., x_n]$ に対して
#par-equation($ sum [x_0, x_1, ..., x_n] = x_0 + x_1 + ... + x_n $)
で定義される演算子である．

この表現を一般化してみよう．リスト $[x_0, x_1, ..., x_n]$ が与えられたとき，任意の二項演算子を $haskell.anyop$ として
#par-equation($ haskell.fold_a^haskell.anyop [x_0, x_1, ..., x_n]
  = a haskell.anyop x_1 haskell.anyop ... haskell.anyop x_n $)
であると定義する．

この新しい演算子 $haskell.fold$ は#keyword[畳み込み演算子]と呼ばれる．変数 $a$ を#keyword[アキュムレータ]と呼ぶ．アキュムレータは右側の引数が空であった場合のデフォルト値と考えても良い．#footnote[Haskellでは $haskell.fold_a^+ x_"s"$ を ```haskell foldl (+)) a xs``` と書く．]

Python 2.7 には畳み込み演算子に相当する ```python reduce``` 関数があり，リスト ```python xs``` の総和 ```python s``` を次のように求めることが出来た．

#sourcecode[```python
# Python 2.7
xs = [0, 1, 2, 3, 4, 5]
s = reduce(lambda x, y: x + y, xs, 0)
```]

この ```python reduce``` 関数はPythonバージョン3では外部モジュールに移されてしまったが，Rubyには標準関数 ```ruby inject``` として受け継がれている．Rubyでは次のように書ける．

#sourcecode[```ruby
# Ruby
xs = [0, 1, 2, 3, 4, 5]
s = xs.inject(0) { |x, y| x + y }
```]

リストの総和をとる演算子 $sum$ は畳み込み演算子 $haskell.fold$ を用いて
#par-equation($ sum x_"s" = haskell.fold_0^+ x_"s" $)
とすれば得られる．この式は両辺の $x_"s"$ を省略して
#par-equation($ sum = haskell.fold_0^+ $)
とも書く．

リストの要素のすべての積をとる演算子 $product$ は
#par-equation($ product = haskell.fold_1^times $)
とすれば得られる．

畳み込み演算子は第1（上）引数に「$haskell.a$ 型と $haskell.b$ 型の引数を取り $haskell.a$ 型の戻り値を返す」二項演算子，第2（下）引数に「$haskell.a$ 型」の初期値，第3（右）引数に「$haskell.b$ 型のリスト」すなわち $[haskell.b]$ 型の変数を取り，$haskell.a$ 型の値を返す．従って畳み込み演算子の型は
#par-equation($ haskell.fold colon.double (haskell.a -> haskell.b -> haskell.a)
  -> haskell.a -> [haskell.b] -> haskell.a $)
である．

畳み込み演算子には次のようなもう一つのバリエーションがある．
#par-equation($ haskell.foldright_a^haskell.anyop [x_0, x_1, ..., x_n]
  = (x_0 haskell.anyop (x_1 haskell.anyop ... haskell.anyop (x_n haskell.anyop a))) $)
これは#keyword[右畳み込み]と呼ばれる演算子である．#footnote[Haskellでは `foldr (+) xs a` と書く．引数の順序に注意しよう．]

畳み込み演算子の面白い応用例を示そう．リストの結合演算子 $(smash)$ を使うと
#par-equation($ haskell.fold_haskell.emptylist^smash [[0, 1, 2], [3, 4, 5], ...] = [0, 1, 2, 3, 4, 5, ...] $)
であるから，演算子 $haskell.fold_haskell.emptylist^smash$ はリストを平坦化する#keyword[平坦化演算子]である．平坦化演算子はconcat演算子とも呼ばれることもあるが，基本的な演算子であるため特別な記号をつけておこう．我々は
#par-equation($ haskell.flat = haskell.fold_haskell.emptylist^smash $)
と定義することにする．#footnote[Haskellでは演算子 $haskell.flat$ の代わりに ```haskell concat``` 関数を使う．]

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

リストのマップ演算子はリスト内包表記を使って次のようにも書ける．
#par-equation($ f * x_"s" = [f x | x in x_"s"] $)
しかし，マップは演算子として定義しておいたほうが見通しが良くなる．

リストのマップ演算子の型は
#par-equation($ (*) colon.double (haskell.a -> haskell.b) -> [haskell.a] -> [haskell.b] $)
である．矢印 $->$ は右結合なので，これは
#par-equation($ (*) colon.double (haskell.a -> haskell.b) -> ([haskell.a] -> [haskell.b]) $)
の意味でもある．念のため上式に注釈を加えると
#par-equation($ (*) colon.double underbrace((haskell.a -> haskell.b), f)
  -> (underbrace([haskell.a], [x_0, x_1, ..., x_n]) -> underbrace([haskell.b], [f x_0, f x_1, ..., f x_n])) $)
である．ここで $f$ と $(f*)$ の型を並べてみると
#par-equation($ f &colon.double haskell.a -> haskell.b \
  (f *) &colon.double [haskell.a] -> [haskell.b] $)
となり，マップ演算子が何をしているのか一目瞭然になる．

具体例を見てみよう．先程のPythonコードの例にあわせて
#par-equation($ f &= backslash x |-> 100 + x \
  x_"s" &= [1, 2, ..., 5] \
  y_"s" &= f * x_"s" $)
とすると $y_"s"$ の値は $[101, 102, 103, 104, 105]$ となる．#footnote[式の順序はどうでも良い．]

=== 余談：IOサバイバルキット2

1行ごとに3次元ベクトルが並べられた，以下の入力ファイルがあるとする．
#sourcecode[```plain-text
1.0 2.0 3.0
4.5 5.5 6.5
```]
このようなファイル形式は計算機科学者にとって見慣れたものである．#footnote[本物の計算機科学者はこのようなファイルに欠損がないか，あらかじめスクリプトを走らせて検査しておくものである．]

各行つまり各ベクトルごとに，そのノルムを計算して出力するプログラムを書きたいとしよう．まず数列を受け取ってそのノルムを返す関数 $haskell.norm$ を次のように定義する．

$ haskell.norm &colon.double [haskell.Double] -> haskell.Double \
 haskell.norm haskell.emptylist &= 0.0 \
 haskell.norm x_"s" &= haskell.sqrt (sum [x * x | x in x_"s"]) $<norm>

 @norm の1行目に出てくる型 $[haskell.Double]$ は $haskell.Double$ のリストである．

 @norm は関数のパタンマッチングを使っている．引数が空リストつまり $haskell.emptylist$ の場合，関数は $0.0$ を返す．それ以外の場合は，リスト内包表記を使ってノルムを計算して返す．

入力ファイル全体を受け取るにはアクション $haskell.getContents$ を用いる．

入力ファイルを1行毎のリストにするには関数 $haskell.lines$ を用いる．関数 $haskell.lines$ の型は
#par-equation($ haskell.lines colon.double haskell.String -> [haskell.String] $)
である．関数 $haskell.lines$ を用いると，入力 
```haskell "1.0 2.0 3.0\n4.5 5.5 6.5"``` が ```haskell ["1.0 2.0 3.0", "4.5 5.5 6.5"]``` になる．

各行を空白で区切ってリストに格納するには関数 $haskell.words$ を用いる．関数 $haskell.words$ の型は
#par-equation($ haskell.words colon.double haskell.String -> [haskell.String] $)
である．関数 $haskell.words$ を用いると，入力 ```haskell "1.0 2.0 3.0"``` が ```haskell ["1.0", "2.0", "3.0"]``` になる．

文字列を浮動小数点数に変換するには次の関数 $haskell.readDouble$ を用いる．
#par-equation($ haskell.readDouble &colon.double haskell.String -> haskell.Double \
  haskell.readDouble &= haskell.read $)
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
2. 読み込んだ入力を $haskell.lines$ でリストに変換する．
3. 1行毎 $(*)$ のリストを $haskell.words$ で空白で区切ったリストに変換する．
4. 各行について $(*)$ 空白で区切ったリストの1単語ずつ $(*)$ を $haskell.readDouble$ で浮動小数点数に変換する．
5. 各行について $(*)$ 浮動小数点数のリストのノルムを $norm$ で計算する．
6. ノルムのリストを $haskell.print$ で出力する．

@io-survival-kit-2 をHaskellコードで書くと次のようになる．Haskellでは，我々のマップ演算子 $(*)$ を ```haskell <$>``` と書き，我々の左バインド演算子 $(haskell.bind)$ を ```haskell =<<``` と書く．

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

@io-survival-kit-2 において，アクション $haskell.print$ に代えて次の $haskell.printEach$ を用いると，入力と出力を同じ形式にできる．#footnote[Haskell では ```haskell printEach xs = print `mapM_` xs``` と書く．]
#par-equation($ haskell.printEach x_"s" = haskell.print *_"M" x_"s" $)
演算子 $*_"M"$ は#keyword[アクション]版のマップ演算子である．アクションについては @monad で扱う．

=== この章のまとめ

- ホモジニアスな配列を「リスト」と呼ぶ．型 $haskell.a$ のリストを $[haskell.a]$ と表記する．リストを意味する記号 $[]$ を「リスト型コンストラクタ」と呼ぶ．リスト $[haskell.a]$ は $[]_haskell.a$ と表記することもできる．
- リストの値は $[x_0, x_1, ..., x_n]$ のように生成する．リスト値を生成する記号 $[]$ を「リスト値コンストラクタ」と呼ぶ．
- 整数かつ公差が正の等差数列は $[0, 1, ..., 10]$ あるいは $[0, ..., 10]$ 途中を省略して書いても良い．
- 習慣的にリスト変数は $x_"s"$ のように $"s"$ をつけて書く．
- 空リストは $haskell.emptylist$ と表記する．
- リストが空リストかどうかは $haskell.null$ 関数で判定できる．
- $n$ 個の $x$ からなるリスト $x_"s"$ は $x_"s" = n arrow.ccw x$ と生成できる．
- リストは内包表記でも生成できる．
- リストは結合できる．リスト $x_"s"$ と $y_"s"$ の結合は $x_"s" smash y_"s"$ と表記する．
- リスト $x_"s"$ から最初の $n$ 個を取り出す場合は $n arrow.zigzag x_"s"$ と表記する．
- リストの長さは無限でも良い．
- 文字列とは文字型 $(haskell.Char)$ のリストであり，型 $haskell.String$ として定義されている．
- リストは畳み込み演算子 $(haskell.fold)$ で畳み込みが出来る．
- リストはマップ演算子 $(*)$でマップできる．

#showybox(title: "リスト型の表記")[Haskellでは $haskell.a$ 型のリストを $[haskell.a]$ 型あるいは $haskell.List_haskell.a$ 型と表記するが，これは他の型との整合性においていくぶん不便である場合がある．新しいHaskell標準では $haskell.List_haskell.a$ に加えて $haskell.ListNew_haskell.a$ という書き方が認められている．

一方，Haskellのリスト値コンストラクタは $[x]$ または $x:haskell.emptylist$ であり $[]_x$ という書き方は許されない．]

== 再帰
<recursion>

手続き型プログラミングを学習すると，逐次実行，条件分岐，繰り返しで任意のプログラムが書けることを教わるだろう．関数型プログラミングでは，逐次実行を意識することはあまりない．例外は入出力（IO）を扱う場合で，これは @io で扱う．また我々は条件分岐について @curry-style で見てきた．この節では繰り返し処理のための#keyword[再帰]について学ぶ．

=== 関数の再帰適用

自然数 $n$ の#keyword[階乗]は次のように定義される．
#par-equation($ n! = n times (n - 1) times ... times 1 $)
数学者は $0! = 1$ と定義するので，この式は
#par-equation($ 0! &= 1 \
  n! &= n times (n - 1)! $)
という風に「再帰的に」書き直すことが出来る．再帰とは，定義式の両辺に同じ関数名が現れることを指す．#footnote[Yコンビネータを使う場合はこの限りではない．]

自然数の階乗（factorial）を計算する関数をPythonで書くと次のようになる．
#sourcecode[```python
# Python
def fact(n):
  if n == 0:
    return 1
  else:
    return n * fact(n - 1)
```]

Haskellでは後置演算子を定義できないので，Pythonプログラムに倣って関数 $haskell.fact$ として定義しよう．関数は内部で自分自身を適用しても良いので，階乗関数 $haskell.fact$ の定義は次のようになる．
#par-equation($ haskell.fact n = haskell.kwcase n haskell.kwof cases(0 arrow.r.dotted 1,
  square.stroked.dotted arrow.r.dotted n times haskell.fact (n - 1)) $)
と定義できる．関数が自分自身を適用することを関数の#keyword[再帰適用]と呼ぶ．#footnote[Haskellでは ```haskell fact n = case n of { 0 -> 1; _ -> n * fact (n - 1) }``` と書く．]

これで我々は関数の適用，変数の代入，ラムダ式，条件式，再帰の方法を学んだわけである．これだけあれば，原理的にはどのようなアルゴリズムも書くことができる．今日からはカリー風な数学であらゆるアルゴリズムを表現できるのである！

#pb

このように関数は再帰的に呼び出せる．いま $n >= 0$ を前提とすると $n$ 番目のフィボナッチ数を計算する関数 $haskell.fib$ を次のように定義できる．

$ haskell.fib 0 &= 0 \
  haskell.fib 1 &= 1 \
  haskell.fib n &= haskell.fib (n-1) + haskell.fib (n-2) $

二つの自然数の最大公約数（GCD）を計算する関数 $haskell.greatestCommonDivisor$ も再帰的に定義できる．次の例では関数の型定義も一緒に行うことにした．また中置演算子 $percent$ は剰余を表す．
#par-equation($ haskell.greatestCommonDivisor &colon.double haskell.Int -> haskell.Int -> haskell.Int \
  haskell.greatestCommonDivisor 0 space y &= y \
  haskell.greatestCommonDivisor x y &= haskell.greatestCommonDivisor (x class("binary", percent) y) x $)
このように関数 $haskell.greatestCommonDivisor$ が定義されていると
#par-equation($ n = haskell.greatestCommonDivisor 10 space 15 $)
とすれば $n = 5$ を得る．

=== リストと再帰

数学におけるリストは自由に考えることが出来るが，計算機上ではその実装も考えておかねばならない．我々はリストをLispにおけるリスト構造と同じ構造を持つものとする．Lispにおけるリストとは，変数 $haskell.first$ と 変数 $haskell.rest$ からなるペアの集合である．変数 $haskell.first$ がリストの要素を参照し，変数 $haskell.rest$ が次のペアを参照する．リストの最後のペアの $haskell.rest$ は空リストを参照する．

リストのための特別な表現
#par-equation($ haskell.first : haskell.rest $)
を用い，変数 $haskell.first$ はリストが保持する型，変数 $haskell.rest$ はリスト型であるとする．演算子 $:$ をLispに倣って#keyword[cons演算子]と呼ぶ．リストの構造を @first-and-rest で表す．

#figure(
  image("fig/first-rest.svg"),
  caption: [リストの構造]
)<first-and-rest>

要素 $haskell.rest$ はリストまたは空リストであるから，一般にリストは次のように展開できることになる．

$ [x_0, x_1, x_2, ..., x_n] &= x_0 : [x_1, x_2, ..., x_n] \
  &= x_0 : x_1 : [x_2, ..., x_n] \
  &= x_0: x_1 : x_2 : ... : x_n : haskell.emptylist $

cons演算子 $(:)$ は右結合する．すなわち $x_0 : x_1 : x_2 = x_0 : (x_1 : x_2)$ である．

マップ演算子 $(*)$ の実装は，リストの実装に踏み込めば簡単である．空でないリストは必ず $x : x_"s"$ という形をしているから，次のようにマップ演算子を定義できる．

$ f * haskell.emptylist &= haskell.emptylist \
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
  f haskell.emptylist &= 0\
  f (x : x_"s") &= x $

$f haskell.emptylist$ が $0$ を返すのは不自然だが，関数$f$の戻り型を整数型としているためこれは仕方がない．エラーを考慮する場合は@maybe で述べるMaybeを使う必要がある．

#pb

リストを引数にとる関数はいつでも $f (x : x_"s") = ...$ という風にパタンマッチを行えるが，式の右辺でリスト全体すなわち $(x : x_"s")$ を参照したい場合もあるであろう．そのような場合は
#par-equation($ f a_"s" haskell.at (x : x_"s") = ... $)
として，変数 $a_"s"$ でリスト全体を参照することも可能である．このような記法を#keyword[asパタン]と呼ぶ．#footnote[Haskellでは ```haskell f as @ (x : xs) = ...``` と書く．]

#pb

リストの再帰を使うと，#keyword[クイックソート]も簡単に書くことが出来る．クイックソートは次のように定義できる．

$ haskell.quicksort haskell.emptylist &= haskell.emptylist\
  haskell.quicksort (x : x_"s") 
  &= haskell.quicksort l_"s" smash [x] smash haskell.quicksort r_"s"  \
  & space.nobreak haskell.kwwhere { l_"s" = [l | l in x_"s", l < x ]; r_"s" = [r | r in x_"s", r >= x ] } $

なお，関数は再帰させるたびに計算機のスタックメモリを消費する．これを回避するためのテクニックが，次節で述べる末尾再帰である．

=== 末尾再帰

計算機科学者は，同じ再帰でも#keyword[末尾再帰]という再帰のスタイルを好む．末尾再帰とは，関数の再帰適用を関数定義の末尾にすることである．この章に出てきた階乗関数 $haskell.fact$ を例にとろう．階乗関数 $haskell.fact$ は
#par-equation($ haskell.fact x = haskell.kwcase x haskell.kwof cases(0 arrow.r.dotted 1, square.stroked.dotted arrow.r.dotted x times haskell.fact(x - 1)) $)
のような形をしていた．末尾の関数をよりはっきりさせるために演算子 $(times)$ を前置にして
#par-equation($ haskell.fact x = haskell.kwcase x haskell.kwof cases(0 arrow.r.dotted 1, square.stroked.dotted arrow.r.dotted (times) x space haskell.fact(x - 1)) $)
と書いてみよう．この定義の末尾の式は $(times)x space haskell.fact(x - 1)$ である．これだと末尾の関数は $haskell.fact$ ではなく演算子 $(times)$ なので，末尾に再帰適用を行ったことにはならない．

そこで，次のように形を変えた階乗関数 $haskell.fact'$ を考えてみる．
#par-equation($ haskell.fact' a x = haskell.kwcase x haskell.kwof cases(0 arrow.r.dotted a, square.stroked.dotted arrow.r.dotted haskell.fact' (a times x) space (x - 1)) $)
こうすれば末尾の関数がもとの $haskell.fact'$ と一致する．#footnote[Haskellでは ```haskell fact' a x = case x of { 0 -> 1; _ -> fact' (a * x) (x - 1) }``` と書く．]

関数 $haskell.fact$ が，例えば
#par-equation($ haskell.fact 3 &= 3 times haskell.fact 2 \
  &= 3 times 2 times haskell.fact 1 \
  &= 3 times 2 times 1 times haskell.fact 0 \
  &= 3 times 2 times 1 times 1 \
  &= 6 $)
と展開されるのに対し，同じく $haskell.fact'$ は
#par-equation($ haskell.fact' space 1 space 3 &= haskell.fact' (1 times 3) space (3 - 1) \
  &= haskell.fact' space 3 space 2 \
  &= haskell.fact' (3 times 2) space (2 - 1) \
  &= haskell.fact' space 6 space 1 \
  &= haskell.fact' (6 times 1) space (1 - 1) \
  &= haskell.fact' space 6 space 0 \
  &= 6 $)
であるから，関数 $haskell.fact$ が「横に伸びる」のに対して，関数 $haskell.fact'$ は「横に伸びない」ことになる．計算式が「横に伸びない」性質は，計算機のリソースを無駄に消耗しないことが期待されるため，計算機科学者が好むのである．また末尾再帰は後述する「末尾再帰最適化」のチャンスをコンパイラに与える．

// tail recursive quicksort

Haskellを含む幾つかのプログラミング言語処理系は，コンパイル時に#keyword[末尾再帰最適化]を行う．末尾再帰最適化とは，一言で言うと再帰を計算機が扱いやすいループに置き換えることである．では最初から我々もループで関数を表現しておけば，と思われるかもしれないが，再帰以外の方法でループを表現する場合には必ず変数（ループカウンタ）への破壊的代入が必要になるため，我々は末尾再帰に慎ましくループを隠すのである．#footnote[Schemeは末尾再帰最適化を行うことが言語仕様によって決められている．]

=== 余談：遅延評価

遅延評価のお陰で，Haskellでは#keyword[無限リスト]を扱うことができる．無限リストを扱えるのは，我々がいつも遅延評価を行うからである．遅延評価とは，本当の計算は必要になるまで行わないという方式のことである．

無限リストの応用例として，素数を発見するプログラムを考えてみよう．まずある整数の素因数をすべて見つける関数 $haskell.factors$ を定義する．関数 $haskell.factors$ の定義は次のようになる．ただし $percent$ は整数の剰余を表す中置演算子である．

$ haskell.factors &colon.double haskell.Int -> [haskell.Int] \
  haskell.factors n &= [x | x in [1, 2, ...,n], n class("binary", percent) x equiv 0] $

関数 $haskell.factors$ を使うと，ある整数が素数であるかどうかを判定する関数 $haskell.isPrime$ を定義できる．関数 $haskell.isPrime$ の定義は次のようになる．

$ haskell.isPrime &colon.double haskell.Int -> haskell.Bool \
  haskell.isPrime n &= haskell.factors n equiv [1, n] $

素数は2以上の整数で $haskell.isPrime$ が真であるものであるから，素数のリストを $p_"s"$ とすると
#par-equation($ p_"s" = [x | x in [2, 3, ...], haskell.isPrime x] $)
となる．最初の500個の素数を $p_500$ とすると
#par-equation($ p_500 = 500 haskell.take p_"s" $)
となる．

上記のすべてをHaskellで書くと次のようになる．

#sourcecode[```haskell
-- Haskell
factors :: Int -> [Int]
factors n = [x | x <- [1..n], n `mod` x == 0]

isPrime :: Int -> Bool
isPrime n = factors n == [1, n]

ps :: [Int]
ps = [x | x <- [2..], isPrime x]

p500 = 500 `take` ps
```]

このプログラムでは本格的に素数を探索することはできないが，例えば1万個程度の素数なら実用的な時間で計算できる．このように数学的記述をそのままプログラムに書けるところがHaskellの強みである．

#pb

Haskellは意図しない限り遅延評価を行う．これは特に左畳み込み演算子 $union$ を使う場合に問題となる．いま $x_"s" = [x_0, x_1, x_2, x_3]$ とすると，左畳み込み演算 $union_0^+ x_"s"$ は
#par-equation($ haskell.fold_0^+ x_"s" &= union_0^+(x_0 : x_1 : x_2 : haskell.emptylist) \
  &= haskell.fold_(0+x_0)^+(x_1 : x_2 : x_3 : haskell.emptylist) \
  &= haskell.fold_((0 + x_0) + x_1)^+ (x_2 : x_3 : haskell.emptylist) \
  &= haskell.fold_(((0 + x_0) + x_1) + x_2)^+ (x_3 : haskell.emptylist) \
  &= haskell.fold_((((0 + x_0) + x_1) + x_2) + x_3) haskell.emptylist \
  &= (((0 + x_0) + x_1) + x_2) + x_3 $)
と展開される．遅延評価のために，Haskell処理系は値ではなく式をメモリにストアしなければならないが，左畳み込み演算は大きなメモリを必要としがちである．もし例えば予め $0 + x_0$ を先に計算しておくなど左畳み込みだけ先に評価しておけば，大いにメモリの節約になる．そのためにHaskellは「遅延評価無し」の左畳み込み演算子を用意している．#footnote[「遅延評価無し」の左畳み込み演算子をHaskellでは ```haskell foldl'``` と書く．]

=== この章のまとめ

- 関数は最適に適用できる．再帰とは定義式の両辺に同じ関数名が現れることである．
- リストも再帰的に定義されており $[x_0, x_1, ..., x_n]$ は $x_0 : [x_1, ..., x_n]$ であり $x_0 : x_1 : ... : x_n : haskell.emptylist$ である．
- リストを受け取る関数は $f(x:x_"s")$ または $f a_"s" @ (x:x_"s")$ のように引数を受け取れる．
- 関数の再帰的適用を行う場合は「末尾再帰」を行うことが望ましい．

#showybox(title: "スターリンソート")[
$ haskell.stalinSort &colon.double haskell.Ord supset haskell.a arrow.r.stroked [haskell.a] -> [haskell.a] \
  haskell.stalinSort haskell.emptylist &= haskell.emptylist \
  haskell.stalinSort [x] &= [x] \
  haskell.stalinSort (x : y : z_"s") &|_(x <= y) = x : haskell.stalinSort (y : z_"s") \
  &|_haskell.otherwise = haskell.stalinSort (x : z_"s") $
]

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
#par-equation($ f x y = haskell.kwif x != 0 haskell.kwthen frac(y, x, style: "skewed") haskell.kwelse haskell.Nothing ... text("不完全な定義") $)
残念ながら上式は不完全である．なぜならば $x != 0$ のときの戻り値は数であるのに対して， $x != 0$ のときの戻り値は数ではないからである．そこで
#par-equation($ f x y = haskell.kwif x != 0 haskell.kwthen haskell.Just((frac(y, x, style: "horizontal"))) haskell.kwelse haskell.Nothing $)
とする．ここに $haskell.Just((frac(y, x, style: "horizontal")))$ は数 $frac(y, x, style: "skewed")$ から作られる，値入りのコンテナである．#footnote[Haskell では `f x y = if x /= 0 then Just y / x else Nothing` と書く．]

この関数 $f$ の戻り値はもはや整数 $(haskell.Int)$ 型とは言えない．そこでこの型を $haskell.MaybeType(haskell.Int)$ と表して「Maybe整数（おそらく整数）」型と呼ぶことにする．型 $haskell.a$ から型 $haskell.MaybeA$ を生成するとき，$haskell.Maybe$ を#keyword[型コンストラクタ]と呼ぶ．#footnote[Haskellでは ```haskell Maybe a``` と書く．]

Maybeで包まれた型を持つ変数は $z_?$ のように小さく $?$ をつける．例を挙げる．#footnote[Haskellでは ```haskell zm :: Maybe Int = Just 1``` と書く．]

$ z_? colon.double haskell.MaybeType(haskell.Int) = haskell.Just(1) $

Maybe変数が値を持たない場合は $z_? = haskell.Nothing$ のように書く．#footnote[Haskellでは ```haskell xm = Nothing``` と書く．]

ここで変数 $z_?$ が取り得る値は正しく計算された値をラップしたものか，あるいはエラーを表す値 $haskell.Nothing$ である．このように計算結果に「意味付け」をすることを#keyword[文脈]に入れると言う．#footnote[Maybeを使う方法以外に，リストに入れるという方法もある．正しい計算が出来た場合は $[frac(y, x, style: "skewed")]$ を，そうでない場合は $haskell.emptylist$ を返す関数を作る方法はある．ただし，計算の失敗を表現する場合はその目的のために設計されたMaybeのほうが相応しい．]

一度Maybeになった変数を非Maybeに戻すことは出来ない．変数 $z$ が一度ゼロ除算の危険性に「汚染」された場合，その後ずっとMaybe変数に入れ続けなければいけない．そこで，普通の変数を引数にとる関数 $f$ にMaybe変数 $z_?$ を食わせるには，リストの時と同じようなマップ演算子が必要になる．具体的には，変数 $x$ が $haskell.Int$ 型として，Maybe変数 $x_?=haskell.Just(x)$ が与えられたとき
#par-equation($ f ast.op.o_? x_? = haskell.Just(f x) $)
となるようなMaybeバージョンのマップ演算子 $ast.op.o_?$ を用いる．ここに $f ast.op.o_? x_?$ の型は，もし $f colon.double haskell.Int -> haskell.Float$ ならば $haskell.MaybeType(haskell.Float)$ である．#footnote[Haskellでは $f ast.op.o_? x_?$ を ```haskell f <$> xm``` と書く．]

実際には $x_? equiv haskell.Nothing$ の可能性も考えなければならないから，Maybeバージョンのマップ演算子は
#par-equation($ f ast.op.o_? haskell.Just(x) &= haskell.Just(f x) \
  f ast.op.o_? haskell.Nothing &= haskell.Nothing $)
と定義すれば得られる．#footnote[Haskellでは ```haskell f <$> Just x  = Just (f x); f <$> Nothing = Nothing``` と書く．]

今後，普通の（引数にMaybeが来ることを想定していない）関数 $f$ をMaybe型である変数 $x_?$ に適用させるときには，必ず
#par-equation($ z_? = f ast.op.o_? x_? $)
のようにMaybeバージョンのマップ演算子 $ast.op.o_?$ を用いることにする．これはプログラムの安全性のためである．変数が一旦ゼロ除算の可能性に汚染されたら，最後までMaybeに包んでおかねばならない．

#pb

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

整数 $x$ からMaybe値 $u_? = haskell.Just(x)$ を作り，関数 $g x = 1 + x$ をMaybe値 $u_?$ に食わせてMaybe値 $v_?$ ただし $v_? = g ast.op.o_? u_?$ を得ることをC++では次のように書くことになる．
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

$ z_? = (f *) ast.op.o_? x_? $

=== リストとMaybe

関数 $f$ をMayby値 $x_?$ に適用するために
#par-equation($ z_? = f ast.op.o_? x_? $)
のようなMaybeバージョンのマップ演算子 $(ast.op.o_?)$ を使った．一方で，同じ関数 $f$ をリスト $x_"s"$ に適用するには
#par-equation($ z_"s" = f * x_"s" $)
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
#par-equation($ e_! colon.double haskell.EitherType(haskell.a, haskell.b) $)
と書く．#footnote[Haskellでは ```haskell Either a b``` と書く．]

Eitherには値コンストラクタが2種類あり，それぞれ $haskell.Right(x)$ と $haskell.Left(x)$ である．値コンストラクタは
#par-equation($ e_! = haskell.Right(x) $)
または
#par-equation($ e_! = haskell.Left(x) $)
のように使う．#footnote[Haskellではそれぞれ ```haskell e = Right x``` および ```haskell e = Left x``` と書く．]

Eitherはより複雑な計算エラーが発生する場合に用いる．Maybeが単に失敗を表す $haskell.Nothing$ しか表現できなかったのに対し，Eitherは任意の型の変数で表現できる．習慣的に，正しい(right) 計算結果は $haskell.Right(x)$ 値コンストラクタで格納し，残された (left) エラーの情報は $haskell.Left(x)$ 値コンストラクタで格納する．

Either型はCの共有型 (```c union```) やC++のバリアント型 (```cpp std::variant```) に近い．

=== この章のまとめ

- 計算が正しく行われるかもしれないし，正しく行われないかもしれない状態をMaybeで表現できる．
- Maybeはリストと同じく型パラメタをひとつ取る．型 $haskell.a$ のMaybeを $haskell.MaybeType(haskell.a)$ と表記する．
- Maybeの値コンストラクタは引数をひとつ取る $haskell.Just(x)$ と引数を取らない $haskell.Nothing$ のふたつがある．
- 関数 $f colon.double haskell.a -> haskell.a$ をMaybe値 $x_?$ に適用するにはMaybe版のマップ演算子を用いて $z_? = f ast.op.o_? x_?$ と書く．このときの戻り値 $z_?$ はMaybe値である．
- Maybeとよく似た型にEitherがある．Maybeは値か $haskell.Nothing$ かのいずれかであるが，Eitherは右値 $haskell.Right(x)$ か左値 $haskell.Left(x)$ かのいずれかである．
- リストのマップ演算子 $(*)$ とMaybeのマップ演算子 $(ast.op.o_?)$ は形がそっくりである．

#showybox(title: "例外と大域ジャンプ")[多くのプログラミング言語が大域ジャンプをサポートしている．大域ジャンプとは，プログラムのある部分から別の部分へのジャンプを行うことを指す．多くの場合は，プログラムの逐次実行を中断し，ラベルの付けられた別の場所へ飛ぶ機能が提供される．

古典的には ```c goto``` 命令とラベルの組み合わせが大域ジャンプに使われる．プログラム中の ```c goto``` 命令には大した害が無いものの，ラベルはプログラムの可読性を著しく低下させる．ラベルだけでは，どこから飛んできたのか判断がつかないからである．

そもそも大域ジャンプが必要なのはエラー処理などの「例外的な事象」に限ると割り切って，専用の構文を導入したのがプログラミングにおける例外機構である．例外機構によってエラー処理の見通しは良くなるが，例外機構は参照透過性を破壊するため，関数型プログラミング言語では扱いにくい．そのためにMaybeを導入したのがHaskellであり，またオプショナルなどMaybeの劣化コピーが多くのオブジェクト指向プログラミング言語で採用されている．

なお再帰では分かりづらいループに対して ```c goto``` を使うことが手続き型プログラミングでは多く見受けられるが，Schemeのような言語では ```c goto``` を使う代わりに「継続」を使うことによって見通しを良くしている．]

== 関手
<functor>

#keyword[関手型クラス]は，これまで見てきたリスト型やMaybe型のような#keyword[コンテナ型]を一般化した，一段抽象度の高い概念である．この章では「型（type）の型」である「#keyword[型クラス]（type class）」という概念と，リスト型やMaybe型に共通する性質を抽出した関手型クラスを導入する．#keyword[関手]（functor）は数学の#keyword[圏論]（category theory）における概念で，圏から圏への写像を表す．一方Haskellの関手 $(haskell.Functor)$ は型クラスのひとつであり，圏論における関手と対応する概念である．本書では，数学の関手のほうを「#keyword[圏論的関手]」と呼び，Haskellの関手のほうを「#keyword[関手型クラス]」と呼ぶことにする．

=== リストの世界・Maybeの世界

$haskell.a$ 型の変数 $x, y colon.double haskell.a$ について，関数 $f colon.double haskell.a -> haskell.a$ があり
#par-equation($ y = f x $)
であるとしよう．このように型 $haskell.a$ で閉じた世界を仮に「$haskell.a$ 世界」と呼ぶことにする．この世界では，関数 $f$ は値 $x$ を値 $y$ に変換する．

同様に $[haskell.a]$ 型の変数 $u_"s", v_"s" colon.double [haskell.a]$ について，関数 $g colon.double [haskell.a] -> [haskell.a]$ があり
#par-equation($ v_"s" = g u_"s" $)
であるとしよう．このように型 $[haskell.a]$ で閉じた世界を仮に「$[haskell.a]$ 世界」と呼ぶことにする．この世界では，関数 $g$ はリスト変数 $u_"s"$ をリスト変数 $v_"s"$ に変換する．

今度は $haskell.MaybeA$ 型の変数 $s_?, t_? colon.double haskell.MaybeA$ について，関数 $h colon.double haskell.MaybeA -> haskell.MaybeA$ があり
#par-equation($ t_? = h s_? $)
であるとしよう．このように型 $haskell.MaybeA$ で閉じた世界を仮に「$haskell.MaybeA$ 世界」と呼ぶことにする．この世界では，関数 $h$ は値 $s_?$ を値 $t_?$ に変換する．

ここで，変数 $x, y$ と変数 $u_"s", v_"s"$ はリスト値コンストラクタによって
#par-equation($ u_"s" &= [x] \
  v_"s" &= [y] $)
の関係にあるとしよう．リスト値コンストラクタは値を $haskell.a$ 世界から $[haskell.a]$ 世界へとジャンプさせる機能を持っている．また変数 $x, y$ とMaybe変数 $s_?, t_?$ はMaybe値コンストラクタによって
#par-equation($ s_? &= haskell.Just(x) \
  t_? &= haskell.Just(y) $)
の関係にあるとしよう．Maybe値コンストラクタは値を $haskell.a$ 世界から $haskell.MaybeA$ 世界へとジャンプさせる機能を持っている．

他に $haskell.a$ 世界から $[haskell.a]$ 世界や $haskell.MaybeA$ 世界へと「ジャンプ」させるものがあるだろうか．よく考えてみると，マップ演算子もそうである．なぜなら $u_"s" = [x], v_"s" = [y]$ なのだから $haskell.a$ 世界の関数 $f$ と $[haskell.a]$ 世界の関数 $g$ は無関係ではなく
#par-equation($ v_"s" = g u_"s" = f * u_"s" $)
なのであるから
#par-equation($ g = f * $)
が言える．同様に $s_? = haskell.Just(x), t_? = haskell.Just(y)$ なのだから，$haskell.a$ 世界の関数 $f$ と $haskell.MaybeA$ 世界の関数 $h$ は無関係ではなく
#par-equation($ t_? = h s_? = f ast.op.o_? s_? $)
であり
#par-equation($ h = f ast.op.o_? $)
である．つまりリストのマップ演算子 $*$ が関数 $f$ を $haskell.a$ 世界から $[haskell.a]$ 世界へとジャンプさせ，Maybeのマップ演算子 $ast.op.o_?$ が関数 $f$ を $haskell.a$ 世界から $haskell.MaybeA$ 世界へとジャンプさせているのである．ジャンプを波矢印 $(~~>)$ で表すと，次の表のようになる．

#figure(
  caption: "様々な圏",
  table(
    columns: (auto, auto, auto, auto, auto),
    inset: 10pt,
    table.header([世界（圏）], [値（対象）], [写像（射）], [値のジャンプ], [関数のジャンプ]),
    [$haskell.a$ 世界], $x, y$, $y = f x$, [], [],
    [$[haskell.a]$ 世界], $u_"s", v_"s"$, $v_"s" = g u_"s"$, $x ~~> u_"s", y ~~> v_"s"$, $f ~~> g$,
    [$haskell.MaybeA$ 世界], $s_?, t_?$, $t_? = h s_?$, $x ~~> s_?, y ~~> t_?$, $f ~~> h$,
  )
)

いま「世界」と呼んだものを，数学者は#keyword[圏]と呼ぶ．圏とは#keyword[対象]と#keyword[射]の組み合わせである．本書では「対象」とは変数のことであり，射とは関数だと思えば良い．そして，圏から圏へとジャンプさせるもの $(~~>)$ を#keyword[圏論的関手]と呼ぶ．この例で言えば値コンストラク $[x], haskell.Just(x)$ とマップ演算子 $*, ast.op.o_?$ が関手である．値コンストラクタ $haskell.Just(x)$ は $haskell.a -> haskell.MaybeA$ という型を持ち，マップ演算子 $ast.op.o_?$ は $(haskell.a -> haskell.b) -> (haskell.MaybeA -> haskell.MaybeB)$ という型を持つ．

#pb

Haskellではマップ演算子が定義された型を#keyword[関手型クラス]と呼ぶ．具体的には，マップ演算子が定義されたすべての型は $haskell.Functor$ 型クラスのインスタンスであるとする．つまり $haskell.Functor$ 型クラスには一般化されたマップ演算子が定義されており，そのインスタンスであるリストやMaybeは独自のマップ演算子を定義しなければならないということである．

一般化されたマップ演算子を $ast.op.o$ で表そう．この $ast.op.o$ 演算子は
#par-equation($ (ast.op.o) colon.double haskell.Functor supset haskell.f arrow.r.stroked (haskell.a -> haskell.b) -> haskell.f_haskell.a -> haskell.f_haskell.b $)
という型を持つ．ここに $haskell.Functor supset haskell.f$ は，$haskell.f$ が $haskell.Functor$ 型クラスに属すという制約を表している．また $haskell.f$ は型コンストラクタであり，$haskell.f_haskell.a$ は $haskell.f$ 型コンストラクタと$haskell.a$ 型によって作られたコンテナ型である．

もし型コンストラクタがリスト型コンストラクタであれば，つまり $haskell.f = [space.thin]$ であれば
#par-equation($ (ast.op.o) colon.double (haskell.a -> haskell.b) -> [haskell.a] -> [haskell.b] = (*) $)
であるし，もし型コンストラクタがMaybe型コンストラクタであれば，つまり $haskell.f = haskell.Maybe$ であれば
#par-equation($ (ast.op.o) colon.double (haskell.a -> haskell.b) -> haskell.MaybeA -> haskell.MaybeB = (ast.op.o_?) $)
である．

リストとMaybeは両者ともマップ演算子（と値コンストラクタ）を持つ．両者の関係をまとてみたのが @types-and-map-operators である．オブジェクト指向プログラマなら，リストとMaybeに共通のスーパークラスを設計したくなるであろう．それが型クラス $haskell.Functor$ である．

#figure(
  caption: "型とマップ演算子",
  table(
    columns: (auto, auto, auto, auto),
    inset: 10pt,
    table.header([型], [型コンストラクタ], [マップ演算子], [変数の具体例]),
    [$[haskell.a]$ または $haskell.ListType(haskell.a)$], $[space.thin]$, $*$, $[x]$,
    $haskell.MaybeA$, $haskell.Maybe$, $ast.op.o_?$, $haskell.Just(x)$,
    $haskell.Functor supset haskell.f arrow.r.stroked haskell.f_haskell.a$, $haskell.f$, $ast.op.o$, [具体的な型による]
  )
)
<types-and-map-operators>

=== 関手と関手則
<functor-and-functor-laws>

Haskellの関手すなわち $haskell.Functor$ 型クラスに求められるのは，マップ演算子 $(ast.op.o)$ を持つことだけではない．関手のマップ演算子は，次の#keyword[関手則]を満たす必要がある．

#theorem-box(title: "関手則", outlined: false)[
1. 恒等射の存在（保存）：マップ演算子 $(ast.op.o)$ は $id ast.op.o x_* = id x_*$ を満たす．
2. 結合則：マップ演算子 $(ast.op.o)$ は $g ast.op.o (f ast.op.o x_*) = (g compose f) ast.op.o x_*$ /* $(g compose f) ast.op.o = (g ast.op.o) compose (f ast.op.o)$ */ を満たす．
]

まず関数 $id$ を定義しておくと，これは引数をそのまま返す関数で
#par-equation($ id x = x $)
である．引数 $x$ は変数でも関数でも良いので，ラムダ式を使って
#par-equation($ id &= lozenge.stroked.medium \
  &= backslash x |-> x $)
と書いたほうがわかり良いかもしれない．

さて，関手則には#keyword[射]（しゃ）という言葉が出てきている．数学的には，射は関数を一般化させたものであるが，Haskellでは射と関数を同じ意味で用いる．射は英語のarrowまたはmorphismの翻訳である．

恒等射の保存はリストを考えると簡単に理解できる．リスト変数 $x_"s"$ の各要素に恒等関数 $id$ を適用した結果は，次の式の通りリスト変数 $x_"s"$ そのものである．#footnote[任意の関数 $f$ と任意の値コンストラクタ $chevron.l.closed square.filled chevron.r.closed$ について $f ast.op.o chevron.l.closed x chevron.r.closed = chevron.l.closed f x chevron.r.closed$ が成り立つことをマップ演算子 $(ast.op.o)$ の準同型性と呼ぶ．Haskellでは関手の準同型性を規則にしていないが，後に述べるアプリカティブ関手のインスタンスについては準同型性を要求する．]

$ id * x_"s" &= [id x | x in x_"s"] \
  &= id [x | x in x_"s"] \
  &= id x_"s" $

同じことをMaybeについてもやってみると，次のようになる．

$ id ast.op.o_? x_? 
  &= haskell.kwcase x_? haskell.kwof cases(haskell.Just(x) arrow.r.dotted id haskell.Just(x), square.stroked.dotted arrow.r.dotted id haskell.Nothing) \
  &= id x_? $

ここで $x_? equiv haskell.Nothing$ でれば $id ast.op.o_? x_?$ も $haskell.Nothing$ となるので，常に $id ast.op.o_? x_? = id x_?$ が成立する．

関数合成の保存についても，リストを考えると理解しやすい．リスト変数 $x_"s"$ の各要素に関数 $f$ と関数 $g$ を合成した関数 $g compose f$ を適用した結果は，次の式の通りリスト変数 $x_"s"$ の各要素に関数 $f$ を適用した結果に関数 $g$ を適用した結果である．

$ (g compose f) * x_"s" &= [(g compose f) x | x in x_"s"] \
  &= [g(f x) | x in x_"s"] \
  &= g * [f x | x in x_"s"] \
  &= g * (f * x_"s") $

なお $g * (f * x_"s")$ をさらに次のように変形することも可能である．

$ g * (f * x_"s")
  &= g * (f * lozenge.stroked.medium) x_"s" \
  &= (g * lozenge.stroked.medium) compose (f * lozenge.stroked.medium) x_"s" \
  &= (g*) compose (f*) x_"s" $<functor-law-composition>

@functor-law-composition より，一般性を損なうこと無く
#par-equation($ g ast.op.o (f ast.op.o) = (g ast.op.o) compose (f ast.op.o) $)
の関係が得られるから，関手の結合則は
#par-equation($ (g ast.op.o) compose (f ast.op.o) = (g compose f) ast.op.o $)
とも書かれる．#footnote[Haskellではしばしば ```haskell (fmap g) . (fmap f) = fmap (g . f)``` と表現される．]

このような関手則は $haskell.Functor$ 型クラスに求められる規則である．Haskellは $haskell.Functor$ 型クラスに属する型が関手則を満たしているかチェックしないが，Haskellプログラマは $haskell.Functor$ 型クラスの方が関手則を満たすことを期待する．

#pb

関数の結合則が成り立っていることも確認しよう．任意の関数 $f, g colon.double haskell.a -> haskell.a$ について
#par-equation($ (g compose f) ast.op.o x_?
  &= haskell.kwcase x_?
  haskell.kwof cases(haskell.Just(x) arrow.r.dotted haskell.Just((g compose f) x),
  square.stroked.dotted arrow.r.dotted haskell.Nothing) \
  &= haskell.kwcase x_?
  haskell.kwof cases(haskell.Just(x) arrow.r.dotted haskell.Just(g (f x)),
  square.stroked.dotted arrow.r.dotted haskell.Nothing) \
  &= haskell.kwcase x_?
  haskell.kwof cases(haskell.Just(x) arrow.r.dotted g ast.op.o haskell.Just(f x),
  square.stroked.dotted arrow.r.dotted haskell.Nothing) \
  &= haskell.kwcase x_?
  haskell.kwof cases(haskell.Just(x) arrow.r.dotted g ast.op.o (f ast.op.o x),
  square.stroked.dotted arrow.r.dotted haskell.Nothing) \
  &= g ast.op.o (f ast.op.o x)
$)
であるから，結合則も成り立っている．

=== アプリカティブ関手

関手のマップ演算子 $(ast.op.o)$ をさらに汎用性のあるものにするために新しく考え出された演算子が#keyword[アプリカティブマップ演算子]である．

いま1変数を取る関数 $f colon.double haskell.a -> haskell.a$ があり，リスト変数 $x_"s" colon.double [haskell.a]$ があるとする．型 $haskell.a$ は任意の型である．リスト変数 $x_"s"$ の各要素に関数 $f$ を適用した結果をリスト変数 $z_"s"$ とする．このことを我々は関手マップ演算子 $(ast.op.o)$ を用いて次のように書いた．

$ z_"s" = f ast.op.o x_"s" $<functor-map>

@functor-map は次のように書いても同じである．

$ z_"s" = [f x | x in x_"s"] $

ここで2引数を取る関数 $g colon.double haskell.a -> haskell.a -> haskell.a$ があるとする．この関数 $g$ をリスト変数 $x_"s"$ の各要素と，別なリスト変数 $y_"s"$ の各要素に適用した結果をリスト変数 $z'_"s"$ とする．このことを我々はどのように書いたら良いだろうか．

いま関数 $g$ にリスト変数 $x_"s"$ だけを適用した結果を関数 $g'$ とする．関数 $g'$ は次のようになる．

$ g' &= [g x | x in x_"s"] \
  &= g ast.op.o x_"s" $<partial-application-of-g>

式の右辺がリストであることから分かる通り，関数 $g'$ はリストである．いま我々が欲しいのは，関数リスト $g'$ をリスト変数 $y_"s"$ の各要素に適用する演算子である．なお @partial-application-of-g の2行目の通り，関数リスト $g'$ は $g ast.op.o x_"s"$ と同じである．さて，関数リスト $g'$ をリスト変数 $y_"s"$ の各要素に適用する演算子を $ast.square$ とする．そうすると次のように書ける．

$ z'_"s" &= g' ast.square y_"s" \
  &= g ast.op.o x_"s" ast.square y_"s" $<applicative-map>

この演算子 $ast.square$ を#keyword[アプリカティブマップ演算子]と呼ぶ．アプリカティブマップ演算子は関手マップ演算子よりも汎用的である．なぜならば
#par-equation($ f ast.op.o x_* = chevron.l f chevron.r ast.square x_* $)
であり，関手マップ演算子 $(ast.op.o)$ はアプリカティブマップ演算子 $(ast.square)$ から導出できるからである．ここに $chevron.l f chevron.r$ は文脈に応じて $[f]$ であったり $haskell.Just(f)$ であったりする．記号 $chevron.l square.filled chevron.r$ を#keyword[ピュア演算子]と呼ぶ．#footnote[Haskellでは ```haskell pure f``` と書く．]

なおピュア演算子の名称は「純粋（pure）」であるが，意味合いはむしろ「不純（impure）」のほうが近い．ピュア演算子によって作られる「空（くう）」を総称して $nothing.rev$ とする．空とは，リストで言えば $haskell.emptylist$ であり，Maybeで言えば $haskell.Nothing$ である．

ピュア演算子を用いると，@applicative-map の2行目は次のように書ける．#footnote[Haskell では `zm = (pure g) <*> xm <*> ym` と書く．]

$ z'_* = chevron.l g chevron.r ast.square x_* ast.square y_* $<applicative-style>

@applicative-style はしばしば添字 $*$ を省略して次のように書かれる．

$ z' = chevron.l g chevron.r ast.square x ast.square  y $<applicative-style-2>

そこで，我々も誤解を招く恐れがない場合は添字 $*$ を省略することにする．

#pb

ピュア演算子とアプリカティブマップ演算子を必ず持つ関手のことを#keyword[アプリカティブ関手]と呼び，型クラス $haskell.Applicative$ に属するものとする．アプリカティブ関手は関手を拡張したものであり，次のアプリカティブ関手則を持つものとする．ただし $x_* colon.double haskell.Applicative supset haskell.f arrow.r.stroked haskell.fa$ とする．

#theorem-box(title: "アプリカティブ関手則", outlined: false)[
1. 恒等射の存在：アプリカティブマップ演算子 $(ast.square)$ は $chevron.l id chevron.r ast.square x_* = id x_*$ を満たす．
2. 結合則：アプリカティブマップ演算子 $(ast.square)$ は $h ast.square (g ast.square f) = chevron.l compose chevron.r ast.square h ast.square g ast.square f$ を満たす．
3. 準同型性： $chevron.l f chevron.r ast.square chevron.l x chevron.r = chevron.l f x chevron.r$ または同じことであるが $f ast.op.o chevron.l x chevron.r = chevron.l f x chevron.r$ である．
4. 交換則： $f ast.square chevron.l x chevron.r = chevron.l (lozenge.stroked.medium haskell.apply x) chevron.r ast.square f$ が成り立つ．
]

これらの規則のうち「恒等射の存在」と「結合則」は関手則から導かれる．

#pb

アプリカティブ関手型クラスは，関手型クラスを拡張したものである．そのため，アプリカティブ関手型クラスに属する型は自動的に関手型クラスにも属する．

リスト型，Maybe型とも，関手型クラスに属すると同時に，アプリカティブ関手型クラスにも属する．また両者ともアプリカティブ関手則を満たす．例えばリスト型の準同型性は次のように確かめられる．
#par-equation($ f * [x] = [f x] $)
ここにリスト型では $ast.op.o = *$ であり，リスト型のピュア演算子 $chevron.l square.filled chevron.r$ はリスト構成の演算子 $[square.filled]$ であることを思い出しておこう．

#pb

アプリカティブマップ演算子を用いると#keyword[アプリカティブスタイル]という記法が使える．関数 $phi, psi$ が引数を文脈に入れる関数，例えば
#par-equation($ phi, psi colon.double haskell.Applicative supset haskell.f arrow.r.stroked haskell.a -> haskell.fa $)
であるとしよう．また関数 $omega$ が2引数を取り
#par-equation($ omega colon.double haskell.a -> haskell.a -> haskell.a $)
という型だとしよう．すると，次のようにコンテナ変数 $u_*, v_*$ を作っておいて，関数 $omega$ を適用させることができる．

$  u_* &= phi x \
  v_* &= psi y \
  w_* &= omega ast.op.o u_* ast.square v_* $

コンテナ変数 $u_*, v_*$ のいずれかが $nothing.rev$ であればコンテナ変数 $w_*$ の値も $nothing.rev$ になる．これは2個の計算を並列に行って，その結果をそれぞれ $u_*, v_*$ に入れておくことを意味する．このような書き方を#keyword[アプリカティブスタイル]と呼ぶ．@legokichi #footnote[Haskellでは ```haskell w = omega <$> (phi x) <*> (psi y)``` と書く．これは ```haskell w = do { u <- phi x; v <- psi y; return (omega u v) }``` と書くのと同じである．]

アプリカティブスタイルは，関数 $omega$ を変数 $u_*, v_*$ にあたかも適用したかのように見える．実際，アプリカティブスタイルはかつて次のように書くことが提案されたが，採用はされなかった．#footnote[現在のHaskellでは ```haskell w = liftA2 omega u v``` と書くことで代用されている．元の提案は `w = [|omega u v|]` であった．]

$ w = [| omega u v |] ... "採用されなかった文法" $

=== 余談：型をつくる

我々はすでにある型に別名を与える方法を見てきた．型シノニムである．例えば $haskell.String$ 型は $haskell.Char$ 型のリストとして定義されていて，次のように書かれている．

$ haskell.kwtype haskell.String eq.def [haskell.Char] $

キーワード $haskell.kwtype$ は型シノニム（#underline[type] synonym）を定義するキーワードである．型シノニムは既存の型に別名を与えるだけなので，真に新しい型を作り出しているわけではない．@mizunashi-mana-data

新しい型を作り出すにはキーワード $haskell.kwdata$ を使う．我々が今まで型（type）と呼んできたものは，実はデータ型（#underline[data] type）と呼ぶのが正式である．そこで，新しい型を作り出すキーワードも $haskell.kwdata$ なのである．型シノニムの定義には新しい型名（例えば $haskell.String$）と，元になる型名（例えば $[haskell.Char]$）をイコール $(eq.def)$ の両辺に書いた．新しい型を作り出す場合は，次式のようにイコールの左辺に新しい型名を書き，右辺に新しい値コンストラクタの名前を書く．

$ haskell.kwdata "型名" eq.def "値コンストラクタ" $

簡単な具体例は次のようなものである．
#par-equation($ haskell.kwdata haskell.Zero eq.def "Zero" $)
ここで左辺の $haskell.Zero$ は新しい型名であり，右辺の $"Zero"$ は新しい値コンストラクタの名前である．この $haskell.Zero$ 型は唯一の値 $"Zero"$ しか持てないので，それほど面白みのある型ではない．それでも
#par-equation($ haskell.kwdata haskell.Zero eq.def "Zero" haskell.kwderiving haskell.Show $)
というふうに型クラス $haskell.Show$ のインスタンスであることを明示すると，Haskellは値 $"Zero"$ を文字列に変換する関数 $haskell.showfunc$ を自動で定義してくれる．そこで
#par-equation($ z = "Zero" $)
として
#par-equation($ s = haskell.showfunc z $)
とすると，$s$ には文字列 $haskell.constantstring("Zero")$ が入る．

#pb

より興味深い型を作るには2種類の方向性がある．ひとつは値コンストラクタに引数を与える方法である．例えば2個の浮動小数点数を組み合わせた型 $haskell.XY$ は次のように定義できる．#footnote[Haskellでは ```haskell type XY = XY Double Double deriving Show``` と書く．]

$ haskell.kwdata haskell.XY eq.def "XY"_(haskell.Double haskell.Double) haskell.kwderiving haskell.Show $

値 $(1.0, 2.0)$ を作り出すには
#par-equation($ v = "XY"_(1.0 space 2.0) $)
とする．値 $v$ は $haskell.XY$ 型の値である．

関数 $haskell.addXY$ を次のように定義してみよう．
#par-equation($ &haskell.addXY colon.double haskell.XY -> haskell.XY -> haskell.XY \
  &haskell.addXY (haskell.XY x y) (haskell.XY x' y') = "XY"_(x + x' space y + y') $)
こうすると
#par-equation($ v &= "XY"_(1.0 space 2.0) \
  v' &= "XY"_(3.0 space 4.0) \
  w &= haskell.addXY v v' $)
とすることで $w$ には $"XY"_(4.0 space 6.0)$ が入る．このように，値コンストラクタに引数をとる新しい型を作ることができる．その構文は次のようなものである．

$ haskell.kwdata "型名" eq.def "値コンストラクタ"_"引数の型" $

もう一つの方向性は#keyword[直和]を使う方法である．直和とは，複数の型を組み合わせた型である．例えば，我々の $haskell.Bool$ 型は値コンストラクタ $haskell.True$ と $haskell.False$ からなる直和である．実際 $haskell.Bool$ 型は次のように定義されている．

$ haskell.kwdata haskell.Bool eq.def haskell.True xor haskell.False $

そこで $haskell.Bool$ 型とよく似た我々独自の型として $haskell.Cool$ 型を作ってみよう．この $haskell.Cool$ 型は $haskell.True, haskell.False$ の代わりに $haskell.Yes, haskell.No, haskell.Dunno$ という3種類の値コンストラクタからなる直和である．また型クラス  $haskell.Show$ のインスタンスであることを明示して関数 $haskell.showfunc$ のデフォルト実装を自動で定義してくれるようにすると同時に，型クラス $haskell.Eq$ のインスタンスであることを明示して値コンストラクタを比較する比較演算子 $(equiv)$ も持つことを保証しよう．ただし比較演算子 $(equiv)$ のデフォルト実装は使えないため，自前で定義することにする．

型の定義は次のようになる．#footnote[Haskellでは ```haskell data Cool = Yes | No | Dunno deriving (Eq, Show)``` と書く．]

$ haskell.kwdata haskell.Cool eq.def haskell.Yes xor haskell.No xor haskell.Dunno haskell.kwderiving (haskell.Eq, haskell.Show) $

比較演算子 $(equiv)$ の定義はキーワード $haskell.kwinstance$ を使って次のように書く．

$ haskell.kwinstance haskell.Eq supset haskell.Cool &haskell.kwwhere \
  &haskell.Yes equiv haskell.Yes = haskell.True \
  &haskell.Yes equiv haskell.Dunno = haskell.True \
  &haskell.No equiv haskell.No = haskell.True \
  &haskell.No equiv haskell.Dunno = haskell.True \
  &haskell.Dunno equiv haskell.Yes = haskell.True \
  &haskell.Dunno equiv haskell.No = haskell.True \
  &haskell.Dunno equiv haskell.Dunno = haskell.True $

否定の比較演算子 $(equiv.not)$ は型クラス $haskell.Eq$ のデフォルト実装が用いられるため，自前で定義する必要はない．

#pb

引数付きの値コンストラクタを使う方法と，直和を使う方法の2種類は組み合わせて用いることができる．例えば，次のような型クラスを作ることも可能である．@damepo

$ haskell.kwdata haskell.typename("Shape") eq.def haskell.Circle_haskell.Double xor haskell.Rect_(haskell.Double haskell.Double) $

// プログラミング言語によっては，型に対する演算を行う機能がある．これを#keyword[型レベルプログラミング]と呼ぶ．Haskellでは型コンストラクタを使ってコンテナ型から新しい型を作ることができるほか，コンテナ型を作ることも出来る． #tk

=== この章のまとめ

- リスト，Maybeはよく似たマップ演算子を持つ．両者を抽象化したものが関手型クラスである．関手型クラスは他にも様々な型をインスタンスとして持つ．
- 関手型クラスに属する型は一般化されたマップ演算子 $(ast.op.o)$ を持つ．
- 関手型クラスに属する型は「関手則」を満たすように設計されなければならない．関手則とは「恒等射の存在」と「結合則」である．
- 関手型クラスを拡張したものがアプリカティブ関手型クラスである．アプリカティブ関手型クラスに属する型はアプリカティブマップ演算子 $(ast.square)$ を持つ．アプリカティブマップ演算子は複数引数を受け取る関数用のマップ演算子と考えられる．
- アプリカティブ関手型クラスに属する型はピュア演算子 $(chevron.l square.filled chevron.r)$ を持つ．ピュア演算子は値を最もシンプルな形でコンテナに包む．
- アプリカティブ関手型クラスに属する型は「アプリカティブ関手則」を満たすように設計されなければならない．アプリカティブ関手則とは「恒等射の存在」「結合則」「準同型性」「交換則」である．
- Haskellでは新しいデータ型を作る仕組みがあり，値コンストラクタに複数の型の変数を引数として与える方法（直積）と，値コンストラクタを選ばせる方法（直和）の両方を混在させられる．

// 関手型クラスが数学での圏にだいたい相当するということ．

#showybox(title: "Haskellの関手と数学の関手")[
Haskellの教科書では「関手」と言った場合，次のような意味を持つ場合がある．
- 関手型クラス $(haskell.Functor)$
- 関手型クラスのインスタンスである型（例：リストやMaybe）
- 関手型クラスのインスタンスである型の変数
- 数学での圏論における関手（functor）

このように紛らわしいことがあるため，本書では数学における「関手」のことを「圏論的関手」と呼ぶことにする．

ややこしいことにC++で ```cpp operator ()``` を実装したクラスのことをファンクタ（functor）と呼ぶことがある．これは関数オブジェクト（function object）の別名で，圏論的関手やHaskellの関手型クラスとは無関係である．C++のファンクタはHaskellのラムダ式に近い．
]

== モナド
<monad>

モナド（Monad）型クラスは，Haskellにおいて複雑な計算や文脈付きの値をシンプルな構造で扱うための抽象的な仕組みである．モナド型クラスは関手型クラスやアプリカティブ関手型クラスをさらに拡張したもので，特に「文脈付きの計算の直列化」を可能にする．モナド型クラスに提供されるバインド演算子によって，，値が「文脈」に包まれていたとしても，その値を取り出したり，新しい計算に適用したりすることができる．これにより，「エラーが起きた場合に自動的に計算を中断する」「副作用をプログラムの他の部分から隔離する」といった柔軟な計算制御が実現できる．

=== バインド演算子

一般マップ演算子をピュア演算子と一般アプリカティブマップ演算子に分解することで，式の見通しを良くすることができるアプリカティブスタイルという記法を採用できた．いま変数 $x, y colon.double haskell.a$ があり，引数を文脈に入れる関数 $phi, psi colon.double haskell.Applicative supset haskell.f arrow.r.stroked haskell.a -> haskell.fa$ および2引数関数 $omega colon.double haskell.a -> haskell.a -> haskell.a$ があるとしよう．すると，アプリカティブスタイルでは次のようにコンテナ変数 $u_*, v_*$ に関数 $omega$ を適用させることができる．

$  u_* &= phi x \
  v_* &= psi y \
  w_* &= omega ast.op.o u_* ast.square v_* $

上式をまとめて書くと次のようになる．

$ w_* = omega ast.op.o (psi y) ast.square (phi x) $<applicative-style-psi-phi>

コンテナ変数 $u_*, v_*$ のいずれかが $nothing.rev$ であれば式全体の値が $nothing.rev$ になる．これは2個の計算を並列に行って，その結果をそれぞれ $u_*, v_*$ に入れておき，最後に関数 $omega$ に投げるという#keyword[計算構造]を具現化したものである．#footnote[@applicative-style-psi-phi はHasellのdo記法を用いると $w_* = haskell.kwdo { u <- phi x; v <- psi y; chevron.l omega u v chevron.r } $ と書くことが出来る．]

一方で，我々は直列に計算を行いたい場合もある．文脈が無い場合，その方法は単純な関数合成 $(compose)$ である．例えば，関数 $f, g, h colon.double haskell.a -> haskell.a$ があるとき，式
#par-equation($ z = (h compose g compose f) x $)
は，変数 $x$ に対してまず関数 $f$ を適用し，その結果に関数 $g$ を適用し，さらにその結果に関数 $h$ を適用するという計算を行う．では文脈がある場合はどうだろうか．我々が欲しいのは，文脈なしの変数 $x$ を受け取って，文脈ありの戻り値を返すような関数を合成する新たな演算子である．そのような演算子は#keyword[バインド演算子]または#keyword[左バインド演算子]と呼ばれる．本書ではバインド演算子を $haskell.bind$ と書く．

関数 $phi', psi', omega'$ ただし
#par-equation($ phi', psi', omega' colon.double haskell.a -> haskell.MaybeA $)
があるとする．変数 $x$ に関数 $phi', psi', omega'$ を連続して適用しようとすると，次のようになる．

$ u_* &= phi' x \
  v_* &= haskell.kwcase u_* haskell.kwof cases(haskell.Just(u) arrow.r.dotted psi' u, square.stroked.dotted arrow.r.dotted haskell.Nothing) \
  w_* &= haskell.kwcase v_* haskell.kwof cases(haskell.Just(v) arrow.r.dotted omega' v, square.dotted arrow.r.dotted haskell.Nothing) $

ひとつの式にまとめても，あまり冴えない．
#par-equation($ w_* &= haskell.kwcase v_* haskell.kwof cases(haskell.Just(v) arrow.r.dotted omega' v, square.dotted arrow.r.dotted haskell.Nothing) \
  &haskell.kwwhere v_* eq.delta haskell.kwcase u_* haskell.kwof cases(haskell.Just(u) arrow.r.dotted psi' u, square.stroked.dotted arrow.r.dotted haskell.Nothing) \
  &haskell.kwwhere u_* eq.delta phi' x $)
やりたいことは変数 $x$ に関数 $phi', psi', omega'$ を連続的に適用することだけである．もしPythonを使っていたら，次のように簡潔に書くところだ．

#sourcecode[```python
# Python
try:
  u = phi(x)
  v = psi(u)
  w = omega(v)
except Exception as e:
  print(f"Something went wrong: {e}")
```]

このような簡潔さを手に入れるために，我々はバインド演算子 $(haskell.bind)$ を導入するのである．関数 $phi$ ただし
#par-equation($ phi colon.double haskell.a -> haskell.ma $)
があるとする．ここに型コンストラクタ $haskell.m$ は関手型コンストラクタ $haskell.f$ のようなもので，バインド演算子 $(haskell.bind)$ が定義される特別な型コンストラクタであるとしよう．

変数 $x_* colon.double haskell.ma$ が与えられたとき，バインド演算子 $(haskell.bind)$ は次のように作用する．

$ phi haskell.bind x_* &|_(x_* = chevron.l x chevron.r) = chevron.l phi x chevron.r \
  &|_haskell.otherwise = nothing.rev $<bind-op>

ここに $chevron.l square.filled chevron.r$ はピュア演算子である．また $nothing.rev$ は抽象化された空で，型に応じて空リスト $(haskell.emptylist)$ または $haskell.Nothing$ などになる．

もう一つの関数 $psi$ ただし
#par-equation($ psi colon.double haskell.a -> haskell.ma $)
があるとき，次のように関数を合成することができる．

$ z_* = psi haskell.bind (phi haskell.bind x_*) $<bind-composition>

バインド演算子 $(haskell.bind)$ は右結合するため @bind-composition は
#par-equation($ z_* = psi haskell.bind phi haskell.bind x_* $)
と書ける．この式は「変数 $x_*$ に関数 $phi$ を適用し，その結果に関数 $psi$ を適用する」と読める．#footnote[Haskellでは ```haskell z = psi =<< phi =<< x ``` と書く．なおHaskellプログラマは演算子の左右を入れ替えた ```haskell z = x >>= phi >>= psi``` という書き方を好む．]

このようなバインド演算子が定義された型クラスのことを#keyword[モナド]と呼び $haskell.Monad$ で表す．すべてのアプリカティブ関手はモナドである．上述の型コンストラクタ $haskell.m$ はモナド型クラスのインスタンス，すなわち $haskell.Monad supset haskell.m$ であった．

#pb

我々のバインド演算子は左バインド演算子とも言う．というのは，他に#keyword[右バインド演算子] $(haskell.bindRight)$ もあるからである．右バインド演算子は左バインド演算子の左右を入れ替えたもので，左結合する．式 $z = psi haskell.bind phi haskell.bind x$ は「変数 $x$ に関数 $phi$ を作用させて，さらに関数 $psi$ を作用させたものを $z$ とする」と読めるが，右バインド演算子を使うと次のようにより自然言語に近い順序になる．

$ z = x haskell.bindRight phi haskell.bindRight psi $

実際，多くのHaskellプログラマが左バインド演算子よりも右バインド演算子を好む．これはUNIXシェルで次のようにすることと似ているからかもしれない．

#sourcecode[```shell-unix-generic
$ cat x | phi | psi > z
```]

上記のコマンドは，ファイル `x` の中身を書き出し（`cat`），プログラム $phi$（`phi`）が処理をして書き出し，続いてプログラム $psi$（`psi`）が処理をして，ファイル `z` に書き出すことを意味する．もしプログラム `phi` または `psi` が異常終了すれば，この一連のパイプラインも異常終了する．

#pb

モナドはアプリカティブ関手を拡張したもので，次の関係が成り立つ．
#par-equation($ haskell.Monad subset.eq haskell.Applicative subset.eq haskell.Functor $)
関手，アプリカティブ関手のように，型 $haskell.a$ をモナドに「入れた」ものを次のように書く．
#par-equation($ haskell.Monad supset haskell.m arrow.r.stroked haskell.ma $)
関手はマップ演算子 $(ast.op.o)$ を持つ型クラスであった．アプリカティブ関手はアプリカティブマップ演算子 $(ast.square)$ とピュア演算子 $(chevron.l square.filled chevron.r)$ を持つ．ピュア演算子を直接使うことはないが，アプリカティブ関手のインスタンスとなる型ではそれぞれ独自の実装を持つ．例えばリスト型は $[square.filled]$ というピュア演算子を持つし，Maybe型は $haskell.Just(square.filled)$ というピュア演算子を持つ．

モナドのインスタンスは追加でバインド演算子 $(haskell.bind)$ を持つことになる．歴史的な理由で，モナドのピュア演算子 $(chevron.l square.filled chevron.r)$ のことをリターン（return）演算子と呼ぶが，本質は同じものである．そこで本書では一貫してピュア演算子と呼び続けることにする．#footnote[歴史的理由とは，アプリカティブ関手とモナドがそれぞれ独立して関手の拡張として定義されたことである．そのため，どちらも独立のピュア演算子を持つことになり，モナドがアプリカティブの派生として再定義された現代でも名目上は別の名前が与えられている．]

関手は関手則，アプリカティブ関手はアプリカティブ関手則に従う．両方を再掲しておこう．関手則は次のようなものである．

#theorem-box(title: "関手則", outlined: false)[
1. 恒等射の存在（保存）：マップ演算子 $(ast.op.o)$ は $id ast.op.o x_* = id x_*$ を満たす．
2. 結合則：マップ演算子 $(ast.op.o)$ は $g ast.op.o (f ast.op.o x_*) = (g compose f) ast.op.o x_*$ /* $(g compose f) ast.op.o = (g ast.op.o) compose (f ast.op.o)$ */ を満たす．
]

アプリカティブ関手則は次のようなものである．

#theorem-box(title: "アプリカティブ関手則", outlined: false)[
1. 恒等射の存在：アプリカティブマップ演算子 $(ast.square)$ は $chevron.l id chevron.r ast.square x_* = id x_*$ を満たす．
2. 結合則：アプリカティブマップ演算子 $(ast.square)$ は $h ast.square (g ast.square f) = chevron.l compose chevron.r ast.square h ast.square g ast.square f$ を満たす．
3. 準同型性： $chevron.l f chevron.r ast.square chevron.l x chevron.r = chevron.l f x chevron.r$ または同じことであるが $f ast.op.o chevron.l x chevron.r = chevron.l f x chevron.r$ である．
4. 交換則： $f ast.square chevron.l x chevron.r = chevron.l (lozenge.stroked.medium haskell.apply x) chevron.r ast.square f$ が成り立つ．
]

アプリカティブ関手は，アプリカティブ関手則のみならず，関手則も満たす．そして，モナドは次節で述べるモナド則と，アプリカティブ関手則，関手則を満たす．

=== モナド則

モナドは次のモナド則を満たす．ただし $x_* colon.double haskell.Monad supset haskell.m arrow.r.stroked haskell.ma$ かつ $phi, psi colon.double haskell.Monad supset haskell.m arrow.r.stroked haskell.a -> haskell.ma$ である．

#theorem-box(title: "モナド則", outlined: false)[
1. 恒等射（左単位元）の存在：バインド演算子 $(haskell.bind)$ は $chevron.l lozenge.stroked.medium chevron.r haskell.bind x_* = x_*$ を満たす．#footnote[恒等射の存在における式 $chevron.l lozenge.stroked.medium chevron.r haskell.bind x_*$ の左単位元 $(chevron.l lozenge.stroked.medium chevron.r haskell.bind)$ は多くの文献で「右単位元」と書かれている．これはHaskellにおいて式 $chevron.l lozenge.stroked.medium chevron.r haskell.bind x_* = x_*$ を  ```haskell x >>= return = x``` と書くからである．]
2. 結合則：バインド演算子 $(haskell.bind)$ は $psi haskell.bind (phi haskell.bind x_*) = (psi haskell.bind (phi lozenge.stroked.medium)) haskell.bind x_*$ を満たす．#footnote[モナドの結合則は $ psi haskell.bind phi haskell.bind x_*
  = psi haskell.bind (phi haskell.bind x_*)$ のようにも表現出来る．]
3. 準同型性（右単位元の存在）：バインド演算子 $(haskell.bind)$ は $phi haskell.bind chevron.l x chevron.r = phi x$ を満たす．
// 交換則? #tk
]

Haskellには，型クラス $haskell.Monad$ が上記のモナド則を満たすことを強制する仕組みはない．しかし，多くのプログラマーがこれらのモナド則を満たすようにモナドを実装する．モナド型クラスがモナド則を満たすことで，多くの有益なテクニックが使えるようになるからである．

// モナド則の有益性については @programming-and-algebraic-structures で述べる．

#pb

アプリカティブ関手則は関手マップ演算子 $(ast.op.o)$ またはアプリカティブ関手マップ演算子 $(ast.square)$ を用いた関数マップ演算に対して，準同型性を保証するものであった．モナド則はバインド演算子 $(haskell.bind)$ を用いた関数バインド演算に対して，準同型性を保証するものである．

これまで見てきたリスト型はモナド型クラスに属する．そこでリストの準同型性を確認しておこう．いま
#par-equation($ phi colon.double haskell.a -> [haskell.a] $)
として
#par-equation($ f colon.double haskell.a -> haskell.a $)
という関数があり，両者が
#par-equation($ phi x = [f x] $)
であるとしよう．このとき
#par-equation($ phi haskell.bind [x] &= phi x \ 
  &= [f x] $)
であり，準同型性が保たれている．

Maybe型もまたモナド型クラスに属する．関数 $psi$ が
#par-equation($ psi &colon.double haskell.a -> haskell.MaybeA \
  psi x &= haskell.Just(f x) $)
のとき，
#par-equation($ psi haskell.bind haskell.Just(x) &= psi x \
  &= haskell.Just(f x) $)
であり，準同型性が保たれている．@kazu-yamamoto-functor @ryusei-yamaguchi


// 結合則の右辺 $(psi haskell.bind (phi lozenge.stroked.medium)) haskell.bind x_*$ を $haskell.kwdo$ 記法で書くと次のようになる．
// $ haskell.kwdo {y <- haskell.kwdo { x <- x_*; phi x}; psi y} $

// 結合則の左辺 $psi haskell.bind (phi haskell.bind x_*)$ を $haskell.kwdo$ 記法で書くと次のようになる．
// $ haskell.kwdo {x <- x_*; haskell.kwdo {y <- phi x}; psi y} $
// 上式は次のように縮約できる．
// $ haskell.kwdo {x <- x_*; y <- phi x; psi y} $




=== 破壊的代入を隠すモナド

Haskellは一般的に破壊的代入を許さないが，ある条件では許す．一例は関数の参照透過性を保つ場合である．関数の参照透過性とは，関数に同じ引数を与えた場合，同じ値がいつも返ることをいう．つまり，関数は内部に一時変数を持ってもよく，その一時変数に破壊的代入を行っても，関数の参照透過性を破らない限りは許されるということである．C言語で言えば関数内で ```c for``` ループを持つ場合，Pythonで言えば関数内でイテレータを使ってループを回す場合がそれにあたる．

このように破壊的代入される変数を関数内に隠す機構をサポートする仕組みが状態トランスフォーマー（State Transformer）モナド型，略して#keyword[STモナド]である．

まず破壊的代入を許すような変数を生成する必要がある．そこで，破壊的代入を許すような変数を生成する演算子を導入しよう．この変数の初期値を $x$ とするとき，我々はこの演算子を $penta.filled_x$ で表す．#footnote[Haskellでは ```haskell newSTRef x``` と書く．]

次に，破壊的代入を許す変数から値を取り出す演算子を導入しよう．我々はこの演算子を $star.stroked$ で表す．値を取り出す演算子 $(star.stroked)$ は「抜き身」では使えず，必ずバインド演算子 $(haskell.bind)$ を通して次のように使う．#footnote[Haskellでは ```haskell mu = readSTRef =<< newSTRef x``` と書く．]

$ mu = star.stroked haskell.bind penta.filled_x $<new-and-read>

ここに結果 $mu$ はSTモナド型の変数で，破壊的代入を許す変数の値ではなく「初期値 $x$ を持つ破壊的代入を許す無名の変数から値を取り出す」行動を意味する．そのため $mu$ のことを#keyword[STアクション]と呼ぶ．なお $mu$ の型を明示すると次のようになる．

$ mu colon.double forall haskell.s |=> haskell.ST_(haskell.s haskell.a) $

STアクション $mu$ を評価する演算子を導入しよう．我々はこの演算子を $penta.stroked$ で表す．次のプログラムは演算子 $penta.filled$ を使って破壊的代入を許す変数を生成し，その値を取り出す例である．#footnote[Haskellでは ```haskell x = 1; mu = readSTRef =<< newSTRef x; main = print $ runST mu``` と書く．]

$ x &= 1 \
  mu &= star.stroked haskell.bind penta.filled_x \
  haskell.main &= haskell.print haskell.apply penta.stroked mu $

もちろんこれはつまらないプログラムである．ここで $star.stroked = backslash v |-> star.stroked v$ であるから，@new-and-read は次のように書き換えられる．
#par-equation($ mu = (backslash v |-> star.stroked v) haskell.bind penta.filled_x $)
この書き換えによって，演算子 $star.stroked$ の引数を陽に表すことが出来る．そこで $star.stroked v$ の直前に変数 $v$ に対する破壊的代入を行うこととする．その方法は2通りある．ひとつめの方法は次のようなもので，ここでは $underline(v eq.star x')$ で破壊的代入が可能な変数を指し示す変数 $v$ に値 $x'$ を代入している．#footnote[Haskellでは ```haskell mu = (\v -> writeSTRef v x' >> readSTRef v) =<< newSTRef x``` と書く．]

$ mu = (backslash v |-> underline(v eq.star x') >> star.stroked v) haskell.bind penta.filled_x $

演算子 $>>$ は「何か（第1引数）を行って，その結果を捨てて，次の何か（第2引数）の値を返す」という意味である．式 $underline(v eq.star x')$ は「変数 $v$ が指し示す破壊的代入が可能な変数に値 $x'$ を破壊的に代入する」という意味で，我々は式の値には興味がないので捨ててしまうのである．

ふたつめの方法は次のようなものである．ここでは $underline(f star.filled v)$ で破壊的代入が可能な変数を指し示す変数 $v$ に関数 $f$ を適用し，その結果で $v$ を書き換える．#footnote[Haskellでは ```haskell mu = (\v -> modifySTRef v f >> readSTRef v) =<< newSTRef x``` と書く．]

$ mu = (backslash v |-> underline(f star.filled v) >> star.stroked v) haskell.bind penta.filled_x $<st-monad>

演算子 $star.filled$ はC++における引数の「参照渡し」を実現するものと思えば良い．式 $underline(f star.filled v)$ は値 $f v$ を使って変数 $v$ が指し示す破壊的代入が可能な変数を書き換える．C++との違いは，破壊的代入がこの $v$ に関するラムダ式の中，あるいは同じことであるがSTモナド型の変数 $mu$ の中でしか行えないことである．変数 $v$ で示されている変数をSTモナド $mu$ の外側からアクセスすることはできない．

@st-monad を含むプログラムをHaskellで書くと次のようになる．

#sourcecode[```haskell
-- Haskell
import Control.Monad
import Control.Monad.ST
import Data.STRef

f :: Num a => a -> a
f x = x + 1

m = (\v -> v `modifySTRef` f >> readSTRef v) =<< newSTRef 1

main = print $ runST m
```]

我々の演算子 $penta.filled$ はHaskellの ```haskell newSTRef``` であり，我々の演算子 $star.stroked$ はHaskellの ```haskell readSTRef``` である．また我々の二項演算子 $star.filled$ はHaskellの ```haskell modifySTRef``` である．我々の演算子 $penta.stroked$ はHaskellの ```haskell runST``` である．

なお上記のプログラムには登場していないが，我々の破壊的代入演算子 $eq.star$ はHaskellの ```haskell writeSTRef``` である．

#pb

破壊的代入を利用して，リストの和を取る関数 $sum'$ を書いてみると次のようになる．@_7shi-st-monad

$ sum' x_"s" = penta.stroked haskell.apply
  (backslash a |-> ((backslash i |-> underline((+i) star.filled a)) *_"M" x_"s") >> haskell.readSTRefOp a) 
  haskell.bind penta.filled_0 $<sum-by-st-monad>

@sum-by-st-monad では，初期値 $0$ を持つ破壊的代入が可能な変数 $penta.filled_0$ を作り，変数 $a$ で受け，それに変数 $i$ で取り出したリスト $x_"s"$ の各要素を足して $(+i)$ いき，その結果 $(star.stroked a)$ を評価 $(penta.stroked)$ している．

@sum-by-st-monad を含むHaskellプログラムは次のようになる．

#sourcecode[```haskell 
-- Haskell
import Control.Monad
import Control.Monad.ST
import Data.STRef

sum' xs = runST $ (\a -> ((\i -> a `modifySTRef` (+ i)) `mapM_` xs) >> readSTRef a) =<< newSTRef 0

main = print $ sum' [1..100]
```]

なお，まったく同じプログラムであるが，次のような#keyword[do記法]を使うことも出来る．こちらのほうが，手続き型プログラミングに慣れたプログラマには読みやすいかもしれない．

#sourcecode[```haskell
-- Haskell
import Control.Monad
import Control.Monad.ST
import Data.STRef

sum' xs = runST $ do
    a <- newSTRef 0
    mapM_ (\i -> modifySTRef a (+ i)) xs
    readSTRef v

main = print $ sum' [1..100]
```]    

ここで用いたdo記法については後述する．また ```haskell mapM``` およびその亜種の ```haskell mapM_``` についても後述する．

=== 余談：IOサバイバルキット3

本書冒頭の例に戻って，単語を数えるプログラムを考えよう．まずは話を簡単にするために，文字列を仮に次のように定義しておこう．
#par-equation($ s = haskell.constantstring("Hello, world! Hello, once again, to you and you and you.") $)
あとでファイル入力を扱えるようにするが，一旦は文字列 $s$ を入力とする．いま解きたい問題は，文字列 $s$ に含まれる単語を数えることである．

まずは文字列 $s$ からアルファベット以外の文字を取り除く．これにはリストの内包表記を使ったほうが簡単であるが，ここでは内包表記を使わずに関数 $haskell.clean$ を次のように定義しておこう．

// $ u = [t | c in s, haskell.kwlet t eq.delta haskell.kwif haskell.isAlpha c haskell.kwthen haskell.toLower c haskell.kwelse haskell.constantchar(" ")] $

$ haskell.clean &colon.double haskell.String -> haskell.String \
  haskell.clean haskell.emptylist &= haskell.emptylist \
  haskell.clean (x : x_"s") &= (haskell.kwif haskell.isAlpha x haskell.kwthen haskell.toLower x haskell.kwelse haskell.constantchar(" ")) : haskell.clean x_"s" $

関数 $haskell.clean$ を文字列 $s$ に適用して文字列 $t$ を得ておく．

$ t = haskell.clean s $

文字列 $t$ には小文字アルファベットと空白のみが含まれている．これを $haskell.words$ 関数でリストにしよう．
#par-equation($ u = haskell.words t $)
ここで変数 $u$ は $haskell.String$ のリスト，つまり $[haskell.String]$ 型である．

単語のリスト $u$ を $haskell.sort$ 関数でソートして $v$ とする．
#par-equation($ v = haskell.sort u $)
変数 $v$ はソートされた単語リストである．リスト $v$ を $haskell.group$ 関数でグループ化して $w$ とする．
#par-equation($ w = haskell.group v $)
この $haskell.group$ 関数は，リスト $v$ をグループ化してリストのリスト，つまり $[[haskell.String]]$ 型のリストを返す．

リストのリスト $w$ を $haskell.count$ 関数で単語の出現頻度を計算して $x$ とする．
#par-equation($ x = haskell.count w $)
この $haskell.count$ 関数は，リストのリストを受け取り，その中の各リストの要素数とリストの先頭要素からなるタプルのリストを返すように，我々自身が定義する必要がある．そこで，次の定義を用いよう．
#par-equation($ haskell.count &colon.double [[haskell.String]] ->[paren.l.stroked haskell.Int, haskell.String paren.r.stroked] \
  haskell.count haskell.emptylist &= haskell.emptylist \
  haskell.count (x_"s" : x_"ss") &= paren.l.stroked haskell.length x_"s", haskell.head x_"s" paren.r.stroked : haskell.count x_"ss" $)
関数 $haskell.head$ の使用は非推奨であるが，単純化のために使うことにする．これで変数 $x$ は単語とその出現頻度のペアを収めたリストとなっている．

今度は，リスト $x$ を出現頻度順にソートする必要がある．関数 $haskell.sort$ は順序が定義された型のリストだけをソート対象とするので，任意の型のリストをソート出来る $haskell.sortBy$ 関数を使う．この $haskell.sortBy$ 関数は，二つの要素を比較する関数を受け取り，その比較結果に従ってリストをソートする．この比較関数を $haskell.compFst$ としよう．関数 $haskell.compFst$ を次のように定義する．
#par-equation($ haskell.compFst &colon.double paren.l.stroked haskell.Int, haskell.String paren.r.stroked -> paren.l.stroked haskell.Int, haskell.String paren.r.stroked -> haskell.Ordering\
  haskell.compFst paren.l.stroked a, square.stroked.dotted paren.r.stroked paren.l.stroked b, square.stroked.dotted paren.r.stroked &= haskell.compare b a $)
関数 $haskell.compare$ は二つの要素を比較して，結果を $haskell.Ordering$ 型で返す．引数の順序を入れ替えているのは，出現頻度順にソートするためである．

ソートされた結果を次のようにリスト $y$ とする．

$ y = haskell.sortBy haskell.compFst x $

最後に，印字しやすいように体裁を整える関数 $haskell.form$ を定義する．

$ haskell.form &colon.double [paren.l.stroked haskell.Int, haskell.String paren.r.stroked] -> haskell.String \
  haskell.form haskell.emptylist &= haskell.constantstring("") \
  haskell.form (x : x_"s") &= (haskell.kwlet paren.l.stroked a, b paren.r.stroked eq.delta x haskell.kwin haskell.showfunc a smash haskell.constantstring(" ") smash b) smash haskell.constantstring("\n") smash haskell.form x_"s" $

関数 $haskell.form$ を使ってリスト $y$ を文字列 $z$ に変換する．

$ z = haskell.form y $

印字には文字列をそのまま書き出すアクション $haskell.putStrLn$ を用いることとし，これを $haskell.main$ アクションとする．
#par-equation($ haskell.main = haskell.putStrLn z $)
これで，入力がプログラムに固定されていることをのぞいて，プログラムが完成したことになる．せっかくなので，これまで定義した関数を $haskell.doIt$ という名前の関数にまとめておこう．
#par-equation($ haskell.doIt &colon.double haskell.String -> haskell.String \
  haskell.doIt x &= haskell.form haskell.apply (haskell.sortBy haskell.compFst) haskell.apply haskell.count haskell.apply haskell.group haskell.apply haskell.sort haskell.apply haskell.words haskell.apply haskell.clean x $)
この「全部入り」関数 $haskell.doIt$ を文字列 $s$ に適用して文字列 $z$ を得ておき，印字することにしよう．これまでの経過をまとめると次のように出来る．

$ 
haskell.clean &colon.double haskell.String -> haskell.String \
  haskell.clean haskell.emptylist &= haskell.emptylist \
  haskell.clean (x : x_"s") &= (haskell.kwif haskell.isAlpha x haskell.kwthen haskell.toLower x haskell.kwelse haskell.constantchar(" ")) : haskell.clean x_"s" \
  haskell.count &colon.double [[haskell.String]] ->[paren.l.stroked haskell.Int, haskell.String paren.r.stroked] \
  haskell.count haskell.emptylist &= haskell.emptylist \
  haskell.count (x_"s" : x_"ss") &= paren.l.stroked haskell.length x_"s", haskell.head x_"s" paren.r.stroked : haskell.count x_"ss" \
haskell.compFst &colon.double paren.l.stroked haskell.Int, haskell.String paren.r.stroked -> paren.l.stroked haskell.Int, haskell.String paren.r.stroked -> haskell.Ordering\
  haskell.compFst paren.l.stroked a, square.stroked.dotted paren.r.stroked paren.l.stroked b, square.stroked.dotted paren.r.stroked &= haskell.compare b a \
  haskell.form &colon.double [paren.l.stroked haskell.Int, haskell.String paren.r.stroked] -> haskell.String \
  haskell.form haskell.emptylist &= haskell.constantstring("") \
  haskell.form (x : x_"s") &= (haskell.kwlet paren.l.stroked a, b paren.r.stroked eq.delta x haskell.kwin haskell.showfunc a smash haskell.constantstring(" ") smash b) smash haskell.constantstring("\\n") smash haskell.form x_"s" \
haskell.doIt &colon.double haskell.String -> haskell.String \
  haskell.doIt x &= haskell.form haskell.apply (haskell.sortBy haskell.compFst) haskell.apply haskell.count haskell.apply haskell.group haskell.apply haskell.sort haskell.apply haskell.words haskell.apply haskell.clean x \
s &= haskell.constantstring("Hello, world! Hello, once again, to you and you and you.") \
z &= haskell.doIt s \
  haskell.main &= haskell.putStrLn z $

こうしておけば，中間変数 $t, u, v, w, x, y$ を使わずにプログラムを書くことができる．以上の式をHaskellで書くと次のようになる．

#sourcecode[
```haskell 
import Data.Char
import Data.List

clean :: String -> String
clean "" = ""
clean (x:xs) = (if isAlpha x then toLower x else ' ') : clean xs

count :: [[String]] -> [(Int, String)]
count [] = []
count (xs:xss) = (length xs, head xs) : count xss

compFst :: (Int, String) -> (Int, String) -> Ordering
compFst (a, _) (b, _) = compare b a

form :: [(Int, String)] -> String
form [] = ""
form (x:xs) = (let (a, b) = x in show a ++ " " ++ b) ++ "\n" ++ form xs

doIt :: String -> String
doIt x = form $ (sortBy compFst) $ count $ group $ sort $ words $ clean x

s :: String
s = "Hello, world! Hello, once again, to you and you and you."

z :: String
z = doIt s

main = putStrLn z
```]

次のように出力されれば，プログラムは正しく動いている．

#sourcecode[```txt
3 you
2 and
2 hello
1 again
1 once
1 to
1 world
```]

最後の仕上げは，関数 $haskell.doIt$ をファイルからの入力に適用することである．と言っても，難しいことはなにもない．関数 $haskell.doIt$ は文字列 $(haskell.String)$ を受け取るのだが，ファイルからの入力は参照透過性を持たないので，戻り値を文字列ではなく，#keyword[IO文字列] $(haskell.IOString)$ とする必要があるだけである．IO文字列については続く節で説明する．そこで，関数 $haskell.doIt'$ という名前のラッパー関数を次のように定義する．
#par-equation($ haskell.doIt' &colon.double haskell.String -> haskell.IOString \
  haskell.doIt' x &= chevron.l haskell.doIt x chevron.r $)
関数 $haskell.doIt'$ は元の関数 $haskell.doIt$ をピュア演算子でラップして，戻り値をIO文字列にするだけである．

ファイルからの入力にはアクション $haskell.getContents$ を用いる．このアクションはファイルからの入力を文字列として返す．アクション $haskell.getContents$ を我々の $haskell.doIt'$ にバインドして，次のようにIO文字列 $z'$ を得ておこう．
#par-equation($ z' &colon.double haskell.IOString \
  z' &= haskell.doIt' haskell.bind haskell.getContents $)
IO文字列 $z'$ は文字列ではないので，アクション $haskell.putStrLn$ に直接渡すことは出来ないが，バインドすることで中身を引き渡すことが出来る．次のように $haskell.main$ アクションを定義すると，IO文字列 $z'$ の中身を印字することができる．
#par-equation($ haskell.main = haskell.putStrLn haskell.bind z' $)
以上でプログラムが完成した．関数 ```haskell doIt``` が定義されているとして，残りをHaskellで書くと次のようになる．

#sourcecode[```haskell 
doIt' :: String -> IO String
doIt' x = pure (doIt x)

z' :: IO String
z' = doIt' =<< getContents

main = putStrLn =<< z'
```]

Haskell Stackを使っている場合，次のように実行できる．

#sourcecode[```shell-unix-generic
$ stack run < input.txt
```]

=== この章のまとめ

- アプリカティブスタイルは計算構造の一種である，並列した計算を表す．
- 純粋な関数合成も計算構造の一種である，直列した計算を表す．ただし純粋な関数合成は文脈を扱えない．
- モナド型クラスとバインド演算子 $(haskell.bind)$ は一般的な計算構造を表現できる，より強力な仕組みである．
- モナド型クラスに属する型は関手則，アプリカティブ関手則に加えてモナド則も満たすように設計されなければならない．モナド則とはバインド演算子版「恒等射の存在」「結合則」「準同型性」である．
- モナド型クラスのひとつSTモナド型を用いると，破壊的代入をプログラムの他の部分から隠すことが出来る．

#showybox(title: "const修飾子とmut修飾子")[
Haskellでは全ての変数に対して破壊的代入が禁止されている．例外はSTモナド型やIOモナド型の内部で行われる破壊的代入程度である．一方，C言語ではデフォルトで変数への破壊的代入が許可されている．そこで「うっかり」破壊的代入をしないように，変数の型に ```c const``` 修飾子をつけることが出来る．例えば ```c main``` 関数の第2引数 ```c argv``` を無意味に破壊しないように，次のコードのように ```c const``` 修飾子を埋め込むことはよく行われている．

#sourcecode[```c
/* C */
#include <stdio.h> 
 
int main(int argc, const char *const *argv) { 
  while (--argc > 0) { 
    ++argv; 
    printf("%s\n", *argv); 
  } 
  return 0; 
}
```]

C言語よりも新しいプログラミング言語であるRustでは，変数はデフォルトで変更不可能になっており，変更可能な変数の型には ```rust mut``` 修飾子を付けなければならない．Haskellのように破壊的代入を禁止するよりも，Rustのほうが現実的な選択かもしれない．]

== IO
<io>

実用的なプログラムには必ず入出力（IO）がある．ところがIOとは参照透過性を持たない行動であり，関数型プログラミングの世界観とは相容れない．そこで，HaskellではIOをモナド型クラスで表現する．IOという「破壊活動」をモナド型クラスのインスタンスの変数に閉じ込めて，プログラムの他の部分と分離するのである．#footnote[Haskellでは「型クラス（type class）のインスタンス（instance）」は型（type）のことである．C++やJavaではインスタンスがオブジェクト（object）を意味するので，混同しないように気をつけよう．]

=== IOモナド

今後，モナド型クラスに属する型の変数のことを単に「モナド」と呼ぶ．またモナド型クラスではない型の変数を受け取ってモナドを返す関数を「文脈に入れる関数」と呼ぶ．モナド型クラスに属する型はバインド演算子 $(haskell.bind)$ を持つので，モナドに対してバインド演算子を用いて文脈に入れる関数を適用することができる．

ここで改めて概念を整理しておこう．@functor-applicative-monad に示すように，関手型クラス $(haskell.Functor)$ に属する型はマップ演算子 $(ast.op.o)$ を持つ．アプリカティブ関手型クラス $(haskell.Applicative)$ に属する型はマップ演算子に加えてアプリカティブマップ演算子 $(ast.square)$ とピュア演算子 $(chevron.l square.filled chevron.r)$ を持つ．モナド型クラス $(haskell.Monad)$ に属する型は，マップ演算子，アプリカティブマップ演算子，ピュア演算子に加えて，バインド演算子 $(haskell.bind)$ を持つ．

#figure(
  caption: "関手・アプリカティブ関手・モナド",
  table(
    columns: (auto, auto),
    inset: 10pt,
    table.header([型クラス], [特徴]),
    [関手], [関手マップ演算子 $(ast.op.o)$ を持つ],
    [アプリカティブ関手], [関手の特徴に加えて…… \ アプリカティブマップ演算子 $(ast.square)$ とピュア演算子 $chevron.l square.filled chevron.r$ を持つ],
    [モナド], [アプリカティブ関手の特徴に加えて…… \ バインド演算子 $(haskell.bind)$ を持つ],
  )
)
<functor-applicative-monad>

これまで，マップ演算子がループを，アプリカティブマップ演算子が並列な計算を，バインド演算子が直列な計算を表現できることを見てきた．またバインド演算子を用いて，破壊的代入をモナドの中に隠す方法を見てきた．

モナドとバインド演算子はまた，参照透過性を持たない入出力（IO）をプログラムに組み込むのにも使える．

#pb

まずIO型 $(haskell.IO)$ を導入する．IO型はモナド型クラスのインスタンスである．HaskellではIO型がモナド型クラスのインスタンスであることを次のように宣言している．#footnote[Haskellでは ```haskell instance Monad IO``` と表現される．]

$ haskell.kwinstance haskell.Monad supset haskell.IO $

IO型はモナド型クラスのインスタンスであるので，ピュア演算子とバインド演算子を引き継いでいる．またIO型はリスト型と同じく型パラメタを必要とし $haskell.IO_haskell.a$ のような形で使われる．

// #pb

// 入出力（IO）は参照透過性を持たない．入力は毎回異なるし，出力は状態の書き換えであるからだ．そこで，IOをプログラムの他の部分から切り離して，他の参照透過性のある部分から触れられないようにしておく必要がある．そのためには，IOをモナドで表現する必要がある．

ファイルを丸ごと読み込むアクションは $haskell.getContents$ である．アクション $haskell.getContents$ の型は
#par-equation($ haskell.getContents colon.double haskell.IOString $)
である．アクション $haskell.getContents$ をバインド $(haskell.bind)$ すると，ファイルの内容を文字列として得ることができる．例を挙げる．

$ f &colon.double haskell.String -> haskell.String \
  f x &= haskell.constantstring("My mother said: ") smash x \
  f' &colon.double haskell.String -> haskell.IOString \
  f'x &= chevron.l f x chevron.r \
  s &colon.double haskell.IOString \
  s &= f' haskell.bind haskell.getContents $<my-mother-said>

@my-mother-said はファイル内容の先頭に一言付け加えて変数 $s$ に代入するプログラムである．関数 $f$ は文字列を受け取って文字列を返す参照透過性のある関数である．このような関数は「ピュアすぎて」アクションとバインド $(haskell.bind)$ することが出来ない．そこで，関数 $f$ をピュア演算子でラップして，戻り値をIO文字列にする関数 $f'$ を定義している．

アクション $haskell.getContents$ は標準入力から内容を受け取るが，任意のファイルから内容を読むにはアクション $haskell.readFile$ を用いる．アクション $haskell.readFile$ は
#par-equation($ s' &colon.double haskell.IOString \
  s' &= haskell.readFile haskell.constantstring("input.txt") $)
のように使う．

#pb

出力とは，破壊的代入である．そこで出力もIOモナドで表現する必要がある．出力によく使われるアクションは文字列を印字する $haskell.putStrLn$ である．アクション $haskell.putStrLn$ の型は
#par-equation($ haskell.putStrLn colon.double haskell.String -> haskell.IOunit $)
である．これはアクション $haskell.putStrLn$ が文字列 $(haskell.String)$ を受け取って，何らかの破壊的操作を行って，空っぽのIOアクション $(haskell.IOunit)$ を返すことを意味する．@minegishirei-file-io

アクション $haskell.putStrLn$ に文字列を渡すと，その文字列を標準出力へ印字する．例を挙げる．
#par-equation($ haskell.main = haskell.putStrLn haskell.constantstring("Hello, world!") $)
ここで文字列型 $(haskell.String)$ をIOモナドに包んで返す関数 $phi$ があるとしよう．例えば，$phi$ が次のような関数であるとする．
#par-equation($ phi s = chevron.l haskell.constantstring("I said: ") smash s chevron.r $)
ここに $chevron.l square.filled chevron.r$ はピュア演算子である．このような関数でも，バインド演算子 $(haskell.bind)$ を用いて，文字列を印字することができる．例を挙げる．
#par-equation($ haskell.main = haskell.putStrLn haskell.bind (phi haskell.constantstring("Hello, world!")) $)
このように，IOモナドに包まれた関数をバインド $(haskell.bind)$ すると，文字列を印字することができる．

型クラス $haskell.Show$ に属する型は，値を文字列に変換する関数 $haskell.showfunc$ を提供する．アクション $haskell.print$ は，型クラス $haskell.Show$ に属する型の値を受け取って，その値を文字列に変換して，標準出力へ印字する．例を挙げる．
#par-equation($ x colon.double haskell.Int = 1 \
  haskell.main = haskell.print x $)
この例では，型 $haskell.Int$ が型クラス $haskell.Show$ のインスタンスなので，アクション $haskell.print$ に直接渡すことができる．

#pb

リストに対するIOアクションはマップできる．ただし
#par-equation($ x_"s" &= [0,1,...,9] \
  f_"s" &= haskell.print * x_"s" $)
としても $haskell.main = f_"s"$ と書くことはできない．これは関数リスト $f_"s"$ がIOアクションではないからである．関数リスト $f_"s"$ をIOアクションに変換するには，関数 $haskell.sequence$ を用いて
#par-equation($ haskell.main = haskell.sequence f_"s" $)
とする．この関数リスト $f_"s"$ を作る代わりに，次のようなIOアクションを作ることが出来る．
#par-equation($ mu = haskell.print *_"M" x_"s" $)
この $mu$ はIOアクションなので $haskell.main = mu$ とすることが出来る．なお $mu$ の値は $haskell.print$ の戻り値すなわち $emptyset$ のリスト $[emptyset, emptyset, ..., emptyset]$ になる．戻り値を捨てても良い場合は
#par-equation($ mu = haskell.print *_"M_" x_"s" $)
とする．#footnote[Haskellでは ```haskell mu = print `mapM_` xs``` と書く．]

=== 疑似乱数

入力と似た概念に#keyword[疑似乱数]がある．疑似乱数は計算機が擬似的に発生させる乱数で，事前に値がわからない点がユーザからの入力と共通する．疑似乱数は計算機の状態に依存するので，参照透過性を持たない．次の例は変数 $r$ に疑似乱数を代入するものである．@random-numbers-in-haskell

$ r = haskell.randomIO colon.double haskell.IOFloat $

この変数 $r$ の値はプログラム実行時にランダムに定まる「汚染された」値である．そのため，プログラム中の他の参照透過性を持つ変数と混ぜて扱うことが出来ない．変数 $r$ はIOモナドに包まれているので，バインド演算子 $(haskell.bind)$ を使って，文脈に入れる関数の中で使うことが出来る．一例は $haskell.print$ アクションで，次の式は疑似乱数を印字するものである．

$ haskell.main = haskell.print haskell.bind r $

繰り返し演算子の文脈ありバージョン $(haskell.replicate_M)$ を用いると次のように#keyword[擬似乱数列]を生成できる．#footnote[Haskellでは ```haskell rs = n `replicateM` (randomIO :: IO Float)``` と書く．]

$ r_"s" = 5 haskell.replicate_M (haskell.randomIO colon.double haskell.IOFloat) $

Haskellは指定された範囲の疑似乱数を生成するアクション $haskell.randomRIO$ も提供している．次の例は6面体のサイコロを振るものである．
#par-equation($ r' = haskell.randomRIO paren.l.stroked 1, 6 colon.double haskell.Int paren.r.stroked $)
このとき，変数 $r'$ の値は $1$ から $6$ までの整数のいずれかである．

=== mainアクション

Haskellでは関数はすべて参照透過性を持つことが期待されている．そこで $haskell.putStrLn$ のようなアクションをどのように解釈するか，改めて触れておく．アクション $haskell.putStrLn$ の型は
#par-equation($ haskell.putStrLn colon.double haskell.String -> haskell.IOunit $)
である．これはアクション $haskell.putStrLn$ が文字列 $(haskell.String)$ を受け取って，何らかの動作を行う「命令書」すなわちIOアクションと，付随する戻り値があることを意味する．ただし付随する戻り値のほうはユニット型 $(haskell.Unit)$ で，ユニット型の唯一の値がユニット $(emptyset)$ であるため，事実上戻り値は無いことになる．また「命令書」はプログラム実行時に「破壊活動」を行うのであるが，命令書自体は変化しないため，参照透過性を持つ．

Haskellは最初に実行されるアクションがあり，そのアクションを $haskell.main$ で表している．この $haskell.main$ アクションは何も受け取らず「命令書」の実行だけをし，何も返さない．そこで $haskell.main$ の型は
#par-equation($ haskell.main &colon.double haskell.IO_haskell.Unit $)
と決められている．

最も単純な $haskell.main$ アクションは次のようになる．
#par-equation($ haskell.main = chevron.l emptyset chevron.r $)
この $haskell.main$ アクションは何も受け取らず，何もせず，何も返さない．ただしHaskellランタイムはHaskellプログラム終了時にOSに対して戻り値を返す．この戻り値は，明示的に指示しない限り，プログラムの正常終了を意味する $0$ である．特定の数値を戻り値として返したい場合は，アクション $haskell.exitWith$ が必要になるが，これは別の章で取り上げることにする．

アクション $haskell.putStrLn$ は文字列 $(haskell.String)$ を受け取って，その文字列を標準出力へ印字する．このアクションを $haskell.main$ として定義すると，次のようになる．
#par-equation($ haskell.main = haskell.putStrLn haskell.constantstring("Hello, world!") $)
このプログラムを実行すると，標準出力に "Hello, world!" が印字される．

アクション $haskell.getContents$ は標準入力から内容を受け取って，その内容をIO文字列 $(haskell.IOString)$ として返す．アクション $haskell.putStrLn$ は引数に文字列しか取れないので，もし $haskell.putStrLn$ を使って標準入力の内容を印字しようと思うと，バインド演算子 $(haskell.bind)$ を用いて
#par-equation($ haskell.main = haskell.putStrLn haskell.bind haskell.getContents $)
とすることになる．

任意の関数 $f$ ただし $f colon.double haskell.String -> haskell.String $ をアクション $haskell.putStrLn$ と $haskell.getContents$ の間に挟む場合は
#par-equation($ haskell.main = haskell.putStrLn haskell.bind (backslash x |-> chevron.l f x chevron.r) haskell.bind haskell.getContents $)
// main = putStrLn . (\x -> pure (f x)) =<< getContents ???
とする．また文脈に入れる関数 $g colon.double haskell.String -> haskell.IOString $を使う場合は単に
#par-equation($ haskell.main = haskell.putStrLn haskell.bind g haskell.bind haskell.getContents $)
// main = putStrLn . g =<< getContents ???
でよい．@mizunashi-mana-io

=== 余談：do記法

標準入力から1行を文字列として読み取って，その文字列を標準出力に書き出すだけのプログラムをPythonで書くならば，次のようになるだろう．

#sourcecode[```python
# Python
import sys
def main():
  s = sys.stdin.readline()
  print(s)
main()
```]

このプログラムは，標準入力から ```python readline()``` で1行を読み取り，変数 ```python s``` に代入したあと ```python print(s)``` で標準出力へ書き出している．このような書き方を#keyword[逐次処理]あるいは#keyword[逐次実行]と呼ぶ．この書き方はプログラマの直観ともよく合致するため，多くのプログラミング言語が採用するところである．むしろ逐次処理以外のプログラミングを考えられないというプログラマもいるであろう．

Haskellにはシンタックスシュガーとして逐次処理記法が導入されている．それが#keyword[do記法]である．標準入力から1行を読み取って変数 $s$ に代入し，それを標準出力に書き出すHaskellプログラムを我々はこれまで
#par-equation($ haskell.main = (backslash s |-> haskell.putStrLn s) haskell.bind haskell.getLine $)
と書くことにしてきた．ここに変数 $s$ はアクション $haskell.getLine$ から得られる文字列を陽に示すためにラムダ式のパラメタとして書き出したものである．この式を，キーワード $haskell.kwdo$ を用いて次のように書き直すことが出来る．この記法は「まず $haskell.getLine$ の結果を $s$ に代入し，その結果の $s$ を $haskell.putStrLn$ する」と読める．

$ haskell.main = haskell.kwdo {s <- haskell.getLine; haskell.putStrLn s} $<do-notation>

@do-notation をHaskellプログラムで書くと次のようになる．

#sourcecode[```haskell
-- Haskell
main = do { s <- getLine; putStrLn s }
```]

改行を用いた記法にすると，このHaskellプログラムは次のようによりPythonに近い書き方になる．

#sourcecode[```haskell
-- Haskell
main = do       -- In Python
  s <- getLine  -- s = readline()
  putStrLn s    -- print(s)
```]

標準入力から受け取った文字列を関数 $f$ で処理する場合，Pythonならば次のようなプログラムになるであろう．

#sourcecode[```python
# Python
import sys
def main():
  s = sys.stdin.readline()
  t = f(s)
  print(t)
main()
```]

同じことをHaskellで書くと次のようになる．

#sourcecode[```haskell
--Haskell
-- f :: String -> String
main = do { s <- getLine; let t = f s in putStrLn t }
```]

改行を用いた記法にすると，このHaskellプログラムは次のようによりPythonに近い書き方になる．

#sourcecode[```haskell
--Haskell
-- f :: String -> String
main = do       -- In Python
  s <- getLine  -- s = readline()
  let t = f s   -- t = f(s)
  putStrLn t    -- print(t)
```]

Haskellプログラムでdo記法を採用するかどうかは
#par-equation($ haskell.main = (backslash s |-> haskell.putStrLn haskell.bind f s) haskell.bind haskell.getLine $)
// main = (\s -> putStrLn $ f s) =<< getLine ???
と書くか
#par-equation($ haskell.main = haskell.kwdo { s <- haskell.getLine; haskell.kwlet t eq.delta f s haskell.kwin haskell.putStrLn t} $)
と書くかの違いでしかない．プログラマは好きな方を採用すればよいのである．

#pb

do記法の利点のひとつに「継続渡しスタイル（continuation passing style）」を簡潔に書けることがある．継続渡しスタイルとは，関数に戻り値の返し先すなわち#keyword[継続]を引数として渡すスタイルである．@wikipedia-continuation-passing-style

次の例は，継続渡しではない通常の関数である．継続渡しでない書き方を「直接スタイル（direct style）」と呼ぶ．関数 $haskell.sqr$ は引数の自乗を，関数 $haskell.add$ はふたつの引数の和を計算する．

$ haskell.sqr &colon.double haskell.Double -> haskell.Double \
  haskell.sqr x &= x times x \
  haskell.add &colon.double haskell.Double -> haskell.Double -> haskell.Double \
  haskell.add x y &= x + y $

これらの関数と標準関数 $haskell.sqrt$ を使って，三平方の定理を計算する関数 $haskell.pyth$ を次のように定義する．

$ haskell.pyth &colon.double haskell.Double -> haskell.Double -> haskell.Double \
  haskell.pyth x y &= haskell.sqrt (haskell.add (haskell.sqr x) (haskell.sqr y)) $

継続渡しとは，関数の戻り値の返し先を引数として受け取るものである．この戻り値の返し先，すなわち継続を関数 $c$ で表すことにしよう．そうすると $haskell.sqr$ と $haskell.add$ は次のようになる．関数の $"&"$ は継続渡しスタイルを表す．

$ haskell.sqr_"&" &colon.double haskell.Double -> (haskell.Double -> haskell.a) -> haskell.a \
  haskell.sqr_"&" x c&= c (x times x) \
  haskell.add_"&" &colon.double haskell.Double -> haskell.Double -> (haskell.Double -> haskell.a) -> haskell.a \
  haskell.add_"&" x y c&= c (x + y) $

標準関数 $haskell.sqrt$ の継続渡し版は次のようになる．

$ haskell.sqrt_"&" &colon.double haskell.Double -> (haskell.Double -> haskell.a) -> haskell.a \
  haskell.sqrt_"&" x c &= c (haskell.sqrt x) $

なお
#par-equation($ haskell.sqrt_"&" x c = c (haskell.sqrt x) \
  arrow.t.b.double \
  haskell.sqrt_"&" x = backslash c |-> c(haskell.sqrt x) $)
なので，どちらの書き方をしても良い．

継続渡しスタイルで三平方の定理の計算を行うには次のようになる．

$ haskell.pyth_"&" &colon.double haskell.Double -> haskell.Double -> (haskell.Double -> haskell.a) -> haskell.a \
  haskell.pyth_"&" x y c&= haskell.sqr_"&" x 
    (backslash x' |-> haskell.sqr_"&" y
      (backslash y' |-> haskell.add_"&" x' y'
        (backslash z' |-> haskell.sqrt_"&" z' c))) $<cps>

この計算の結果を印字するには次のようにする．
#par-equation($ haskell.main &= haskell.print (haskell.pyth_"&" 3.0 space 4.0 space id) $)
結果は $5.0$ である．

さて，話をややこしくしただけに見える継続渡しスタイルであるが，利点がある．その前に，継続渡しスタイルをより簡潔に表現する方法を見ておこう．それには#keyword[継続モナド]を使う．

継続モナド版の $haskell.sqr, haskell.add, haskell.sqrt$ は次のようになる．
#par-equation($ haskell.sqr_"m" &colon.double haskell.Double -> haskell.Cont_(haskell.a space.hair haskell.Double) \
  haskell.sqr_"m" x &= chevron.l x times x chevron.r \
  haskell.add_"m" &colon.double haskell.Double -> haskell.Double -> haskell.Cont_(haskell.a space.hair haskell.Double) \
  haskell.add_"m" x y &= chevron.l x + y chevron.r \
  haskell.sqrt_"m" &colon.double haskell.Double -> haskell.Cont_(haskell.a space.hair haskell.Double) \
  haskell.sqrt_"m" x &= chevron.l haskell.sqrt x chevron.r $)
ここに $haskell.Cont$ は継続モナド型コンストラクタである．

継続を意味する引数 $c$ が隠されたので，簡潔になった．これらの継続モナド版を使って三平方の定理を計算する関数も作っておこう．ここでdo記法の出番である．

$ haskell.pyth_"m" &colon.double haskell.Double -> haskell.Double -> haskell.Cont_(haskell.a space.hair haskell.Double) \
  haskell.pyth_"m" x y &= haskell.kwdo 
    {x' <- haskell.sqr_"m" x;
    y' <- haskell.sqr_"m" y;
    z' <- haskell.add_"m" x' y';
    z'' <- haskell.sqrt_"m" z';
    chevron.l z'' chevron.r} $

関数 $haskell.pyth_"m"$ の戻り値は継続モナドであるから，それを印字するには専用の演算子 $arrow.l.loop$ を用いて次のようにする．
#par-equation($ haskell.main = haskell.print arrow.l.loop (haskell.pyth_"m" 3.0 space 4.0) $)
または，逆方向の演算子 $arrow.r.loop$ を用いて次のようにする．#footnote[Haskellでは $arrow.r.loop$ を ```haskell runCont``` 関数を用いて書く．例えば $haskell.main = (haskell.pyth_"m" 3.0 space 4.0) arrow.r.loop haskell.print$ は ```haskell main = (pyth_m 3.0 4.0) `runCont` print``` と書く．]

$ haskell.main = (haskell.pyth_"m" 3.0 space 4.0) arrow.r.loop haskell.print $

わざわざ継続渡しスタイルを用いるのは#keyword[カレント継続]（current continuation）を使うためである．#footnote[Current continuationの日本語訳はまだ決まっていないようである．日本のプログラマはcurrent continuationをしばしばCCと略すほか「現在の継続」と呼ぶこともある．本書ではcurrent continuationを「カレント継続」と訳すことにした．]

カレント継続は，ある関数から見て，次に実行されるべき継続を表す．@cps のような継続渡しスタイルであれば，渡された継続が次に実行されるべき継続であるが，一般の関数からは次に実行されるべき継続が見えない．次に実行すべき継続を $note.eighth.alt$ で表すことにすると $haskell.sqr_"&", haskell.add_"&", haskell.sqrt_"&"$ は次のようになる．
#par-equation($ haskell.sqr_"&" x note.eighth.alt &= note.eighth.alt (x times x) \
  haskell.add_"&" x y note.eighth.alt &= note.eighth.alt (x + y) \
  haskell.sqrt_"&" x note.eighth.alt &= note.eighth.alt (haskell.sqrt x) $)
カレント継続 $note.eighth.alt$ を自動的に生成する演算子 $note.sixteenth.beamed$ を考える．この演算子 $note.sixteenth.beamed$ は関数 $f$ を受け取り，次のように $f note.eighth.alt$ を返す．
#par-equation($ note.sixteenth.beamed f = f note.eighth.alt $)
ここで注意しないといけないことがある．記号 $note.eighth.alt$ はカレント継続を表す記号であるが，これはプログラマから見ることは出来ず，またプログラム中で動的に変化する．一方で，カレント継続を与える演算子 $note.sixteenth.beamed$ は実在する演算子で，プログラマが書くことが出来る．#footnote[Haskellでは $note.sixteenth.beamed$ を ```haskell callCC``` と書く．]

カレント継続は $note.sixteenth.beamed$ 演算子に続く関数に引数として渡されるので，次のようにラムダ式で受け取ることが出来る．
#par-equation($ note.sixteenth.beamed (backslash q |-> ...) $)
この式では変数 $q$ にはカレント継続が拘束される．本書ではシンタックスシュガーとして次の記法も導入しておこう．カレント継続を引数として渡してやる演算子 $backslash.not$ を導入する．演算子 $backslash.not$ はラムダ式と同じように
#par-equation($ backslash.not q |-> ... $)
として使う．ただし引数 $q$ には実行環境がカレント継続を拘束する．一般のラムダ式のように，プログラマが引数の値を与える必要はない．#footnote[Haskellでは $backslash.not$ に直接対応する演算子は無い．しかし $backslash.not q |-> f$ は ```haskell callCC $ \ q -> f``` と書ける．]

引数 $q$ はカレント継続なので，関数 $f$ の中で呼び出すということは，関数 $f$ からの「脱出」を意味する．これを利用して，関数からの「早期リターン」のようなテクニックを実現することも可能である．例えば $haskell.pyth_"m" x y$ を変形して，もし $x<0$ または $y<0$ であれば戻り値 $0.0$ で早期リターンするようには次のようにする．
#par-equation($ haskell.pyth_"cc" &colon.double haskell.Double -> haskell.Double -> haskell.Cont_(haskell.a space.hair haskell.Double) \
  haskell.pyth_"cc" x y &= backslash.not q |->
    haskell.kwdo {
      haskell.when (x <= 0 or y <= 0) (q space 0.0); \
      &space.quad x' <- haskell.sqr_"m" x;
      y' <- haskell.sqr_"m" y;
      z' <- haskell.add_"m" x' y';
      z'' <- haskell.sqrt_"m" z';
      chevron.l z'' chevron.r} $)
ここに関数 $haskell.when$ は第1引数が真であれば第2引数を実行する関数である．関数 $haskell.when$ の第2引数と戻り値はモナド型クラスのインスタンスである必要がある必要があるため，モナドの中でしか利用できない．

関数 $haskell.pyth_"cc"$ を使ったプログラムをHaskellで書くと次のようになる．

#sourcecode[```haskell
import Control.Monad.Cont
sqr_m :: Float -> Cont a Float
sqr_m x = pure (x * x)

add_m :: Float -> Float -> Cont a Float
add_m x y = pure (x + y)

sqrt_m :: Float -> Cont a Float
sqrt_m x = pure (sqrt x)

pyth_cc :: Float -> Float -> Cont a Float
pyth_cc x y = callCC $ \q -> do
  when (x <= 0 || y <= 0) (q 0.0)
  x' <- sqr_m x
  y' <- sqr_m y
  z' <- add_m x' y'
  z'' <- sqrt_m z'
  pure z''

main = (pyth_cc 5 12) `runCont` print
```]

=== この章のまとめ

- Haskellにおける入出力（IO）はIO型を通して行われる．IO型はIOモナド型クラスのインスタンスである．
- IO型の戻り値を返す関数を「IOアクション」と呼ぶ．
- ファイルの読み込みは $haskell.getContents colon.double haskell.IOString$ で行うことが出来る．
- バインド演算子 $(haskell.bind)$ を用いると，IOアクションを直列につなげることが出来る．
- 疑似乱数もIO型を通して取得する．
- mainアクションもIO型である．
- do記法を使うと，バインド演算子を用いた式を手続き型プログラミング風に書くことが出来る．
- do記法と「カレント継続」を組み合わせると，プログラムはより手続き型風になる．

#showybox(title: "作用と副作用")[
関数 $z = f x $ の参照透過性を保ったまま，関数 $f$ に副作用を持たせるには次のように定義すると良い．
$ paren.l.stroked z, w' paren.r.stroked = f paren.l.stroked x, w paren.r.stroked $

引数 $x$ に注目すると $z = f x$ の関係性は保たれており，一方で $w$ で表現される内部状態は関数 $f$ の実行後に $w'$ に変化するものと理解することが出来る．

そのため，副作用を隠すためにはモナド型クラスはなくても良い．モナド型クラスを導入する理由は関数合成と，逐次実行を担保するためである．@saru1
]

= 今後の追記予定

本書には今後第2部，第3部を追記する予定である．第2部は具体的なHaskellプログラミングを，第3部はより高度な数学概念を扱う．また第1部も随時更新する予定である．@this-book

#bibliography("references.yaml")

// #tk 索引

