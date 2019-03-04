package CardSetter {
    use strict;
    use warnings;
    use feature 'say';

    use FindBin;
    use lib "$FindBin::Bin/../../lib";

    use Set::Peco;

    sub read_directory {
        my $attr = shift;

        my @list;

        opendir (my $dh, $attr->{lesson_dir});
        for my $card_filename (readdir $dh) {
            $card_filename =~ s/.*\/(.+)\z/$1/;

            if ($card_filename =~ /\A(.*)\.txt\z/) {
                push @list, $1;
            }
            elsif ($card_filename =~ /\.(yml)\z/) {
                $attr->{fmt} = $1;
            }
        }
        closedir $dh;

        return \@list;
    }

    sub select_card {
        my $attr = shift;
        my $list = shift;
        my $flag_test = shift // '';

        my @command_card = qw/exit/;
        my $course_dir = $attr->{lesson_dir};
        my @cards;

        for (@$list) {
            push @cards, $_;
        }

        @cards = sort @cards;
        my @options = (@cards, @command_card);
        my $options = join "\n", @options;

        while (1) {
            $attr->{choose} = Peco::peco($options, $flag_test);
            last if ($attr->{choose} ne '')
        }

        return $attr;
    }
}

1;
