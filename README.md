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
    checkout ex4

Create a new virtualenv that uses Python 3. Please make sure to run this command outside of any virtual Python environment:

    ./scripts/make_virtualenv.sh

**Important**: Then activate the env by executing the `source` command that is output by the shell script above.

Download and install required software (including the version enhanced with source_factors):

    ./scripts/download_install_packages.sh

Download fully preprocessed corpora already in BPE format, together with some auxiliary models (truecasing model, BPE model) and vocabularies.

    ./scripts/download_preprocessed_data.sh

Then finally train a model:

    ./scripts/train.sh

The training process can be interrupted at any time, and the best checkpoint will always be saved.

Evaluate a trained model with

    ./scripts/evaluate.sh

Hint to the training and evaluating step: Make sure, you declare the correct configuration file depending on the combine method you trained your model inside the for-loop.

# Summary and findings

#### Implementation

* If source_factors are given, validation of the combine method and embedding dimensions (relevant if adding the vectors) is done.
* Creation of additional embedding vector for the source factor, if config parameters are valid.
* Call the encoder with the embedding vector of the source sentence combined with the embedding vector of the source factors (in our case the POS-tags) to the source sentence vector.
* Depending on the  value of the combine_method parameter, the source factor vectors are added ('add') or concatenated ('concatenate') to the source vector. This is done inside the call of the encoder instance.


#### Parameters setting

* For training a model with or without source factors, set the respective config file inside the train.sh script.
* Inside the config file the embedding dimensions have to be set accordingly. In case of addition as combine method, the embedding dimensions for the source factor embedding vectors and the embedding vectors of the source sentence have to be the same (and also match the dimension of the decoder embedding vector dimension). In case of concatenating, the two dimensions together have to be the same as the decoder embedding vector dimension (e.g. 256 + 256 = 512).

#### Results

```
*-------------------------*
|  src_factors |   BLEU   | 
|--------------------------
|  na          |    8.5   | 
|--------------------------
|  add         |    0.6   |
|--------------------------
|  concatenate |          | 
*-------------------------*
```

Besides the fact, that training takes much longer, the consideration of source factors also does not have a positive impact on the BLEU score. On the contrary. It is much worse, as can be taken out of the table below. 

* combine method 'add': Took obviously longer runtime to train the model and the result had the worse BLEU score (0.6). 
* combine method 'concatenate': Runtime was longer than without source factors, but clearly faster than 'add'. The results were better (1.23)
* No source factors included made the processing of course faster, because the compute-intensive operation of adding / concatenating was left out. Also the BLEU score is much better (8.5) than the other two, which is of course kind of disappointing.

My assumption for the bad results in the adding method is, that the embedding vectors are manipulated in a "wrong direction" when adding the source factor embeddings (kind of just moving them around in the vector space).

Concatenating them made more sense to me, as the vectors keep their embedding values and just get some additional dimensions which indicate the corresponding part of speech. I was wondering if training the model again with adapted dimensions (for example giving dimension of 450 to the source sentence embeddings and 72 to the source factor embeddings, supposing the decoder embedding size was still 512), would result in a better BLEU score, as the factor embeddings actually in my understanding don't have to be that large, as we have a very limited corpus here.

I was thinking of combining the vectors should maybe be considered again, when decoding the encoder output. But I did not know how to do that.
