use strict;
use warnings;
use utf8;
use open OUT => qw/:utf8 :std/;
use Carvo::Save;

package Carvo {
    use Time::Piece;
    our ($point, $miss) = (0, 0);
    our $total = $point + $miss;
    our ($times, $hits, $errors) = qw/times hits errors/;
    our $voice_sw = 'on';
    our $voice = 'say';
    our @logs;
    my $extr = 3;
    my $mode = 'random';
    my $title = 'title';
    my $escape_sw = 'off';
    my $long_voice_sw = 'off';
    my $log_check = 'on';
    my $fail_sw = 'off';
    my $end = 'end';
    my $voice_in = 1;
    my ($num, $port, $port_back) = (0, 0, 0);
    my $msg_correct = "Please input a correct one.";
    my ($value, $words, $english, $key, $limit, $fail, $custom, $escape_title, $escape_end, $result);
    my (@words, @voice, @fail, @fail_out);
    my %english;
    sub main {
        $english = shift;
        %english = %$english;
        mode();
        my $enter = '\n';
        $limit = @words;
        my $msg_usual = 'Input a command or help(h|--help).';
        my $msg_limit = "You can choose a number from 1-";
        my $msg_random = "This is random select.";

        my @escape;
        for (@words) {
            if ($_ ne $title && $_ ne $end) {
                push @escape, $_;
            }
        }
        $escape_title = $escape[0];
        $escape_end = $escape[-1];

        if (exists ($english{$title})) {
            if (ref $english{$title} eq "ARRAY") {
                print "Welcome to the \"".$english->{$title}[0]."\"\n";
                $value = $english->{$title}[0];
                value();
                print `$voice $value`;
                for (keys %{$english->{$title}[1]}) {
                    print $_."\n".$english->{$title}[1]{$_}."\n\n";
                }
            } else {
                print "Welcome to the \"".$english->{$title}."\"!\n";
                $value = $english->{$title};
                value();
                print `$voice $value`;
            }

        }
        print "$msg_limit".$limit."\n$msg_usual\n";
        my $input = sub {
            while (my $in_ans = <>) {
                if ($in_ans =~ /^($enter)$/) {
                    $escape_sw = 'on';
                    $log_check = 'off';
                    if (ref $english->{$key} eq "ARRAY") {
                        push @logs, "*$key: $english->{$key}[0]\n";
                    } else {
                        push @logs, "*$key: $english->{$key}\n";
                    }
                    push @fail, $key."\n";
                    qa('a');
                    print "\n$msg_usual\n";
                    last;
                } else {
                    $escape_sw = 'off';
                    my $regexp = chomp $in_ans;
                    my $match;
                    $match = "$key";
                    $regexp = $in_ans;
                    $match =~ s/\?$/\\?/;
                    if ($regexp =~ /^($match)$/) {
                        $point++;
                        $log_check = 'on';
                        $total = $point + $miss;
                        plural($total, $point, $miss);
                        print "\nGood!!\n";
                        qa('a');
                        print "\nYou tried $total $times. $point $hits and $miss $errors.\n$msg_usual\n";
                        last;
                    } else {
                        $escape_sw = 'on';
                        $miss++;
                        $log_check = 'off';
                        if (ref $english->{$key} eq "ARRAY") {
                            push @logs, "*$key: $english->{$key}[0]\n";
                        } else {
                            push @logs, "*$key: $english->{$key}\n";
                        }
                        push @fail, $key."\n";
                        print "\nNG! Again!\n";
                    }
                }
            }
        };
        while (my $in_way = <>) {
            $in_way =~ s/^--(.+)/$1/;
            if ($in_way =~ /^(q|quit)$/) {
                $total = $point + $miss;
                $port = 0;
                @fail = ();
                $fail_sw = 'off';
                last;
            } elsif ($in_way =~ /^0$/) {
                print "\n$msg_limit".$limit."\n";
            } elsif ($in_way =~ /^(qq)$/) {
                $total = $point + $miss;
                print "\nTotal score:\n";
                print $result = "$total\t$times\n$point\t$hits\n$miss\t$errors\n";
                logs();
                result();
                if ($voice_sw eq 'on') {
                    print `$voice Bye!`;
                }
                exit;
            } elsif ($in_way =~ /^(\d+)$/) {
                $num = $1;
                $port = $num;
                if ($in_way > $limit) {
                    print "\nToo big! $msg_limit".$limit."\n$msg_random\n\n";
                    jump();
                    $input->();
                } else {
                    qa('q');
                    $input->();
                }
            } elsif ($in_way =~ /^(\n|[^\W\D]+)$/) {
                if ($port == $limit) {
                    print "You exceeded the maximum. Return to the beggining.\n\n";
                    $num = 1;
                    $port = $num;
                    qa('q');
                    $input->();
                } else {
                    $num = $port+1;
                    $port = $num;
                    qa('q');
                    $input->();
                }
            } elsif ($in_way =~ /^(v)$/) {
                voice();
                print "\n$msg_usual\n";
            } elsif ($in_way =~ /^x(\d+)$/) {
                $extr = $1;
                print "You changed the figure extracted character $extr.";
                print "\n$msg_usual\n";
            } elsif ($in_way =~ /^(h|help)$/) {
                help();
                print "\n$msg_limit".$limit."\n$msg_usual\n";
            } elsif ($in_way =~ /^(sh|short)$/) {
                $long_voice_sw = 'off';
                print 'You turned on short voice version.';
                print "\n$msg_usual\n";
            } elsif ($in_way =~ /^(lo|long)$/) {
                $long_voice_sw = 'on';
                print 'You turned on long voice version.';
                print "\n$msg_usual\n";
            } elsif ($in_way =~ /^(l|list)$/) {
                list();
                print "\n$msg_limit".$limit."\n$msg_usual\n";
            } elsif ($in_way =~ /^(f|fail)$/) {
                fail();
                print "\n$msg_limit".$limit."\n$msg_usual\n";
            } elsif ($in_way =~ /^(b|back)$/) {
                back();
                print "\n$msg_limit".$limit."\n$msg_usual\n";
            } elsif ($in_way =~ /^(revival|rv)$/) {
                Save::buffer($num, $words, $english);
                ($num, $words, $english) = Save::revival();
                $port = $num;
                qa('q');
                $input->();
            } elsif ($in_way =~ /^(unrevival|urv)$/) {
                ($num, $words, $english) = Save::unrev();
                $port = $num;
                qa('q');
                $input->();
            } elsif ($in_way =~ /^(save|sv)$/) {
                Save::save($num, $words, $english);
                print "$num/$limit\n";
                print "\n$msg_usual\n";
            } elsif ($in_way =~ /^(r|random)$/) {
                $mode = 'random';
                mode();
                list();
                print "\n$msg_usual\n";
            } elsif ($in_way =~ /^(o|order)$/) {
                $mode = 'order';
                mode();
                list();
                print "\n$msg_usual\n";
            } elsif ($in_way =~ /^(s|same)$/) {
                $num = $port;
                qa('q');
                $input->();
            } elsif ($in_way =~ /^(j|jump)$/) {
                jump();
                $input->();
            } elsif ($in_way =~ /^(\w+)$/) {
                $key = $1;
                if (exists($english{$key})) {
                    my $num_get = num_get($key, @words);
                    my $num_here = $num_get + 1;
                    print "\nHere is $key($num_here)\n$msg_usual\n";
                } else {
                    print "\nHere is not '$key'.\n$msg_usual\n";
                }
            } else {
                print "\n$msg_correct\n";
            }
        }
        sub list {
            if ($fail_sw eq 'off') {
                for (sort keys %$english) {
                    my $num_get = num_get($_, @words);
                    my $num_here = $num_get + 1;
                    print "$_: $num_here\n";
                }
            } elsif ($fail_sw eq 'on') {
                for (@fail_out) {
                    my $num_get = num_get($_, @words);
                    my $num_here = $num_get + 1;
                    print "$_: $num_here\n";
                }
            }
        }
        sub help {
            my $help = <<"EOD";

Command:
    全般:
        h   --help	これが出てくる
        l   --list	単語リストを表示
        o   --order	単語リストを辞書順に構成（デフォルト）
        r   --random	単語リストをランダムに出てくる
        q   --quit	コース終了
        qq  --force-quit	コース選択画面を経ずにプログラム終了
    操作:
        s   --same	直前の語句を繰り返す
        j   --jump	ランダムにジャンプ
        数字    	任意の番号へジャンプ
        単語    	リストにその語句が含まれていれば紐付く数字と共に表示（英単語のみ）
    読み上げ設定:
        v   --voice	on/off切り替え
        lo  --long	例文を読み上げる（カードに例文がある場合）
        sh  --short	例文を読み上げない（デフォルト）
    その他:
        x＋数字   	ヒントの文字数を設定（例: x2）
        f   --fail	誤答リストへ移動
        b   --back	通常リストへ戻る
        sv  --save	最後に回答した語句（番号）をセーブ
        rv  --revival	セーブした語句へ復帰
        urv --unrevival	セーブした語句へ復帰する前の場所へ復帰
EOD
            print $help."\n";
        }
        sub fail {
            print "You turned on fail list mode.\n";
            $fail_sw = 'on';
            if (@fail == 0) {
                print "Here is no data.\n";
                $fail_sw = 'off';
            } else {
                my %unique = map {$_ => 1} @fail;
                @fail_out = keys %unique;
                chomp @fail_out;
                @words = @fail_out;
                $limit = @words;
                $words = \@words;
                $port_back = $port;
                $num = 0;
                $port = $num;
            }
        }
        sub back {
            print "You turned back to normal mode.\n";
            $fail_sw = 'off';
            @words = keys %english;
            $limit = @words;
            $words = \@words;
            $num = $port_back;
            $port = $num;
        }
        sub num_get {
            my($str, @arr) = @_;
            my $i = 0;
            for (@arr) {
                if($str eq $arr[$i]){
                    return $i;
                } else {
                    $i++;
                }
            }
        }
        sub jump {
            $num = int(rand($limit+1));
            $port = $num;
            qa('q');
        }
        sub mode {
            if ($mode eq 'order') {
                @words = sort (keys %english);
            } elsif ($mode eq 'random') {
                @words = keys %english;
            }
            $words = \@words;
        }
    }

    sub voice {
        print "You can change voice setting. (on/off)\n";
        while (my $voice_sw_in = <>) {
            if ($voice_sw_in =~ /^(\n|on)$/) {
                $voice_sw = 'on';
                print "Select a number.\n";
                print `$voice select a number`;
                my @voice = (qw/Agnes Kathy Princess Vicki Victoria Alex Bruce Fred Junior Ralph Albert Bahh Bells Boing Bubbles Cellos Deranged Hysterical Trinoids Whisper Zarvox/, '"Bad News"', '"Good News"', '"Pipe Organ"');
                my $voice_count = 1;
                for (@voice) {
                    print $voice_count.". ".$_."\n";
                    $voice_count++;
                }
                print "Enter: Default type\n";

                while ($voice_in = <>) {
                    chomp($voice_in);
                    if ($voice_in =~ /\D/) {
                        print "$msg_correct\n";
                    } elsif ($voice_in =~ /\d/ && $voice_in > scalar(@voice)) {
                        print scalar(@voice)."\n";
                        print $voice_in."\n";
                        print "Too big! $msg_correct\n";
                    } elsif ($voice_in =~ /^$/) {
                        $voice = "say";
                        print "You selected Default type.\n";
                        print `$voice hi`;
                        last;
                    } else {
                        my $voice_selected = $voice[$voice_in-1];
                        $voice = "say -v $voice_selected";
                        print "You selected $voice_selected\n";
                        print `$voice hi I am $voice_selected`;
                        last;
                    }
                }
                last;
            } elsif ($voice_sw_in =~ /^off$/) {
                $voice_sw = 'off';
                last;
            } else {
                print "$msg_correct\n";
            }
        }
    }
    sub qa {
        my $ans;
        my $qa_switch = shift;
        $key = $words->[$num-1];
        $key =~ s/(.+)(\n)*$/$1/;
        if ($key eq $title) {
            $key = $escape_title;
        } elsif ($key eq $end) {
            $key = $escape_end;
        }
        my $sentence;
        if (ref $english->{$key} eq "ARRAY") {
            $ans = substr($key, 0, $extr);
            my @voice_tmp = ();
            if ($qa_switch eq 'q') {
                print "$ans: $english->{$key}[0]\n";
                if (ref $english->{$key}[1] eq "HASH") {
                    for $sentence (sort keys %{$english->{$key}[1]}) {
                        print "- $english->{$key}[1]{$sentence}\n";
                    }
                } elsif (ref $english->{$key} eq "ARRAY") {
                }
            } elsif ($qa_switch eq 'a') {
                print $ans = "$key($num): $english->{$key}[0]\n";
                if ($log_check eq 'on') {
                    push @logs, $ans;
                }
                if (ref $english->{$key}[1] eq "HASH") {
                    for my $sentence (sort keys %{$english->{$key}[1]}) {
                        print $ans = "- $sentence: $english->{$key}[1]{$sentence}\n";
                        if ($log_check eq 'on') {
                            push @logs, $ans;
                        }
                        push @voice_tmp, $sentence;
                    }
                } elsif (ref $english->{$key}[1] eq "ARRAY") {
                    my $array_values;
                    print $array_values = "$english->{$key}[1]\n";
                if ($log_check eq 'on') {
                    push @logs, $array_values;
                }
                    push @voice_tmp, $array_values;
                }
                if ($voice_sw eq 'on') {
                    $value = $key;
                    value();
                    print `$voice $value`;
                    if ($long_voice_sw eq 'on') {
                        for (@voice_tmp) {
                            $value = $_;
                            value();
                            print `$voice $value`;
                        }
                    }
                }
            }
        } else {
            $ans = substr($key, 0, $extr);
            if ($qa_switch eq 'q') {
                print "$ans: $english->{$key}\n";
            } elsif ($qa_switch eq 'a') {
                print $ans = "$key($num): $english->{$key}\n";
            if ($log_check eq 'on') {
                push @logs, $ans;
            }
                if ($voice_sw eq 'on') {
                    $value = $key;
                    value();
                    print `$voice $value`;
                }
            }
        }
    };
    sub value {
        $value =~ s/'//g;
        $value =~ s/;//g;
        $value =~ s/&/and/g;
        $value =~ s/\(/ /g;
        $value =~ s/\[/. /g;
        $value =~ s/\)/. /g;
        $value =~ s/\]/. /g;
    }
    sub plural {
        ($times, $hits, $errors) = @_;
        unless ($times == 1) {
            $times = 'times';
        } else {
            $times = 'time';
        }
        unless ($point == 1) {
            $hits = 'hits';
        } else {
            $hits = 'hit';
        }
        unless ($miss == 1) {
            $errors = 'errors';
        } else {
            $errors = 'error';
        }
    }
    sub logs {
        my @tidy;
        for my $tidy (@logs) {
            if ($tidy =~ /(.+)\(\d+\)(.+)/) {
                push @tidy, "$1$2\n";
            } elsif ($tidy =~ s/\d+\. //) {
                push @tidy, $tidy;
            } else {
                push @tidy, $tidy;
            }
        }
        my %unique = map {$_ => 1} @tidy;
        my @words = sort keys %unique;
        my @tmp;
        open my $fh_in, '<', 'data/logs.txt' or die $!;
        for (<$fh_in>) {
            push @tmp, $_;
        }
        close $fh_in;
        open my $fh_out, '>', 'data/logs.txt' or die $!;
        print $fh_out localtime->datetime(T=>' ')."\n";
        print $fh_out $result;
        print $fh_out "---\n";
        print $fh_out @words;
        print $fh_out "\n";
        print $fh_out @tmp;
        close $fh_out;
    }
    sub result {
        my @tmp;
        open my $fh_in, '<', 'data/result.txt' or die $!;
        for (<$fh_in>) {
            push @tmp, $_;
        }
        close $fh_in;
        open my $fh_out, '>', 'data/result.txt' or die $!;
        print $fh_out localtime->datetime(T=>' ')."\n";
        print $fh_out $result."\n";
        print $fh_out @tmp;
        close $fh_out;
    }
}

1;
