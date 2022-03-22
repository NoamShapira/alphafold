DEFENCE_PROTEIN="$1"
PHAGE_PROTEIN="$2"
RESULTS_DIR="$3"
DEFENCE_PHAGE="$DEFENCE_PROTEIN"_"$PHAGE_PROTEIN"

EREZ_DATA_DIR=/home/labs/sorek/erezy/AF
REPO_DIR=/home/labs/sorek/noamsh/alphafold-pycharm

mkdir "$RESULTS_DIR"/"$DEFENCE_PHAGE"
COMBINED_FASTA_PATH="$RESULTS_DIR"/"$DEFENCE_PHAGE"/"$DEFENCE_PHAGE".fasta

cat "$EREZ_DATA_DIR"/matrix/bacteria/"$DEFENCE_PROTEIN"/"$DEFENCE_PROTEIN".fasta "$EREZ_DATA_DIR"/matrix/phages/"$PHAGE_PROTEIN"/"$PHAGE_PROTEIN".fasta > "$COMBINED_FASTA_PATH"

# /apps/containers/singularity/AlphaFold-2.1.2-fosscuda-2020b-BETA.sif
module load Singularity; singularity exec --nv --env XLA_FLAGS="--xla_gpu_force_compilation_parallelism=1" /apps/containers/singularity/AlphaFold-2.2.0-foss-2021a-CUDA-11.3.1.sif python "$REPO_DIR"/run_alphafold.py --fasta_paths="$COMBINED_FASTA_PATH" --output_dir="$RESULTS_DIR" --max_template_date=2022-01-01 --model_preset=multimer --data_dir=/shareDB/alphafold/ --uniref90_database_path=/shareDB/alphafold/uniref90/uniref90.fasta --mgnify_database_path=/shareDB/alphafold/mgnify/mgy_clusters_2018_12.fa --template_mmcif_dir=/shareDB/alphafold/pdb_mmcif/mmcif_files --obsolete_pdbs_path=/shareDB/alphafold/pdb_mmcif/obsolete.4.dat --bfd_database_path=/shareDB/alphafold/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt --uniclust30_database_path=/shareDB/alphafold/uniclust30/uniclust30_2018_08/uniclust30_2018_08 --pdb_seqres_database_path=/shareDB/alphafold/pdb_seqres/pdb_seqres.1.txt --uniprot_database_path=/shareDB/alphafold/uniprot/uniprot.fasta --use_gpu_relax=true --use_precomputed_msas=true --run_relax=false
