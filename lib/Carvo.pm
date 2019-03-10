package Carvo {
    use strict;
    use warnings;
    use feature 'say';

    use FindBin;
    use lib "$FindBin::Bin/../lib";

    use Set::Generator;
    use Set::CardSetter;
    use Play::Commander;
    use Close::Logger;
    use Close::Closer;

    use YAML::Tiny;

    sub init {
        my $yaml = YAML::Tiny->read('config.yaml');
        my $attr = $yaml->[0];

        # 音声設定
        $attr->{sound_flag} = 1;
        $attr->{sound_flag} = 0 if (! -d $attr->{sound_dir});

        $attr->{voice_visible} = 1;
        $attr->{voice_visible} = 0 if ($^O ne 'darwin');
        $attr->{voice_flag} = 0 if $attr->{voice_visible} == 0;

        # 挙動用数値
        $attr->{num} = 0,
        $attr->{num_buffer} = 0,
        $attr->{num_normal} = 0,

        # 得点用数値
        $attr->{point} = 0,
        $attr->{miss} = 0,
        $attr->{total} = 0,

        # 誤答リスト初期化
        $attr->{fail_flag} = 0,
        my $data->{fail} = [];

        print `say -v $attr->{voice} hi` if $attr->{voice_flag} == 1;

        return ($attr, $data);
    }

    sub select {
        my ($attr, $data) = @_;

        # カード選択
        my $list = CardSetter::read_dict($attr);
        $attr = CardSetter::select_card($attr, $list);

        # 終了前記録
        if ($attr->{choose} eq 'exit') {
            $data = Logger::store($data);
            Closer::record($attr, $data);
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

    sub help {
        open my $fh_help, '<', 'docs/help.txt' or die $!;
        my $help = do { local $/; <$fh_help> };
        close $fh_help;

        use Encode;
        $help = decode('utf8', $help);
        return $help;
    }
}

1;
