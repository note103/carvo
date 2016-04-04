package Generator {
    use strict;
    use warnings;
    use feature 'say';

    use open qw/:utf8 :std/;
    use Carp 'croak';
    use YAML;
    use Encode;

    sub switch {
        my ($fh, $dict, $card);
        my ($lesson, $fmt, $card_head, $card_dir, $card_name) = @_;

        opendir(my $card_iter, $card_dir) or croak("Can't opendir $card_dir.");
        for my $file (readdir $card_iter) {
            if ($file =~ /\.$fmt$/) {
                $dict = $card_dir . '/' . $file;
            }
            elsif ($file =~ /$card_head\_.+\.txt$/) {
                $card = $card_dir . '/' . $file;
            }
        }
        closedir $card_iter;

        $dict = YAML::LoadFile($dict);

        open $fh, '<', $card or croak("Can't open $card file.");
        my %set_dict;
        for (<$fh>) {
            chomp;
            $set_dict{$_} = $dict->{$_};
        }
        my $set_dict = \%set_dict;
        close $fh;

        return ($set_dict, $fmt, $card_name);
    }
}

1;
