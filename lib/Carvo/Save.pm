use strict;
use warnings;

package Save {
    use JSON;
    use Carp qw/croak/;
    use Encode;
    use open ':utf8';

    my ($num, $words, $english);
    sub save {
        ($num, $words, $english) = @_;
        open my $fh_out_num, '>', 'data/save/main/num.txt' or croak("Can't open file.");
        print $fh_out_num $num;
        close $fh_out_num;

        open my $fh_out_arr, '>', 'data/save/main/words.txt' or croak("Can't open file.");
        my @tidy;
        for (@$words) { push @tidy, $_."\n"; }
        for (@tidy) { $_ =~ s/\n\n/\n/; }
        for (@tidy) { print $fh_out_arr $_; }
        close $fh_out_arr;

        open my $fh_out_hash, '>', 'data/save/main/save.txt' or croak("Can't open file.");
        my $json = encode_json($english);
        $json = decode('utf8', $json);
        print $fh_out_hash $json;
        close $fh_out_hash;
    }
    sub buffer {
        ($num, $words, $english) = @_;
        open my $fh_out_num, '>', 'data/save/buffer/num.txt' or croak("Can't open file.");
        print $fh_out_num $num;
        close $fh_out_num;

        open my $fh_out_arr, '>', 'data/save/buffer/words.txt' or croak("Can't open file.");
        my @tidy;
        for (@$words) { push @tidy, $_."\n"; }
        for (@tidy) { $_ =~ s/\n\n/\n/; }
        for (@tidy) { print $fh_out_arr $_; }
        close $fh_out_arr;

        open my $fh_out_hash, '>', 'data/save/buffer/save.txt' or croak("Can't open file.");
        my $json = encode_json($english);
        $json = decode('utf8', $json);
        print $fh_out_hash $json;
        close $fh_out_hash;
    }
    sub revival {
        open my $fh_in_num, '<', 'data/save/main/num.txt' or croak("Can't open file.");
        $num = <$fh_in_num>;
        close $fh_in_num;

        open my $fh_in_arr, '<', 'data/save/main/words.txt' or croak("Can't open file.");
        my @words = <$fh_in_arr>;
        for (@words) { $_ =~ s/^\n//;}
        $words = \@words;
        close $fh_in_arr;

        open my $fh_in_hash, '<', 'data/save/main/save.txt' or croak("Can't open file.");
        my $english = do {local $/; <$fh_in_hash>};
        $english = decode_json(encode('utf8', $english));
        close $fh_in_hash;
        return ($num, $words, $english);
    }
    sub unrev {
        open my $fh_in_num, '<', 'data/save/buffer/num.txt' or croak("Can't open file.");
        $num = <$fh_in_num>;
        close $fh_in_num;

        open my $fh_in_arr, '<', 'data/save/buffer/words.txt' or croak("Can't open file.");
        my @words = <$fh_in_arr>;
        for (@words) { $_ =~ s/^\n//;}
        $words = \@words;
        close $fh_in_arr;

        open my $fh_in_hash, '<', 'data/save/buffer/save.txt' or croak("Can't open file.");
        my $english = do {local $/; <$fh_in_hash>};
        $english = decode_json(encode('utf8', $english));
        close $fh_in_hash;
        return ($num, $words, $english);
    }
}
1;

