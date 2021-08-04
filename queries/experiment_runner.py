#!/usr/bin/env python3
import argparse
import os
import tempfile

sampling_rates=[0.01, 0.02, 0.05, 0.1, 0.2, 0.5]

parser = argparse.ArgumentParser()
parser.add_argument("-num_runs", default=1000, help="Number of runs for a query", type=int)
parser.add_argument("-infile", help="Input SQL file", type=argparse.FileType('r'))
parser.add_argument("-output_dir", help="Output directory location", type=argparse.FileType('w'))
args = parser.parse_args()

with args.infile as in_file:
  sql_text=args.num_runs * in_file.read()

tmp = tempfile.NamedTemporaryFile(suffix='.sql')

with open(tmp.name, 'w') as f:
  f.write(sql_text)

print("Filename: ", tmp.name)
with open(tmp.name, 'r') as f:
  print(f.read())
