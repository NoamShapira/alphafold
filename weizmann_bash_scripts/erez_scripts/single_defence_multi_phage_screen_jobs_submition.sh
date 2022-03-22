#!/bin/bash
EREZ_DATA_DIR=/home/labs/sorek/erezy/AF
DEFENCE_PROTEIN_NAME=SpyCas
FILE_WITH_PHAGE_PROTEINS="$EREZ_DATA_DIR"/matrix/list
MSA_ARANMENT_AND_PIPELINE_BASH="$EREZ_DATA_DIR"/run_pipeline.sh

JOB_MEMORY_MB=40000

bsub -q molgen-short 'while read p do if [ ! -s "$EREZ_DATA_DIR"/"$DEFENCE_PROTEIN_NAME"/results/"$DEFENCE_PROTEIN_NAME"_$p/timings.json ] ; then bsub -q gpu-long -R rusage[mem="$JOB_MEMORY_MB"] -gpu num=1 -R affinity[cpu*1] -o /dev/null -R hname!=ibdgx007 bash "$MSA_ARANMENT_AND_PIPELINE_BASH" "$DEFENCE_PROTEIN_NAME" "$p" ; fi ;done < "$FILE_WITH_PHAGE_PROTEINS"'