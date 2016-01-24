package Carvo {
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
    use Read;
    use Menu;

    my $data_dir   = 'src';
    my $course_dir = "$data_dir/lesson";

    sub course {
        my ($attr, $data) = @_;

        $data = Util::logs($data) unless (!$data);
        $data->{fail} = [];
        $Run::quit = '' if (!$Run::quit);

        my $lists = Read::read_data('course', $attr);
        Menu::print_menu('course', $lists);

        while (my $in = <STDIN>) {

            if ($in =~ /^(q|quit)$/) {
                Exit::record($attr, $data);
            }
            elsif ($in =~ /^(r|result)$/) {
                print `open $data_dir/log/result*`;
            }
            elsif ($in =~ /^(l|log)$/) {
                print `open $data_dir/log/log*`;
            }
            elsif ($in =~ /^(\w+)$/) {
                $attr->{selected_course_head} = $1;
                for (keys %{ $attr->{courses} }) {
                    if ($attr->{selected_course_head} eq $_) {
                        $attr->{card_dir}
                            = $course_dir . '/'
                            . $attr->{selected_course_head} . "_"
                            . $attr->{courses}->{ $attr->{selected_course_head} };
                        card($attr, $data);
                        last;
                    }
                    else {
                        $attr->{card_dir} = '';
                    }
                }
                unless ($attr->{card_dir} eq '') {
                    last;
                }
            }
            Menu::print_menu('course', $lists);
        }
    }

    sub card {
        my ($attr, $data) = @_;

        $data = Util::logs($data) unless (!$data);

        my $lists = Read::read_data('card', $attr);
        Menu::print_menu('card', $lists);

        while (my $in = <STDIN>) {
            if ($in =~ /^(qq)$/) {
                Exit::record($attr, $data);
            }
            elsif ($in =~ /^(q|quit)$/) {
                course($attr, $data);
            }
            elsif ($in =~ /^(e|edit)$/) {
                print `open $attr->{card_dir}`;
            }
            elsif ($in =~ /^(.+)$/) {
                $attr->{selected_card_head} = $1;
                Read::read_data('card', $attr);
                for (keys %{ $attr->{cards} }) {
                    if ($attr->{selected_card_head} eq $_) {
                        $attr->{card_name} = $attr->{cards}->{ $attr->{selected_card_head} };
                        ($data->{dict}, $attr->{fmt}, $attr->{card_name}) = Generator::switch(
                            $attr->{selected_course_head}, $attr->{fmt},
                            $attr->{selected_card_head},   $attr->{card_dir},
                            $attr->{card_name}
                        );

                        $attr->{fail_sw} = 'off' if ($attr->{fail_sw} eq 'on');

                        if ($attr->{selected_course_head} eq 'p') {

                            $attr->{voice_swap} = 'value' if ($attr->{voice_swap} eq 'key');
                            $attr->{order}      = 'order' if ($attr->{order} eq 'random');
                            $data->{words} = Util::order($attr, $data)
                                if ($attr->{order} eq 'random');
                            $attr->{speech} = 'on' if ($attr->{speech} eq 'off');

                            Speech->set($attr, $data);

                        }
                        else {

                            $attr->{voice_swap} = Util::voice_swap($attr->{voice_swap})
                                if ($attr->{voice_swap} eq 'value');
                            $attr->{order} = Util::order_swap($attr->{order})
                                if ($attr->{order} eq 'order');
                            $data->{words} = Util::order($attr, $data)
                                if ($attr->{order} eq 'order');
                            $attr->{speech} = 'off'
                                if ($attr->{speech} eq 'on');
                            say '';

                            if ($attr->{selected_course_head} eq 'b') {
                                Bookkeeping->set($attr, $data);
                            }
                            else {
                                English->set($attr, $data);
                            }
                        }
                        Carvo::course($attr, $data) if ($Run::quit eq 'qq');
                    }
                }
            }
            Menu::print_menu('card', $lists);
        }
    }

    #    sub Read::read_data {
    #        my ($grade, $attr) = @_;
    #
    #        my $lists;
    #
    #        if ($grade eq 'course') {
    #            $lists->{course_list} = [];
    #
    #            opendir(my $dirh, $course_dir)
    #                or croak("Can't opendir $course_dir: $!");
    #            for my $course_filename (readdir $dirh) {
    #                if ($course_filename =~ /^(\w+)_(\w+)$/) {
    #                    ($attr->{course_head}, $attr->{course_name}) = ($1, $2);
    #                    $attr->{courses}->{ $attr->{course_head} } = $attr->{course_name};
    #                    push @{ $lists->{course_list} }, "$attr->{course_head}: $attr->{course_name}";
    #                }
    #            }
    #            closedir $dirh;
    #        }
    #        elsif ($grade eq 'card') {
    #            $lists->{card_list} = [];
    #
    #            opendir(my $dirh, $attr->{card_dir})
    #                or croak("Can't open file: $!");
    #            for my $card_filename (readdir $dirh) {
    #                if ($card_filename =~ /^((.+)_(.*)\.txt)$/) {
    #                    ($attr->{card_head}, $attr->{card_name}) = ($2, $3);
    #                    $card_filename = $1;
    #                    $attr->{cards}->{ $attr->{card_head} } = $attr->{card_name};
    #                    push @{ $lists->{card_list} }, "$attr->{card_head}: $attr->{card_name}";
    #                }
    #                elsif ($card_filename =~ /\.(yml|json)$/) {
    #                    $attr->{fmt} = $1;
    #                }
    #            }
    #            closedir $dirh;
    #        }
    #        return $lists;
    #    }
    #
    #    sub Menu::print_menu {
    #        my ($grade, $lists) = @_;
    #
    #        my @command_course = ('r: result', 'l: log');
    #        my @command_card   = ('e: edit',   'q: exit');
    #
    #        my $msg_selectcard   = "Please select a card.\n";
    #        my $msg_selectcourse = "Please select a course.\n";
    #
    #        if ($grade eq 'course') {
    #            say $msg_selectcourse;
    #
    #            say "$grade: ";
    #            for (@{ $lists->{course_list} }) { say "\t$_"; }
    #
    #            say 'command:';
    #            for (@command_course) { say "\t$_"; }
    #        }
    #        elsif ($grade =~ /card/) {
    #            say $msg_selectcard;
    #
    #            if ($grade eq 'card') {
    #                say "$grade: ";
    #                for (@{ $lists->{card_list} }) { say "\t$_"; }
    #                say 'command:';
    #                for (@command_card) { say "\t$_"; }
    #            }
    #            elsif ($grade eq 'edit') {
    #                say "\t$grade: ";
    #                for (@{ $lists->{card_list} }) { say "\t\t$_"; }
    #                say "\t\tq: exit\n";
    #            }
    #        }
    #    }
}

1;
