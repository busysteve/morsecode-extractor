#!/bin/sh
# ~/bin/mp32raw
# script converts mp3 files into raw files
mkdir cd
while read f
do
newfilename=`basename $f .mp3`.raw
madplay $f "--output=raw:$newfilename"
mv $newfilename ./cd/
done

