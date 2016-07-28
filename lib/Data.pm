package Data {
    use strict;
    use warnings;
    use feature 'say';

    sub init {
        my %attr = (
            total => 0,
            point => 0,
            miss  => 0,

            num      => 0,
            num_buffer => 0,
            num_normal => 0,

            voice      => 'say',
            voice_ch => 'off',

            extr       => 3,
            log_record => 'on',
            order      => 'random',
            fail_sw    => 'off',
            quit     => '',

            rw     => 'r',
            ans_num     => '',
            lesson => 'src/lesson',
            lesson_root => 'src/lesson',
        );
        return \%attr;
    }
}

1;
