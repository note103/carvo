package Responder {
    use strict;
    use warnings;
    use feature 'say';
    use List::Util 'shuffle';
    use List::MoreUtils 'uniq';

    my $attr;
    my $data;
    my $key;
    my $clean;
    my $in_ans;
    my $correct_component_buff;
    my $giveup = '[Give up!]';

    sub set {
        ($attr, $data) = @_;
        $attr->{ng} = 0;
        Command::set($attr, $data);
    }

    sub respond {
        ($attr, $data) = @_;

        if ($in_ans eq $attr->{ans}) {
            $attr->{log_record} = 'on';
            $attr->{point}++;
            $attr->{total} = $attr->{point} + $attr->{miss};
            print "\nGood!!\n";
            $attr->{ng} = 0;

            if ($attr->{sound_able} == 1) {
                if (( $attr->{point} % 10 ) == 0) {
                    print `afplay $attr->{sound_dir}/ok10.mp3`;
                } elsif (( $attr->{point} % 25 ) == 0) {
                    print `afplay $attr->{sound_dir}/ok25.mp3`;
                }
            }

            $data->{log} = Responder::mark('a', $attr, $data);
            print $data->{result} = Util::result($attr, $data);
        }
        elsif ($in_ans eq $giveup) {
            Responder::mark('a', $attr, $data);
            print $data->{result} = Util::result($attr, $data);
        }
        else {
            $attr->{log_record} = 'off';
            $attr->{miss}++;
            $attr->{total} = $attr->{point} + $attr->{miss};

            push @{ $data->{log} }, "*$key: $data->{dict}->{$key}\n";
            push @{ $data->{fail} }, $key . "\n";

            say "\nNG! Again!\n";
            $attr->{ng} = 1;

            if ($attr->{sound_able} == 1) {
                print `afplay $attr->{sound_dir}/ng.mp3`;
            }
            Responder::mark('q', $attr, $data);
        }
        return ($attr, $data);
    }

    sub mark {
        my ($qa_switch, $attr, $data) = @_;

        $key = $data->{words}->[$attr->{num} - 1];
        $key =~ s/(.+)(\n)*$/$1/;

        my $ans = $key;

        if ($qa_switch eq 'q') {
            my $limit = scalar(@{$data->{words}});
            my @select = (1..$limit);

            my $options;

            my $correct = $data->{dict}->{$key};
            $attr->{ans} = $correct;

            my %optmaker;
            $optmaker{$correct} = 1;

            my $opt_count = 5;
            $opt_count = scalar @select if (scalar @select < 5);

            my $rand;
            my $option;
            while (scalar(keys %optmaker) < $opt_count) {
                $rand = shuffle (@select);

                $option = $data->{dict}->{$data->{words}->[$attr->{num} - $rand]};
                next if $option eq '';

                $optmaker{$option} = 1;
            }

            my @options = keys %optmaker;
            @options = shuffle @options;

            push @options, $giveup;
            @options = map {$_ = "- $_"} @options;
            $options = join "\n", @options;

            say $ans;

            $in_ans = `echo "$options" | cho | tr -d "\n"`;
            use Encode;
            $in_ans =~ s/\A- //;
            $in_ans = decode('utf8', $in_ans);
            say $in_ans;

            Responder::respond($attr, $data);
        }
        elsif ($qa_switch eq 'a') {

            print $ans = "$key($attr->{num}): $data->{dict}->{$key}\n";
            push @{ $data->{log} }, $ans if ($attr->{log_record} eq 'on');

            $clean = Util::clean($key);
            print `$attr->{voice} $clean` if $attr->{voice_ch} eq 'on';
        }
        return $data->{log};
    }
}


1;
