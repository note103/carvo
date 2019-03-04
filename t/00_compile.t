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
Set::Generator
Carvo
Set::CardSetter
Record::Recorder
Play::Responder
Play::Command
Play::Util
