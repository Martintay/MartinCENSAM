#!/usr/bin/perl


use strict;

#To find Length of reads in fasta file
#Usage:perl MeasureFasta.pl <fastafile> <output>


my $fasta=$ARGV[0];
my $output=$ARGV[1];

open(FH,"$fasta");
open(OP,">$output");

while(<FH>)
{
chomp($_);
if($_=~/^>/)
{
my $id=$_;
print OP "$id";
}
else
{
my $seq=$_;

my $length_seq=length($seq);

print OP "__$length_seq\n$seq\n";

}
}
