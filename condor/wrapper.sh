#!/bin/bash

cd /afs/cern.ch/work/z/zhangr/FCG/FastCaloChallenge/training
source /afs/cern.ch/work/z/zhangr/HH4b/hh4bStat/scripts/setup.sh

echo $@

task=$1
input=$2
output=$3

model=`echo $output | cut -d '_' -f 1`
config_mask=`echo $output | cut -d '_' -f 2`
config=`echo $config_mask | cut -d '-' -f 1`
mask=`echo $config_mask | cut -d '-' -f 2 | cut -d 'M' -f 2`
prep=`echo $config_mask | cut -d '-' -f 3 | cut -d 'P' -f 2`

if [[ $mask == ?(n)+([0-9]) ]]; then
    version='v2'
    train_addition="--mask=${mask//n/-}"
else
    version='v1'
    train_addition=""
fi

if [[ ! -z "$prep" ]]; then
    train_addition="$train_addition -p $prep"
    evaluate_addition="-p $prep"
fi

if [[ ${task} == *'train'* ]]; then
    command="python train.py -i ${input} -m ${model} -o ../output/dataset1/${version}/${output} -c ../config/config_${config}.json ${train_addition}"
else
    command="python evaluate.py -i ${input} -t ../output/dataset1/${version}/${output} ${evaluate_addition}"
fi
echo $command
$command
cd -
