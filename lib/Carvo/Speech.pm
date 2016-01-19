package Speech {
    use 5.12.0;
    use warnings;
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
                if (ref $data->{dict}->{$key} eq "ARRAY") {
                    push @{ $data->{log} },  "$attr->{num}: $data->{dict}->{$key}[0]\n";
                    push @{ $data->{fail} }, "$attr->{num}: $data->{dict}->{$key}[0]\n";
                }
                else {
                    push @{ $data->{log} },  "$attr->{num}: $data->{dict}->{$key}\n";
                    push @{ $data->{fail} }, "$attr->{num}: $data->{dict}->{$key}\n";
                }

                $data->{log} = $class->repl('a', $attr, $data);
                last;
            }
            else {
                print "\n$msg_usual\n";
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
                print "$attr->{num}/$attr->{limit}: $data->{dict}->{$key}[0]\n";
                if (ref $data->{dict}->{$key}[1] eq "HASH") {
                    for my $sentence (sort keys %{ $data->{dict}->{$key}[1] }) {
                        print "- $data->{dict}->{$key}[1]{$sentence}\n";
                    }
                }
                elsif (ref $data->{dict}->{$key} eq "ARRAY") {
                }
            }
            elsif ($qa_switch eq 'a') {
                print $ans = "$attr->{num}: $data->{dict}->{$key}[0]\n";

                if (ref $data->{dict}->{$key}[1] eq "HASH") {
                    for my $sentence (sort keys %{ $data->{dict}->{$key}[1] }) {
                        print $ans = "- $sentence: $data->{dict}->{$key}[1]{$sentence}\n";
                    }
                }
                $clean = $key;
                $clean = Util::clean($clean);
                print `$attr->{voice} $clean`;
            }
        }
        else {
            $ans = substr($key, 0, $attr->{extr}) unless (!$attr->{extr});
            if ($qa_switch eq 'q') {
                print "$attr->{num}/$attr->{limit}: $data->{dict}->{$key}\n";
            }
            elsif ($qa_switch eq 'a') {
                print $ans = "$attr->{num}: $data->{dict}->{$key}\n";

                if ($attr->{voice_swap} eq 'key') {
                    $clean = $key;
                }
                else {
                    $clean = $data->{dict}->{$key};
                }
                $clean = Util::clean($clean);
                print `$attr->{voice} $clean`;
            }
        }
        return $data->{log};
    }
}

1;
