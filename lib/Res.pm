package Res {
    use strict;
    use warnings;
    use feature 'say';
    use utf8;
    use List::Util 'shuffle';

    my ($attr, $data, $key, $clean);
    my $in_ans;
    my $giveup = '[Give up!]';

    sub set {
        my $class = shift;
        ($attr, $data) = @_;
        Command::run($class, $attr, $data);
    }

    sub proc {
        my $class = shift;
        ($attr, $data) = @_;

        if ($attr->{rw} eq 'r') {
            if ($in_ans eq $attr->{ans}) {
                $attr->{log_record} = 'on';
                $attr->{point}++;
                $attr->{total} = $attr->{point} + $attr->{miss};
                print "\nGood!!\n";
                $data->{log} = $class->repl('a', $attr, $data);
                print $data->{result} = Util::result($attr, $data);
            }
            elsif ($in_ans eq $giveup) {
                $class->repl('a', $attr, $data);
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
                $class->repl('q', $attr, $data);
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

                    $data->{log} = $class->repl('a', $attr, $data);
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
                        $data->{log} = $class->repl('a', $attr, $data);
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
                    }
                }
            }
        }
        return ($attr, $data);
    }

    sub repl {
        my $class = shift;
        my ($qa_switch, $attr, $data) = @_;
        my $ans;

        $key = $data->{words}->[ $attr->{num} - 1 ];
        $key =~ s/(.+)(\n)*$/$1/;

        if ($attr->{rw} eq 'r') {
            $ans = $key;
            if ($qa_switch eq 'q') {

                my $limit = scalar(@{$data->{words}});
                my @select = (1..$limit);

                my $correct = $data->{dict}->{$key};
                $attr->{ans} = $correct;

                my %optmaker;
                $optmaker{$correct} = 1;
                while (scalar(keys %optmaker) < 5) {
                    my $rand = shuffle (@select);
                    $optmaker{$data->{dict}->{$data->{words}->[ $attr->{num} - $rand ]}} = 1;
                }

                my @options = keys %optmaker;
                @options = shuffle @options;

                push @options, $giveup;
                @options = map {$_ = "- $_"} @options;
                my $options = join "\n", @options;

                say $ans;
                $in_ans = `echo "$options" | cho | tr -d "\n"`;
                use Encode;
                $in_ans =~ s/^- //;
                $in_ans = decode('utf8', $in_ans);
                say $in_ans;
                $class->proc($attr, $data);
            }
            elsif ($qa_switch eq 'a') {
                print $ans = "$key($attr->{num}): $data->{dict}->{$key}\n";
                push @{ $data->{log} }, $ans if ($attr->{log_record} eq 'on');
                $clean = Util::clean($key);
                print `$attr->{voice} $clean` if $attr->{voice_ch} eq 'on';
            }
        } else {
            $ans = substr($key, 0, $attr->{extr}) unless (!$attr->{extr});
            if ($qa_switch eq 'q') {
                print "$ans: $data->{dict}->{$key}\n";
                $class->proc($attr, $data);
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
