# Read a config file describing the exact file and approximate file pairs.
# Compute the accuracy of each pair.
# Create a combined result of all pairs.
# The structure of input config file is (without the <>):
# <path of an exact file>,<regex for paths of approx files>
# If a line starts with #, we ignore it.
import glob
import pandas as pd
import os
from accuracy import describeResult

def validateFiles(efile, afiles):
  if len(efile) == 0 or len(afiles) == 0:
    return False
  ret = True
  if not os.path.exists(efile):
    print 'Exact file does not exist: ' + str(efile)
    ret = False
  for f in afiles:
    if not os.path.exists(f):
      print 'Approx file does not exist: ' + str(f)
      ret = False
  return ret 

# Read a line and construct the file objects.
def getFileNames(line):
  if line.startswith('#'):
    return '', []
  expressions = line.split(',')
  exact_file = expressions[0]
  approx_files = glob.glob(expressions[1])
  return exact_file, approx_files

def convertColToInt(df, col_names):
  for c in col_names:
    df[c] = df[c].astype(int)
  return df

def createOutput(config_file, output_file):
  output = pd.DataFrame()
  with open(config_file) as f:
    for cnt, line in enumerate(f):
      line = line.strip()
      efile, afiles = getFileNames(line)
      if validateFiles(efile, afiles):
        for afile in afiles:
            res_dict = describeResult(efile, afile)
            output = output.append(res_dict, ignore_index=True)
  output = convertColToInt(output, ['query', 'sampling_rate', 'selectivity', 'result_size', 'exact_result', 'mean_approx_result'])
  output = output.sort_values(by=['query','design','selectivity','sampling_rate'])
  output.to_csv(output_file, index=False, float_format='%.3f')

config_files = ['skew_config.txt', 'uniform_config.txt']
output_files = ['out_skew.csv', 'out_uniform.csv']

for i in range(len(config_files)):
  createOutput(config_files[i], output_files[i]) 
