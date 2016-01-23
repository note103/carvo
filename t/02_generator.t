use strict;
use Test::More 0.98;
use lib '../lib';
use Carvo;
use Setup::Generator;
use Carp;

my ($card_head_in, $card_filename, $card, $card_name, $card_dir);
my ($dict,         $fmt,           $file, $lesson);
my ($got_dict,     $got_fmt,       $got_card_name);
my $expect_dict;

sub expect {
    ($lesson, $fmt, $card_head_in, $card_dir, $card_name) = @_;

    opendir(my $dh, $card_dir) or die $!;
    for $file (readdir $dh) {
        if ($file =~ /\.$fmt$/) {
            $card = "$card_dir/" . "$file";
        }
        elsif ($file =~ /^$card_head_in\D*.*txt$/) {
            $card_filename = "$card_dir/" . "$file";
        }
    }
    closedir $dh;

    if ($fmt eq 'yml') {
    }
    else {
        open my $fh, '<', $card or croak("Can't open file.");
        my $json = do { local $/; <$fh> };
        $dict = decode_json(encode('utf8', $json));
        close $fh;
    }

    open my $fh, '<', $card_filename or croak("Can't open file.");
    my @card_names = <$fh>;
    close $fh;
    my %set_dict;
    for (@card_names) {
        chomp;
        $set_dict{$_} = $dict->{$_};
    }
    my $set_dict = \%set_dict;

    return ($set_dict, $fmt, $card_name);
}

subtest "yml" => sub {
    use YAML;

    # test-sample
    $lesson       = 'e';
    $fmt          = 'yml';
    $card_head_in = 'fs';
    $card_dir     = 'src/lesson/e_word';
    $card_name    = 'fast-and-slow';

    # got
    ($got_dict, $got_fmt, $got_card_name)
        = Generator::switch($lesson, $fmt, $card_head_in, $card_dir, $card_name);

    is $got_fmt,       $fmt,       'fmt_yml';
    is $got_card_name, $card_name, 'card_name_yml';

    $card = "$card_dir/" . 'dict.yml';
    my $tmp_dict = YAML::LoadFile($card);

    $card_filename = "$card_dir/".$card_head_in.'_'."$card_name.txt";
    #diag $card_filename;

    open my $fh, '<', $card_filename or croak("Can't open file.");
    my @card_names = <$fh>;
    close $fh;
    my %set_dict;
    for (@card_names) {
        chomp;
        $set_dict{$_} = $tmp_dict->{$_};
    }
    $expect_dict = \%set_dict;

    is $got_dict->{absurdly}, $expect_dict->{absurdly}, 'dict_yml';
    #diag explain $got_dict;
    #diag explain $expect_dict;
    diag 'got: ' . $got_dict->{absurdly};
    diag 'got: ' . $expect_dict->{absurdly};
};

subtest "json" => sub {
    use Encode;
    use JSON;
    use open qw/:utf8 :std/;

    # test-sample
    $lesson       = 'p';
    $fmt          = 'json';
    $card_head_in = 't';
    $card_dir     = 'src/lesson/p_speech';
    $card_name    = 'timcook';

    # got
    ($got_dict, $got_fmt, $got_card_name)
        = Generator::switch($lesson, $fmt, $card_head_in, $card_dir, $card_name);

    is $got_fmt,       $fmt,       'fmt_json';
    is $got_card_name, $card_name, 'card_name_json';

    $card = "$card_dir/" . 'dict.json';
    open my $fh, '<', $card or croak("Can't open file.");
    my $json = do { local $/; <$fh> };
    my $tmp_dict = decode_json(encode('utf8', $json));
    close $fh;

    $card_filename = "$card_dir/".$card_head_in.'_'."$card_name.txt";
    #diag $card_filename;

    open $fh, '<', $card_filename or croak("Can't open file.");
    my @card_names = <$fh>;
    close $fh;
    my %set_dict;
    for (@card_names) {
        chomp;
        $set_dict{$_} = $tmp_dict->{$_};
    }
    $expect_dict = \%set_dict;

    is $got_dict->{'01'}, $expect_dict->{'01'}, 'dict_json';
    #diag explain $got_dict;
    #diag explain $expect_dict;
    diag 'got: ' . $got_dict->{'01'};
    diag 'got: ' . $expect_dict->{'01'};
};

done_testing;

