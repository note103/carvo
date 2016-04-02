package Printer {
    use strict;
    use warnings;
    use feature 'say';
    use open ':utf8';

    use Time::Piece;
    use Carp 'croak';

    my $data_dir   = 'src';
    my $course_dir = "$data_dir/lesson";

    sub print_menu {
        my ($grade, $lists) = @_;

        my @command_course = ('r: result', 'l: log');
        my @command_card   = ('e: edit',   'q: exit');

        my $msg_selectcard   = "Please select a card.\n";
        my $msg_selectcourse = "Please select a course.\n";

        if ($grade eq 'course') {
            say $msg_selectcourse;

            say "$grade: ";
            for (@{ $lists->{course_list} }) { say "\t$_"; }

            say 'command:';
            for (@command_course) { say "\t$_"; }
        }
        elsif ($grade =~ /card/) {
            say $msg_selectcard;

            if ($grade eq 'card') {
                say "$grade: ";
                for (@{ $lists->{card_list} }) { say "\t$_"; }
                say 'command:';
                for (@command_card) { say "\t$_"; }
            }
            elsif ($grade eq 'edit') {
                say "\t$grade: ";
                for (@{ $lists->{card_list} }) { say "\t\t$_"; }
                say "\t\tq: exit\n";
            }
        }
    }
}

1;
