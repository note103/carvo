use strict;
use warnings;

package Save {
    use YAML;
    use Carp qw/croak/;
    use Encode;
    use open ':utf8';
    binmode STDOUT, ':utf8';

    my ($name, $num, $words, $kv, $mb);
    my ($file_num, $file_words, $file_kv);

    sub main {
        ($name, $num, $words, $kv) = @_;
        if ($name eq 'sv') {
            save_buffer($num, $words, $kv, 'main');
        } elsif ($name eq 'bf') {
            save_buffer($num, $words, $kv, 'buffer');
        } elsif ($name eq 'rv') {
            rv_urv($num, $words, $kv, 'main');
        } elsif ($name eq 'urv') {
            rv_urv($num, $words, $kv, 'buffer');
        }
    }
    sub save_buffer {
        ($num, $words, $kv, $mb) = @_;
        $file_num = "data/save/$mb/num.txt";
        open my $fh_out_num, '>', $file_num or croak("Can't open file.");
        print $fh_out_num $num;
        close $fh_out_num;

        $file_words = "data/save/$mb/words.txt";
        open my $fh_out_words, '>', $file_words or croak("Can't open file.");
        my @tidy;
        for (@$words) { push @tidy, $_."\n"; }
        for (@tidy) { $_ =~ s/\n\n/\n/; }
        for (@tidy) { print $fh_out_words $_; }
        close $fh_out_words;

        $file_kv = "data/save/$mb/save.txt";
        open my $fh_out_kv, '>', $file_kv or croak("Can't open file.");
        my $yaml = YAML::Dump($kv);
        print $fh_out_kv $yaml;
        close $fh_out_kv;
    }
    sub rv_urv {
        ($num, $words, $kv, $mb) = @_;
        $file_num = "data/save/$mb/num.txt";
        open my $fh_in_num, '<', $file_num or croak("Can't open file.");
        $num = <$fh_in_num>;
        close $fh_in_num;

        $file_words = "data/save/$mb/words.txt";
        open my $fh_in_words, '<', $file_words or croak("Can't open file.");
        my @words = <$fh_in_words>;
        for (@words) { $_ =~ s/^\n//;}
        $words = \@words;
        close $fh_in_words;

        $file_kv = "data/save/$mb/save.txt";
        open my $fh_in_kv, '<', $file_kv or croak("Can't open file.");
        my $kv = do {local $/; <$fh_in_kv>};
        $kv = YAML::Load($kv);
        close $fh_in_kv;
        return ($num, $words, $kv);
    }
}
1;
