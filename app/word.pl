#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';

my @word = <DATA>;
for (@word) {
    if ($_ =~ /^#.+/) {
    } elsif ($_ =~ s/^(\w+)$/$1/g) {
        print `open http://ejje.weblio.jp/content/$_`;
        #print `open http://ejje.weblio.jp/sentence/content/$_`;
    }
}

__DATA__
nanny
nevertheless
#notoriety
#persevere
