DEFENCE_PROTEIN="LsoA"
PHAGE_PROTEIN="IMGVR2400828" # first phage protien
#PHAGE_PROTEIN="IMGVR31678790"

RESULTS_DIR=/home/labs/sorek/noamsh/AF_multimer_exercise/results/
JOB_LOGS_DIR="$RESULTS_DIR"/job_logs

mkdir -p "$JOB_LOGS_DIR"

PIPELINE_SCRIPT=/home/labs/sorek/noamsh/alphafold-pycharm/weizmann_bash_scripts/run_multimer_single_time.sh
JOB_MEMORY_MB=30000
JOB_CPU=8

bsub -q gpu-long -R rusage[mem="$JOB_MEMORY_MB"] -gpu num=1 -R affinity[cpu*"$JOB_CPU"] -o "$JOB_LOGS_DIR" -R hname!=ibdgx007 -m "dgx_hosts hpe6k_hosts hpe8k_hosts asus_hosts" bash "$PIPELINE_SCRIPT" "$DEFENCE_PROTEIN" "$PHAGE_PROTEIN" "$RESULTS_DIR"
