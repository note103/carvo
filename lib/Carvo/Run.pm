package Run {
    use 5.12.0;
    use warnings;
    use utf8;
    use open ':utf8';
    binmode STDOUT, ':utf8';

    my $msg_usual  = 'Enter or input a command or check help(h).';
    my $msg_limit  = "You can choose a number from 1-";
    my $msg_random = "This is random select.";
    my $msg_move_card
        = "If you need to restart that, push 'q' and move there.";
    my $msg_correct = "Please input a correct one.";

    sub run {
        my $class = shift;

        my ($attr, $data) = @_;

        $data->{words} = Util::order($attr, $data);
        $attr->{limit} = @{ $data->{words} };

        print "Welcome to the \"" . $attr->{card_name} . "\"\n";
        my $clean = $attr->{card_name};
        $clean = Util::clean($clean);

        print `$attr->{voice} $clean` if $attr->{voice_ch} eq 'on';
        print "$msg_limit" . $attr->{limit} . "\n$msg_usual\n";

        while (my $selected_command = <>) {
            $selected_command = $1 if ($selected_command =~ /^--(.+)$/);

            if ($selected_command =~ /^(q{1,3}|quit)$/) {
                our $quit     = $1;
                $attr->{total}    = $attr->{point} + $attr->{miss};
                $attr->{num_buffer} = 0;
                if ($quit eq 'qqq') {
                    $data = Util::logs($data);
                    Exit::record($attr, $data);
                }
                last;
            }
            elsif ($selected_command =~ /^(\d+)$/) {
                $attr->{num}      = $1;
                $attr->{num_buffer} = $attr->{num};
                if ($selected_command > $attr->{limit}) {
                    print "\nToo big! $msg_limit" . $attr->{limit}
                        . "\n$msg_random\n\n";
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
                    print
                        "You exceeded the maximum. Return to the beggining.\n\n";
                    $attr->{num}      = 1;
                    $attr->{num_buffer} = $attr->{num};
                    $class->repl('q', $attr, $data);
                    ($attr, $data) = $class->proc($attr, $data);
                }
                else {
                    $attr->{num}      = $attr->{num_buffer} + 1;
                    $attr->{num_buffer} = $attr->{num};
                    $class->repl('q', $attr, $data);
                    ($attr, $data) = $class->proc($attr, $data);
                }
            }
            elsif ($selected_command =~ /^x(\d+)$/) {
                $attr->{extr} = $1;
                print "You changed the figure extracted character $attr->{extr}.\n";
                print "$msg_usual\n";
            }
            elsif ($selected_command =~ /^(h|help)$/) {
                say Util::help();
                print "\n$msg_limit" . $attr->{limit} . "\n";
                print "$msg_usual\n";
            }
            elsif ($selected_command =~ /^(l|list)$/) {
                Util::list($data, $attr);
                print "\n$msg_limit" . $attr->{limit} . "\n$msg_usual\n";
            }
            elsif ($selected_command =~ /^(s|same)$/) {
                $attr->{num} = $attr->{num_buffer};
                $class->repl('q', $attr, $data);
                ($attr, $data) = $class->proc($attr, $data);
            }
            elsif ($selected_command =~ /^(os|order-swap)$/) {
                $attr->{order} = Util::order_swap($attr->{order});
                $data->{words} = Util::order($attr, $data);
                print "\n$msg_usual\n";
            }
            elsif ($selected_command =~ /^(vc|voice-ch)$/) {
                $attr->{voice_ch} = Util::voice_ch($attr->{voice_ch});
                print "\n$msg_usual\n";
            }
            elsif ($selected_command =~ /^(vs|voice-swap)$/) {
                $attr->{voice_swap} = Util::voice_swap($attr->{voice_swap});
                print "\n$msg_usual\n";
            }
            elsif ($selected_command =~ /^(sv|save|ro|read-only|rv|revert)$/)
            {
                if ($selected_command =~ /^(sv|save)$/) {
                    Save::save($attr, $data);
                    print "$attr->{num}/$attr->{limit}\n";
                }
                elsif ($selected_command =~ /^(ro|read-only)$/) {
                    my $save = Save::ro();
                    for (@{ $save->{saved_info} }) { say $_; }
                }
                elsif ($selected_command =~ /^(rv|revert)$/) {
                    my $save = Save::ro();
                    for (@{ $save->{saved_info} }) { say $_; }

                    my $resp;
                    say "\nInput a saved date-time.\n";

                    chomp($attr->{selected_revert} = <STDIN>);

                    ($attr, $data, $resp) = Save::rv($attr, $data);

                    if ($resp eq 'on') {
                        say
                            "You back to \"$attr->{card_name}\". ($attr->{num}/$attr->{limit})\n";
                        $attr->{num_buffer} = $attr->{num};
                        $class->repl('q', $attr, $data);
                        ($attr, $data) = $class->proc($attr, $data);
                    }
                }
                print "\n$msg_usual\n";
            }
            elsif ($selected_command =~ /^(f|fail)$/) {
                ($attr, $data) = Util::fail($attr, $data);
                print "\n$msg_limit" . $attr->{limit} . "\n$msg_usual\n";
            }
            elsif ($selected_command =~ /^(b|back)$/) {
                ($attr, $data) = Util::back($attr, $data);
                print "\n$msg_limit" . $attr->{limit} . "\n$msg_usual\n";
            }
            else {
                print "\n$msg_correct\n";
            }
        }
    }
}

1;
__END__
                #elsif ($quit eq 'qq') {
                #    Carvo::course($attr, $data);
                #}
                #elsif ($quit eq 'q' or 'quit') {
                #    Carvo::card($attr, $data);
                #}

