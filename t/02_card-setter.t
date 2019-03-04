use strict;
use Test::More;
use Carp;
use feature 'say';

use FindBin;
use lib "$FindBin::Bin/../lib";

use Set::CardSetter;

subtest "read_card" => sub {
    my $attr->{lesson_dir} = 'src/lesson';

    # got
    my $got_list = CardSetter::read_directory($attr);

    # expect
    my $expect_list = [];
    opendir(my $dirh, $attr->{lesson_dir}) or die $!;
    for my $card_filename (readdir $dirh) {
        if ($card_filename =~ /\A(.*)\.txt\z/) {
            push @$expect_list, $1;
        }
    }
    closedir $dirh;

    diag explain $got_list;
    diag explain $expect_list;

    is_deeply $got_list, $expect_list, 'card_list';
};

done_testing;
