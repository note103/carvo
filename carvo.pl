#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use Carvo;

my $msg = "Select a number of courses\n
1: ja->en / random (default)
2: ja->en / order
3: en->ja / random
4: en->ja / order
5: mix / random
6: mix / order
q: exit";

print "$msg\n";
while (my $in = <>) {
    if ($in =~ /^(q)$/) {
        print "Total score:\n\t$Carvo::total\t$Carvo::times\n\t$Carvo::point\t$Carvo::hits\n\t$Carvo::miss\t$Carvo::errors\n";
        last;
    } elsif ($in =~ /^(1|\n)$/) {
        Carvo::tutor(Words::english(), 'random', 'ja2en');
    } elsif ($in =~ /^(2)$/) {
        Carvo::tutor(Words::english(), 'order', 'ja2en');
    } elsif ($in =~ /^(3)$/) {
        Carvo::tutor(Words::english(), 'random', 'en2ja');
    } elsif ($in =~ /^(4)$/) {
        Carvo::tutor(Words::english(), 'order', 'en2ja');
    } elsif ($in =~ /^(5)$/) {
        Carvo::tutor(Words::english(), 'random', 'mix');
    } elsif ($in =~ /^(6)$/) {
        Carvo::tutor(Words::english(), 'order', 'mix');
    } else {
        print "Please input a correct one.\n";
    }
    print "$msg\n";
}


