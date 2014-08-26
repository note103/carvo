#!/usr/bin/env perl
use strict;
use warnings;
use Carvo::Words;

package Carvo {
    our ($point, $miss) = (0, 0);
    our $total = $point + $miss;
    our ($times, $hits, $errors) = qw(times hits errors);
    my ($sort, $lang, $num, $words, $english, $key, $limit, $mix_switch);
    my $port = 0;
    sub tutor {
        ($english, $sort, $lang) = @_;
        my %english = %$english;
        my @words;
        if ($sort eq 'order') {
            @words = sort (keys %english);
        } elsif ($sort eq 'random') {
            @words = keys %english;
        }
        if ($lang eq 'mix') {
            $mix_switch = 'mix';
            mix();
        } else {
            $mix_switch = '';
        }
        $words = \@words;
        my $enter = '\n';
        my $count = @words;
        $limit = $count - 1;
        my $msg1 = 'Input (a number|r[andom]|q[uit]).';
        my $msg2 = 'Input (a number|r[andom]|enter[next]|q[uit]).';
        my $msg3 = 'Input (a number|r[andom]|s[ame]|enter[next]|q[uit]).';
        my $msg_limit = "You can choose a number from 1-$limit.";
        my $msg_toobig = "Too big! $msg_limit";
        print "$msg2\n$msg_limit\n";
        sub voice {
            while (my $in2 = <>) {
                if ($in2 =~ /^($enter)$/) {
                    qa('a');
                    print "\n$msg3\n";
                    last;
                } else {
                    my $regexp = chomp $in2;
                    my $match;
                    if ($lang eq 'ja2en') {
                        $match = "\^$key\$";
                        $regexp = $in2;
                    } elsif ($lang eq 'en2ja') {
                        $match = $in2;
                        if (ref $english->{$key}) {
                            $regexp = $english->{$key}[0];
                        } else {
                            $regexp = $english->{$key};
                        }
                    }
                    if ($regexp =~ /^$match$/) {
                        $point++;
                        $total = $point + $miss;
                        plural($total, $point, $miss);
                        print "\nGood!!\n";
                        qa('a');
                        print "\nYou tried $total $times. $point $hits and $miss $errors.\n$msg3\n";
                        last;
                    } elsif ($regexp =~ /$match/) {
                        print "\nSoso...\n";
                        qa('a');
                        print "\nLet's try again!\n";
                    } else {
                        $miss++;
                        print "\nNG! Again!\n";
                    }
                }
            }
        }
        while (my $in = <>) {
            if ($in =~ /^(q)$/) {
                $total = $point + $miss;
                $port = 0;
                last;
            } elsif ($in =~ /^0$/) {
                print "\n$msg_limit\n";
            } elsif ($in =~ /^(\d+)$/) {
                $num = $1;
                $port = $num;
                if ($in > $limit) {
                    print "\n$msg_toobig\nThis is random select.\n";
                    random();
                    voice();
                } else {
                    qa('q');
                    voice();
                }
            } elsif ($in =~ /^(n|\n)$/) {
                if ($port == $limit) {
                    print "\nYou exceeded the maximum. Return to the beggining.\n\n";
                    $num = 1;
                    $port = $num;
                    qa('q');
                    voice();
                } else {
                    $num = $port+1;
                    $port = $num;
                    qa('q');
                    voice();
                }
            } elsif ($in =~ /^(r)$/) {
                random();
                voice();
            } elsif ($in =~ /^(s)$/) {
                $num = $port;
                qa('q');
                voice();
            } elsif ($in =~ /^(\w+)$/) {
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
                    print "\nHere is $key($num_get)\n$msg2\n";
                } else {
                    print "\nHere is not '$key'.\n$msg3\n";
                }
            } elsif ($in =~ /^([\W\D]+)$/) {
                print "\nPlease input a correct one.\nThis is random select.\n";
                random();
                voice();
            } else {
                print "\nPlease input a correct one.\n";
            }
        }
    }
    sub qa {
        my $qa_switch = shift;
        if ($qa_switch eq 'q') {
            $key = $words->[$num];
        }
        mix();
        if (ref $english->{$key}) {
            my $ex_num = 0;
            if ($qa_switch eq 'q') {
                if ($lang eq 'en2ja') {
                    print "$key\n";
                    for my $sentence (keys %{$english->{$key}[1]}) {
                        $ex_num++;
                        print "ex$ex_num.\t$sentence\n";
                    }
                } elsif ($lang eq 'ja2en') {
                    print "$english->{$key}[0]\n";
                    for my $sentence (keys %{$english->{$key}[1]}) {
                        $ex_num++;
                        print "ex$ex_num.\t$english->{$key}[1]{$sentence}\n";
                    }
                }
            } elsif ($qa_switch eq 'a') {
                print "$key($num): $english->{$key}[0]\n";
                for my $sentence (keys %{$english->{$key}[1]}) {
                    $ex_num++;
                    print "\nex$ex_num.\t$sentence\n\t$english->{$key}[1]{$sentence}\n";
                }
            }
        } else {
            if ($qa_switch eq 'q') {
                if ($lang eq 'en2ja') {
                    print "$key\n";
                } elsif ($lang eq 'ja2en') {
                    print "$english->{$key}\n";
                }
            } elsif ($qa_switch eq 'a') {
                print "$key($num): $english->{$key}\n";
            }
        }
    }
    sub mix {
        if ($mix_switch eq 'mix') {
            my $mix = int(1 + rand 2);
            if ($mix == 1) {
                $lang = 'ja2en';
            } elsif ($mix == 2) {
                $lang = 'en2ja';
            }
        }
    }
    sub random {
        $num = int(rand($limit+1));
        $port = $num;
        qa('q');
    }
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
