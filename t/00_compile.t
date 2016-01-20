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
Carvo::English
Carvo::Bookkeeping
Carvo::Run
Carvo::Util
Carvo::Speech
Carvo::Run::Exit
Carvo::Run::Save
