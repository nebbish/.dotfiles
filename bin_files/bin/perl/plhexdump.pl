#!/usr/bin/env perl


# Copied from:   https://rubysash.com/programming/perl/hex-dump-with-perl-scripting/

use strict;
use warnings;
use POSIX 'ceil';

for my $file (@ARGV) {

	my $size = 16 * ceil( (-s $file) / 16 );
	my $form = length sprintf '%x', $size-1;
	$form ||= 1;

	print "File: $file\n";
	open my $fh, '<', $file or die $!;

	my $i = 0;
	while ( my $rb = read $fh, my $buf, 16 ) {

		my @x = unpack '(H2)*', $buf;
		push @x, '  ' until @x == 16;

		$buf =~ tr/\x20-\x7E/./c;
		$buf .= ' ' x (16 - length($buf));

		printf "%0*x: %s [%s]\n",
			$form,
			$i++,
			sprintf( "%s %s %s %s  %s %s %s %s - %s %s %s %s  %s %s %s %s", @x ),
			$buf;
	}

	print "\n";
}
