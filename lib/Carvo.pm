package Carvo {
    use strict;
    use warnings;
    use feature 'say';
    use open ':utf8';

    use Setup::Generator;
    use Selector;
    use Printer;
    use Carvo::Res;
    use Carvo::Util;
    use Carvo::Command;
    use Carvo::Exit;
    use Carvo::Restorer;

    my $data_dir   = 'src';
    my $course_dir = "$data_dir/lesson";

    sub card {
        my ($attr, $data) = @_;

        $data = Util::logs($data) unless (!$data);

        my $lists = Selector::read($attr);
        Printer::print($lists);

        while (my $in = <STDIN>) {
            if ($in =~ /^(q+|quit)$/) {
                Exit::record($attr, $data);
            }
            elsif ($in =~ /^(e|edit)$/) {
                print `open $course_dir`;
            }
            elsif ($in =~ /^(r|result)$/) {
                print `open $data_dir/log/result*`;
            }
            elsif ($in =~ /^(l|log)$/) {
                print `open $data_dir/log/log*`;
            }
            elsif ($in =~ /^(.+)$/) {
                $attr->{selected_card_head} = $1;
                Selector::read($attr);
                for (keys %{ $attr->{cards} }) {
                    if ($attr->{selected_card_head} eq $_) {
                        $attr->{card_name} = $attr->{cards}->{ $attr->{selected_card_head} };
                        ($data->{dict}, $attr->{fmt}, $attr->{card_name}) = Generator::switch(
                            $attr->{selected_course_head}, $attr->{fmt},
                            $attr->{selected_card_head},   $course_dir,
                            $attr->{card_name}
                        );

                        $attr->{fail_sw} = 'off' if ($attr->{fail_sw} eq 'on');
                        $attr->{order} = Util::order_swap($attr->{order})
                            if ($attr->{order} eq 'order');
                        $data->{words} = Util::order($attr, $data)
                            if ($attr->{order} eq 'order');
                        say '';
                        Res->set($attr, $data);
                        Exit::record($attr, $data) if ($Command::quit eq 'qq');
                    }
                }
            }
            Printer::print($lists);
        }
    }
}

1;
