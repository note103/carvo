package Printer {
    use strict;
    use warnings;
    use feature 'say';

    sub print {
        my $attr = shift;
        my $list = shift;

        my @command_card = qw/exit/;
        my $course_dir = $attr->{lesson_dir};
        my @cards;

        for (@$list) {
            push @cards, $_;
        }

        @cards = sort @cards;
        my @options = (@cards, @command_card);
        my $options = join "\n", @options;

        while (1) {
            $attr->{choose} = `echo "$options" | peco | tr -d "\n"`;
            last if ($attr->{choose} ne '')
        }

        return $attr;
    }
}

1;
