#!/bin/sh

if test $# -ne 2
then
	echo "$0 file1 file2"
	exit
fi

cat $1 |
sed "s/$//" |
sed "s/\&#xD;$//" |
sed "s/ /\&nbsp;/g" |
sed "s/	/ /g" > tmp1

cat $2 |
sed "s/$//" |
sed "s/\&#xD;$//" |
sed "s/ /\&nbsp;/g" |
sed "s/	/ /g" > tmp2

htmldiff.pl tmp1 tmp2

