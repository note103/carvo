package Exit {
    use 5.12.0;
    use warnings;
    use Time::Piece;
    use Carp 'croak';
    use open ':utf8';

    my $result;

    sub record {
        my ($attr, $data) = @_;

        $result
            = "$attr->{total}\ttimes\n$attr->{point}\thits\n$attr->{miss}\terrors\n";

        my $log_record = logs($data, $result);

        say "\nRecord:";
        print @$log_record;

        say "\nScore:";
        print $result;
        #print `$attr->{voice} Bye!`;

        exit;
    }

    my $data_dir = 'src/log';

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
        my $log_filepath = $data_dir . '/log.txt';

        open my $fh_in, '<', $log_filepath or croak("Can't open file.");
        for (<$fh_in>) {
            push @log_buffer, $_;
        }
        close $fh_in;

        open my $fh_out, '>', $log_filepath or croak("Can't open file.");
        say $fh_out localtime->datetime(T => ' ');
        print $fh_out $result;
        say $fh_out '---';
        say $fh_out @log_record;
        say $fh_out @log_buffer;
        close $fh_out;

        return \@log_record;
    }

    sub result {
        $result = shift;
        my @result_buffer;
        my $result_filepath = $data_dir . '/result.txt';

        open my $fh_in, '<', $result_filepath or croak("Can't open file.");
        for (<$fh_in>) {
            push @result_buffer, $_;
        }
        close $fh_in;

        open my $fh_out, '>', $result_filepath or croak("Can't open file.");
        say $fh_out localtime->datetime(T => ' ');
        say $fh_out $result;
        say $fh_out @result_buffer;
        say '';
        close $fh_out;
    }
}

1;
