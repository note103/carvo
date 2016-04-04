package Printer {
    use strict;
    use warnings;
    use feature 'say';
    use open ':utf8';

    my $data_dir   = 'src';
    my $course_dir = "$data_dir/lesson";

    sub print {
        my $lists = shift;
        my @command_card = ('r: result', 'l: log', 'q: exit');

        say "Please select a card.\n";
        say "card: ";
        for (@{ $lists->{card_list} }) { say "\t$_"; }
        say 'command:';
        for (@command_card) { say "\t$_"; }
    }
}

1;
