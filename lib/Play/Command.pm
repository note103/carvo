package Command {
    use strict;
    use warnings;
    use feature 'say';

    use FindBin;
    use lib "$FindBin::Bin/../../lib";

    use Set::Peco;
    use Play::Responder;
    use Play::Util;
    use Close::Logger;
    use Close::Closer;

    our %msg = (
        limit     => "You can choose a number from 1-",
        random    => "This is random select.",
        correct   => "Please input a correct one.",
        voice   => "You cannot turn on voice mode on this lesson.",
        exceed   => "You exceeded the maximum. Return to the beggining.\n",
    );

    sub set {
        my ($attr, $data) = @_;

        $attr->{limit} = @{$data->{words}};
        say "Welcome to the \"" . $attr->{choose} . "\"";

        my $clean = $attr->{choose};
        $clean = Util::cleanup($clean);

        print `say -v $attr->{voice} $clean` if $attr->{voice_flag} == 1;
        say "$msg{limit}".$attr->{limit}."\n";

        my @command = qw(
            play
            again
            card
            exit
            list
            fail
            voice
            help
        );

        if ($attr->{voice_visible} == 0) {
            @command = grep {$_ ne 'voice'} @command;
        }
        $attr->{command} = join "\n", @command;

        return $attr;
    }

    sub distribute {
        my $attr = shift;
        my $data = shift;

        while (1) {
            my $command_print = $attr->{command};
            my $selected_command = `echo "$command_print" | cho | tr -d "\n"`;

            if ($selected_command =~ /\A(card|exit)/) {
                $attr->{quit} = $1;
                $attr->{total}      = $attr->{point} + $attr->{miss};
                $attr->{num_buffer} = 0;

                $data = Logger::store($data);
                Closer::record($attr, $data) if ($attr->{quit} eq 'exit');

                return ($attr, $data);
            }
            elsif ($selected_command eq 'list') {
                my $list = Util::list($data, $attr);
                my $list_print = join "", @$list;

                my $list_choice = Peco::peco($list_print);

                if ($list_choice =~ /\A(\d+):/) {
                    $attr->{num}        = $1;
                    $attr->{num_buffer} = $attr->{num};

                    if ($attr->{num} > $attr->{limit}) {
                        say "\nToo big! $msg{limit}" . $attr->{limit} . "\n$msg{random}\n";
                        ($attr) = Util::random_jump($attr);
                        Responder::respond('q', $attr, $data);
                    }
                    else {
                        Responder::respond('q', $attr, $data);
                    }
                } else {
                    say "$msg{correct}";
                }
            }
            elsif ($selected_command =~ /\Aplay\z/) {
                if ($attr->{num_buffer} == $attr->{limit}) {
                    unless ($attr->{fail_flag} == 1) {
                        say $msg{exceed};
                    }
                    $attr->{num}        = 1;
                    $attr->{num_buffer} = $attr->{num};
                    Responder::respond('q', $attr, $data);
                }
                else {
                    $attr->{num}        = $attr->{num_buffer} + 1;
                    $attr->{num_buffer} = $attr->{num};
                    Responder::respond('q', $attr, $data);
                }
            }
            elsif ($selected_command eq 'again') {
                $attr->{num} = $attr->{num_buffer};
                Responder::respond('q', $attr, $data);
            }
            elsif ($selected_command eq 'voice') {
                if ($attr->{voice_visible} == 0) {
                    say $msg{voice};
                } else {
                    $attr = Util::voice_change($attr);
                }
            }
            elsif ($selected_command eq 'fail') {
                if ($attr->{fail_flag} == 0) {
                    ($attr, $data) = Util::go_to_fail($attr, $data);
                } else {
                    ($attr, $data) = Util::back_to_normal($attr, $data);
                }
                say "$msg{limit}" . $attr->{limit};
            }
            elsif ($selected_command eq 'help') {
                say Carvo::help();
                say "$msg{limit}" . $attr->{limit};
            }
            else {
                say "$msg{correct}";
            }
            say '';
        }
    }
}

1;
