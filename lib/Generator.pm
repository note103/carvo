package Generator {
    use strict;
    use warnings;
    use feature 'say';

    use open qw/:utf8 :std/;
    use Carp 'croak';
    use YAML;
    use JSON;
    use Encode;

    sub convert {
        my ($fh, $dict, $card);
        my ($fmt, $card_head, $card_dir, $card_name) = @_;

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

        unless ($dict) {
            my @course_iter = glob "src/lesson/*";
            for my $file (@course_iter) {
                if ($file =~ /\.$fmt$/) {
                    $dict = $file;
                }
            }
        }

        if ($fmt eq 'yml') {
            $dict = YAML::LoadFile($dict);
        }
        else {
            open my $fh, '<', $dict or croak("Can't open JSON file.");
            my $json = do { local $/; <$fh> };
            $dict = decode_json(encode('utf8', $json));
            close $fh;
        }

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
