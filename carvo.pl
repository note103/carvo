#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use Carvo;
use Time::Piece;

my $msg = "Select a number of courses\n
1: ja->en / random (default)
2: ja->en / order
3: en->ja / random
4: en->ja / order
5: mix / random
6: mix / order
q: exit";

print "$msg\n";
my $logs = \@Carvo::logs;
my $log;
my $result;
my $timestamp = localtime;

while (my $in = <>) {
    if ($in =~ /^(q)$/) {
        print "Total score:\n";
        print $result = "\t$Carvo::total\t$Carvo::times\n\t$Carvo::point\t$Carvo::hits\n\t$Carvo::miss\t$Carvo::errors\n";
        print $timestamp->datetime(T=>' ')."\n";
        logs();
        result();
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

sub logs {
    my @tidy;
    for my $tidy (@$logs) {
        if ($tidy =~ /(.+)\(\d+\)(.+)/) {
            push @tidy, "$1$2\n";
        }
    }
    my %unique = map {$_ => 1} @tidy;
    my @words = sort keys %unique;
    open my $fh, '>>', 'data/logs.txt' or die $!;
    print $fh @words;
    print $fh "\nTotal score:\n".$result;
    print $fh $timestamp->datetime(T=>' ')."\n";
    print $fh "---\n";
    close $fh;
}
sub result {
    open my $fh, '>>', 'data/result.txt' or die $!;
    print $fh $timestamp->datetime(T=>' ')."\n";
    print $fh $result."\n";
    close $fh;
}
