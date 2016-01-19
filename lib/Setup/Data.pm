package Data {
    use 5.12.0;
    use warnings;
    use lib 'lib';

    sub init {
        my %attr = (
            total => 0,
            point => 0,
            miss  => 0,

            num      => 0,
            num_buffer => 0,
            num_normal => 0,

            voice      => 'say',
            voice_swap => 'key',

            extr       => 3,
            log_record => 'on',
            order      => 'random',
            fail_sw    => 'off',
            speech     => 'off',
            quit     => '',
        );
        return \%attr;
    }
}

1;
