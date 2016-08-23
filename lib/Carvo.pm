package Carvo {
    use strict;
    use warnings;
    use feature 'say';
    use open ':utf8';

    use Generator;
    use Reader;
    use Printer;
    use Res;
    use Util;
    use Command;
    use Exit;
    use Restorer;

    my $data_dir   = 'src';

    sub card {
        my ($attr, $data) = @_;
        # $data = Util::logs($data) unless (!$data);

        my $lists = Reader::read($attr);
        $attr = Printer::print($lists, $attr);

        my $in = '';
        $in = $1 if ($attr->{choose} =~ /(\w+)/);

        if ($in eq '') {
            Exit::record($attr, $data);
        }
        elsif ($in =~ /^(q+|quit|exit|back)$/) {
            chomp $in;
            if ($attr->{lesson} ne $attr->{lesson_root}) {
                if ($in eq 'q' || $in eq 'back') {
                    $attr->{lesson} = $attr->{lesson_root};
                    card($attr, $data);
                }
                elsif ($in eq 'qq') {
                    $data = Util::logs($data);
                    Exit::record($attr, $data);
                }
            }
            $data = Util::logs($data);

            Exit::record($attr, $data);
        }
        elsif ($in =~ /^(result)$/) {
            system "cat $data_dir/log/result.txt | less";
            card($attr, $data);
        }
        elsif ($in =~ /^(fail)$/) {
            system "perl fail.pl 365 100 | less";
            card($attr, $data);
        }
        elsif ($in =~ /^(log)$/) {
            system "cat $data_dir/log/log.txt | less";
            card($attr, $data);
        }
        elsif ($in =~ /^(.+)$/) {
            $attr->{bookkeeping} = 'off';
            $attr->{selected_card_head} = $1;
            if ($attr->{selected_card_head} =~ /^b/) {
                $attr->{voice_ch} = 'off';
                $attr->{bookkeeping} = 'on';
            }

            for (keys %{ $attr->{cards} }) {
                if ($attr->{selected_card_head} eq $_) {
                    $attr->{card_name} = $attr->{cards}->{ $attr->{selected_card_head} };
                    my $cardname = "$attr->{lesson}/$attr->{selected_card_head}_$attr->{card_name}";

                    if (-d $cardname) {
                        $attr->{lesson} = $cardname;
                        card($attr, $data);
                    }

                    my @current_dir = glob "$attr->{lesson}/*";
                    $_ =~ s/\.txt$// for (@current_dir);
                    my @exist = grep {$_ eq $cardname} @current_dir;
                    card($attr, $data) if (scalar(@exist) == 0);

                    ($data->{dict}, $attr->{fmt}, $attr->{card_name}) = Generator::convert(
                        $attr->{fmt}, $attr->{selected_card_head},
                        $attr->{lesson},  $attr->{card_name}
                    );

                    $attr->{fail_sw} = 'off' if ($attr->{fail_sw} eq 'on');
                    $attr->{order} = Util::order_swap($attr->{order})
                        if ($attr->{order} eq 'order');
                    $data->{words} = Util::order($attr, $data)
                        if ($attr->{order} eq 'order');
                    say '';
                    Res->set($attr, $data);
                    Exit::record($attr, $data) if ($attr->{quit} eq 'qq');
                }
            }
        }
        card($attr, $data);
    }
}

1;
