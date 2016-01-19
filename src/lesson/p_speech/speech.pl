#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use Time::Piece;
use Time::Seconds;
use v5.20;
use DDP { deparse => 1 };

my @array = <DATA>;
my @num_line;
my $n = 152;
for my $line (@array) {
    if ( $n =~ /^(\d)$/ ) {
        $n = '0' . $n;
    }
    push @num_line, "$n: $line";
    $n++;
}

my $s4 = '    ';
my $s8 = $s4 . $s4;

my @line;
for my $str (@num_line) {
    $str =~ s/"/\\"/g;
    if ( $str =~ /^#.*/ ) {
    }
    elsif ( $str =~ s/^(.+): (.+)/$s4"=$1" : "$2"/g ) {
    }
    elsif ( $str =~ s/^(.+)\t(.+)/$s4"=$1" : "$2"/g ) {
    }
    elsif ( $str =~ s/^$s4(.+): (.+)/$s8"$1" : "$2",/g ) {
    }
    elsif ( $str =~ s/^$s4(.+): (.+)/$s8"$1" : "$2",/g ) {
    }
    elsif ( $str =~ s/^>$s4(.+): (.+)/$s8">$1" : "$2",/g ) {
    }
    elsif ( $str =~ s/^<$s4(.+): (.+)/$s8"<$1" : "$2",/g ) {
    }
    push @line, $str;
}
my @json;
for my $str2 (@line) {
    if ( $str2 =~ /^($s4")=(.+" : )(.+)/ ) {
        push @json, "$1$2$3,\n";
    }
    elsif ( $str2 =~ /^($s4".+" : )(.+)/ ) {
        push @json, "$1\[\n$s8$2\n";
    }
    elsif ( $str2 =~ /^($s8")>(.+" : ".+"),/ ) {
        push @json, "$s8\{\n$s4$1$2,\n";
    }
    elsif ( $str2 =~ /^($s8")<(.+" : ".+"),/ ) {
        push @json, "$s4$1$2\n$s8\}\n$s4\],\n";
    }
    elsif ( $str2 =~ /^($s8".+" : ".+"),/ ) {
        push @json, "$s4$1,\n";
    }
}
open my $fh, '>>', 'speech.json' or die "failed to open file: $!";
    print $fh @json;
    print @json;
close $fh;

__DATA__
 
"Jeremy"
At home
Drawing pictures
Of mountain tops
With him on top
Lemon yellow sun
Arms raised in a V
And the dead lay in pools of maroon below
Daddy didn't give attention
Oh, to the fact that mommy didn't care
King Jeremy The Wicked
Ruled his world
Jeremy spoke in class today
Jeremy spoke in class today
Clearly I remember
Pickin' on the boy
Seemed a harmless little fuck
But we unleashed a lion
Gnashed his teeth
And bit the recess lady's breast
How could I forget
And he hit me with a surprise left
My jaw left hurting
Dropped wide open
Just like the day
Oh, like the day I heard
Daddy didn't give affection, no!
And the boy was something that mommy wouldn't wear
King Jeremy The Wicked
Ruled his world
Jeremy spoke in class today
Jeremy spoke in class today
Jeremy spoke in class today
Try to forget this (try to forget this)
Try to erase this (try to erase this)
From the blackboard
Jeremy spoke in class today
Jeremy spoke in class today
Jeremy spoke in, spoke in
Jeremy spoke in, spoke in
Jeremy spoke in class today
