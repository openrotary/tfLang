#!/usr/bin/perl -w

use strict;
use feature qw(say);
use Data::Dumper;
use JSON;

my $json = new JSON;

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
		my $len = length scalar(@html_stack);
		if($floor > $len) {
			push @html_stack, \%$hash;
		}

		# push @dom, \%hash;
		print Dumper \%$hash;
	}
}

if($html_type eq '-f') {
	my %data_hash = ();
	my %currData = ();
	my $key_type = 1;
	my %key_type_hash = (
		'select' => 2,
		'radio' => 3,
		'checkbox' => 4,
		'my' => 5
	);

	while(<READ>) {
		if(!(trim $_)) {
			# 判断本行是否为空
			# 如果为空，重置key_type
			$key_type = 1;
			if(%currData) {
				push @{$data_hash{"root"}->{"children"}}, {%currData};
			}
			%currData = ();
			next;
		}
		if($_ =~ /\#\!/) {
			my @attr = split(' ', trim($'));
			$data_hash{'root'} = {
				'type' => 'form',
				'attr' => [@attr],
				'children' => []
			};

			# print Dumper(\%data_hash);
			next;
		}
		if($_ =~ /\@(select|radio|checkbox|my)/) {
			$_ =~ s/\@//;
			$key_type = $key_type_hash{trim($_)};
			next;
		}
		if($_ =~ /^-\s/) {
			my ($key, $label_placehoder) = split '/', $';
			my ($label, $placehoder) = $label_placehoder ? (split ':', $label_placehoder) : $key;
			$key =~ s/\-//;
			%currData = (
				'type' => $key_type,
				'label' => trim($label),
				'key' => trim($key),
				'placehoder' => $placehoder ? trim($placehoder) : '',
			);
			# print Dumper(\%currData);
			next;
		}
		if($_ =~ /^~\s/) {
			my ($valid, $warn) = split ':', $';
			$currData{'valid'} = [split ' ', $valid];
			$currData{'warn'} = trim $warn;
			# print Dumper(\%currData);
		}
	}
	my $text = $json->encode(\%data_hash);
	print "$text";
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