[![Build Status](https://travis-ci.org/note103/carvo.svg?branch=master)](https://travis-ci.org/note103/carvo)

carvo
=====

cards of vocabulary

## 説明

- 英単語の学習を行うゲームです。
- 出題される設問に対応する回答を選択肢から選びます。

## DEMO

![](DEMO.gif)

### 音声付き動画
- https://www.youtube.com/watch?v=yvPyS1f2-kc

## 使い方

1) 任意の場所にルートディレクトリを設置して中へ入ります。
```
$ cd carvo
```

2) `carvo.pl`を実行します。
```
$ perl carvo.pl
```

3) 表示される選択肢から希望する「カード」を選びます。

4) コマンド群から`play`を選択すると設問が表示されます（英単語、英文、簿記仕訳科目）。

5) 対応する回答を選択肢から選ぶと、正答なら`Good!`、誤答なら`NG!`という結果が表示されます。

### 機能

`help`コマンドを選択すると機能一覧が表示されます。

```
- play	次の問題を出題
- again	同じ問題を出題
- card	プレイを終了してカード選択画面へ移動
- exit	ゲームを終了
- list	カード内の単語を一覧表示＆選択した単語へ移動
- fail	誤答カードへ移動
- voice	音声機能のon/off（macOSのみ）
- help	ヘルプ表示
```

### 得点

- 正答なら`hit`, 誤答なら`error`, その合計を`times`として加算します。
- 得点はカードやレッスンを切り替えても保持され、ゲームの終了時に回答記録と成績が出力されます。

### 単語カード

- `src/lesson`ディレクトリに入っている単語カードはサンプルです。使用者の好みに応じて書き換えてください。
- `dict.yml` に `英単語: 和訳` 形式で辞書を作成し、同ディレクトリ内に `.txt` 拡張子でファイル（単語カード）を作成します。
    - `sample.txt` というファイルを作成すればゲーム内の選択肢として `sample` が現れます。
- 単語カードには辞書で記載している英単語のみ使用できます。

## 依存ツール

コマンドラインツールの`peco`と`cho`が必要です。

- [peco](https://github.com/peco/peco)
- [cho](https://github.com/mattn/cho)

## ライセンス
Copyright (C) Hiroaki Kadomatsu.

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

## 作者

Hiroaki Kadomatsu (@note103)

- [Blog](http://note103.hateblo.jp/)
- [Twitter](https://twitter.com/note103)
