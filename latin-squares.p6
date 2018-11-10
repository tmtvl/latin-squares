#!/usr/bin/env perl6
use v6;

use Terminal::ANSIColor;


sub build-array (Int $n) {
	my @arr;
	my @ns = (0..^$n).pick(*);

	for 0..^$n -> $i {
		@arr.push(($i, |($i^..^$n), |(0..^$i)));
	}

	return @arr.pick(*).map({ .map({ @ns[$_] }) });
}

sub colour-array (Int $n) {
	my $step = 1530 / $n;

	my @colours;

	for 1..$n -> $i {
		my $colour = $step * $i;

		my $r = 0;
		my $g = 0;
		my $b = 0;

		given $colour {
			when $colour < 255  { $r = $colour;                                                 }
			when $colour < 510  { $r = 255;            $g = $colour - 255;                      }
			when $colour < 765  { $r = 765 - $colour;  $g = 255;                                }
			when $colour < 1020 {                      $g = 255;            $b = $colour - 765; }
			when $colour < 1275 {                      $g = 1275 - $colour; $b = 255;           }
			when $colour < 1530 { $r = $colour - 1275;                      $b = 255;           }
			default             { $r = 255;                                 $b = 255;           }
		}

		@colours.push(($r.Int, $g.Int, $b.Int).join(','));
	}

	return @colours;
}

sub transform-n ($n, Bool $colour, Str $c, Str $style?, Str $hashstyle?) {
	my $return = $n;

	given $style {
		when 'alpha' { $return = ('a'..'z')[$n]; }
		when 'hash'  { $return = $hashstyle; }
		when 'num'   { }
	}
	
	return $colour ?? colored("$return", "$c") !! $return;
}

sub transform-array (@arr, Bool $colour, Str $style?, Str $hashstyle?) {
	my @result;

	my @colours = colour-array(@arr.elems);

	for @arr -> @line {
		@result.push(@line.map({ transform-n($_, $colour, @colours[$_], $style, $hashstyle) }));
	}

	return @result;
}

sub print-array (@arr) {
	.join.say for @arr;
}

sub MAIN (Int $n where { $n < 1530 } = 4, Bool :$colour, Str :$style = 'num', Str :$hashstyle = '#') {
	my @arr = build-array($n);

	if ($colour || so $style || so $hashstyle) {
		@arr = transform-array(@arr, $colour, $style, $hashstyle);
	}

	print-array(@arr);
}
