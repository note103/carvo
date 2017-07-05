use strict;
use Test::More;
use Carp 'croak';

use FindBin;
use lib "$FindBin::Bin/../../lib";

use Data;
use Generator;

use YAML;
use File::Slurp 'read_file';


subtest "yml" => sub {

    # sample
    my $fmt          = 'yml';
    my $card_dir     = 'src/lesson';
    my $card_name    = 'daily01';

    # got
    my ($got_dict, $got_card_name)
        = Generator::convert($fmt, $card_dir, $card_name);

    is $got_card_name, $card_name, 'card_name_yml';

    my $dict = "$card_dir/" . 'dict.yml';
    my $tmp_dict = YAML::LoadFile($dict);

    my $card = "$card_dir/$card_name.txt";

    my $words = read_file($card);
    my @words = split /\n/, $words;
    my %set_dict;
    for (@words) {
        $set_dict{$_} = $tmp_dict->{$_};
    }
    my $set_dict = \%set_dict;

    diag 'got: ' . $got_dict->{absurdly};
    diag 'expect: ' . $set_dict->{absurdly};
    is $got_dict->{absurdly}, $set_dict->{absurdly}, 'dict_yml';
};


done_testing;
