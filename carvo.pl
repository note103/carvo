#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';

use FindBin;
use lib "$FindBin::Bin/lib";

use Carvo;


my $attr = Carvo::init();

while (1) {
    Carvo::card($attr);
}
