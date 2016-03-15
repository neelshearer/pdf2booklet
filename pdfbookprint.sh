#!/bin/bash

file="$1"
filename=${file%.*}
extension=${file##*.}
newfilename=$filename-booklet
newfile=$newfilename.$extension
pdftops -paper A4 "$1" - | psbook | psnup -2 -pa4 | ps2pdf -sPAPERSIZE=a4 - "$newfile"
echo
echo "A new file,'$newfile' has been created"
echo 
read -n1 -r -p "Would you now like to print your booklet? (any key to continue, or ^C to quit)" key
echo
pdftk A="$newfile" cat Aend-1odd output - | lpr
# take out the sheets and feed them back in
read -n1 -r -p "When you have put the sheets back in the feed tray, press any key to print the other side..." key
echo 
pdftk A="$newfile" cat Aeven output - | lpr
