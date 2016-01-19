#!/usr/bin/env perl
use 5.12.0;
use warnings;
use lib 'lib';
use Setup::Data;
use Carvo;

say "\nWelcome!";
print `say Welcome!`;

my $attr = Data::init();

Carvo::course($attr);
