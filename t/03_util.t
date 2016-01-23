use strict;
use Test::More 0.98;
use lib '../lib';
use Carvo;
use Carvo::Util;
use Carp;

sub sample {
    my ($card_head_in, $card_filename, $card, $card_name, $card_dir);
    my ($dict, $fmt, $file, $lesson);
    $lesson       = 'e';
    $fmt          = 'yml';
    $card_head_in = 'fs';
    $card_dir     = 'src/lesson/e_word';
    $card_name    = 'fast-and-slow';

    $card = "$card_dir/" . 'dict.yml';
    my $tmp_dict = YAML::LoadFile($card);

    $card_filename = "$card_dir/" . $card_head_in . '_' . "$card_name.txt";

    open my $fh, '<', $card_filename or croak("Can't open file.");
    my @card_names = <$fh>;
    close $fh;
    my %set_dict;
    for (@card_names) {
        chomp;
        $set_dict{$_} = $tmp_dict->{$_};
    }
    $dict = \%set_dict;
    return $dict;
}

subtest "order" => sub {

    my $order = 'order';
    my $attr->{order} = $order;
    my $data->{dict}  = sample();

    # got_order
    $data->{word} = Util::order($attr, $data);
    my $got_order = $data->{word};

    # expect_order
    my @word         = sort keys %{ $data->{dict} };
    my $expect_order = \@word;

    diag 'got_order: ' . $got_order->[0];
    diag 'expect_order: ' . $expect_order->[0];
    is $got_order->[0], $expect_order->[0], 'check-order';

    $order = 'random';
    $attr->{order} = $order;
    $data->{dict}  = sample();

    # got_random
    $data->{word} = Util::order($attr, $data);
    my $got_random = $data->{word};

    # expect_random
    @word         = keys %{ $data->{dict} };
    my $expect_random = \@word;

    diag 'got_order: ' . $got_order->[0];
    diag 'expect_order: ' . $expect_order->[0];
    is $got_random->[0], $expect_random->[0], 'check-order';
};

subtest "jump" => sub {

    # sample
    my $attr = {
        num        => 10,
        limit      => 10000,
        num_buffer => 0,
    };
    my %expect = %$attr;

    # got
    $attr = Util::jump($attr);
    my $got_num = $attr->{num};

    # expect
    my $expect_num = $expect{num};

    diag 'got_num: ' . $got_num;
    diag 'expect_num: ' . $expect_num;
    isnt $got_num, $expect_num, 'check-jump';
};

subtest "result" => sub {

    # sample
    my $attr = {
        total => 3,
        point => 2,
        miss  => 1,
    };
    my $data = {};

    # got
    my $got = Util::result($attr, $data);

    # expect
    my $expect
        = "\nYou tried $attr->{total} times. $attr->{point} hits and $attr->{miss} errors.\n";

    diag 'got_result: ' . $got;
    diag 'expect_result: ' . $expect;
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

    is $got, $expect, 'check-help';
};

done_testing;
