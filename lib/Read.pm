package Read {
    use 5.12.0;
    use warnings;
    use open ':utf8';
    use Time::Piece;
    use Carp;

    use Setup::Generator;
    use Carvo::English;
    use Carvo::Speech;
    use Carvo::Bookkeeping;
    use Carvo::Util;
    use Carvo::Run;
    use Carvo::Run::Exit;
    use Carvo::Run::Save;

    my $data_dir   = 'src';
    my $course_dir = "$data_dir/lesson";

    sub read_data {
        my ($grade, $attr) = @_;

        my $lists;

        if ($grade eq 'course') {
            $lists->{course_list} = [];

            opendir(my $dirh, $course_dir)
                or croak("Can't opendir $course_dir: $!");
            for my $course_filename (readdir $dirh) {
                if ($course_filename =~ /^(\w+)_(\w+)$/) {
                    ($attr->{course_head}, $attr->{course_name}) = ($1, $2);
                    $attr->{courses}->{ $attr->{course_head} } = $attr->{course_name};
                    push @{ $lists->{course_list} }, "$attr->{course_head}: $attr->{course_name}";
                }
            }
            closedir $dirh;
        }
        elsif ($grade eq 'card') {
            $lists->{card_list} = [];

            opendir(my $dirh, $attr->{card_dir})
                or croak("Can't open file: $!");
            for my $card_filename (readdir $dirh) {
                if ($card_filename =~ /^((.+)_(.*)\.txt)$/) {
                    ($attr->{card_head}, $attr->{card_name}) = ($2, $3);
                    $card_filename = $1;
                    $attr->{cards}->{ $attr->{card_head} } = $attr->{card_name};
                    push @{ $lists->{card_list} }, "$attr->{card_head}: $attr->{card_name}";
                }
                elsif ($card_filename =~ /\.(yml|json)$/) {
                    $attr->{fmt} = $1;
                }
            }
            closedir $dirh;
        }
        return $lists;
    }
}

1;
