package Generator {
    use strict;
    use warnings;
    use feature 'say';

    use open IO => qw/:utf8 :std/;
    use Carp 'croak';
    use YAML::Tiny;
    use File::Slurp 'read_file';
    use List::Util 'shuffle';

    sub convert {
        my ($attr, $data) = @_;

        my $card_dir = $attr->{lesson_dir};
        my $card_name = $attr->{choose};

        my $dict;
        my $card;

        opendir(my $card_iter, $card_dir) or croak("Can't opendir $card_dir.");
        for my $file (readdir $card_iter) {
            if ($file =~ /\.yaml\z/) {
                $dict = "$card_dir/$file";
            }
            elsif ($file =~ /$card_name\.txt\z/) {
                $card = "$card_dir/$file";
            }
        }
        closedir $card_iter;

        my $yaml = YAML::Tiny->read($dict);
        $data->{dict} = $yaml->[0];

        my $words = read_file($card);
        my @words = split /\n/, $words;
        @words = shuffle @words;

        $data->{words} = \@words;

        return $data;
    }
}

1;
