use strict;
use Test::More;

for (<DATA>) {
    chomp;
    use_ok $_;
}

done_testing;

__DATA__
Generator
Carvo
CardSetter
Recorder
Responder
Command
Util
