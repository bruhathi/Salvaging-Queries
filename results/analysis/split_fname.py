# Given a file name return split it in a list
# that describes the experimental config.
import re
import glob

delimiters=['/', '_', '-', '.']
results_dirname='results'

def splitFileName(filename):
  tokens = re.split(r'(/|_|-|\.)', filename)
  filtered_tokens = [t for t in tokens if t not in delimiters and len(t) > 0]
  left_idx = filtered_tokens.index(results_dirname)
  right_idx = -1 
  if filtered_tokens[-2].endswith('pc'):
    right_idx = -2 
  return filtered_tokens[left_idx + 1 : right_idx]

# using a keyword, find if a term with that prefix exists in the list.
# if so, extract the right substring.
# for example: keyword = 'Selectivity', l = ['Selectivity50'], return 50
# If not found, return a default value which is -1
def findSubStr(keyword, l):
  matches = filter(lambda x : keyword in x, l)
  if len(matches) > 0:
    # We assume only one match.
    return int(matches[0][len(keyword):])
  return -1

# Given a list of string, there's one string which is numeric.
# Return it. Return -1 if not found. 
def extractQueryNum(l):
  for i in l:
    if i.isdigit():
      return int(i)
  return -1

def createDict(filename):
  l = splitFileName(filename)
  res = dict()
  res['dataset'] = l[0]
  res['design'] = l[1]
  res['selectivity'] = int(findSubStr('Selectivity', l))
  res['sampling_rate'] = int(findSubStr('samplingRate', l))
  res['query'] = int(extractQueryNum(l))
  res['filename'] = filename.split('/')[-1]
  return res
