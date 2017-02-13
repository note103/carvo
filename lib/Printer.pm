package Printer {
    use strict;
    use warnings;
    use feature 'say';

    sub print {
        my ( $lists, $attr ) = @_;

        my @command_card;
        if ($attr->{lesson} eq $attr->{lesson_root}) {
            @command_card = ('exit');
        } else {
            @command_card = ('back', 'exit');
        }
        my $course_dir = $attr->{lesson};
        my @cards = @{ $lists->{card_list} };

        my %data;
        my @num; my @head; my @word;
        for (sort @cards) {
            if ($_ =~ /\A(\D+)(\d+)(.+)/) {
                push @head, $1;
                push @num, $2;
                push @word, $3;
            }
            elsif ($_ =~ /\A(\D+)(.+)/) {
                push @head, $1;
                push @num, 0;
                push @word, $2;
            }
        }
        my @sorted;
        for my $head (@head) {
            for my $num (sort {$a <=> $b} @num) {
                for my $word (@word) {
                    for my $card (@cards) {
                        if ($card eq "$head$num$word") {
                            $card =~ s/\A\w+: //;
                            push @sorted, $card;
                            @cards = grep {$_ ne $card} @cards;
                        }
                        elsif ($card eq "$head$word") {
                            $card =~ s/\A\w+: //;
                            push @sorted, $card;
                            @cards = grep {$_ ne $card} @cards;
                        }
                    }
                }
            }
        }
        my @options = (@sorted, @command_card);
        my $options = join "\n", @options;
        my $choose = `echo "$options" | peco | tr -d "\n"`;

        $choose = 'back' if $choose eq "";
        $attr->{choose} = '';

        for (@{ $lists->{card_list} }) {
            $choose =~ s/\(.+\)//;
            if ($_ =~ /$choose/) {
                $attr->{choose} = $_;
            }
        }
        $attr->{choose} = $choose if $attr->{choose} eq '';

        return $attr;
    }
}

1;
