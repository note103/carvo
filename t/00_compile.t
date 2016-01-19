use strict;
use Test::More;
use lib '../lib';

for (<DATA>) {
    chomp;
    use_ok $_;
}

done_testing;

__DATA__
Setup::Generator
Carvo::English
Carvo::Run
Carvo::Run::Exit
