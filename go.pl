#!/usr/bin/perl -w

use strict;
use feature qw(say);
use Data::Dumper;

my ($html_type, $read_url, $write_url) = @ARGV;

open READ, "<$read_url" or die "$!";
open WRITE, ">$write_url" or die "$!";

sub trim {
    my $s = shift; 
    $s =~ s/^\s+|\s+$//g; 
    return $s;
}

sub dom_func {
    my @dom = ();
    return sub {
        my (%hash) = @_;
        # print Dumper(\%hash);
        if(!%hash) {
            @dom = ();
            return [];
        }
        push @dom, \%hash;
        print Dumper @dom;
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
            say "kk";
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
            if($text =~ /[\>\<]/) {
                $align = $text =~ /</ ? 0 : 1;
            }
            # $align 可用， 0，2，1
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
            $_ =~ s/\#/\>\>\>\>\>/g;
            my %html_hash = (
                'tag' => $tag,
                'attr' => [@attr],
                'content' => trim $content
            );
            $handle->(%html_hash);
            next;
        }
    }
}

close READ;
close WRITE;