#!/bin/bash

file="$1"
newfile=${file%.*}-booklet.${file##*.}
# convert to ps (force A4 paper), reorder pages to booklet ordering, 
# place the pages 2 to a page (force A4 - gives better space usage), 
# convert back to pdf (force A4) - the papersize specification at 
# the very end is the only really critical one (for some reason 
# ps2pdf by default seems to convert to Letter - aaarghh!)
pdftops -paper A4 "$1" - | psbook | psnup -2 -pa4 | ps2pdf -sPAPERSIZE=a4 - "$newfile"
echo
echo "A new file,'$newfile' has been created in the source directory"
echo 
read -n1 -r -p "Would you now like to print your booklet? (any key to continue, or ^C to quit)" key
echo
# print all the odd numbered pages first in reverse order
pdftk A="$newfile" cat Aend-1odd output - | lpr
echo
read -n1 -r -p "When you have put the sheets back in the feed tray, press any key to print the other side..." key
echo 
# now print all the even numbered pages
pdftk A="$newfile" cat Aeven output - | lpr
echo
echo "Your document has printed - if your original document had an odd number of pages check the feed tray for the last page..."
echo
