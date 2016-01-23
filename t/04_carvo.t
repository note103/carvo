use strict;
use Test::More 0.98;
use lib '../lib';
use Carvo;
use Carp;

my ($card_head_in, $card_filename, $card, $card_name, $card_dir, $course_dir, $lists);
my ($dict, $fmt, $file, $lesson);

subtest "course" => sub {
    #got
    my $attr ={};
    my $data ={};
    my $grade = 'course';
    my $got = Carvo::read_data($grade, $attr);

    #expect
    $course_dir = "src/lesson";
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
    is_deeply $got, $lists, 'read_data';
};

done_testing;
__END__
sub dict {
    $lesson       = 'e';
    $fmt          = 'yml';
    $card_head_in = 'fs';
    $card_dir     = 'src/lesson/e_word';
    $card_name    = 'fast-and-slow';

    $card = "$card_dir/" . 'dict.yml';
    my $tmp_dict = YAML::LoadFile($card);

    $card_filename = "$card_dir/" . $card_head_in . '_' . "$card_name.txt";

    open my $fh, '<', $card_filename or croak("Can't open file.");
    my @card_names = <$fh>;
    close $fh;
    my %set_dict;
    for (@card_names) {
        chomp;
        $set_dict{$_} = $tmp_dict->{$_};
    }
    $dict = \%set_dict;
    return $dict;
}

