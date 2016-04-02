use strict;
use Test::More;

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
