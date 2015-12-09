use strict;
use warnings;

package Generator {
    sub switch {
        use YAML;
        use JSON;
        my %convert;
        my ($fh, $file, $cards);
        my ($head, $fmt) = @_;

        my $dir = 'card';
        opendir(my $dh, $dir) or die "Can't opendir $dir: $!";
        for $file (readdir $dh) {
            if ($file =~ /^$head\D*.*$fmt$/) {
                $cards = "card/$file";
            }
        }
        closedir $dh;

        my $conv;
        if ($fmt eq 'yml') {
            $conv = YAML::LoadFile($cards);
        } else {
            open my $fh, '<', $cards or die "Can't open $cards: $!";
            my $json = do {local $/; <$fh>};
            $conv = decode_json($json);
            close $fh;
        }
        return ($conv, $fmt);
    }
}
1;
