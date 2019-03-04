use strict;
use Test::More;
use Carp 'croak';

use FindBin;
use lib "$FindBin::Bin/../lib";

use Set::Generator;

use YAML;
use File::Slurp 'read_file';

# sample
my $attr;
$attr->{lesson_dir} = 'src/lesson';
$attr->{choose} = 'sample2';
my $expected_words = read_file("$attr->{lesson_dir}/$attr->{choose}.txt");
my @expected_words = split /\n/, $expected_words;
@expected_words = sort @expected_words;

# got
my $data;
$data = Generator::convert($attr, $data);
@{$data->{words}} = sort @{$data->{words}};

diag 'got: ' . $data->{words}->[0];
diag 'expect: ' . $expected_words[0];
is_deeply $data->{words}, \@expected_words, 'words';

my $dict = "$attr->{lesson_dir}/dict.yml";
my $tmp_dict = YAML::LoadFile($dict);

my $card = "$attr->{lesson_dir}/$attr->{choose}.txt";

diag 'got: ' . $data->{dict}->{absurdly};
diag 'expect: ' . $tmp_dict->{absurdly};
is $data->{dict}->{absurdly}, $tmp_dict->{absurdly}, 'dict_yml';

done_testing;
