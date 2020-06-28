#!/usr/bin/perl -w

use strict;
use feature qw(say);
use Data::Dumper;

my ($html_type, $read_url) = @ARGV;

open READ, "<$read_url" or die "$!";


sub trim {
	my $s = shift;
	$s =~ s/^\s+|\s+$//g;
	return $s;
}


sub dom_func {
	my @html_stack = ();
	my $currfloor = 0;
	return sub {
		my ($hash, $floor) = @_;
		say $floor;
		if(!$hash) {
			@html_stack = ();
			return [];
		}

		# get Dom length
		my $len = length @html_stack;
		if($floor > $len) {
			push @html_stack, \%$hash;
		}

		# push @dom, \%hash;
		print print Dumper \%$hash;
	}
}

if($html_type eq '-t') {
	my %data_hash = ();
	my %table_key_type_hash = (
		'#'=> 'slot',
		':'=> 'type'
	);
	my %currData = ();
	my @table_list = ();
	my $handle = dom_func();

	while(<READ>) {
		if(!(trim $_)) {

			# 判断本行是否为空
			if(!%currData) {
				next;
			}
			my @children = $data_hash{"root"}->{"children"};
			push @children, %currData;
			$data_hash{"root"}->{"children"} = [@children];
			%currData = ();
			next;
		}
		if($_ =~ /^\#\!/) {

			# 匹配表格
			my @attr = split(' ', trim($'));
			$data_hash{'root'} = {
				'type' => 'table',
				'attr' => [@attr],
				'children' => []
			};

			# print Dumper(\%data_hash);
			next;
		}
		if($_ =~ /\|.+?\|/) {
			my $align = 2;
			my $text = $_;
			my @attr = split ' ', $';

			# $align 可用， 0，2，1
			if($text =~ /[\>\<]/) {
				$align = $text =~ /</ ? 0 : 1;
			}
			$text =~ s/[\|\<\>|]//g;
			my ($key, $label) = split '/', $text;
			my $key_type = $key =~ s/[\:\#]// ? $table_key_type_hash{$&} : '';
			%currData = (
				'keyType' => $key_type,
				'key' => trim($key),
				'attr' => [@attr],
				'label' => $label =~ /\*/ ? '' : trim $label,
			);
			next;
		}
		if($_ =~ /\>{1,}/) {
			my ($tag_attr, $content) = split ' : ', $';
			my @attr = split ' ', $tag_attr;
			my $tag = shift @attr;
			my %html_hash = (
				'tag' => $tag,
				'attr' => [@attr],
				'content' => trim $content
			);
			my $floor = trim $&;
			$handle->(\%html_hash, length $floor);
			next;
		}
	}
}

close READ;