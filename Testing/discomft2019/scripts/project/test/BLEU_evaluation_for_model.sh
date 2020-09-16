#!/bin/bash -e

MODEL_DIR=${1:-.}
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-0}
GPUs=($(echo $CUDA_VISIBLE_DEVICES | tr ',' ' '))
NGPU=${#GPUs[@]}
MCONF=$MODEL_DIR/model_config.json
ROOT=$(jq -r '.basedir' < $MCONF)
[ -n "$CMTBT_GROOT" ] || { echo '$CMTBT_GROOT not found' >&2; exit 1; }
GCONF=$ROOT/global_config.json

SRC_SUFFIX=$(jq -r '.source_suffix' < $MCONF)
TRG_SUFFIX=$(jq -r '.target_suffix' < $MCONF)
BEAM_SIZE=$(jq -r '.beam_size' < $MCONF)
BATCH_CAPACITY=$(jq -r '.batch_capacity' < $MCONF)

SPM=$(jq -r '.spm.model_file' < $GCONF)

[ 'true' = $(jq -r '.target_context' < $MCONF) ] \
    && TRANSLATOR="$CMTBT_GROOT/scripts/project/context_aware_translation.py" \
    || TRANSLATOR="$CMTBT_GROOT/scripts/transformer/inference.py"
SPMDECODE="d:/Priya/Work6/Workspace/Testing/discomt2019/scripts/project/test/spmdecode.py"
#BLEUPY="d:/Priya/Work6/Workspace/Testing/discomt2019/scripts/project/test/multi_bleu.py"
#value="d:/Priya/Work6/Workspace/copy_out"
logdir=$MODEL_DIR/log/eval/bleu_$(date '+%Y%m%d-%H%M%S')/
mkdir -p $logdir

for i in $(jq -r '.iwslt17.file_name_prefix.train' < $GCONF); do
    src_case=$(echo ${i}${SRC_SUFFIX}|tr -d '\r')
    trg_case=$(echo ${i}${TRG_SUFFIX}|tr -d '\r')
    src_sbw=$ROOT/data/concat/parallel/${src_case}
    ref_sbw=$ROOT/data/concat/parallel/${trg_case}
    #src_sbw=$ROOT/data/concat/parallel/${test_case}$SRC_SUFFIX
    #ref_sbw=$ROOT/data/concat/parallel/${test_case}$TRG_SUFFIX

    prefix=$(echo ${logdir}${i}|tr -d '\r')
    mkdir -p $prefix

    echo """beam size: $BEAM_SIZE
source: $src_sbw
reference: $ref_sbw""" > $prefix/info

    src=${prefix}/src
    ref=${prefix}/ref
    out=${prefix}/out
    out_sbw=${prefix}/out_sbw
    all=${prefix}/all
    score=${prefix}/score
    #cp $value $out_sbw
    python $TRANSLATOR --model_dir $MODEL_DIR --beam_size $BEAM_SIZE --n_gpus $NGPU \
        < $src_sbw > $out_sbw
    python $SPMDECODE $out_sbw > $out
    python $SPMDECODE $src_sbw > $src
    #spm_decode --model $SPM < $src_sbw > $src
    python $SPMDECODE $ref_sbw > $ref
    #spm_decode --model $SPM < $ref_sbw > $ref
    #python $BLEUPY --reference $ref < $out > $score
    $CMTBT_GROOT/scripts/project/test/moses_bleu_value.sh $ref < $out > $score

    paste $src $ref $out | while IFS=$'\t' read s r o; do
        echo "[src] $s"
        echo "[ref] $r"
        echo "[out] $o"
        echo ""
    done > $all
done
