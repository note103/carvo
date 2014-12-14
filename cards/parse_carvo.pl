#!/usr/bin/env perl
use strict;
use warnings;

for my $str (<DATA>) {
    $str =~ s/(.+): (.+)/    "$1" : "$2",/g;
    print $str;
}

__DATA__
isolate: 〈国組織など〉を孤立させる|離す
isolate Iraq economically: イラクを経済的に孤立させる
