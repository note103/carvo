package Generator {
    use v5.12;
    use warnings;
    use Carp;

    sub switch {
        use YAML;
        use JSON;
        use Encode;
        use open qw/:utf8 :std/;

        my ($fh, $file, $card);
        my ($lesson, $fmt, $card_head_in, $card_dir, $card_body) = @_;

        my $card_filename;
        opendir(my $dh, $card_dir) or croak("Can't open file.");
        for $file (readdir $dh) {
            if ($file =~ /\.$fmt$/) {
                $card = "$card_dir/" . "$file";
            }
            elsif ($file =~ /^$card_head_in\D*.*txt$/) {
                $card_filename = "$card_dir/" . "$file";
            }
        }
        closedir $dh;

        my $dict;
        if ($fmt eq 'yml') {
            $dict = YAML::LoadFile($card);
        }
        else {
            open my $fh, '<', $card or croak("Can't open file.");
            my $json = do { local $/; <$fh> };
            $dict = decode_json(encode('utf8', $json));
            close $fh;
        }

        open $fh, '<', $card_filename or croak("Can't open file.");
        my @card_names = <$fh>;
        close $fh;
        my %set_dict;
        for (@card_names) {
            chomp;
            $set_dict{$_} = $dict->{$_};
        }
        my $set_dict = \%set_dict;

        return ($set_dict, $fmt, $card_body);
    }
}
1;
