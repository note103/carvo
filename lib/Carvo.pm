package Carvo {
    use strict;
    use warnings;
    use feature 'say';

    use Command;
    use Recorder;
    use Generator;
    use CardSetter;
    use Util;

    sub init {
        my $attr = {
            ans_num    => '',
            fail_sw    => 'off',
            lesson_dir => 'src/lesson',
            sound_dir  => 'src/sound',
            log_record => 'on',
            miss       => 0,
            num        => 0,
            num_buffer => 0,
            num_normal => 0,
            point      => 0,
            quit       => '',
            sound_able => 1,
            total      => 0,
            voice      => 'say',
            voice_able => 1,
            voice_ch   => 'on',
        };

        # 音声設定
        $attr->{voice_able} = 0 unless ($^O eq 'darwin');
        $attr->{sound_able} = 0 unless (-d 'src/sound');

        if ($attr->{voice_able} == 1) {
            $attr->{voice_ch} = 'on';
        }
        else {
            $attr->{voice_ch} = 'off';
        }

        # 誤答リスト初期化
        my $data->{fail} = [];

        return ($attr, $data);
    }

    sub select {
        my ($attr, $data) = @_;

        # カード選択
        my $list = CardSetter::read_directory($attr);
        $attr = CardSetter::select_card($attr, $list);

        if ($attr->{choose} eq 'exit') {
            $data = Util::logs($data);
            Recorder::record($attr, $data);
        }
        else {
            return ($attr, $data);
        }
    }

    sub play {
        my ($attr, $data) = @_;

        # 辞書作成
        $data = Generator::convert($attr, $data);

        $attr->{fail_sw} = 'off' if ($attr->{fail_sw} eq 'on');

        # ゲーム開始
        $attr = Command::set($attr, $data);
        ($attr, $data) = Command::distribute($attr, $data);

        return ($attr, $data);
    }
}

1;
