#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use lib 'lib';

use Data;
use Carvo;

my $attr = Data::init();

Carvo::card($attr);
