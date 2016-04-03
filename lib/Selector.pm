package Selector {
    use strict;
    use warnings;
    use feature 'say';

    use open ':utf8';
    use Carp 'croak';
    use File::Slurp 'read_dir';

    sub read {
        my $attr = shift;

        my $data_dir   = 'src';
        my $course_dir = "$data_dir/lesson";
        my $lists->{card_list} = [];

        my @course_iter = read_dir($course_dir);
        for my $card_filename (@course_iter) {
            if ($card_filename =~ /^(\w+)_(.*)\.txt$/) {
                ($attr->{card_head}, $attr->{card_name}) = ($1, $2);
                $attr->{cards}->{ $attr->{card_head} } = $attr->{card_name};
                push @{ $lists->{card_list} }, "$attr->{card_head}: $attr->{card_name}";
            }
            elsif ($card_filename =~ /\.(yml|json)$/) {
                $attr->{fmt} = $1;
            }
        }
        return $lists;
    }
}

1;
