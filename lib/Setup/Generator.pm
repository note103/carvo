package Generator {
    use 5.12.0;
    use warnings;
    use Carp;

    sub switch {
        use YAML;
        use JSON;
        use Encode;
        use open qw/:utf8 :std/;
        use Path::Tiny;

        my ($fh, $dict, $card);
        my ($lesson, $fmt, $card_head, $card_dir, $card_name) = @_;

        my $card_iter = path($card_dir)->iterator;
        while (my $file = $card_iter->()) {
            if ($file =~ /\.$fmt$/) {
                $dict = $file;
            }
            elsif ($file =~ /$card_head\_.+\.txt$/) {
                $card = $file;
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

        open $fh, '<', $card or croak("Can't open card file.");
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
