carvo
=====

cards of vocabulary

## 説明

- 英単語などの学習を行うゲームです。
- 出題される設問に対応する回答を選択肢から選びます。

## DEMO

![](DEMO.gif)

### 音声付き動画
- https://youtu.be/X4pVW7ozteo

## 使い方

1) 任意の場所にルートディレクトリを設置して中へ入ります。
```
$ cd carvo
```

2) `carvo.pl`を実行します。
```
$ perl carvo.pl
```

3) 表示される選択肢から希望する「レッスン」を選び、その中から希望する「カード」を選びます。

4) コマンド群から`play`を選択すると設問が表示されます（英単語、英文、簿記仕訳科目）。

5) 対応する回答を選択肢から選ぶと、正答なら`Good!`、誤答なら`NG!`という結果が表示されます。

### 機能

`help`コマンドを選択すると機能一覧が表示されます。

```
- play	次の問題を出題
- again	同じ問題を出題
- quit-this-card	プレイを終了してカード選択画面へ移動
- exit-carvo	ゲームを終了
- question-list	カード内の単語を一覧表示＆選択した単語へ移動
- voice-mode	音声機能のon/off（OS Xのみ）
- cave-mode	虫食い機能のon/off（一部レッスンのみ）
- fail-mode	誤答カードへ移動
- read-write-mode	5肢選択モード（デフォルト）<->直接入力モードの切替え（一部レッスンのみ）
- set-word-count	ヒントの文字数を設定（直接入力モードのみ）
- help	ヘルプ一覧表示
```

### 得点／記録

- 正答なら`hit`, 誤答なら`error`, その合計を`times`として加算します。
- 得点はカードやレッスンを切り替えても保持され、ゲームの終了時に成績と回答記録が出力されます。
- 回答記録は`docs/log`ディレクトリ内の`log.txt`に記載されます。
- 1日分の成績は`docs/log`ディレクトリ内の`result.txt`に記載されます。

### サンプルデータ

- `src/lesson`ディレクトリに入っているレッスン・ファイルはサンプルです。使用者の好みに応じて書き換えてください。

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
