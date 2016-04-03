#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use lib 'lib';

use Setup::Data;
use Carvo;

say "\nWelcome!";

my $attr = Data::init();

Carvo::card($attr);
