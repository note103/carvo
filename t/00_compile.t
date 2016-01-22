use strict;
use Test::More;
use lib '../lib';

use_ok $_ for qw(
    Carvo
    Setup::Generator
    Setup::Data
    Carvo::English
    Carvo::Bookkeeping
    Carvo::Run
    Carvo::Util
    Carvo::Speech
    Carvo::Run::Exit
    Carvo::Run::Save
);

done_testing;
