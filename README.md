Carvo2
=====

Cards of vocabulary vol.2

## 説明

- [Carvo](https://github.com/note103/Carvo) の第2弾のようなものです。

## DEMO

![](https://dl.dropboxusercontent.com/u/7779513/gif/carvo/2014-11-03.gif)

## Carvo との違い

使い勝手はほぼ同じですが、以下の点が異なります。

1. 以前にあった登録語の多寡によるモード分けはやめて、ランダムモードと順列モードの違いを採択。
  - 順列モードは語句の順番（アルファベット順など）
1. 以前の登録語は「英単語/その日本語訳」の1:1だったが、Perlの配列やハッシュのリファレンス機能を用いて、1つの単語から紐づく文章（日本語/英語それぞれ）を表示できるようにした（文章は複数も可）
1. 登録語ファイルを一本化したのでソースコードの構造がシンプルになり、量も減った（はず）
1. 英語を見て日本語回答を入力する機能を削除した（いろいろ難しかったので）

上記のうち、とくに2と3は作成のモチベーションになっています。

## 使い方

1. [以前](https://github.com/note103/Carvo)とほぼ同じですが、まず任意の場所にディレクトリを置いて中に入り、
```
$ cd Carvo2
```

1. ターミナルで`carvo.pl`を実行します。
```
$ perl carvo.pl
```

1. 選択肢が出てくるので、いずれかの番号を入力＆エンターするとレッスンが始まります  
※選択せずにエンターすると自動的に`default`を選択します。  
※`q`を入力すると退室します。  

1. スタートすると単語が出てくるので、そのままターミナルに回答（英単語に対する日本語、日本語に対する逆）を打ち込むと、`NG!`または`OK!`と出てきます。

1. 任意の数字を入れると、その番号に紐付いた単語が出てきます。
  - 登録単語以上の数字（番号）は受け付けません。上限はレッスン開始直後に表示されます。
  - 何も入力せずにエンターすると、1番からスタートします。以後も正解またはギブアップ（後述の`q`コマンド）の後にエンターを入力すると次の番号の単語が出てきます。
  - 正解もギブアップもしない状態で未入力のままエンターした場合には「Again!」と出て回答を求めます。

1. 数字以外に以下のコマンドを入力すると、それぞれの動作をします。
  - **s**: 直前に出た単語をもう一度出します。
  - **j**: ランダムに単語を出力します（これを使用しなければ番号順に出力します）。
  - **q**: レッスンのループから抜けます。

1. レッスン終了後、もう一度`q`を入力するとプログラムも終了します。

## 得点について

- 正答/誤答するたびに得点が加算されます。レッスンのモード（上記番号）を切り替えても得点を保持しますが、プログラムを終了すると記録はリセットされます。
- 正答は`hit`, 誤答は`error`, その合計を`try`数として加算します。回答を入力しなかった場合はそのいずれにも含まれません。
- プログラム終了時に総計を出力します。

## サンプルデータについて

- 登録語を記しているWords.pmは暫定的なものなので、どこかに再配布可能なデータがあれば今後はそういう物を使うかもしれません。

## TODO

- [以前のTODO](https://github.com/note103/Carvo/blob/master/README.md#todo)

## DONE

- r[andom]コマンドをj[ump]コマンドに修正（Carvo2ではランダムモードを実装しており「ランダム」の語義/語句が混在して良くないため） - 2014/11/03 11:39
- 退出時に出てくる得点結果をテキストファイル等に自動的に書き出せるようにしたい - done! 2014/08/27 01:30
- Carvo2 公開 2014/08/25 20:01
- ランダム設定のときに日英混在で出てくるようにしたい - done!
- どの階層にいても`qq`で終了するようにしたい - abort
- [以前の完了項目](https://github.com/note103/Carvo/blob/master/README.md#done)

## ライセンス
Copyright (C) Hiroaki Kadomatsu.

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

## 作者

Hiroaki Kadomatsu (@note103)

- [Blog](http://note103.hateblo.jp/)
- [Twitter](https://twitter.com/note103)
