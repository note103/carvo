use strict;
use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib";

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
