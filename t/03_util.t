use strict;
use Test::More 0.98;
use lib '../lib';
use Carvo;
use Carvo::Util;
use Carp;

subtest "result" => sub {

    # sample
    my $attr = {
        total => 3,
        point => 2,
        miss  => 1,
    };
    my $data = {};

    ## got
    my $got = Util::result($attr, $data);

    ## expect
    my $expect
        = "\nYou tried $attr->{total} times. $attr->{point} hits and $attr->{miss} errors.\n";

    diag 'got: '.$got;
    diag 'expect: '.$expect;
    is $got, $expect, 'check-result';
};

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

__END__
    # got
    my $result = "3\ttimes\n2\thits\n1\terrors\n";
    my $got = Util::result($result);

    # expect
    my $expect = "\nYou tried 3 times. 2 hits and 1 errors.\n";

    is $got, $expect, 'check-result';

