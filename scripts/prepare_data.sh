#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data
tools=$base/tools

mkdir -p $base/shared_models

src=de
trg=en

# cloned from https://github.com/bricksdont/moses-scripts
MOSES=$tools/moses-scripts/scripts


#################################################################

# measure time

SECONDS=0

# Sample data to 100k sentence pairs

shuf -n 100000 --random-source=train.de-en.de <(cat -n train.de-en.de) > samples/sample1.de-en.de
shuf -n 100000 --random-source=train.de-en.de <(cat -n train.de-en.en) > samples/sample2.de-en.en

cut -b 8- samples/sample1.de-en.de > train.de-en.de
cut -b 8- samples/sample2.de-en.en > train.de-en.en


