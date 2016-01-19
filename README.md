Carvo
=====

Cards of vocabulary

## 説明

- 英単語などの学習をゲーム感覚で行うためのツールです。
- 設問に対応する回答を入力します。

## DEMO

![](https://dl.dropboxusercontent.com/u/7779513/carvo/2016-01-20-00-27.gif)

https://www.youtube.com/watch?v=Xvao6oK8L0M

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

1. スタートすると設問が表示されます。回答を打ち込むと、`OK!`またはまたは`NG!`と出てきます。

1. 任意の数字を入れると、その番号に紐付いた設問が出てきます。
  - 何も入力せずにエンターすると、出題されます。

1. `h`または`--help`コマンドでヘルプが出てきます。

1. その他のコマンドに以下があります。（ヘルプより）
```
h   --help	ヘルプ一覧表示
l   --list	単語リストを表示
q   --quit	進行中のレッスンを終了
qq  	2段階一斉終了
qqq 	3段階一斉終了
os  --order-swap	単語の並び順をランダム/辞書順で切り替え
s   --same	直前の設問を再表示
数字    	任意の問題番号へジャンプ
x＋数字   	ヒントの文字数を設定（例: x2）
vs  --voice-swap	読み上げ設定のon/off切り替え
f   --fail	誤答リストへ移動
b   --back	通常リストへ戻る
sv  --save	最後に回答した語句（番号）をセーブ
ro  --read-only	セーブした語句へ復帰
rv  --revert	セーブした語句へ復帰
```

## 得点について

- 正答/誤答するたびに得点が加算されます。レッスンを切り替えても得点は保持されますが、プログラムを終了すると記録は消えます。
- 正答は`hit`, 誤答は`error`, その合計を`times`として加算します。回答を入力しなかった場合は加算されまれません。
- プログラム終了時に成績および回答記録を出力します。

## サンプルデータについて

- `src/lesson`ディレクトリに入っているファイルは、書式例としてのサンプルデータです。使用者の好みに応じて書き換えてください。

## ライセンス
Copyright (C) Hiroaki Kadomatsu.

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

## 作者

Hiroaki Kadomatsu (@note103)

- [Blog](http://note103.hateblo.jp/)
- [Twitter](https://twitter.com/note103)
