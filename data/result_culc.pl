#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';

my @line = <DATA>;
my $num = 0;
for my $str (@line) {
    if ($str =~ /^(\d+)\thit/) {
        $num +=  $1;
        print $str;
        say "total: $num";
    } else {
        print '';
    }
}
print $num;

__DATA__
