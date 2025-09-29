#!/usr/bin/perl

my $to_print = "";

while (<>) {

  if (/^xml:base=/) {
    $to_print =~ s/\n$//;
  }

  $_ =~ s/xml:base=("|')([a-zA-Z0-9\/\.:_]*)("|')//;
  #print "# $_ #\n";

  $to_print .= $_;

}

print "$to_print";
