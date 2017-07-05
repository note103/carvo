package Carvo {
    use strict;
    use warnings;
    use feature 'say';

    use Command;
    use Data;
    use Exit;
    use Generator;
    use Printer;
    use Reader;
    use Responder;
    use Util;


    sub init {
        my $attr = Data::init();

        $attr->{voice_able} = 0 unless ($^O eq 'darwin');
        $attr->{sound_able} = 0 unless (-d 'src/sound');

        return $attr;
    }

    sub card {
        my ($attr, $data) = @_;

        $data->{fail} = [];

        # 音声設定
        if ($attr->{voice_able} == 1) {
            $attr->{voice_ch} = 'on';
        }
        else {
            $attr->{voice_ch} = 'off';
        }

        $attr = Printer::print($attr, Reader::read($attr));

        if ($attr->{choose} eq 'exit') {
            $data = Util::logs($data);
            Exit::record($attr, $data);
        }
        else {
            ($data->{dict}, $attr->{card_name}) = Generator::convert(
                $attr->{fmt}, $attr->{lesson_dir},  $attr->{choose}
            );

            $attr->{fail_sw} = 'off' if ($attr->{fail_sw} eq 'on');

            @{$data->{words}} = keys %{$data->{dict}};

            say '';
            Responder::set($attr, $data);
            Exit::record($attr, $data) if ($attr->{quit} eq 'exit');
        }
    }
}

1;
