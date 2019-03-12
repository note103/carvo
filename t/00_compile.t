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
Carvo
Play::Commander
Play::Responder
Play::Util
Close::Closer
Close::Logger
Set::CardSetter
Set::Generator
Set::Peco
