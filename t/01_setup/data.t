use strict;
use Test::More 0.98;
use lib '../lib';
use Carvo;
use Setup::Data;

my $data = {
    total => 0,
    point => 0,
    miss  => 0,
    num      => 0,
    num_buffer => 0,
    num_normal => 0,
    voice      => 'say',
    voice_swap => 'key',
    voice_ch => 'off',
    extr       => 3,
    log_record => 'on',
    order      => 'random',
    fail_sw    => 'off',
    speech     => 'off',
    quit     => '',
};
is_deeply Data::init(), $data || diag explain Data::init();

done_testing;

