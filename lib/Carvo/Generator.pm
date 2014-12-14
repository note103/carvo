#!/usr/bin/env perl
use strict;
use warnings;
use 5.012;

package Generator {
    my %convert;
    my ($fh, $file, $convert, $cards);
    sub switch {
        use JSON;
        my $num = shift;
        our $num_port;

        my $dir = 'cards';
        opendir(my $dh, $dir) || die "can't opendir $dir: $!";
        for $file (readdir $dh) {
            if ($file =~ /^$num\D*.*(.json)/) {
                $cards = "cards/$file";
                $num_port = $num;
            }
        }
        closedir $dh;

        open $fh, '<', $cards || die "can't opendir $dir: $!";
        my @tmp = <$fh>;
        my $json_text = decode_json("@tmp");
        close $fh;
        return $json_text;
    }
}
1;
