package Peco;
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

sub peco {
    my $path = shift;

    my $result = qx{echo "$path" | peco | tr -d "\n"};

    return $result;
}


1;
