package Data {
    use strict;
    use warnings;
    use feature 'say';

    sub init {
        my %attr = (
            ans_num     => '',
            cave => 0,
            extr       => 3,
            fail_sw    => 'off',
            lesson => 'src/lesson',
            lesson_root => 'src/lesson',
            log_record => 'on',
            miss  => 0,
            num      => 0,
            num_buffer => 0,
            num_normal => 0,
            point => 0,
            quit     => '',
            rw     => 'r',
            total => 0,
            voice      => 'say',
            voice_ch => 'on',
            voice_able => 1,
            sound_able => 1,
        );
        return \%attr;
    }
}

1;
