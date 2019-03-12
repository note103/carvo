package Logger;
use strict;
use warnings;
use feature 'say';

sub store {
    my $data = shift;

    $data->{log}        = [] if (!$data->{log});
    $data->{log_buffer} = [] if (!$data->{log_buffer});

    @{$data->{log_buffer}} = (@{$data->{log_buffer}}, @{$data->{log}});
    my %log = map {$_ => 1} @{$data->{log_buffer}};
    @{$data->{log_buffer}} = keys %log;
    $data->{log} = $data->{log_buffer};

    return $data;
}


1;
