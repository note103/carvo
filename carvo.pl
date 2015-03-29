#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use Carvo;
use Carvo::Generator;
use Time::Piece;
use 5.012;
use open ":utf8";

my $dir = 'card';
my $num_last;
my @files;
opendir(my $dirh, $dir) || die "can't opendir $dir: $!";
for my $file (readdir $dirh) {
    if ($file =~ /^(.+)_(.*)(.json)/) {
        push @files, "$1: $2";
        $num_last = $1;
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
while (my $in = <>) {
    if ($in =~ /^(q)$/) {
        print "\nTotal score:\n";
        print $result = "$Carvo::total\t$Carvo::times\n$Carvo::point\t$Carvo::hits\n$Carvo::miss\t$Carvo::errors\n";
        logs();
        result();
        if ($Carvo::voice_sw eq 'on') {
            print `$Carvo::voice Bye!`;
        }
        last;
    } elsif ($in =~ /^(\n)$/) {
        Carvo::main(Generator::switch('1'));
    } elsif ($in =~ /^(r|result)$/) {
        print `open data/result*`;
    } elsif ($in =~ /^(l|logs)$/) {
        print `open data/logs*`;
    } elsif ($in =~ /^(e|edit)$/) {
        say 'Select a file.';
        msg_edit();
        while (my $edit = <>) {
            if ($edit =~ /^(.+|\n)$/) {
                my $num;
                if ($1 =~ /\n/) {
                    $num = 1;
                } else {
                    $num = $1;
                }
                my ($file, $cards);
                my $dir = 'card';
                opendir(my $dh, $dir) or die "can't opendir $dir: $!";
                for $file (readdir $dh) {
                    if ($file =~ /^$num.*(.json)/) {
                        $cards = "card/$file";
                        print `open $cards app/parse.pl app/word.pl`;
                    }
                }
                closedir $dh;
                say 'Select a file.';
                msg_edit();
            } elsif ($edit =~ /^(q)$/) {
                say $msg_first;
                last;
            } else {
                say $msg_correct;
            }
        }
    } elsif ($in =~ /^(.+)$/) {
        my $num = $1;
        Carvo::main(Generator::switch($num));
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
