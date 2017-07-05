package Command {
    use strict;
    use warnings;
    use feature 'say';

    our %msg = (
        limit     => "You can choose a number from 1-",
        random    => "This is random select.",
        correct   => "Please input a correct one.",
        voice   => "You cannot turn on voice mode on this lesson.",
        exceed   => "You exceeded the maximum. Return to the beggining.\n",
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

        my @command = qw/
            play
            again
            change-card
            exit
            list
            fail
            voice
            help
        /;

        if ($attr->{voice_able} == 0) {
            @command = grep {$_ ne 'voice'} @command;
        }
        $attr->{command} = join "\n", @command;

        return $attr;
    }

    sub option {
        my $attr = shift;

        $attr->{selected_command} = "\n"    if $attr->{get} eq 'play';
        $attr->{selected_command} = "again" if $attr->{get} eq 'again';
        $attr->{selected_command} = "change"     if $attr->{get} eq 'change-card';
        $attr->{selected_command} = "exit"   if $attr->{get} eq 'exit';
        $attr->{selected_command} = "list"   if $attr->{get} eq 'list';
        $attr->{selected_command} = "fail"  if $attr->{get} eq 'fail';
        $attr->{selected_command} = "voice" if $attr->{get} eq 'voice';
        $attr->{selected_command} = "help"  if $attr->{get} eq 'help';

        return $attr;
    }

    sub run {
        my ($attr, $data) = @_;
        my $selected_command = $attr->{selected_command};

        $selected_command = $1 if ($selected_command =~ /\A--(.+)\z/);

        if ($selected_command =~ /\A(change|exit)\z/) {
            $attr->{quit} = $1;
            $attr->{total}      = $attr->{point} + $attr->{miss};
            $attr->{num_buffer} = 0;

            $data = Util::logs($data);
            Exit::record($attr, $data) if ($attr->{quit} eq 'exit');
            return;
        }
        elsif ($selected_command =~ /\A(\d+)\z/) {
            $attr->{num}        = $1;
            $attr->{num_buffer} = $attr->{num};
            if ($selected_command > $attr->{limit}) {
                say "\nToo big! $msg{limit}" . $attr->{limit} . "\n$msg{random}\n";
                ($attr) = Util::jump($attr);
                Responder::mark('q', $attr, $data);
            }
            else {
                Responder::mark('q', $attr, $data);
            }
        }
        elsif ($selected_command eq 'list') {
            my $list_out = Util::list($data, $attr);
            my $l = join "", @$list_out;
            my $num = `echo "$l" | peco | tr -d "\n"`;
            if ($num =~ /\A(\d+):/) {
                $attr->{selected_command} = $1;
                run($attr, $data);
                return;
            } else {
                say "$msg{correct}";
            }
        }
        elsif ($selected_command =~ /\A(\n|[^\W\D]+)\z/) {
            if ($attr->{num_buffer} == $attr->{limit}) {
                unless ($attr->{fail_sw} eq 'on') {
                    say $msg{exceed};
                }
                $attr->{num}        = 1;
                $attr->{num_buffer} = $attr->{num};
                Responder::mark('q', $attr, $data);
            }
            else {
                $attr->{num}        = $attr->{num_buffer} + 1;
                $attr->{num_buffer} = $attr->{num};
                Responder::mark('q', $attr, $data);
            }
        }
        elsif ($selected_command eq 'again') {
            $attr->{num} = $attr->{num_buffer};
            Responder::mark('q', $attr, $data);
        }
        elsif ($selected_command eq 'voice') {
            if ($attr->{voice_able} == 0) {
                say $msg{voice};
            } else {
                $attr = Util::sound($attr);
            }
        }
        elsif ($selected_command eq 'fail') {
            if ($attr->{fail_sw} eq 'off') {
                ($attr, $data) = Util::fail($attr, $data);
            } else {
                ($attr, $data) = Util::back($attr, $data);
            }
            say "$msg{limit}" . $attr->{limit};
        }
        elsif ($selected_command eq 'help') {
            say Util::help();
            say "$msg{limit}" . $attr->{limit};
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
