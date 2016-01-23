use strict;
use Test::More 0.98;
use lib '../lib';
use Carvo;
use Carvo::Util;
use Carp;

subtest "help" => sub {
    use open ':utf8';
    binmode STDOUT, ':utf8';

    # got
    my $got = Util::help();

    # expect
    open my $fh_help, '<', 'src/help.txt' or die $!;
    my $expect = do { local $/; <$fh_help> };
    close $fh_help;

    #diag $got;
    #diag $expect;
    is $got, $expect, 'check-help';
};

done_testing;

