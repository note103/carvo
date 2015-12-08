use strict;
use warnings;

package Generator {
    my %convert;
    my ($fh, $file, $convert, $cards);
    sub switch {
        use YAML;
        use JSON;
        my $head = shift;

        my $dir = 'card';
        opendir(my $dh, $dir) or die "can't opendir $dir: $!";
        for $file (readdir $dh) {
            if ($file =~ /^$head\D*.*(.yml)/) {
                $cards = "card/$file";
            }
        }
        closedir $dh;

        my $conv = YAML::LoadFile($cards);
        return $conv;
    }
}
1;
