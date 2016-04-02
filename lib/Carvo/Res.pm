package Res {
    use strict;
    use warnings;
    use feature 'say';
    use utf8;

    my ($attr, $data, $key, $clean);
    my $msg_usual = 'Enter or input a command or check help(h).';

    sub set {
        my $class = shift;
        ($attr, $data) = @_;
        Run::run($class, $attr, $data);
    }

    sub proc {
        my $class = shift;
        ($attr, $data) = @_;

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
                print "$msg_usual\n";
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
        return ($attr, $data);
    }

    sub repl {
        my $class = shift;
        my ($qa_switch, $attr, $data) = @_;
        my $ans;

        $key = $data->{words}->[ $attr->{num} - 1 ];
        $key =~ s/(.+)(\n)*$/$1/;

        if (ref $data->{dict}->{$key} eq "ARRAY") {
            $ans = substr($key, 0, $attr->{extr}) unless (!$attr->{extr});
            if ($qa_switch eq 'q') {
                print "$ans: $data->{dict}->{$key}[0]\n";
                if (ref $data->{dict}->{$key}[1] eq "HASH") {
                    for my $sentence (sort keys %{ $data->{dict}->{$key}[1] }) {
                        print "- $data->{dict}->{$key}[1]{$sentence}\n";
                    }
                }
                elsif (ref $data->{dict}->{$key} eq "ARRAY") {
                }
            }
            elsif ($qa_switch eq 'a') {
                print $ans = "$key($attr->{num}): $data->{dict}->{$key}[0]\n";
                push @{ $data->{log} }, $ans if ($attr->{log_record} eq 'on');

                if (ref $data->{dict}->{$key}[1] eq "HASH") {
                    for my $sentence (sort keys %{ $data->{dict}->{$key}[1] }) {
                        print $ans = "- $sentence: $data->{dict}->{$key}[1]{$sentence}\n";
                        push @{ $data->{log} }, $ans if ($attr->{log_record} eq 'on');
                    }
                }
                $clean = $key;
                $clean = Util::clean($clean);
                print `$attr->{voice} $clean` if $attr->{voice_ch} eq 'on';
            }
        }
        else {
            $ans = substr($key, 0, $attr->{extr}) unless (!$attr->{extr});
            if ($qa_switch eq 'q') {
                print "$ans: $data->{dict}->{$key}\n";
            }
            elsif ($qa_switch eq 'a') {
                print $ans = "$key($attr->{num}): $data->{dict}->{$key}\n";
                push @{ $data->{log} }, $ans if ($attr->{log_record} eq 'on');
                if ($attr->{voice_swap} eq 'key') {
                    $clean = $key;
                }
                else {
                    $clean = $data->{dict}->{$key};
                }
                $clean = Util::clean($clean);
                print `$attr->{voice} $clean` if $attr->{voice_ch} eq 'on';
            }
        }
        return $data->{log};
    }
}

1;
