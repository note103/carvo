use strict;
use Test::More;
use Carp 'croak';

use FindBin;
use lib "$FindBin::Bin/../lib";

use Carvo;
use Play::Util;

subtest "randome_jump" => sub {
    # sample
    my $attr = {
        num        => 10,
        limit      => 10000,
        num_buffer => 0,
    };
    my %expect = %$attr;

    # got
    $attr = Util::random_jump($attr);

    is   $attr->{limit},      $expect{limit},      'check-jump1';
    isnt $attr->{num},        $expect{num},        'check-jump2';
    isnt $attr->{num_buffer}, $expect{num_buffer}, 'check-jump3';
};

subtest "help" => sub {
    # got
    my $got = Carvo::help();

    # expect
    open my $fh_help, '<', 'docs/help.txt' or die $!;
    my $expect = do { local $/; <$fh_help> };
    close $fh_help;

    use Encode;
    $expect = decode('utf8', $expect);

    is $got, $expect, 'check-help';
};

done_testing;
