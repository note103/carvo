package Util {
    use 5.12.0;
    use warnings;
    use utf8;
    use open ':utf8';
    binmode STDOUT, ':utf8';

    sub result {
        my ($attr, $data) = @_;

        $data->{result}
            = "\nYou tried $attr->{total} times. $attr->{point} hits and $attr->{miss} errors.\n";

        return $data->{result};
    }

    sub logs {
        my $data = shift;

        $data->{log}        = [] if (!$data->{log});
        $data->{log_buffer} = [] if (!$data->{log_buffer});

        @{ $data->{log_buffer} } = (@{ $data->{log_buffer} }, @{ $data->{log} });
        my %log = map { $_ => 1 } @{ $data->{log_buffer} };
        @{ $data->{log_buffer} } = keys %log;
        $data->{log} = $data->{log_buffer};

        return $data;
    }

    sub help {
        use Carp 'croak';

        open my $fh_help, '<', 'src/help.txt' or croak("Can't open file");
        my $help = do { local $/; <$fh_help> };
        close $fh_help;
        say $help;
    }

    sub list {
        my ($data, $attr) = @_;

        my @list;
        if ($attr->{speech} eq 'on') {
            my @arr;
            if ($attr->{fail_sw} eq 'off') {
                for (sort keys %{ $data->{dict} }) {
                    push @arr, ${ $data->{dict} }{$_};
                }
            }
            elsif ($attr->{fail_sw} eq 'on') {
                my %unique = map { $_ => 1 } @{ $data->{words} };
                for (sort keys %unique) {
                    chomp;
                    push @arr, $_;
                }
            }
            for (@arr) {
                my $l = length($_);
                my $s = substr($_, 0, 70);
                my $d = '...';
                $d = '' if ($l < 70);
                push @list, "($l): $s $d";
            }
            say '';
            my $i = 1;
            for (@list) { print "$i $_\n"; $i++; }
        }
        else {
            if ($attr->{fail_sw} eq 'off') {
                for (sort keys %{ $data->{dict} }) {
                    push @list, $_;
                }
            }
            elsif ($attr->{fail_sw} eq 'on') {
                my %unique = map { $_ => 1 } @{ $data->{words} };
                for (sort keys %unique) {
                    chomp;
                    push @list, $_;
                }
            }
            for (@list) {
                my $num_get = num_get($_, \@{ $data->{words} });
                my $num_tmp = $num_get + 1;
                print "$_: $num_tmp\n";
            }
        }
    }

    sub num_get {
        my ($listed_word, $words_base) = @_;
        my @words   = @$words_base;
        my $num_get = 0;

        for (@words) {
            if ($listed_word eq $words[$num_get]) {
                return $num_get;
            }
            else {
                $num_get++;
            }
        }
        return $num_get;
    }

    sub jump {
        my ($attr) = @_;
        $attr->{num}      = int(rand($attr->{limit} + 1));
        $attr->{num_buffer} = $attr->{num};
        return ($attr);
    }

    sub order {
        my ($attr, $data) = @_;
        my @words;

        if ($attr->{order} eq 'order') {
            @words = sort keys %{ $data->{dict} };
        }
        elsif ($attr->{order} eq 'random') {
            @words = keys %{ $data->{dict} };
        }
        $data->{words} = \@words;

        return $data->{words};
    }

    sub order_swap {
        my $order_swap = shift;

        if ($order_swap eq 'random') {
            $order_swap = 'order';
        }
        else {
            $order_swap = 'random';
        }

        return $order_swap;
    }

    sub voice_swap {
        my $voice_swap = shift;

        if ($voice_swap eq 'key') {
            $voice_swap = 'value';
        }
        else {
            $voice_swap = 'key';
        }

        return $voice_swap;
    }

    sub clean {
        my $clean = shift;

        $clean =~ s/[\'\;]//g;
        $clean =~ s/&/and/g;
        $clean =~ s/[\(]/ /g;
        $clean =~ s/[\[\)\]]/. /g;

        return $clean;
    }

    sub fail {
        my ($attr, $data) = @_;

        $data->{words_back} = $data->{words};
        my @words = @{ $data->{words} };

        $data->{fail} = [] unless (ref $data->{fail});
        my @fail = @{ $data->{fail} };

        $attr->{fail_sw} = 'on';
        if (@fail == 0) {
            print "No data yet.\n";
            $attr->{fail_sw} = 'off';
        }
        else {
            print "You turned on fail list mode.\n";
            my %unique = map { $_ => 1 } @fail;
            my @fail_words = keys %unique;
            chomp @fail_words;
            @words            = @fail_words;
            $attr->{limit}    = @words;
            $data->{words}    = \@words;
            $attr->{num_normal} = $attr->{num_buffer};
            $attr->{num}      = 1;
            $attr->{num_buffer} = $attr->{num};
        }

        return ($attr, $data);
    }

    sub back {
        my ($attr, $data) = @_;

        print "You turned back to normal mode.\n";
        $attr->{fail_sw} = 'off';
        my @words = @{ $data->{words_back} };
        $attr->{limit}    = @words;
        $data->{words}    = \@words;
        $attr->{num}      = $attr->{num_normal};
        $attr->{num_buffer} = $attr->{num};

        return ($attr, $data);
    }

}

1;