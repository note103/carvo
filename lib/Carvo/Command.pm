package Command {
    use strict;
    use warnings;
    use feature 'say';

    use utf8;
    use open ':utf8';
    binmode STDOUT, ':utf8';

    my %msg = (
        usual     => 'Enter or input a command or check help(h).',
        limit     => "You can choose a number from 1-",
        random    => "This is random select.",
        move_card => "If you need to restart that, push 'q' and move there.",
        correct   => "Please input a correct one.",
    );

    sub run {
        my $class = shift;

        my ($attr, $data) = @_;

        $data->{words} = Util::order($attr, $data);
        $attr->{limit} = @{ $data->{words} };

        print "Welcome to the \"" . $attr->{card_name} . "\"\n";
        my $clean = $attr->{card_name};
        $clean = Util::clean($clean);

        print `$attr->{voice} $clean` if $attr->{voice_ch} eq 'on';
        print "$msg{limit}" . $attr->{limit} . "\n$msg{usual}\n";

        while (my $selected_command = <>) {
            $selected_command = $1 if ($selected_command =~ /^--(.+)$/);

            if ($selected_command =~ /^(q{1,2}|quit)$/) {
                our $quit = $1;
                $attr->{total}      = $attr->{point} + $attr->{miss};
                $attr->{num_buffer} = 0;
                if ($quit eq 'qq') {
                    $data = Util::logs($data);
                    Exit::record($attr, $data);
                }
                last;
            }
            elsif ($selected_command =~ /^(\d+)$/) {
                $attr->{num}        = $1;
                $attr->{num_buffer} = $attr->{num};
                if ($selected_command > $attr->{limit}) {
                    print "\nToo big! $msg{limit}" . $attr->{limit} . "\n$msg{random}\n\n";
                    ($attr) = Util::jump($attr);
                    $class->repl('q', $attr, $data);
                    ($attr, $data) = $class->proc($attr, $data);
                }
                else {
                    $class->repl('q', $attr, $data);
                    ($attr, $data) = $class->proc($attr, $data);
                }
            }
            elsif ($selected_command =~ /^(\n|[^\W\D]+)$/) {
                if ($attr->{num_buffer} == $attr->{limit}) {
                    print "You exceeded the maximum. Return to the beggining.\n\n";
                    $attr->{num}        = 1;
                    $attr->{num_buffer} = $attr->{num};
                    $class->repl('q', $attr, $data);
                    ($attr, $data) = $class->proc($attr, $data);
                }
                else {
                    $attr->{num}        = $attr->{num_buffer} + 1;
                    $attr->{num_buffer} = $attr->{num};
                    $class->repl('q', $attr, $data);
                    ($attr, $data) = $class->proc($attr, $data);
                }
            }
            elsif ($selected_command =~ /^(l|list)$/) {
                Util::list($data, $attr);
                print "\n$msg{limit}" . $attr->{limit} . "\n$msg{usual}\n";
            }
            elsif ($selected_command =~ /^(s|same)$/) {
                $attr->{num} = $attr->{num_buffer};
                $class->repl('q', $attr, $data);
                ($attr, $data) = $class->proc($attr, $data);
            }
            elsif ($selected_command =~ /^(v|voice-change)$/) {
                $attr->{voice_ch} = Util::voice_ch($attr->{voice_ch});
                print "\n$msg{usual}\n";
            }
            elsif ($selected_command =~ /^(sv|save|ro|read-only|rs|restore)$/) {
                if ($selected_command =~ /^(sv|save)$/) {
                    Restorer::save($attr, $data);
                    print "$attr->{num}/$attr->{limit}\n";
                }
                elsif ($selected_command =~ /^(ro|read-only)$/) {
                    my $save = Restorer::ro();
                    for (@{ $save->{saved_info} }) { say $_; }
                    print "\n$msg{limit}" . $attr->{limit} . "\n$msg{usual}\n";
                }
                elsif ($selected_command =~ /^(rs|restore)$/) {
                    my $save = Restorer::ro();
                    for (@{ $save->{saved_info} }) { say $_; }

                    my $resp;
                    say "\nInput a saved date-time.\n";

                    chomp($attr->{selected_restore} = <STDIN>);

                    ($attr, $data, $resp) = Restorer::rs($attr, $data);

                    if ($resp eq 'on') {
                        say "You back to \"$attr->{card_name}\". ($attr->{num}/$attr->{limit})\n";
                        $attr->{num_buffer} = $attr->{num};
                        $class->repl('q', $attr, $data);
                        ($attr, $data) = $class->proc($attr, $data);
                    } elsif ($resp eq 'off') {
                        print "\n$msg{limit}" . $attr->{limit} . "\n$msg{usual}\n";
                    }
                }
            }
            elsif ($selected_command =~ /^(f|fail)$/) {
                ($attr, $data) = Util::fail($attr, $data);
                print "\n$msg{limit}" . $attr->{limit} . "\n$msg{usual}\n";
            }
            elsif ($selected_command =~ /^(b|back)$/) {
                ($attr, $data) = Util::back($attr, $data);
                print "\n$msg{limit}" . $attr->{limit} . "\n$msg{usual}\n";
            }
            elsif ($selected_command =~ /^(h|help)$/) {
                say Util::help();
                print "\n$msg{limit}" . $attr->{limit} . "\n";
                print "$msg{usual}\n";
            }
            else {
                print "\n$msg{correct}\n";
            }
        }
    }
}

1;
