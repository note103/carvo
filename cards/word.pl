#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';

my @word = <DATA>;
for (@word) {
    if ($_ =~ /^#.+/) {
    } elsif ($_ =~ s/^(\w+):.+$/$1/g) {
        print `open http://ejje.weblio.jp/content/$_`;
        print `open http://ejje.weblio.jp/sentence/content/$_`;
    }
}

__DATA__
nanny: 子守の女性
nevertheless: それでもやはり
#notoriety: 悪評|悪名の高い人
#persevere: 我慢する|耐える|信じ続ける
#privilege: 特典|光栄
