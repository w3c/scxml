#!/usr/bin/perl

my $is_heading = 0;
my $heading = "";
my $rest = "";
my $id = "";
my $level;
my $orig = "";

while (<>) {
  chomp;

  if (/<h([1-4])>(.*)/) {
    $level = $1;
    $orig = $2;
    $orig =~ s/<\/h[1-4]>$//;

    #print "# orig=${orig}\n"; # log

    if ($orig =~ /^<a id=/) {
      print "$_\n";
      $is_heading = 0;
      next;
    }
    $is_heading = 1;
  }

  if ($is_heading) {

    #print "orig=${orig}\n"; # log
   
    if (/(.*)<\/h[1-4]>/) {

      $rest = $1;
      #print "rest=${rest}\n" # log;

      if ($rest !~ /^<h([1-4])/) {
        $orig .= $rest;
      }

      # print "added=${orig}\n"; # log

      $id = $orig;
      $id =~ s/^ //;
      $id =~ s/^[ 0-9]+\. //;
      $id =~ s/[ \.]/_/g;
      $id =~ s/[(),"]/_/g;
      $id =~ s/[\?]//g;
      $id =~ s/<code>//g;
      $id =~ s/<\/code>/_/g;
      $id =~ s/(_)\1/$1/g;
      $id =~ s/_$//;

      #print STDERR "##${id}##\n";

      print "<h${level}><a id=\"${id}\" name=\"${id}\"><\/a>${orig}<\/h${level}>\n";

      $is_heading = 0;
      $orig = "";
      $rest = "";
      next;

    } else {
      if ($_ !~ /^<h([1-4])/) {
        $orig .= $_;
      }
      next;
    }

  } else {
    print "$_\n";
    next;
  }
}
