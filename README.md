[![Build Status](https://travis-ci.org/note103/Carvo.svg?branch=master)](https://travis-ci.org/note103/Carvo)
[![Coverage Status](https://coveralls.io/repos/github/note103/Carvo/badge.svg?branch=master)](https://coveralls.io/github/note103/Carvo?branch=master)
[![codecov.io](https://codecov.io/github/note103/Carvo/coverage.svg?branch=master)](https://codecov.io/github/note103/Carvo?branch=master)

Carvo
=====

Cards of vocabulary

## 説明

- 英単語などの学習をゲーム感覚で行うためのツールです。
- 設問に対応する回答を入力します。

## DEMO

![](https://dl.dropboxusercontent.com/u/7779513/carvo/2016-01-20_en.gif)

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

1. スタートすると設問が表示されます。回答を打ち込むと、`Good!`またはまたは`NG!`と出てきます。

1. 任意の数字を入れると、その番号に紐付いた設問が出てきます。
  - 何も入力せずにエンターすると、出題されます。

1. レッスン中に`h`または`--help`コマンドを打つとヘルプが出てきます。
```
h   --help	ヘルプ一覧表示
b   --back	通常リストへ戻る
f   --fail	誤答リストへ移動
l   --list	単語リストを表示
q   --quit	進行中のレッスンを終了
qq  	2段階一斉終了
ro  --read-only	セーブした語句へ復帰
rs  --restore	セーブした語句へ復帰
s   --same	直前の設問を再表示
sv  --save	最後に回答した語句（番号）をセーブ
v   --voice-change	読み上げ設定のon/off切り替え
数字    	任意の問題番号へジャンプ
```

## 得点について

- 正答/誤答するたびに得点が加算されます。レッスンを切り替えても得点は保持され、プログラムを終了すると消えます。
- 正答は`hit`, 誤答は`error`, その合計を`times`として加算します。回答を入力しなかった場合は`times`にのみ加算されます。
- プログラム終了時に成績と回答記録が出力されます。

## サンプルデータについて

- `src/lesson`ディレクトリに入っている出題用ファイルはサンプルデータです。使用者の好みに応じて書き換えてください。

## ライセンス
Copyright (C) Hiroaki Kadomatsu.

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

## 作者

Hiroaki Kadomatsu (@note103)

- [Blog](http://note103.hateblo.jp/)
- [Twitter](https://twitter.com/note103)
