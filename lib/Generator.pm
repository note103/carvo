package Generator {
    use strict;
    use warnings;
    use feature 'say';

    use open IO => qw/:utf8 :std/;
    use Carp 'croak';
    use YAML;
    use File::Slurp 'read_file';

    sub convert {
        my ($fmt, $card_dir, $card_name) = @_;
        my ($dict, $card);

        opendir(my $card_iter, $card_dir) or croak("Can't opendir $card_dir.");
        for my $file (readdir $card_iter) {
            if ($file =~ /\.$fmt\z/) {
                $dict = $card_dir . '/' . $file;
            }
            elsif ($file =~ /$card_name\.txt\z/) {
                $card = $card_dir . '/' . $file;
            }
        }
        closedir $card_iter;

        $dict = YAML::LoadFile($dict) if ($fmt eq 'yml');

        my $words = read_file($card);
        my @words = split /\n/, $words;

        my %set_dict;
        for (@words) {
            $set_dict{$_} = $dict->{$_};
        }
        my $set_dict = \%set_dict;

        return ($set_dict, $card_name);
    }
}

1;
