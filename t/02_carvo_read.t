use strict;
use Test::More 0.98;
use lib '../../lib';
use Carvo;
use Carp;

my ($card_head_in, $card_filename, $card, $card_name, $card_dir, $course_dir, $lists);
my ($dict, $fmt, $file, $lesson, $attr, $data);

subtest "read-course" => sub {
    #got
    my $got_list_course = Read::read_data('course', $attr);
    my $expect_list_course;

    #expect
    $course_dir = "src/lesson";
    opendir(my $dirh, $course_dir)
        or croak("Can't opendir $course_dir: $!");
    for my $course_filename (readdir $dirh) {
        if ($course_filename =~ /^(\w+)_(\w+)$/) {
            ($attr->{course_head}, $attr->{course_name}) = ($1, $2);
            $attr->{courses}->{ $attr->{course_head} } = $attr->{course_name};
            push @{ $expect_list_course->{course_list} }, "$attr->{course_head}: $attr->{course_name}";
        }
    }
    closedir $dirh;
    is_deeply $got_list_course, $expect_list_course, 'read_course';
};

subtest "read-card" => sub {
    # sample
    $attr->{card_dir} = 'src/lesson/e_word';

    # got
    my $got_list_card = Read::read_data('card', $attr);
    my $expect_list_card;

    # expect
    opendir(my $dirh, $attr->{card_dir})
        or croak("Can't open file: $!");
    for my $card_filename (readdir $dirh) {
        if ($card_filename =~ /^((.+)_(.*)\.txt)$/) {
            ($attr->{card_head}, $attr->{card_name}) = ($2, $3);
            $card_filename = $1;
            $attr->{cards}->{ $attr->{card_head} } = $attr->{card_name};
            push @{ $expect_list_card->{card_list} }, "$attr->{card_head}: $attr->{card_name}";
        }
        elsif ($card_filename =~ /\.(yml|json)$/) {
            $attr->{fmt} = $1;
        }
    }
    closedir $dirh;
    diag explain $got_list_card;
    diag explain $expect_list_card;
    is_deeply $got_list_card, $expect_list_card, 'read_card';

};

done_testing;
__END__
subtest "stdin-q" => sub {
    my $inputs = "q\n";
    open my $in, '<', \$inputs;
    local *STDIN = $in;
    my $expect = "q";
    is Carvo::course(), $expect;
    close $in;
};

done_testing;
__END__

