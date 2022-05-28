mkdir -p /home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/msas

cat /home/labs/sorek/erezy/AF/matrix/bacteria/"$1"/"$1".fasta /home/labs/sorek/erezy/AF/matrix/phages/"$2"/"$2".fasta > /home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/"$1"_"$2".fasta

cat /home/labs/sorek/erezy/AF/matrix/bacteria/"$1"/msas/A/pdb_seqres.fasta /home/labs/sorek/erezy/AF/matrix/phages/"$2"/msas/B/pdb_seqres.fasta | awk '/^>/{f=!d[$1];d[$1]=1}f' > /home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/pdb_seqres.fasta

#mkdir -p /home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/mmcif_files

#while read p; do cp /shareDB/alphafold/pdb_mmcif/mmcif_files/$(echo $p | cut -d "_" -f 1 ).cif /home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/mmcif_files/$(echo "$p" | cut -d "_" -f 1 ).cif; done</home/labs/sorek/erezy/AF/matrix/bacteria/"$1"/msas/A/pdb_hits.list

#while read p; do cp /shareDB/alphafold/pdb_mmcif/mmcif_files/$(echo $p | cut -d "_" -f 1 ).cif /home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/mmcif_files/$(echo "$p" | cut -d "_" -f 1 ).cif; done</home/labs/sorek/erezy/AF/matrix/phages/"$2"/msas/B/pdb_hits.list

cp -r /home/labs/sorek/erezy/AF/matrix/bacteria/"$1"/msas/A /home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/msas/

cp -r /home/labs/sorek/erezy/AF/matrix/phages/"$2"/msas/B /home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/msas/

module load Singularity; singularity exec --nv --env XLA_FLAGS="--xla_gpu_force_compilation_parallelism=1" /apps/containers/singularity/AlphaFold-2.1.2-fosscuda-2020b-BETA.sif ~/Alphafold/run_alphafold.py --fasta_paths=/home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/"$1"_"$2".fasta --output_dir=/home/labs/sorek/erezy/AF/"$1"/results --max_template_date=2022-01-01 --model_preset=multimer --use_precomputed_msas=true --uniref90_database_path=/home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/"$1"_"$2".fasta --uniprot_database_path=/home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/"$1"_"$2".fasta --pdb_seqres_database_path=/home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/pdb_seqres.fasta --data_dir=/shareDB/alphafold/ --bfd_database_path=/shareDB/alphafold/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt --mgnify_database_path=/home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/"$1"_"$2".fasta --obsolete_pdbs_path=/shareDB/alphafold/pdb_mmcif/obsolete.4.dat --uniclust30_database_path=/shareDB/alphafold/uniclust30/uniclust30_2018_08/uniclust30_2018_08 --template_mmcif_dir=/shareDB/alphafold/pdb_mmcif/mmcif_files --is_prokaryote_list=true 1>/home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/"$1"_"$2".log 2>/home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/"$1"_"$2".log

rm -rf /home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/msas /home/labs/sorek/erezy/AF/"$1"/results/"$1"_"$2"/pdb_seqres.fasta
