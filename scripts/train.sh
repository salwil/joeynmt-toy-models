#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

models=$base/models
configs=$base/configs

mkdir -p $models

num_threads=4
device=5

# measure time

SECONDS=0

# train models:

#CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt train $configs/low_resource_example_words.yaml
 CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt train $configs/low_resource_example_bpe_4000_beamsize_5.yaml

echo "time taken:"
echo "$SECONDS seconds"
