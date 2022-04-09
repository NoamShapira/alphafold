import argparse
import os
import random
import shutil
import string
import sys
from pathlib import Path
from typing import List

sys.path.append('/home/labs/sorek/noamsh/alphafold-pycharm')

import weizmann_scripts.weizmann_config as weizmann_config

parser = argparse.ArgumentParser(
    description="creating results directory like alphafold expect to enable pre-computation of msas")

# required inputes
parser.add_argument('--results_dir', type=str)
parser.add_argument('--bacteria_protein_name', type=str)
parser.add_argument('--phage_protein_name', type=str)

# configurations
parser.add_argument('--bacteria_proteins_dir', type=str, default=str(weizmann_config.EREZ_BACTERIA_PATH))
parser.add_argument('--phage_proteins_dir', type=str, default=str(weizmann_config.EREZ_PHAGE_PATH))

arguments = parser.parse_args()


def _concatenate_multiple_files_to_one_file(src_files: List[Path], dst_path: Path):
    with open(dst_path, 'w+') as outfile:
        for file_path in src_files:
            with open(file_path) as infile:
                outfile.write(infile.read())


def create_combined_result_dir_with_fasta(args):
    bacteria_fasta_path = Path(args.bacteria_proteins_dir, args.bacteria_protein_name,
                               f"{args.bacteria_protein_name}.fasta")
    phage_fasta_path = Path(args.phage_proteins_dir, args.phage_protein_name, f"{args.phage_protein_name}.fasta")
    new_combined_dir_path = Path(args.results_dir, f"{args.bacteria_protein_name}_{args.phage_protein_name}")
    new_combined_fasta_path = Path(new_combined_dir_path,
                                   f"{args.bacteria_protein_name}_{args.phage_protein_name}.fasta")

    if not new_combined_dir_path.exists():
        os.mkdir(new_combined_dir_path)
    if not new_combined_fasta_path.exists():
        _concatenate_multiple_files_to_one_file(src_files=[bacteria_fasta_path, phage_fasta_path],
                                                dst_path=new_combined_fasta_path)


def copy_msas_if_exist_to_dir(args):
    """acording to alphafold nameing conventions, and erez matrix folder conventions"""
    msas_dir_path = Path(args.results_dir, f"{args.bacteria_protein_name}_{args.phage_protein_name}", "msas")
    bacteria_msas_dir = Path(msas_dir_path, "A")
    phage_msas_dir = Path(msas_dir_path, "B")

    bacteria_msas_existing_dir = Path(args.bacteria_proteins_dir, args.bacteria_protein_name, "msas", "A")
    if bacteria_msas_existing_dir.exists() and not bacteria_msas_dir.exists():
        shutil.copytree(bacteria_msas_existing_dir, bacteria_msas_dir)

    phage_msas_existing_dir = Path(args.phage_proteins_dir, args.phage_protein_name, "msas", "B")
    if phage_msas_existing_dir.exists() and not phage_msas_dir.exists():
        shutil.copytree(phage_msas_existing_dir, phage_msas_dir)


def copy_pdb_seqres_with_no_duplicates(args):
    """
    add sequence only if non existed
     for consistency it is done the same way it was done before the python script
    """
    bacteria_pdb_seqres_path = Path(args.bacteria_proteins_dir, args.bacteria_protein_name,
                                    "msas", "A", "pdb_seqres.fasta")
    phage_pdb_seqres_path = Path(args.phage_proteins_dir, args.phage_protein_name, "msas", "B", "pdb_seqres.fasta")
    combined_pdb_seqres_path = Path(args.results_dir, f"{args.bacteria_protein_name}_{args.phage_protein_name}",
                                    "pdb_seqres.fasta")  # no msas

    tmp_combined_feqres_file = Path(args.results_dir,
                                    f"tmp_seq_res_{''.join(random.choice(string.digits) for i in range(6))}.fasta")
    _concatenate_multiple_files_to_one_file(src_files=[bacteria_pdb_seqres_path, phage_pdb_seqres_path],
                                            dst_path=tmp_combined_feqres_file)
    os.system(
        "awk '/^>/{f=!d[$1];d[$1]=1}f'" + f" {str(tmp_combined_feqres_file)}" + f" > {str(combined_pdb_seqres_path)}")
    os.remove(tmp_combined_feqres_file)


create_combined_result_dir_with_fasta(arguments)
copy_msas_if_exist_to_dir(arguments)
copy_pdb_seqres_with_no_duplicates(arguments)
