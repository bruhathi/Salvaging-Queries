import pandas as pd
import re

re_d = re.compile('\d+')

def filterStr(input):
  if not input.startswith('|'):
    return False
  if not input.endswith('|'):
    return False
  if re_d.search(input) or 'NULL' in input:
    return True
  return False
 
# Given a string separated by pipe (character) and whitespaces,
# return a tokenized version of the row.
def tokenizeLine(input):
  try:
    return [float(k) for k in re.split('[ |]', input) if len(k) > 0]
  except ValueError:
    # print "Non numeric data found in the row: " + str(input)
    return []

# Return a dataframe excluding the rows in which at least one 
# of the column's value is non-numeric.
def getDF(fileName):
  with open(fileName, "r") as f:
    contents = f.read().splitlines()
    output = map(tokenizeLine, filter(filterStr, contents))
  df = pd.DataFrame([l for l in output if len(l) > 0])
  return df
