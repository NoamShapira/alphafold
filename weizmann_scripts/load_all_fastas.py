import dataclasses
from pathlib import Path
from typing import Dict

import pandas as pd

import alphafold.data.parsers as parsers
import weizmann_scripts.weizmann_config as weizmann_config


@dataclasses.dataclass(frozen=True)
class FastaChain:
    sequence: str
    description: str


def read_all_fasta_protein_folders(dir_with_proteins: Path) -> Dict[str, FastaChain]:
    """ assumes dir structure: dir has subdirs with protein names contaning fasta files with that name"""
    all_proteins = {}
    for input_fasta_path_dir in dir_with_proteins.glob("*"):
        protein_name = input_fasta_path_dir.stem
        input_fasta_path = Path(input_fasta_path_dir, protein_name + ".fasta")
        with open(input_fasta_path) as f:
            input_fasta_str = f.read()
        input_seqs, input_descs = parsers.parse_fasta(input_fasta_str)
        assert len(set(input_seqs)) == 1, \
            f"all proteins should have 1 chain in fasta file, given {len(input_seqs)} chains, for preotrin {protein_name}"
        all_proteins[protein_name] = (FastaChain(sequence=input_seqs[0], description=input_descs[0]))
    return all_proteins


all_defence_proteins = read_all_fasta_protein_folders(weizmann_config.EREZ_BACTERIA_PATH)
all_phage_proteins = read_all_fasta_protein_folders(weizmann_config.EREZ_PHAGE_PATH)


def get_series_of_protein_size(all_proteins: Dict[str, FastaChain]) -> pd.Series:
    protein_lengths = {}
    for protein_name, protein in all_proteins.items():
        protein_lengths[protein] = len(protein.sequence)

    return pd.Series(protein_lengths)


all_defence_lengths_ser = get_series_of_protein_size(all_defence_proteins)
all_defence_lengths_ser.hist().get_figure().savefig(Path(weizmann_config.IMAGES_DIR, "bacteras_size_hist.pdf"))

all_phages_lengths_ser = get_series_of_protein_size(all_phage_proteins)
all_phages_lengths_ser.hist().get_figure().savefig(Path(weizmann_config.IMAGES_DIR, "phages_size_hist.pdf"))
