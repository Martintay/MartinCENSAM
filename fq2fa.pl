#!/usr/bin/perl

my $reads = $ARGV[0];
my $output=$ARGV[1];

open (OP,">$output");
open (FILE, $reads);
while($buff = <FILE>){
        if(substr($buff,0,1) eq "@"){
                $header = substr($buff,1,length($buff)-1);
                $read = <FILE>;

                print OP ">" . $header;
                print OP $read;


        }

        if(substr($buff,0,1) eq "+"){
                $read = <FILE>;
        }
}
close (FILE);



sub trim($)
{
        my $string = shift;
        $string =~ s/^\s+//;
        $string =~ s/\s+$//;
        return $string;
}

