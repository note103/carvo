package Reader {
    use strict;
    use warnings;
    use feature 'say';

    use File::Slurp 'read_dir';

    sub read {
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
}

1;
