# Given two input files, compute the accuracy of the experiment.
from extract import getDF
from split_fname import createDict
import glob

def validateDFs(exact_df, approx_df):
  err_msg = ''
  if exact_df.shape != (1, 1):
    err_msg = err_msg + 'Expected 1 row and 1 column in the exact dataframe, got ' + str(exact_df.shape[0]) + ' and ' + str(exact_df.shape[1]) + '\n'
  if approx_df.shape[1] != 1:
    err_msg = err_msg + 'Expected 1 column in approx dataframe, got : ' + str(approx_df.shape[1]) + '\n'
  if len(err_msg) > 0:
    print err_msg
    return False
  return True

def getExactResult(exact_df):
  return exact_df.iloc[0, 0]

def addErrorColumn(exact_result, approx_df):
  err_col = abs(approx_df.loc[:, 0] - exact_result)/exact_result 
  approx_df['error'] = 100.0 * err_col
  return approx_df

def getMeanError(exact_df, approx_df):
  if not validateDFs(exact_df, approx_df):
    return -100.0
  eresult = getExactResult(exact_df)
  newdf = addErrorColumn(eresult, approx_df)
  return newdf['error'].mean()

def getMeanResult(approx_df):
  return approx_df.loc[:, 0].mean()

def describeResult(exact_file, approx_file):
  d = createDict(approx_file)
  exact_df = getDF(exact_file)
  approx_df = getDF(approx_file)
  d['error'] = getMeanError(exact_df, approx_df)
  d['mean_approx_result'] = getMeanResult(approx_df)
  d['exact_result'] = getExactResult(exact_df)
  d['result_size'] = len(approx_df)
  return d
