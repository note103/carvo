use strict;
use Test::More 0.98;
use Carvo;
use Carp;

my ($card_head_in, $card_filename, $card, $card_name, $card_dir, $course_dir, $lists);
my ($dict, $fmt, $file, $lesson, $attr, $data);
$attr = {
    total => 0,
    point => 0,
    miss  => 0,
    
    num      => 0,
    num_buffer => 0,
    num_normal => 0,
    
    voice      => 'say',
    voice_swap => 'key',
    
    extr       => 3,
    log_record => 'on',
    order      => 'random',
    fail_sw    => 'off',
    speech     => 'off',
    quit     => '',
};

subtest "std-io" => sub {
    my $inputs = "w\n";
    open my $in, '<', \$inputs;
    local *STDIN = $in;

    my $output;
    open my $out, '>', \$output;
    local *STDOUT = $out;

    Carvo::course($attr, $data);

    like $output, qr/Please select a course./;
    like $output, qr/w: word/;

    close $in;
    close $out;
};

done_testing;
