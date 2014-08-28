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
        Carvo::main(Words::english(), 'random', 'ja2en');
    } elsif ($in =~ /^(2)$/) {
        Carvo::main(Words::english(), 'order', 'ja2en');
    } elsif ($in =~ /^(3)$/) {
        Carvo::main(Words::english(), 'random', 'en2ja');
    } elsif ($in =~ /^(4)$/) {
        Carvo::main(Words::english(), 'order', 'en2ja');
    } elsif ($in =~ /^(5)$/) {
        Carvo::main(Words::english(), 'random', 'mix');
    } elsif ($in =~ /^(6)$/) {
        Carvo::main(Words::english(), 'order', 'mix');
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

    my @tmp;
    open my $fh_in, '<', 'data/logs.txt' or die $!;
    for (<$fh_in>) {
        push @tmp, $_;
    }
    close $fh_in;

    open my $fh_out, '>', 'data/logs.txt' or die $!;
    print $fh_out @words;
    print $fh_out "\nTotal score:\n".$result;
    print $fh_out $timestamp->datetime(T=>' ')."\n";
    print $fh_out "---\n";
    print $fh_out @tmp;
    close $fh_out;
}

sub result {
    my @tmp;
    open my $fh_in, '<', 'data/result.txt' or die $!;
    for (<$fh_in>) {
        push @tmp, $_;
    }
    close $fh_in;

    open my $fh_out, '>', 'data/result.txt' or die $!;
    print $fh_out $timestamp->datetime(T=>' ')."\n";
    print $fh_out $result."\n";
    print $fh_out @tmp;
    close $fh_out;
}
