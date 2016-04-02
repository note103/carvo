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
Setup::Data
Carvo
Printer
Selector
Carvo::Res
Carvo::Run
Carvo::Util
Carvo::Exit
Carvo::Save
