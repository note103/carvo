package Exit {
    use strict;
    use warnings;
    use feature 'say';

    use open ':utf8';
    use Carp 'croak';
    use Time::Piece;
    use File::Slurp;

    sub record {
        my ($attr, $data) = @_;

        my $result = "$attr->{total}\ttimes\n$attr->{point}\thits\n$attr->{miss}\terrors\n";

        my $log_record = logs($data, $result);
        my $result_record = result($attr);

        say "\nRecord:";
        print @$log_record;

        say "\nScore:";
        print $result;
        print `$attr->{voice} Bye!` if $attr->{voice_ch} eq 'on';

        exit;
    }

    my $data_dir = 'docs/log';

    sub logs {
        my ($data, $result) = @_;
        my @log_cleanup;

        for (@{ $data->{log} }) {
            if ($_ =~ /(.+)\(\d+\)(.+)/) {
                push @log_cleanup, "$1$2\n";
            }
            elsif ($_ =~ s/\d+\. //) {
                push @log_cleanup, $_;
            }
            else {
                push @log_cleanup, $_;
            }
        }
        my %unique = map { $_ => 1 } @log_cleanup;
        my @log_record = sort keys %unique;

        my @log_buffer;
        my $log_file = $data_dir . '/log.txt';

        open my $fh_in, '<', $log_file or croak("Can't open file.");
        for (<$fh_in>) {
            push @log_buffer, $_;
        }
        close $fh_in;

        open my $fh_out, '>', $log_file or croak("Can't open file.");
        say $fh_out localtime->datetime(T => ' ');
        print $fh_out $result;
        say $fh_out '---';
        say $fh_out @log_record;
        say $fh_out @log_buffer;
        close $fh_out;

        return \@log_record;
    }

    sub result {
        my $attr = shift;

        my $t = $attr->{total};
        my $h = $attr->{point};
        my $e = $attr->{miss};

        my $result_file = $data_dir . '/result.txt';

        my $read_past_result = read_file($result_file);
        my @result_buffer = split /\n/, $read_past_result;

        my $today= localtime->date;
        my $fday = qr/\d{4}-\d{2}-\d{2}/;
        my $day = '';

        push @result_buffer, "$today\ttimes: 00\thits: 00\terrors: 00" unless (@result_buffer);

        for my $merge (@result_buffer) {
            if ($merge =~ /^($fday)\ttimes: (\d+)\thits: (\d+)\terrors: (\d+)$/) {
                $day = $1;
                if ($day eq $today) {
                    $t += $2; $h += $3; $e += $4;
                    $t =~ s/^(\d)$/0$1/; $h =~ s/^(\d)$/0$1/; $e =~ s/^(\d)$/0$1/;
                    $merge = "$day\ttimes: $t\thits: $h\terrors: $e";
                    last;
                } else {
                    $t =~ s/^(\d)$/0$1/; $h =~ s/^(\d)$/0$1/; $e =~ s/^(\d)$/0$1/;
                    unshift @result_buffer, "$today\ttimes: $t\thits: $h\terrors: $e";
                    last;
                }
            }
        }

        my @result;
        for (@result_buffer) {
            push @result, "$_\n";
        }
        write_file($result_file, @result);
    }
}

1;
