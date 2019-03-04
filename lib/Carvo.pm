package Carvo {
    use strict;
    use warnings;
    use feature 'say';

    use FindBin;
    use lib "$FindBin::Bin/../lib";

    use Set::Generator;
    use Set::CardSetter;
    use Play::Util;
    use Record::Recorder;
    use Play::Command;

    use JSON;
    use File::Slurp;

    sub init {
        my $json = read_file( 'config.json' ) ;
        my $attr = decode_json($json);

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

        # 終了前記録
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
