Carvo
=====

Cards of vocabulary

## 説明

- 英単語などの学習を行うゲームです。
- 出題される設問に対応する回答を選択肢から選びます。

## DEMO

![](DEMO.gif)

### 音声付き動画
- https://www.youtube.com/watch?v=jgVvJfHAvL0

## 使い方

1) 任意の場所にルートディレクトリを設置して中へ入り、
```
$ cd Carvo
```

2) `carvo.pl`を実行します。
```
$ perl carvo.pl
```

3) 表示される選択肢から希望する「レッスン」を選び、その中から希望する「カード」を選びます。

4) コマンド群から`play`を選択すると設問が表示されます（英単語、英文、簿記仕訳科目）。
5) 対応する回答を選択肢から選ぶと、正解なら`Good!`、誤答なら`NG!`という結果が表示されます。

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
