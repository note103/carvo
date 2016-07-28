package Command {
    use strict;
    use warnings;
    use feature 'say';

    use utf8;
    use open ':utf8';
    binmode STDOUT, ':utf8';

    my %msg = (
        limit     => "You can choose a number from 1-",
        random    => "This is random select.",
        move_card => "If you need to restart that, push 'q' and move there.",
        correct   => "Please input a correct one.",
    );

    my @command_r = qw/play again voice quit exit num mode fail save restore remove help >>/;
    my @command_w = qw/play again voice quit exit num mode fail save restore remove x help >>/;

    sub se {
        my ($attr, $data) = @_;

        $attr->{selected_command} = "\n" if $attr->{get} eq 'play';
        $attr->{selected_command} = "s" if $attr->{get} eq 'again';
        $attr->{selected_command} = "q" if $attr->{get} eq 'quit';
        $attr->{selected_command} = "qq" if $attr->{get} eq 'back';
        $attr->{selected_command} = "qqq" if $attr->{get} eq 'exit';
        $attr->{selected_command} = "v" if $attr->{get} eq 'voice';
        $attr->{selected_command} = "l" if $attr->{get} eq 'list';
        $attr->{selected_command} = "f" if $attr->{get} eq 'fail';
        $attr->{selected_command} = "sv" if $attr->{get} eq 'save';
        $attr->{selected_command} = "rs" if $attr->{get} eq 'restore';
        $attr->{selected_command} = "rm" if $attr->{get} eq 'remove';
        $attr->{selected_command} = "rw" if $attr->{get} eq 'mode';
        $attr->{selected_command} = "h" if $attr->{get} eq 'help';

        if ($attr->{get} eq 'x') {
            if ($attr->{rw} eq 'w') {
                print ">> ";
                while (my $x = <>) {
                    if ($x =~ /\A\d+/) {
                        $attr->{selected_command} = "x$x";
                        last;
                    } elsif ($x =~ /q|exit/) {
                        last;
                    } else {
                        say $msg{correct};
                    }
                }
            } else {
                say 'You are in r mode now.';
                $attr->{selected_command} = ":";
            }
        } elsif ($attr->{get} =~ '>>') {
            print ">> ";
            while (my $type = <>) {
                $attr->{selected_command} = "$type";
                last;
            }
        } elsif ($attr->{get} =~ 'num') {
            my $list_out = Util::list($data, $attr);
            my $l = join "", @$list_out;
            my $num = `echo "$l" | peco | tr -d "\n"`;
            if ($num =~ /\A(\d+):/) {
                $attr->{selected_command} = $1;
                $attr->{selected_command} =~ s/\A0//;
            } else {
                $attr->{selected_command} = ':';
            }
        }
        return $attr;
    }
    sub run {
        my $class = shift;

        my ($attr, $data) = @_;

        $data->{words} = Util::order($attr, $data);
        $attr->{limit} = @{ $data->{words} };

        say "Welcome to the \"" . $attr->{card_name} . "\"";
        my $clean = $attr->{card_name};
        $clean = Util::clean($clean);

        print `$attr->{voice} $clean` if $attr->{voice_ch} eq 'on';
        say "$msg{limit}" . $attr->{limit};

        say '';
        my $start;
        if ($attr->{rw} eq 'w') {
            $start = join "\n", @command_w;
        } else {
            $start = join "\n", @command_r;
        }

        $attr->{get} = `echo "$start" | cho | tr -d "\n"`;
        $attr = se($attr, $data);
        $attr->{class} = $class;
        res($attr, $data);
    }
    sub res {
        my ($attr, $data) = @_;
        my $class = $attr->{class};
        my $selected_command = $attr->{selected_command};

        $selected_command = $1 if ($selected_command =~ /^--(.+)$/);

        if ($selected_command =~ /^(q{1,3}|quit)$/) {
            $attr->{quit} = $1;
            $attr->{total}      = $attr->{point} + $attr->{miss};
            $attr->{num_buffer} = 0;

            $data = Util::logs($data);
            if ($attr->{lesson} ne $attr->{lesson_root}) {
                if ($attr->{quit} eq 'qqq') {
                    Exit::record($attr, $data);
                }
                elsif ($attr->{quit} eq 'qq') {
                    $attr->{lesson} = $attr->{lesson_root};
                    Carvo::card($attr, $data);
                }
            } else {
                if ($attr->{quit} =~ /qq+/) {
                    Exit::record($attr, $data);
                }
            }
            return;
        }
        elsif ($selected_command =~ /^(\d+)$/) {
            $attr->{num}        = $1;
            $attr->{num_buffer} = $attr->{num};
            if ($selected_command > $attr->{limit}) {
                say "\nToo big! $msg{limit}" . $attr->{limit} . "\n$msg{random}\n";
                ($attr) = Util::jump($attr);
                $class->repl('q', $attr, $data);
            }
            else {
                $class->repl('q', $attr, $data);
            }
        }
        elsif ($selected_command =~ /^(\n|[^\W\D]+)$/) {
            if ($attr->{num_buffer} == $attr->{limit}) {
                print "You exceeded the maximum. Return to the beggining.\n\n";
                $attr->{num}        = 1;
                $attr->{num_buffer} = $attr->{num};
                $class->repl('q', $attr, $data);
            }
            else {
                $attr->{num}        = $attr->{num_buffer} + 1;
                $attr->{num_buffer} = $attr->{num};
                $class->repl('q', $attr, $data);
            }
        }
        elsif ($selected_command =~ /^(l|list)$/) {
            my $list_out = Util::list($data, $attr);
            print for @$list_out;
            say "$msg{limit}" . $attr->{limit};
        }
        elsif ($selected_command =~ /^(s|same)$/) {
            $attr->{num} = $attr->{num_buffer};
            $class->repl('q', $attr, $data);
        }
        elsif ($selected_command =~ /^(v|voice-change)$/) {
            if ($attr->{bookkeeping} eq 'on') {
                say 'Cannot turn to voice mode. Because you are in bookkeeping area.';
            } else {
                $attr->{voice_ch} = Util::voice_ch($attr->{voice_ch});
            }
        }
        elsif ($selected_command =~ /^(sv|save|rs|restore|rm|remove)$/) {
            my $save = Restorer::read_only();
            if ($selected_command =~ /^(sv|save)$/) {
                Restorer::save($attr, $data);
                say "$attr->{num}/$attr->{limit}\n";
                say "$msg{limit}" . $attr->{limit};
            }
            elsif ($selected_command =~ /^(rs|restore|rm|remove)$/) {

                my @saved_list = ( @{ $save->{saved_info}}, '[Cancel]');
                my $saved_list = join "\n", @saved_list;
                $attr->{selected_restore} = `echo "$saved_list" | tail -n 25 | peco | tr -d "\n"`;

                my $resp;
                if ($selected_command =~ /(rs|restore)/) {
                    $attr->{command_restore} = 'restore';
                }
                elsif ($selected_command =~ /(rm|remove)/) {
                    $attr->{command_restore} = 'remove';
                }
                ($attr, $data, $resp) = Restorer::restore_func($attr, $data);

                say "You back to \"$attr->{card_name}\". ($attr->{num}/$attr->{limit})\n" if ($resp eq 'on');
                say "$msg{limit}" . $attr->{limit};
            }
        }
        elsif ($selected_command =~ /^(f|fail)$/) {
            if ($attr->{fail_sw} eq 'off') {
                $attr->{w_bak} = 'on' if ($attr->{rw} eq 'w');
                ($attr, $data) = Util::fail($attr, $data);
                $attr->{rw} = 'w' if ($attr->{limit} < 5);
            } else {
                $attr->{rw} = 'r' if ($attr->{limit} < 5);
                $attr->{rw} = 'w' if ($attr->{w_bak} eq 'on');
                ($attr, $data) = Util::back($attr, $data);
            }
                say "$msg{limit}" . $attr->{limit};
        }
        elsif ($selected_command =~ /^(h|help)$/) {
            say Util::help();
            say "$msg{limit}" . $attr->{limit};
        }
        elsif ($selected_command =~ /^x(\d+)$/) {
            $attr->{extr} = $1;
            print "You changed the figure extracted character $attr->{extr}.\n";
        }
        elsif ($selected_command =~ /^rw$/) {
            if ($attr->{bookkeeping} eq 'on') {
                $attr->{rw} = 'r';
                say 'Cannot turn on w mode. Because you are in bookkeeping area.';
            } else {
                if ($attr->{rw} eq 'r') {
                    $attr->{rw} = 'w';
                } else {
                    $attr->{rw} = 'r';
                }
                print "You've turned on $attr->{rw} mode.\n";
            }
        }
        elsif ($selected_command =~ /^:$/) {
            print "$msg{correct}\n";
        }
        else {
            print "$msg{correct}\n";
        }
        say '';
        my $start;
        if ($attr->{rw} eq 'w') {
            $start = join "\n", @command_w;
        } else {
            $start = join "\n", @command_r;
        }

        $attr->{get} = `echo "$start" | cho | tr -d "\n"`;
        $attr = se($attr, $data);
        res($attr, $data);
    }
}

1;
