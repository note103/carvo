#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use Carvo;
use Time::Piece;

my $msg = "Select a number of courses\n
r: random (default)
o: order
q: exit";

print "$msg\n";
my $logs = \@Carvo::logs;
my $log;
my $result;
my $timestamp = localtime;

while (my $in = <>) {
    if ($in =~ /^(q)$/) {
        print "\nTotal score:\n";
        print $result = "$Carvo::total\t$Carvo::times\n$Carvo::point\t$Carvo::hits\n$Carvo::miss\t$Carvo::errors\n";
        logs();
        result();
        last;
    } elsif ($in =~ /^(r|\n)$/) {
        Carvo::main(Words::english(), 'random');
    } elsif ($in =~ /^(o)$/) {
        Carvo::main(Words::english(), 'order');
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
    print $fh_out $timestamp->datetime(T=>' ')."\n";
    print $fh_out $result."\n";
    print $fh_out @words;
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
