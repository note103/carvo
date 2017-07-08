#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';

use FindBin;
use lib "$FindBin::Bin/lib";

use Carvo;


my ($attr, $data) = Carvo::init();

while (1) {

    ($attr, $data) = Carvo::select($attr, $data);

    ($attr, $data) = Carvo::play($attr, $data);

}
