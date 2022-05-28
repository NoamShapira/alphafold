DEFENCE_PROTEIN="2778764920,2562880088" # 2 defence proteins with the same length

#PHAGE_PROTEIN="IMGVR2400828" # first phage protien
#PHAGE_PROTEIN="IMGVR31678790"
PHAGE_PROTEIN="IMGVR22161441"

RESULTS_DIR=/home/labs/sorek/noamsh/AF_multimer_exercise/results/
JOB_LOGS_DIR="$RESULTS_DIR"/job_logs

mkdir -p "$JOB_LOGS_DIR"

PIPELINE_SCRIPT=/home/labs/sorek/noamsh/alphafold/weizmann_scripts/run_multimer_multi_defence_proteins.sh
JOB_MEMORY_MB=50000

bsub -q gpu-long -R rusage[mem="$JOB_MEMORY_MB"] -gpu num=1 -o "$JOB_LOGS_DIR" -R 'hname!=cn300 && hname!=cn301 && hname!=cn302 && hname!=cn303 && hname!=cn304 && hname!=cn736' bash "$PIPELINE_SCRIPT" "$DEFENCE_PROTEIN" "$PHAGE_PROTEIN" "$RESULTS_DIR"
