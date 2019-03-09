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

    # use JSON;
    # use File::Slurp;
    use YAML::Tiny;

    sub init {
        # my $json = read_file( 'config.json' ) ;
        # my $attr = decode_json($json);
        my $yaml = YAML::Tiny->read('config.yaml');
        my $attr = $yaml->[0];

        # 音声設定
        $attr->{voice_visible} = 1;
        $attr->{sound_flag} = 1;

        $attr->{voice_visible} = 0 unless ($^O eq 'darwin');
        $attr->{sound_flag} = 0 unless (-d 'src/sound');

        if ($attr->{voice_visible} == 1) {
            $attr->{voice_flag} = 1;
        }
        else {
            $attr->{voice_flag} = 0;
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

        $attr->{fail_flag} = 0 if ($attr->{fail_flag} == 1);

        # ゲーム開始
        $attr = Command::set($attr, $data);
        ($attr, $data) = Command::distribute($attr, $data);

        return ($attr, $data);
    }
}

1;
