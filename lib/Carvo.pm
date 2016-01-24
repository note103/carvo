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
}

1;
