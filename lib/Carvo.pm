#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
binmode(STDOUT, ":utf8");

package Carvo {
    our ($point, $miss) = (0, 0);
    our $total = $point + $miss;
    our ($times, $hits, $errors) = qw/times hits errors/;
    our $voice_sw = 'off';
    our @logs;
    my ($words, $english, $key, $limit);
    my (@words, @voice);
    my $mode = 'random';
    my $title = 'title';
    my $end = 'end';
    my $voice = 'say';
    my $voice_in = 1;
    my %english;
    my ($port, $num) = (0, 0);
    my $msg_correct = "Please input a correct one.";
    sub main {
        $english = shift;
        %english = %$english;
        mode();
        my $enter = '\n';
        $limit = @words;
        my $msg_first = 'Input (num|enter|r|o|j|v|q).';
        my $msg_usual = 'Input (num|enter|r|o|j|v|s|q).';
        my $msg_limit = "You can choose a number from 1-$limit.";
        my $msg_random = "This is random select.";
        if (exists ($english{$title})) {
            print "Welcome to the \"".$english{$title}."\"!\n";
            if ($voice_sw eq 'on') {
                print `say Welcome to the $english{$title}`;
            }
        }
        print "$msg_limit\n$msg_first\n";
        my $input = sub {
            while (my $in_ans = <>) {
                if ($in_ans =~ /^($enter)$/) {
                    $miss++;
                    push @logs, $key."*\n";
                    qa('a');
                    print "\n$msg_usual\n";
                    last;
                } else {
                    my $regexp = chomp $in_ans;
                    my $match;
                    $match = "$key";
                    $regexp = $in_ans;
                    if ($regexp =~ /($match)/) {
                        $point++;
                        $total = $point + $miss;
                        plural($total, $point, $miss);
                        if ($regexp =~ /^($match)$/) {
                            print "\nGood!!\n";
                        } else {
                            print "\nNot too bad.\n";
                        }
                        qa('a');
                        print "\nYou tried $total $times. $point $hits and $miss $errors.\n$msg_usual\n";
                        last;
                    } else {
                        $miss++;
                        push @logs, $key."*\n";
                        print "\nNG! Again!\n";
                    }
                }
            }
        };
        while (my $in_way = <>) {
            if ($in_way =~ /^(q)$/) {
                $total = $point + $miss;
                $port = 0;
                last;
            } elsif ($in_way =~ /^0$/) {
                print "\n$msg_limit\n";
            } elsif ($in_way =~ /^(\d+)$/) {
                $num = $1;
                $port = $num;
                if ($in_way > $limit) {
                    print "\nToo big! $msg_limit\n$msg_random\n\n";
                    jump();
                    $input->();
                } else {
                    qa('q');
                    $input->();
                }
            } elsif ($in_way =~ /^(n|\n)$/) {
                if ($port == $limit) {
                    print "You exceeded the maximum. Return to the beggining.\n\n";
                    $num = 1;
                    $port = $num;
                    qa('q');
                    $input->();
                } else {
                    $num = $port+1;
                    $port = $num;
                    qa('q');
                    $input->();
                }
            } elsif ($in_way =~ /^(v)$/) {
                voice();
                print "\n$msg_usual\n";
            } elsif ($in_way =~ /^(j)$/) {
                jump();
                $input->();
            } elsif ($in_way =~ /^(r)$/) {
                $mode = 'random';
                mode();
                jump();
                $input->();
            } elsif ($in_way =~ /^(o)$/) {
                $mode = 'order';
                mode();
                if ($port == $limit) {
                    $num = 0;
                } else {
                    $num = $port+1;
                }
                $port = $num;
                qa('q');
                $input->();
            } elsif ($in_way =~ /^(s)$/) {
                $num = $port;
                qa('q');
                $input->();
            } elsif ($in_way =~ /^(\w+)$/) {
                $key = $1;
                if (exists($english{$key})) {
                    my $num_get = num_get($key, @words);
                    sub num_get {
                        my($str, @arr) = @_;
                        my $i = 0;
                        for (@arr) {
                            if($str eq $arr[$i]){
                                return $i;
                            } else {
                                $i++;
                            }
                        }
                    }
                    my $num_here = $num_get + 1;
                    print "\nHere is $key($num_here)\n$msg_first\n";
                } else {
                    print "\nHere is not '$key'.\n$msg_usual\n";
                }
            } elsif ($in_way =~ /^([\W\D]+)$/) {
                print "\n$msg_correct\n$msg_random\n\n";
                jump();
                $input->();
            } else {
                print "\n$msg_correct\n";
            }
        }
        sub jump {
            $num = int(rand($limit+1));
            $port = $num;
            qa('q');
        }
        sub mode {
            if ($mode eq 'order') {
                @words = sort (keys %english);
            } elsif ($mode eq 'random') {
                @words = keys %english;
            }
            $words = \@words;
        }
    }

    sub voice {
        print "You can turn on/off the switch. (Y/n)\n";
        while (my $voice_sw_in = <>) {
            if ($voice_sw_in =~ /^(\n|y)$/) {
                $voice_sw = 'on';
                print "Select a number.\n";
                print `$voice select a number`;
                my @voice = (qw/Agnes Kathy Princess Vicki Victoria Alex Bruce Fred Junior Ralph Albert Bahh Bells Boing Bubbles Cellos Deranged Hysterical Trinoids Whisper Zarvox/, '"Bad News"', '"Good News"', '"Pipe Organ"');
                my $voice_count = 1;
                for (@voice) {
                    print $voice_count.". ".$_."\n";
                    $voice_count++;
                }
                while ($voice_in = <>) {
                    chomp($voice_in);
                    if ($voice_in =~ /\D/) {
                        print "$msg_correct\n";
                    } elsif ($voice_in =~ /\d/ && $voice_in > scalar(@voice)) {
                        print scalar(@voice)."\n";
                        print $voice_in."\n";
                        print "Too big! $msg_correct\n";
                    } elsif ($voice_in =~ /^$/) {
                        $voice = "say";
                        print "You selected default type.\n";
                        print `$voice hi`;
                        last;
                    } else {
                        my $voice_selected = $voice[$voice_in-1];
                        $voice = "say -v $voice_selected";
                        print "You selected $voice_selected\n";
                        print `$voice hi I am $voice_selected`;
                        last;
                    }
                }
                last;
            } elsif ($voice_sw_in =~ /^n$/) {
                $voice_sw = 'off';
                last;
            } else {
                print "$msg_correct\n";
            }
        }
    }
    sub qa {
        my $ans;
        my $qa_switch = shift;
        $key = $words->[$num-1];
        if ($key eq $title) {
            $key = $words->[-1];
        } elsif ($key eq $end) {
            $key = $words->[0];
        }
        if (ref $english->{$key}) {
            my $ex_num = 0;
            if ($qa_switch eq 'q') {
                print "$english->{$key}[0]\n";
                for my $sentence (sort keys %{$english->{$key}[1]}) {
                    $ex_num++;
                    print "$ex_num. $english->{$key}[1]{$sentence}\n";
                }
            } elsif ($qa_switch eq 'a') {
                print $ans = "$key($num): $english->{$key}[0]\n";
                push @logs, $ans;
                for my $sentence (sort keys %{$english->{$key}[1]}) {
                    $ex_num++;
                    print $ans = "$ex_num. $sentence: $english->{$key}[1]{$sentence}\n";
                    push @logs, $ans;
                }
                if ($voice_sw eq 'on') {
                    print `$voice $key`;
                }
            }
        } else {
            if ($qa_switch eq 'q') {
                print "$english->{$key}\n";
            } elsif ($qa_switch eq 'a') {
                print $ans = "$key($num): $english->{$key}\n";
                push @logs, $ans;
                if ($voice_sw eq 'on') {
                    print `$voice $key`;
                }
            }
        }
    };
    sub plural {
        ($times, $hits, $errors) = @_;
        unless ($times == 1) {
            $times = 'times';
        } else {
            $times = 'time';
        }
        unless ($point == 1) {
            $hits = 'hits';
        } else {
            $hits = 'hit';
        }
        unless ($miss == 1) {
            $errors = 'errors';
        } else {
            $errors = 'error';
        }
    }
}


1;
