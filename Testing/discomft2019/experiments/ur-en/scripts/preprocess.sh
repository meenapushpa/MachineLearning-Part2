#!/bin/bash -e

# This script performs preprocessing on raw texts.
#
# ./this.sh (source|target|train)
#
# - preprocessing
#   stdin: texts
#   stdout: texts (preprocessed)
# - training
#   stdin/stdout: None

# The following is an example for en->ja

ROOT=$(dirname $0)/..
GROOT=$ROOT/../..
GCONF="$ROOT/global_config.json"


export MOSES="$GROOT/scripts/mosesdecoder/scripts"
export TRUECASE_MODEL="$ROOT/data/truecase_model"


SPM="$(jq -r '.spm.model_file' < $GCONF)"
if [ "$1" == "source" ]; then
    #echo "Preprocess English texts"
    python ../../scripts/preprocess-scripts/urdu_tokenizer.py "$1" output.txt
    python ../../experiments/ur-en/encodespm.py
    #spm_encode --model $SPM
elif [ "$1" == "target" ]; then
    # Preprocess Japanese texts
    $GROOT/scripts/preprocess-scripts/eu_moses.sh en > output1.txt
    python ../../experiments/ur-en/encodespmsrc.py
elif [ "$1" == "_source" ]; then
    # Preprocess Japanese texts
    python ../../scripts/preprocess-scripts/urdu_tokenizer.py "$1" "$2"
elif [ "$1" == "_target" ]; then
    $GROOT/scripts/preprocess-scripts/eu_moses.sh en
elif [ "$1" == "train" ]; then
    # Train moses truecaser for English
    EN_TRAIN="./data/raw/parallel/$(jq -r '.iwslt17.file_name_prefix.train' < $GCONF).src"
    $GROOT/scripts/preprocess-scripts/eu_moses.sh en train < $EN_TRAIN

    # No training is needed for the Japanese tokenizer
else
    exit 1
fi
