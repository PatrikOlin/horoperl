#!/usr/bin/env perl

use strict;
use warnings;

my $file = shift || 'horoscopes';    # corpus
my $n    = shift || 2;               # n-gram length
my $max  = shift || 100;             # max words

sub build_dict {
    my ( $n, @words ) = @_;
    my %dict;
    for my $i ( 0 .. $#words - $n ) {
        my @prefix = @words[ $i .. $i + $n - 1 ];
        push @{ $dict{ join ' ', @prefix } }, $words[ $i + $n ];
    }
    return %dict;
}

sub pick_one {
    $_[ rand @_ ];
}

my $text = do {
    open my $fh, '<', $file;
    local $/;
    <$fh>;
};

my @words = split ' ', $text;
my $start = int( rand scalar( @words - $n ) );
push @words, @words[ $start .. $start + $n - 1 ];
my %dict  = build_dict( $n, @words );
my @rotor = @words[ $start .. $start + $n - 1 ];
my @chain = @rotor;

for ( 1 .. $max ) {
    my $new = pick_one( @{ $dict{ join ' ', @rotor } } );
    shift @rotor;
    push @rotor, $new;
    push @chain, $new;
}

my $result = join( ' ', @chain );
$result =~ s/([a-z\s\W]+)//;
my @parts = split( /[\.!?]([^:]+)$/, reverse($result) );
$result = reverse( $parts[1] );
print $result . "\n";
