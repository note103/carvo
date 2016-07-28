package Reader {
    use strict;
    use warnings;
    use feature 'say';

    use open ':utf8';
    use Carp 'croak';
    use File::Slurp 'read_dir';

    sub read {
        my $attr = shift;

        my $course_dir = $attr->{lesson};
        my $lists->{card_list} = [];

        my @course_iter = glob "$course_dir/*";
        for my $card_filename (@course_iter) {
            $card_filename =~ s/.*\/(.+)$/$1/;
            if ($card_filename =~ /^(\w+)_(.*)\.txt$/) {
                ($attr->{card_head}, $attr->{card_name}) = ($1, $2);
                $attr->{cards}->{ $attr->{card_head} } = $attr->{card_name};
                push @{ $lists->{card_list} }, "$attr->{card_head}: $attr->{card_name}";
            }
            elsif ($card_filename =~ /\.(yml|json)$/) {
                $attr->{fmt} = $1;
            }
            elsif ($card_filename =~ /^((\w+)_(.*))$/) {
                my $dirname = "$course_dir/$1";
                if (-d $dirname) {
                    my @nested_files = glob "$course_dir/$1/*";
                    @nested_files = grep {/\.txt/} @nested_files;

                    my $nested_filenum = (scalar( @nested_files ));
                    ($attr->{card_head}, $attr->{card_name}) = ($2, $3);
                    $attr->{cards}->{ $attr->{card_head} } = $attr->{card_name};
                    push @{ $lists->{card_list} }, "$attr->{card_head}: $attr->{card_name}($nested_filenum)";
                }
            }
        }
        return $lists;
    }
}

1;
