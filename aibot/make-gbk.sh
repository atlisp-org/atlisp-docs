#!/bin/sh
for i in `ls *.org`
do
    iconv -c -f utf-8 -t gb2312 $i > ~/@lisp/.cache/$i
done

