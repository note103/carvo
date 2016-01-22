use strict;
use Test::More 0.98;
use lib '../lib';
use Carvo;
use Setup::Generator;

subtest "yml" => sub {
    my $card_dir = '../src/lesson/e_word';
    my ($dict, $fmt, $card_name) = Generator::switch(
        'e', 'yml', 'fs', 'src/lesson/e_word', 'fast-and-slow'
    );
    is $fmt, 'yml';
};

subtest "json" => sub {
    my $card_dir = '../src/lesson/p_speech';
    my ($dict, $fmt, $card_name) = Generator::switch(
        'p', 'json', 't', 'src/lesson/p_speech', 'timcook'
    );
    is $fmt, 'json';
};

done_testing;
