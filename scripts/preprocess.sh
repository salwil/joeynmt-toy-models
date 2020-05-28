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
JOEYNMT=$tools/joeynmt/scripts

bpe_num_operations=4000
bpe_vocab_threshold=10

#################################################################

# measure time

SECONDS=0

# tokenization:

for corpus in train dev test; do
  cat $data/$corpus.de-en.$src | $MOSES/tokenizer/tokenizer.perl -l $src > $data/$corpus.de-en.tokenized.$src
done

for corpus in train dev test; do
  cat $data/$corpus.de-en.$trg | $MOSES/tokenizer/tokenizer.perl -l $trg > $data/$corpus.de-en.tokenized.$trg
done

# learn BPE model on train (concatenate both languages):

subword-nmt learn-joint-bpe-and-vocab -i $data/train.de-en.tokenized.$src $data/train.de-en.tokenized.$trg \
  --write-vocabulary $base/shared_models/vocab.$src $base/shared_models/vocab.$trg \
  -s $bpe_num_operations --total-symbols -o $base/shared_models/$src$trg.bpe

# apply BPE model to train, test and dev
for corpus in train dev test; do
	subword-nmt apply-bpe -c $base/shared_models/$src$trg.bpe --vocabulary $base/shared_models/vocab.$src --vocabulary-threshold $bpe_vocab_threshold < $data/$corpus.de-en.tokenized.$src > $data/$corpus.de-en.bpe.$src
	subword-nmt apply-bpe -c $base/shared_models/$src$trg.bpe --vocabulary $base/shared_models/vocab.$trg --vocabulary-threshold $bpe_vocab_threshold < $data/$corpus.de-en.tokenized.$trg > $data/$corpus.de-en.bpe.$trg
done

#build vocabulary file for bpe
python $JOEYNMT/build_vocab.py $data/train.de-en.bpe.de data/train.de-en.bpe.en --output_path 'shared_models/vocab.txt'


