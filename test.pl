#!/usr/bin/perl -w

use strict;
use feature qw(say);

my $text = "xxxx : yyyy / iiii";
my ($a, $b, $c) = split /[:\/]/, $text;
print "$a, $b, $c";