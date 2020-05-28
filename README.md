# joeynmt-toy-models

This repo is just a collection of scripts showing how to install [JoeyNMT](https://github.com/joeynmt/joeynmt), preprocess
data, train and evaluate models.

# Requirements

- This only works on a Unix-like system, with bash.
- Python 3 must be installed on your system, i.e. the command `python3` must be available
- Make sure virtualenv is installed on your system. To install, e.g.

    `pip install virtualenv`

# Steps

Clone this repository in the desired place and check out the correct branch:

    git clone https://github.com/salwil/joeynmt-toy-models
    cd joeynmt-toy-models
    checkout ex5

Create a new virtualenv that uses Python 3. Please make sure to run this command outside of any virtual Python environment:

    ./scripts/make_virtualenv.sh

**Important**: Then activate the env by executing the `source` command that is output by the shell script above.

Download and install required software:

    ./scripts/download_install_packages.sh

Download and split data:

    ./scripts/download_data.sh

Extract only 100k lines of training data, to make the system working on a normal machine:
    
    ./scripts/prepare_data.sh

Preprocess data (the script is designed for tokenizing and bpe):

    ./scripts/preprocess.sh

Then finally train a model:

    ./scripts/train.sh

The training process can be interrupted at any time, and the best checkpoint will always be saved.

Evaluate a trained model with

    ./scripts/evaluate.sh


#### Results and findings

##### Ex. 1

BLEU by evaluating with translations of beam size = 5

```
*------------------------------------*
|  use BPE     |vocab size|   BLEU   | 
|------------------------------------*
|  no          |   2000   |    4.5   | 
|------------------------------------*
|  yes         |   2000   |    6.7   |
|------------------------------------*
|  yes         |   4000   |    10.5  |
*-------------------------*----------*

```

A model trained with subwords is obviously better than with whole words. The resulting translations have a clearly better BLEU score (6.7). When we extend the vocabulary from 2000 to 4000, the BLEU is again increased clearly to 10.5.

