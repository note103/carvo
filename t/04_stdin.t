use strict;
use warnings;
use Test::More;
use File::Basename 'basename';

use FindBin;
use lib "$FindBin::Bin/../lib";
use Set::CardSetter;


# expect
my $expect = 'sample1';

# got
my $lesson_dir = 'src/lesson';
my $attr->{lesson_dir} = $lesson_dir;

my @ls = glob "$lesson_dir/*";
@ls = map {
    my $basename = basename $_ ;
    if ($basename =~ /.txt$/) {
        $basename =~ s/.txt//;
        $basename;
    }
    else {
        ;
    }
} @ls;
my $ls = join "\n", @ls;

my $input = "$expect\n";
open my $stdin, '<', \$input;
local *STDIN = *$stdin;

my $got_ref = CardSetter::select_card($attr, \@ls);
my $got = $got_ref->{choose};

close $stdin;

is $got, $expect, 'check-stdin';

done_testing;

