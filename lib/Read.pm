package Selector {
    use strict;
    use warnings;
    use open ':utf8';
    use Time::Piece;
    use Carp 'croak';
    use File::Slurp 'read_dir';

    sub read_data {
        my ($stage, $attr) = @_;
        my $data_dir   = 'src';
        my $course_dir = "$data_dir/lesson";
        my $lists;

        if ($stage eq 'course') {
            $lists->{course_list} = [];

            my @course_iter = read_dir($course_dir);
            for (@course_iter) {
                my $course_filename = $course_dir.'/'.$_;
                if ($course_filename =~ /[^(\.DS)](\w+)_(\w+)$/) {
                    ($attr->{course_head}, $attr->{course_name}) = ($1, $2);
                    $attr->{courses}->{ $attr->{course_head} } = $attr->{course_name};
                    push @{ $lists->{course_list} }, "$attr->{course_head}: $attr->{course_name}";
                }
            }
        }
        elsif ($stage eq 'card') {
            $lists->{card_list} = [];

            my @course_iter = read_dir($attr->{card_dir});
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
        }
        return $lists;
    }
}

1;
