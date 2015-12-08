Carvo
=====

Cards of vocabulary

## 説明

- 英単語学習をゲーム感覚で行うためのツールです。
- 日本語が出てきたらそれに対応する英単語を打ち込みます。

## DEMO

![](https://dl.dropboxusercontent.com/u/7779513/carvo/2015-11-27_carvo.gif)

## 使い方

1. 任意の場所にディレクトリを設置して中へ入り、
```
$ cd Carvo
```

1. `carvo.pl`を実行します。
```
$ perl carvo.pl
```

1. コースの選択肢が出てくるので、行頭のコマンドを入力＆エンターするとレッスンが始まります  
※`q`で退室します。  

1. スタートすると単語が出てきます。回答を打ち込むと、`OK!`またはまたは`NG!`と出てきます。

1. 任意の数字を入れると、その番号に紐付いた単語が出てきます。
  - 何も入力せずにエンターすると、1番からスタートします。

1. `h`または`--help`コマンドでヘルプが出てきます。

1. その他のコマンドに以下があります。（ヘルプより）
```
全般:
    h   --help	これが出てくる
    l   --list	単語リストを表示
    o   --order	単語リストを辞書順に構成（デフォルト）
    r   --random	単語リストをランダムに構成
    q   --quit	コース終了
    qq  --force-quit	コース選択画面を経ずにプログラム終了
操作:
    s   --same	直前の語句を繰り返す
    j   --jump	ランダムにジャンプ
    数字    	任意の番号へジャンプ
    単語    	リストにその語句が含まれていれば紐付く数字と共に表示（英単語のみ）
読み上げ設定:
    v   --voice	on/off切り替え
    lo  --long	例文を読み上げる（カードに例文がある場合）
    sh  --short	例文を読み上げない（デフォルト）
その他:
    f   --fail	誤答リストへ移動
    b   --back	通常リストへ戻る
    sv  --save	最後に回答した語句（番号）をセーブ
    rv  --revival	セーブした語句へ復帰
    urv --unrevival	セーブした語句へ復帰する前の場所へ復帰
```

## 得点について

- 正答/誤答するたびに得点が加算されます。レッスンのモードを切り替えても得点は保持されますが、プログラムを終了すると記録は消えます。
- 正答は`hit`, 誤答は`error`, その合計を`times`として加算します。回答を入力しなかった場合は加算されまれません。
- プログラム終了時に合計成績を出力します。

## サンプルデータについて

- `card`ディレクトリに入っているファイルは、書式例としてのサンプルデータです。使用者の好みに応じて書き換えてください。

## ライセンス
Copyright (C) Hiroaki Kadomatsu.

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

## 作者

Hiroaki Kadomatsu (@note103)

- [Blog](http://note103.hateblo.jp/)
- [Twitter](https://twitter.com/note103)
