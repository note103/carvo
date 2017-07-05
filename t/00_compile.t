use strict;
use Test::More;

for (<DATA>) {
    chomp;
    use_ok $_;
}

done_testing;

__DATA__
Generator
Data
Carvo
Printer
Reader
Responder
Command
Util
Exit
