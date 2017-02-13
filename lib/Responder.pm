package Responder {
    use strict;
    use warnings;
    use feature 'say';
    use List::Util 'shuffle';
    use List::MoreUtils 'uniq';

    my ($attr, $data, $key, $clean);
    my $in_ans;
    my $correct_component_buff;
    my $giveup = '[Give up!]';

    sub set {
        ($attr, $data) = @_;
        $attr->{ng} = 0;
        Command::set($attr, $data);
    }

    sub respond {
        ($attr, $data) = @_;

        if ($attr->{rw} eq 'r') {
            if ($in_ans eq $attr->{ans}) {
                $attr->{log_record} = 'on';
                $attr->{point}++;
                $attr->{total} = $attr->{point} + $attr->{miss};
                print "\nGood!!\n";
                $attr->{ng} = 0;

                if ($attr->{sound_able} == 1) {
                    if (( $attr->{point} % 10 ) == 0) {
                        print `afplay ./src/sound/ok10.mp3`;
                    } elsif (( $attr->{point} % 25 ) == 0) {
                        print `afplay ./src/sound/ok25.mp3`;
                    }
                }

                $data->{log} = Responder::judge('a', $attr, $data);
                print $data->{result} = Util::result($attr, $data);
            }
            elsif ($in_ans eq $giveup) {
                Responder::judge('a', $attr, $data);
                print $data->{result} = Util::result($attr, $data);
            }
            else {
                $attr->{log_record} = 'off';
                $attr->{miss}++;
                $attr->{total} = $attr->{point} + $attr->{miss};
                if (ref $data->{dict}->{$key} eq "ARRAY") {
                    push @{ $data->{log} }, "*$key: $data->{dict}->{$key}[0]\n";
                }
                else {
                    push @{ $data->{log} }, "*$key: $data->{dict}->{$key}\n";
                }
                push @{ $data->{fail} }, $key . "\n";
                say "\nNG! Again!\n";
                $attr->{ng} = 1;

                if ($attr->{sound_able} == 1) {
                    print `afplay ./src/sound/ng.mp3`;
                }
                Responder::judge('q', $attr, $data);
            }
        } else {
            while (my $in_ans = <>) {
                if ($in_ans =~ /^\n$/) {
                    $attr->{log_record} = 'off';
                    if (ref $data->{dict}->{$key} eq "ARRAY") {
                        push @{ $data->{log} }, "*$key: $data->{dict}->{$key}[0]\n";
                    }
                    else {
                        push @{ $data->{log} }, "*$key: $data->{dict}->{$key}\n";
                    }
                    push @{ $data->{fail} }, $key . "\n";

                    $data->{log} = Responder::judge('a', $attr, $data);
                    print $data->{result} = Util::result($attr, $data);
                    last;
                }
                else {
                    my $regexp = chomp $in_ans;
                    my $match;
                    $match  = "$key";
                    $regexp = $in_ans;
                    $match =~ s/\?$/\\?/;
                    if ($regexp =~ /^($match)$/) {
                        $attr->{log_record} = 'on';
                        $attr->{point}++;
                        $attr->{total} = $attr->{point} + $attr->{miss};
                        print "\nGood!!\n";
                        $attr->{ng} = 0;

                        $data->{log} = Responder::judge('a', $attr, $data);
                        print $data->{result} = Util::result($attr, $data);

                        last;
                    }
                    else {
                        $attr->{log_record} = 'off';
                        $attr->{miss}++;
                        $attr->{total} = $attr->{point} + $attr->{miss};
                        if (ref $data->{dict}->{$key} eq "ARRAY") {
                            push @{ $data->{log} }, "*$key: $data->{dict}->{$key}[0]\n";
                        }
                        else {
                            push @{ $data->{log} }, "*$key: $data->{dict}->{$key}\n";
                        }
                        push @{ $data->{fail} }, $key . "\n";
                        print "\nNG! Again!\n";
                        $attr->{ng} = 1;
                    }
                }
            }
        }
        return ($attr, $data);
    }

    sub judge {
        my ($qa_switch, $attr, $data) = @_;
        my $ans;
        my $opt_num = 5;

        $key = $data->{words}->[ $attr->{num} - 1 ];
        $key =~ s/(.+)(\n)*$/$1/;

        if ($attr->{rw} eq 'r') {

            $ans = $key;
            if ($qa_switch eq 'q') {

                my $limit = scalar(@{$data->{words}});
                my @select = (1..$limit);

                my $options;

                if ($attr->{cave} eq 'off') {
                    my $correct = $data->{dict}->{$key};
                    $attr->{ans} = $correct;

                    my %optmaker;
                    $optmaker{$correct} = 1;

                    if (scalar @select < 5) {
                        $opt_num = scalar @select;
                    }
                    else {
                        $opt_num = 5;
                    }

                    while (scalar(keys %optmaker) < $opt_num) {
                        my $rand = shuffle (@select);
                        $optmaker{$data->{dict}->{$data->{words}->[ $attr->{num} - $rand ]}} = 1;
                    }

                    my @options = keys %optmaker;
                    @options = shuffle @options;

                    push @options, $giveup;
                    @options = map {$_ = "- $_"} @options;
                    $options = join "\n", @options;

                    say $ans;
                }
                else {
                    my @component;
                    my $correct_component = '';

                    if ($attr->{ng} == 0) {
                        @component = split / /, $key;

                        while (length $correct_component < $opt_num) {
                            $correct_component = $component[( int rand(scalar @component) )];
                            $correct_component = "" unless ($correct_component =~ /\A\w{5,}\z/);
                        }
                        $attr->{ans} = $correct_component;
                        $correct_component_buff = $correct_component;
                    } else {
                        $correct_component = $correct_component_buff;
                    }

                    my %optmaker;
                    $optmaker{$correct_component} = 1;
                    while (scalar(keys %optmaker) < $opt_num) {
                        my $rand = shuffle (@select);
                        $optmaker{$data->{words}->[ $attr->{num} - $rand ]} = 1;
                    }

                    my @options;
                    my $opt_count = 0;
                    while (scalar(@options) < $opt_num) {
                        for (keys %optmaker) {
                            my @opt_component = split / /, $_;
                            my $rand = int rand(scalar @opt_component);
                            my $x = $opt_component[$rand];
                            my $y = $opt_component[$rand -1];
                            if ($x =~ /\A\w{5,}\z/) {
                                push @options, $x;
                            }
                            elsif ($y ne $x) {
                                if ($y =~ /\A\w{5,}\z/) {
                                    push @options, $y;
                                }
                            }
                            else {
                                next;
                            }
                            @options = uniq @options;
                            last if (scalar @options == $opt_num);
                        }
                    }
                    @options = shuffle @options;

                    push @options, $giveup;
                    @options = map {$_ = "- $_"} @options;
                    $options = join "\n", @options;

                    my $cave = $ans;
                    $cave =~ s/$correct_component/(***)/;
                    say $cave;
                }

                $in_ans = `echo "$options" | cho | tr -d "\n"`;
                use Encode;
                $in_ans =~ s/^- //;
                $in_ans = decode('utf8', $in_ans);
                say $in_ans;

                Responder::respond($attr, $data);
            }
            elsif ($qa_switch eq 'a') {
                if ($attr->{cave} eq 'off') {
                    if (ref $data->{dict}->{$key} eq "HASH") {
                        my @key = keys %{$data->{dict}->{$key}};
                        print $ans = "$key($attr->{num}): $key[0]\n$data->{dict}->{$key}->{$key[0]}\n";
                    }
                    elsif (ref $data->{dict}->{$key} eq "ARRAY") {
                        my @arr = @{$data->{dict}->{$key}};
                        print $ans = "$key($attr->{num}): $arr[0]\n";

                        my $arr_limit = scalar @arr;
                        my $i = 1;
                        for (1..( $arr_limit -1 )) {
                            my @key = keys %{$arr[$i]};
                            print "- $key[0]\n- $arr[$i]->{$key[0]}\n";
                            $i++;
                        }
                    }
                    else {
                        print $ans = "$key($attr->{num}): $data->{dict}->{$key}\n";
                    }
                }
                else {
                    print $ans = "$key($attr->{num}):\n$data->{dict}->{$key}\n";
                }
                push @{ $data->{log} }, $ans if ($attr->{log_record} eq 'on');
                $clean = Util::clean($key);
                print `$attr->{voice} $clean` if $attr->{voice_ch} eq 'on';
            }
        } else {
            $ans = substr($key, 0, $attr->{extr}) unless (!$attr->{extr});
            if ($qa_switch eq 'q') {
                print "$ans: $data->{dict}->{$key}\n";
                Responder::respond($attr, $data);
            }
            elsif ($qa_switch eq 'a') {
                print $ans = "$key($attr->{num}): $data->{dict}->{$key}\n";
                push @{ $data->{log} }, $ans if ($attr->{log_record} eq 'on');
                $clean = Util::clean($key);
                print `$attr->{voice} $clean` if $attr->{voice_ch} eq 'on';
            }
        }
        return $data->{log};
    }
}

1;
