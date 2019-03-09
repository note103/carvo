package Util {
    use strict;
    use warnings;
    use feature 'say';

    sub logs {
        my $data = shift;

        $data->{log}        = [] if (!$data->{log});
        $data->{log_buffer} = [] if (!$data->{log_buffer});

        @{$data->{log_buffer}} = (@{$data->{log_buffer}}, @{$data->{log}});
        my %log = map {$_ => 1} @{$data->{log_buffer}};
        @{$data->{log_buffer}} = keys %log;
        $data->{log} = $data->{log_buffer};

        return $data;
    }

    sub help {
        open my $fh_help, '<', 'docs/help.txt' or die $!;
        my $help = do { local $/; <$fh_help> };
        close $fh_help;

        use Encode;
        $help = decode('utf8', $help);
        return $help;
    }

    sub list {
        my ($data, $attr) = @_;

        # failモードかnormalモードか確認
        my @list;
        if ($attr->{fail_flag} == 0) {
            for (sort keys %{$data->{dict}}) {
                push @list, $_;
            }
        }
        elsif ($attr->{fail_flag} == 1) {
            my %unique = map { $_ => 1 } @{$data->{words}};
            for (sort keys %unique) {
                chomp;
                push @list, $_;
            }
        }

        # 進行中のカードリストを出力用に抽出
        my @list_for_print;
        for (@list) {
            my $num_index = num_index($_, \@{$data->{words}});
            my $num_index_tmp = $num_index + 1;
            push @list_for_print, "$num_index_tmp: $_\n";
        }

        my %list_for_print;
        for (@list_for_print) {
            if ($_ =~ /^(\d+): (.+)/x) {
                $list_for_print{$1} = $2;
            }
        }

        my @list_for_print_sorted;
        for (sort { $a <=> $b } keys %list_for_print) {
            push @list_for_print_sorted, "$_: $list_for_print{$_}\n";
        }

        return \@list_for_print_sorted;
    }

    sub num_index {
        my ($listed_word, $words_base) = @_;

        my @words   = @$words_base;
        my $num_index = 0;

        for (@words) {
            if ($listed_word eq $words[$num_index]) {
                return $num_index;
            }
            else {
                $num_index++;
            }
        }
        return $num_index;
    }

    sub random_jump {
        my ($attr) = @_;

        $attr->{num}        = int(rand($attr->{limit} + 1));
        $attr->{num_buffer} = $attr->{num};

        return $attr;
    }

    sub sound_change {
        my $attr = shift;
        if ($^O eq 'darwin') {
            if ($attr->{voice_ch} eq 'off') {
                $attr->{voice_ch} = 'on';
                $attr->{sound_able} = 1;
                print "You turned to voice mode.\n";
                print `say hi`;
            }
            else {
                $attr->{voice_ch} = 'off';
                $attr->{sound_able} = 0;
                print "You turned to silent mode.\n";
                print `say bye`;
            }
        }
        else {
            say 'Mac environment is required for using voice mode.'
        }
        return $attr;
    }

    sub cleanup {
        my $clean = shift;

        $clean =~ s/[\'\;]//g;
        $clean =~ s/&/and/g;
        $clean =~ s/[\(]/ /g;
        $clean =~ s/[\[\)\]]/. /g;

        return $clean;
    }

    sub go_to_fail {
        my ($attr, $data) = @_;

        $data->{words_back} = $data->{words};
        my @words = @{$data->{words}};

        $data->{fail} = [] unless (ref $data->{fail});
        my @fail = @{$data->{fail}};

        $attr->{fail_sw} = 'on';
        if (@fail == 0) {
            print "No data yet.\n";
            $attr->{fail_sw} = 'off';
        }
        else {
            print "You turned on fail list mode.\n";
            my %unique = map {$_ => 1} @fail;
            my @fail_words = keys %unique;
            chomp @fail_words;
            @words              = @fail_words;
            $attr->{limit}      = @words;
            $data->{words}      = \@words;
            $attr->{num_normal} = $attr->{num_buffer};
            $attr->{num}        = 1;
            $attr->{num_buffer} = $attr->{num};
        }
        return ($attr, $data);
    }

    sub back_to_normal {
        my ($attr, $data) = @_;

        print "You turned back to normal mode.\n";
        $attr->{fail_sw} = 'off';
        my @words = @{$data->{words_back}};
        $attr->{limit}      = @words;
        $data->{words}      = \@words;
        $attr->{num}        = $attr->{num_normal};
        $attr->{num_buffer} = $attr->{num};

        return ($attr, $data);
    }
}


1;
