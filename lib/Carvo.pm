#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
binmode(STDOUT, ":utf8");

package Carvo {
    our ($point, $miss) = (0, 0);
    our $total = $point + $miss;
    our ($times, $hits, $errors) = qw/times hits errors/;
    our $voice_sw = 'on';
    our $voice = 'say';
    our @logs;
    my ($value, $words, $english, $key, $limit, $fail);
    my (@words, @voice, @fail, @fail_out);
    my $mode = 'random';
    my $title = 'title';
    my $escape_sw = 'off';
    my $escape_default_sw = 'on';
    my $fail_sw = 'off';
    my $end = 'end';
    my $voice_in = 1;
    my %english;
    my ($num, $port, $port_back) = (0, 0, 0);
    my $msg_correct = "Please input a correct one.";
    my $escape_title;
    my $escape_end;
    sub main {
        $english = shift;
        %english = %$english;
        mode();
        my $enter = '\n';
        $limit = @words;
        my $msg_first = 'Input (num|enter|r|o|j|v|l|q).';
        my $msg_usual = 'Input (num|enter|r|o|j|v|l|s|q).';
        my $msg_limit = "You can choose a number from 1-";
        my $msg_random = "This is random select.";

        # Create escape key
        my @escape;
        for (@words) {
            if ($_ ne $title && $_ ne $end) {
                push @escape, $_;
            }
        }
        $escape_title = $escape[0];
        $escape_end = $escape[-1];

        if (exists ($english{$title})) {
            if (ref $english{$title} eq "ARRAY") {
                print "Welcome to the \"".$english->{$title}[0]."\"\n";
                $value = $english->{$title}[0];
                value();
                print `$voice $value`;
                for (keys %{$english->{$title}[1]}) {
                    print $_."\n".$english->{$title}[1]{$_}."\n\n";
                }
            } else {
                print "Welcome to the \"".$english->{$title}."\"!\n";
                $value = $english->{$title};
                value();
                print `$voice $value`;
            }

        }
        print "$msg_limit".$limit."\n$msg_first\n";
        my $input = sub {
            while (my $in_ans = <>) {
                if ($in_ans =~ /^($enter)$/) {
                    $escape_sw = 'on';
                    $miss++;
                    push @logs, $key."*\n";
                    push @fail, $key."\n";
                    qa('a');
                    print "\n$msg_usual\n";
                    last;
                } else {
                    $escape_sw = 'off';
                    my $regexp = chomp $in_ans;
                    my $match;
                    $match = "$key";
                    $regexp = $in_ans;
                    if ($regexp =~ /^($match)$/) {
                        $point++;
                        $total = $point + $miss;
                        plural($total, $point, $miss);
                        print "\nGood!!\n";
                        qa('a');
                        print "\nYou tried $total $times. $point $hits and $miss $errors.\n$msg_usual\n";
                        last;
                    } else {
                        $escape_sw = 'on';
                        $miss++;
                        push @logs, $key."*\n";
                        push @fail, $key."\n";
                        print "\nNG! Again!\n";
                    }
                }
            }
        };
        while (my $in_way = <>) {
            if ($in_way =~ /^(q)$/) {
                $total = $point + $miss;
                $port = 0;
                @fail = ();
                $fail_sw = 'off';
                last;
            } elsif ($in_way =~ /^0$/) {
                print "\n$msg_limit".$limit."\n";
            } elsif ($in_way =~ /^(\d+)$/) {
                $num = $1;
                $port = $num;
                if ($in_way > $limit) {
                    print "\nToo big! $msg_limit".$limit."\n$msg_random\n\n";
                    jump();
                    $input->();
                } else {
                    qa('q');
                    $input->();
                }
            } elsif ($in_way =~ /^(n|\n|[^\W\D]+)$/) {
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
            } elsif ($in_way =~ /^(sh)$/) {
                $escape_default_sw = 'on';
                print 'You turned on short voice version.';
                print "\n$msg_usual\n";
            } elsif ($in_way =~ /^(lo)$/) {
                $escape_default_sw = 'off';
                print 'You turned on long voice version.';
                print `$voice You turned on long voice version.`;
                print "\n$msg_usual\n";
            } elsif ($in_way =~ /^(l)$/) {
                list();
                print "\n$msg_limit".$limit."\n$msg_usual\n";
            } elsif ($in_way =~ /^(f)$/) {
                fail();
                print "\n$msg_limit".$limit."\n$msg_usual\n";
            } elsif ($in_way =~ /^(b)$/) {
                back();
                #list();
                print "\n$msg_limit".$limit."\n$msg_usual\n";
            } elsif ($in_way =~ /^(r)$/) {
                $mode = 'random';
                mode();
                list();
                print "\n$msg_usual\n";
            } elsif ($in_way =~ /^(o)$/) {
                $mode = 'order';
                mode();
                list();
                print "\n$msg_usual\n";
            } elsif ($in_way =~ /^(s)$/) {
                $num = $port;
                qa('q');
                $input->();
            } elsif ($in_way =~ /^(j)$/) {
                jump();
                $input->();
            } elsif ($in_way =~ /^(\w+)$/) {
                $key = $1;
                if (exists($english{$key})) {
                    my $num_get = num_get($key, @words);
                    my $num_here = $num_get + 1;
                    print "\nHere is $key($num_here)\n$msg_first\n";
                } else {
                    print "\nHere is not '$key'.\n$msg_usual\n";
                }
            } else {
                print "\n$msg_correct\n";
            }
        }
        sub list {
            if ($fail_sw eq 'off') {
                for (sort keys %$english) {
                    my $num_get = num_get($_, @words);
                    my $num_here = $num_get + 1;
                    print "$_: $num_here\n";
                }
            } elsif ($fail_sw eq 'on') {
                for (@fail_out) {
                    my $num_get = num_get($_, @words);
                    my $num_here = $num_get + 1;
                    print "$_: $num_here\n";
                }
            }
        }
        sub fail {
            print "You turned on fail list mode.\n";
            print `$voice You turned on fail list mode`;
            $fail_sw = 'on';
            if (@fail == 0) {
                print "Here is no data.\n";
                $fail_sw = 'off';
            } else {
                my %unique = map {$_ => 1} @fail;
                @fail_out = keys %unique;
                chomp @fail_out;
                @words = @fail_out;
                $limit = @words;
                $words = \@words;
                $port_back = $port;
                $num = 0;
                $port = $num;
            }
        }
        sub back {
            print "You turned back to normal mode.\n";
            print `$voice You turned back to normal mode`;
            $fail_sw = 'off';
            @words = keys %english;
            $limit = @words;
            $words = \@words;
            $num = $port_back;
            $port = $num;
        }
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
        print "You can change voice setting. (on/off)\n";
        while (my $voice_sw_in = <>) {
            if ($voice_sw_in =~ /^(\n|on)$/) {
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
            } elsif ($voice_sw_in =~ /^off$/) {
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
            $key = $escape_title;
        } elsif ($key eq $end) {
            $key = $escape_end;
        }
        my $sentence;
        if (ref $english->{$key} eq "ARRAY") {
            my @voice_tmp = ();
            if ($qa_switch eq 'q') {
                print "$english->{$key}[0]\n";
                if (ref $english->{$key}[1] eq "HASH") {
                    for $sentence (sort keys %{$english->{$key}[1]}) {
                        print "- $english->{$key}[1]{$sentence}\n";
                    }
                } elsif (ref $english->{$key} eq "ARRAY") {
                }
            } elsif ($qa_switch eq 'a') {
                print $ans = "$key($num): $english->{$key}[0]\n";
                push @logs, $ans;
                if (ref $english->{$key}[1] eq "HASH") {
                    for my $sentence (sort keys %{$english->{$key}[1]}) {
                        print $ans = "- $sentence: $english->{$key}[1]{$sentence}\n";
                        push @logs, $ans;
                        push @voice_tmp, $sentence;
                    }
                } elsif (ref $english->{$key}[1] eq "ARRAY") {
                    my $array_values;
                    print $array_values = "$english->{$key}[1]\n";
                    push @logs, $array_values;
                    push @voice_tmp, $array_values;
                }
                if ($voice_sw eq 'on') {
                    $value = $key;
                    value();
                    print `$voice $value`;
                    unless ($escape_sw eq 'on' || $escape_default_sw eq 'on') {
                        for (@voice_tmp) {
                            $value = $_;
                            value();
                            print `$voice $value`;
                        }
                    }
                }
            }
        } else {
            if ($qa_switch eq 'q') {
                print "$english->{$key}\n";
            } elsif ($qa_switch eq 'a') {
                print $ans = "$key($num): $english->{$key}\n";
                push @logs, $ans;
                if ($voice_sw eq 'on') {
                    $value = $key;
                    value();
                    print `$voice $value`;
                }
            }
        }
    };
    sub value {
        $value =~ s/'//g;
        $value =~ s/;//g;
        $value =~ s/&/and/g;
        $value =~ s/\(/ /g;
        $value =~ s/\[/. /g;
        $value =~ s/\)/. /g;
        $value =~ s/\]/. /g;
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
