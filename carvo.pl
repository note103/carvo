#!/usr/bin/env perl
use strict;
use warnings;
use 5.012;
use Time::Piece;
use open ':utf8';
use lib 'lib';
use Carvo;
use Carvo::Generator;

my $dir = 'card';
my @files;
opendir(my $dirh, $dir) || die "can't opendir $dir: $!";
for my $file (readdir $dirh) {
    if ($file =~ /^(.+)_(.*)(.json)/) {
        push @files, "$1: $2";
    }
}
closedir $dirh;

my $msg_first = "\nWelcome!\nPlease select a number of courses.\n";
say $msg_first;
sub msg {
    for (@files) {
        say $_;
    }
    say "q: exit\n";
}
sub msg_edit {
    for (@files) {
        say "\t$_";
    }
    say "\tq: exit\n";
}

msg();
my $logs = \@Carvo::logs;
my $log;
my $result;

my $msg_correct = "Please input a number or 'q'.\n";
my ($file, $cards, $tag);
OUTER: while (my $in = <>) {
    if ($in =~ /^(q)$/) {
        print "\nTotal score:\n";
        print $result = "$Carvo::total\t$Carvo::times\n$Carvo::point\t$Carvo::hits\n$Carvo::miss\t$Carvo::errors\n";
        logs();
        result();
        if ($Carvo::voice_sw eq 'on') {
            print `$Carvo::voice Bye!`;
        }
        last;
    } elsif ($in =~ /^(r|result)$/) {
        print `open data/result*`;
    } elsif ($in =~ /^(l|logs)$/) {
        print `open data/logs*`;
    } elsif ($in =~ /^(e|edit)$/) {
        say 'Select a file.';
        msg_edit();
        while (my $edit = <>) {
            if ($edit =~ /^(q)$/) {
                say $msg_first;
                last;
            } elsif ($edit =~ /^(.+)$/) {
                $tag = $1;
                my $dir = 'card';
                opendir(my $dh, $dir) or die "can't opendir $dir: $!";
                for $file (readdir $dh) {
                    if ($file =~ /^$tag\_.*(.json)/) {
                        $cards = "card/$file";
                        print `open $cards app/parse.pl app/word.pl`;
                        last OUTER;
                    }
                }
                say $msg_correct;
                closedir $dh;
            }
        }
    } elsif ($in =~ /^(.+)$/) {
        $tag = $1;
        my $dir = 'card';
        opendir(my $dh, $dir) or die "can't opendir $dir: $!";
        for $file (readdir $dh) {
            if ($file =~ /^$tag\_.*(.json)/) {
                Carvo::main(Generator::switch($tag));
            }
        }
        closedir $dh;
        say $msg_correct;
    } else {
        say $msg_correct;
    }
    msg();
}

sub logs {
    my @tidy;
    for my $tidy (@$logs) {
        if ($tidy =~ /(.+)\(\d+\)(.+)/) {
            push @tidy, "$1$2\n";
        } elsif ($tidy =~ s/\d+\. //) {
            push @tidy, $tidy;
        } else {
            push @tidy, $tidy;
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
    print $fh_out localtime->datetime(T=>' ')."\n";
    print $fh_out $result;
    print $fh_out "---\n";
    print $fh_out @words;
    print $fh_out "\n";
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
    print $fh_out localtime->datetime(T=>' ')."\n";
    print $fh_out $result."\n";
    print $fh_out @tmp;
    close $fh_out;
}
