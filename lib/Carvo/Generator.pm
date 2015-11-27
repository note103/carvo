use strict;
use warnings;

package Generator {
    my %convert;
    my ($fh, $file, $convert, $cards);
    sub switch {
        use JSON;
        my $num = shift;

        my $dir = 'card';
        opendir(my $dh, $dir) or die "can't opendir $dir: $!";
        for $file (readdir $dh) {
            if ($file =~ /^$num\D*.*(.json)/) {
                $cards = "card/$file";
            }
        }
        closedir $dh;

        open $fh, '<', $cards or die "can't open $cards: $!";
        my @tmp = <$fh>;
        my $json_text = decode_json("@tmp");
        close $fh;
        return $json_text;
    }
}
1;
