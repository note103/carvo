#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use File::Slurp;
use Time::Piece;
use Time::Seconds;

my $num = 100;
my $count = 10;
$num = $ARGV[0] if ($ARGV[0]);
$count = $ARGV[1] if ($ARGV[1]);

my $data = read_file('src/log/log.txt');
my @data = split /\n/, $data;

my $localtime = localtime->date;
my $localtime2 = localtime->strptime($localtime, '%Y-%m-%d');

my @log;
my @stat;
for my $stat (@data) {
    if ($stat =~ /^(\d{4}-\d{2}-\d{2})/) {
        my $date = $1;
        my $localtime3 = localtime->strptime($date, '%Y-%m-%d');
        my $subtract = ( $localtime2 - $localtime3 ) / ONE_DAY;
        push @log, $stat."\n";
        last if ($subtract >= $num);
    } else {
        push @stat, $stat."\n";
    }
}
my %fail;
for (@stat) {
    if ($_ =~ /\A\*(.+)/) {
        $fail{$1}++;
    }
}

my @sort;
for (sort keys %fail) {
    push @sort, "$fail{$_}: $_";
}

say "\n[$num days/word:$count]";

my %out;
my @head;
my @word;
for (@sort) {
    if ($_ =~ /^(\d+)(: .+)/) {
        push @head, $1;
        push @word, $2;
        $out{$1}{$2} = 1;
    }
}
for my $head (reverse sort @head) {
    for my $word (sort {lc($a) cmp lc($b)} @word) {
        if ($out{$head}{$word}) {
            say $head.$word;
            @word = grep {$_ ne $word} @word;
            $count--;
            exit if ($count == 0);
        }
    }
}
