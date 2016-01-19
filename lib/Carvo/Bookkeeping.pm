package Bookkeeping {
    use 5.12.0;
    use warnings;
    use utf8;

    my ($attr, $data, $key, $clean);
    my $msg_usual = 'Enter or input a command or check help(h).';

    my $accounts;
    my $rand;
    my @good = qw(Good! Excellent! Congrats!);
    my @ng   = qw(No-good Oh.. Soso);
    my $msg_option
        = "資産=a, 負債=b, 純資産=c, 費用=d, 収益=e, \n評価=f, 集合=g, 中間=h, 混合=i, 対照=j, 照合=k, その他=l";

    sub set {
        my $class = shift;
        ($attr, $data) = @_;

        print "$msg_option\n\n";

        Run::run($class, $attr, $data);
    }

    sub proc {
        my $class = shift;
        ($attr, $data) = @_;

        while (my $in_ans = <>) {
            my $match;
            if ($in_ans =~ /^\n$/) {
                $attr->{log_record} = 'off';
                $match = "$data->{dict}->{$key}";
                $accounts = $2 if ($match =~ /(\w)_(.+)/);
                if (ref $data->{dict}->{$key} eq "ARRAY") {
                    push @{ $data->{log} }, "*$key: $data->{dict}->{$key}[0]\n";
                }
                else {
                    push @{ $data->{log} }, "*$key: $accounts\n";
                }
                push @{ $data->{fail} }, $key . "\n";

                $data->{log} = $class->repl('a', $attr, $data);
                print $data->{result} = Util::result($attr, $data);
                print "$msg_usual\n";
                print "$msg_option\n";
                last;
            }
            else {
                my $regexp = chomp $in_ans;
                $match  = "$data->{dict}->{$key}";
                $regexp = $in_ans;
                if ($match =~ /(\w)_(.+)/) {
                    $match    = $1;
                    $accounts = $2;
                }
                $rand = int(rand(3));
                if ($regexp =~ /^$match$/) {
                    $attr->{log_record} = 'on';
                    $attr->{point}++;
                    $attr->{total} = $attr->{point} + $attr->{miss};
                    print "\nGood!!\n";
                    print `$attr->{voice} $good[$rand]`;
                    $data->{log} = $class->repl('a', $attr, $data);
                    print $data->{result} = Util::result($attr, $data);
                    print "$msg_option\n";
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
                        push @{ $data->{log} }, "*$key: $accounts\n";
                    }
                    push @{ $data->{fail} }, $key . "\n";
                    print "\nNG! Again!\n";
                    print `$attr->{voice} $ng[$rand]`;
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
            if ($qa_switch eq 'q') {
                print "$key: $data->{dict}->{$key}[0]\n";
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
            }
        }
        else {
            if ($qa_switch eq 'q') {
                print "$key\n";
            }
            elsif ($qa_switch eq 'a') {
                print $ans = "$key($attr->{num}): $accounts\n";
                push @{ $data->{log} }, $ans if ($attr->{log_record} eq 'on');
            }
        }
        return $data->{log};
    }
}

1;
