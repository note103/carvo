package Peco;
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

sub peco {
    my $path = shift;
    my $flag_test = shift // '';

    my $result;

    if ($flag_test eq '') {
        $result = qx{echo "$path" | peco | tr -d "\n"};
    }
    else {
        chomp ($result = <STDIN>);
    }

    return $result;
}


1;
