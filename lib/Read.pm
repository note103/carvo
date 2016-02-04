package Read {
    use 5.12.0;
    use warnings;
    use open ':utf8';
    use Time::Piece;
    use Carp;
    use Path::Tiny;

    sub read_data {
        my ($stage, $attr) = @_;
        my $data_dir   = 'src';
        my $course_dir = "$data_dir/lesson";
        my $lists;

        if ($stage eq 'course') {
            $lists->{course_list} = [];
            my $course_iter = path($course_dir)->iterator;
            while (my $course_filename = $course_iter->()) {
                if ($course_filename =~ /[^(\.DS)](\w+)_(\w+)$/) {
                    ($attr->{course_head}, $attr->{course_name}) = ($1, $2);
                    $attr->{courses}->{ $attr->{course_head} } = $attr->{course_name};
                    push @{ $lists->{course_list} }, "$attr->{course_head}: $attr->{course_name}";
                }
            }
        }
        elsif ($stage eq 'card') {
            $lists->{card_list} = [];
            my $card_iter = path($attr->{card_dir})->iterator;
            while (my $path = $card_iter->()) {
                my $card_filename = $path->basename;
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
