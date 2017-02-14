package Command {
    use strict;
    use warnings;
    use feature 'say';

    my %msg = (
        limit     => "You can choose a number from 1-",
        random    => "This is random select.",
        move_card => "If you need to restart that, push 'q' and move there.",
        correct   => "Please input a correct one.",
    );

    sub set {
        my ($attr, $data) = @_;

        $attr->{limit} = keys %{ $data->{dict} };

        say "Welcome to the \"" . $attr->{card_name} . "\"";

        my $clean = $attr->{card_name};
        $clean = Util::clean($clean);

        print `$attr->{voice} $clean` if $attr->{voice_ch} eq 'on';
        say "$msg{limit}" . $attr->{limit};

        say '';

        $attr = command($attr);

        my $start = $attr->{command};
        $attr->{get} = `echo "$start" | cho | tr -d "\n"`;

        $attr = option($attr);

        run($attr, $data);
    }

    sub command {
        my $attr = shift;

        my @command = qw/play again quit-this-card exit-carvo question-list voice-mode cave-mode fail-mode read-write-mode set-word-count help/;

        if ($attr->{cave_able} == 0) {
            @command = grep {$_ ne 'cave-mode'} @command;
        }
        if ($attr->{voice_able} eq 'off') {
            @command = grep {$_ ne 'voice-mode'} @command;
        }
        if ($attr->{write_able} == 0) {
            @command = grep {$_ ne 'read-write-mode'} @command;
            @command = grep {$_ ne 'set-word-count'} @command;
        }
        if ($attr->{rw} eq 'r') {
            @command = grep {$_ ne 'set-word-count'} @command;
        }
        else {
            @command = grep {$_ ne 'cave-mode'} @command;
            @command = grep {$_ ne 'voice-mode'} @command;
        }
        if ($attr->{lesson} =~ /bookkeeping/) {
            @command = grep {$_ ne 'fail-mode'} @command;
            @command = grep {$_ ne 'voice-mode'} @command;
        }

        $attr->{command} = join "\n", @command;

        return $attr;
    }

    sub option {
        my $attr = shift;

        $attr->{selected_command} = "\n" if $attr->{get} eq 'play';
        $attr->{selected_command} = "again" if $attr->{get} eq 'again';
        $attr->{selected_command} = "q" if $attr->{get} eq 'quit-this-card';
        $attr->{selected_command} = "qqq" if $attr->{get} eq 'exit-carvo';
        $attr->{selected_command} = "num" if $attr->{get} eq 'question-list';
        $attr->{selected_command} = "voice" if $attr->{get} eq 'voice-mode';
        $attr->{selected_command} = "cave" if $attr->{get} eq 'cave-mode';
        $attr->{selected_command} = "fail" if $attr->{get} eq 'fail-mode';
        $attr->{selected_command} = "rw" if $attr->{get} eq 'read-write-mode';
        $attr->{selected_command} = "help" if $attr->{get} eq 'help';

        if ($attr->{get} eq 'set-word-count') {
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
                say 'You are in read mode now.';
                $attr->{selected_command} = ":";
            }
        }
        return $attr;
    }

    sub run {
        my ($attr, $data) = @_;
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
                Responder::judge('q', $attr, $data);
            }
            else {
                Responder::judge('q', $attr, $data);
            }
        }
        elsif ($selected_command eq 'num') {
            my $list_out = Util::list($data, $attr);
            my $l = join "", @$list_out;
            my $num = `echo "$l" | peco | tr -d "\n"`;
            if ($num =~ /\A(\d+):/) {
                $attr->{selected_command} = $1;
                run($attr, $data);
                last;
            } else {
                say "$msg{correct}";
            }
        }
        elsif ($selected_command =~ /^(\n|[^\W\D]+)$/) {
            if ($attr->{num_buffer} == $attr->{limit}) {
                unless ($attr->{fail_sw} eq 'on') {
                    say "You exceeded the maximum. Return to the beggining.\n";
                }
                $attr->{num}        = 1;
                $attr->{num_buffer} = $attr->{num};
                Responder::judge('q', $attr, $data);
            }
            else {
                $attr->{num}        = $attr->{num_buffer} + 1;
                $attr->{num_buffer} = $attr->{num};
                Responder::judge('q', $attr, $data);
            }
        }
        elsif ($selected_command =~ /^(again)$/) {
            $attr->{num} = $attr->{num_buffer};
            Responder::judge('q', $attr, $data);
        }
        elsif ($selected_command =~ /^(voice)$/) {
            if ($attr->{voice_able} == 0) {
                say 'You cannot turn on voice mode on this lesson.';
            } else {
                $attr = Util::sound($attr);
            }
        }
        elsif ($selected_command =~ /^(fail)$/) {
            if ($attr->{fail_sw} eq 'off') {
                ($attr, $data) = Util::fail($attr, $data);
            } else {
                ($attr, $data) = Util::back($attr, $data);
            }
            say "$msg{limit}" . $attr->{limit};
        }
        elsif ($selected_command =~ /^(help)$/) {
            say Util::help();
            say "$msg{limit}" . $attr->{limit};
        }
        elsif ($selected_command =~ /^x(\d+)$/) {
            $attr->{extr} = $1;
            say "You changed the figure extracted character $attr->{extr}.";
        }
        elsif ($selected_command =~ /^rw$/) {
            if ($attr->{write_able} == 0) {
                $attr->{rw} = 'r';
                say 'You cannot turn on write mode on this lesson.';
            } else {
                if ($attr->{rw} eq 'r') {
                    $attr->{rw} = 'w';
                    say "You've turned on write mode.";
                } else {
                    $attr->{rw} = 'r';
                    say "You've turned on read mode.";
                }
            }
        }
        elsif ($selected_command =~ /^:$/) {
            say "$msg{correct}";
        }
        elsif ($selected_command =~ /^cave$/) {
            if ( $attr->{cave_able} == 1) {
                if ($attr->{cave} eq 'off' ) {
                    $attr->{cave} = 'on';
                    say "You've turned on cave mode.";
                }
                else {
                    $attr->{cave} = 'off';
                    say "You've turned off cave mode.";
                }
            }
            else {
                say "You cannot turn on cave mode on this lesson.";
            }

        }
        else {
            say "$msg{correct}";
        }
        say '';

        $attr = command($attr);

        my $start = $attr->{command};
        $attr->{get} = `echo "$start" | cho | tr -d "\n"`;

        $attr = option($attr);

        run($attr, $data);
    }
}

1;
