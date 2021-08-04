import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
from matplotlib import rc_file

uniform_file = "../analysis/out_uniform.csv"
skew_file = "../analysis/out_skew.csv"

data_types = {"dataset": "object", 
              "design": "object",
              "error": "float64",
              "exact_result": "int64",
              "filename": "object",
              "mean_approx_result": "int64",
              "query": "int64",
              "result_size": "int64",
              "sampling_rate": "int64",
              "selectivity": "int64"}

def getDF(fname):
  return pd.read_csv(fname, dtype=data_types, header=0)

uniform_df = getDF(uniform_file)
skew_df = getDF(skew_file)

def getBaseDF(filename, qid):
  df = getDF(filename)
  return df[df["query"] == qid][["sampling_rate", "design", "error", "selectivity"]]

def getPlot(base_df, output_name, availabilities = [1, 10, 50], selectivities = [1, -1, 50], selectivity_str=["1", "default", "50"]): 
  rc_file('matplotlibrc')
  plt.rcParams['figure.titlesize'] = 'xx-large'
  plt.rcParams['axes.titlesize'] = 10.0
  plt.rcParams['axes.labelsize'] = 10.0
  plt.rcParams['legend.fontsize'] = 10.0
  width = 0.2
  offset = -1 * width
  x_locs = np.arange(1, len(selectivities) + 1)
  colors = sns.color_palette("colorblind", 3)
  designs = base_df["design"].unique().tolist()
  fig, axes = plt.subplots(nrows=len(availabilities), sharex=True)

  for a, ax in zip(availabilities, axes): 
      plot_list = []
      plot_df = base_df[base_df["sampling_rate"] == a][["design", "error", "selectivity"]]    
      for d in designs:
          curr_list = []
          for s in selectivities:
              data = plot_df[(plot_df["selectivity"] == s) & (plot_df["design"] == d)]["error"].tolist()
              curr_list.append(data[0])
          plot_list.append(curr_list)

      ax.bar(x_locs + offset, plot_list[0], width, color = colors[0], label = designs[0], edgecolor='b', linewidth=0.1)
      ax.bar(x_locs, plot_list[1], width, color = colors[1], label = designs[1], edgecolor='b', linewidth=0.1)
      ax.bar(x_locs - offset, plot_list[2], width, color = colors[2], label = designs[2], edgecolor='b', linewidth=0.1)

      ax.set_xticks(x_locs)
      ax.tick_params(axis='both', direction='in')
      ax.grid(color='grey', linestyle='dotted', axis='y', which='major')
      ax.tick_params(axis="x", bottom=False)
      ax.yaxis.set_major_locator(mpl.ticker.MaxNLocator(3))
      ax.set_title("Availability=" + str(a) + "%")
      ax.set_ylabel("Error (%)")
      
  axes[-1].set_xticklabels(selectivity_str)
  axes[0].legend(loc='upper left', ncol=3, bbox_to_anchor=(0.1, 1.9), frameon=False)
  axes[-1].set_xlabel("Selectivity (%)")

  plt.tight_layout()
  plt.savefig(output_name) 
  plt.close()

def getSinglePlotErrVsAvail(base_df, output_name, qid, availabilities, selectivity=-1):
  rc_file('matplotlibrc-fullcolumn')
  plt.rcParams['figure.figsize'] = [3.4, 1.5]
  width = 0.2
  offset = -1 * width
  x_locs = np.arange(1, len(availabilities) + 1)
  colors = sns.color_palette("colorblind", 3)
  designs = base_df["design"].unique().tolist()
  fig, ax = plt.subplots()

  plot_list = []
  for d in designs:
    design_values = []
    plot_df = base_df[base_df["design"] == d][["sampling_rate", "error", "selectivity"]]    
    for a in availabilities:
      data = plot_df[plot_df["sampling_rate"] == a]["error"].tolist()
      design_values.append(data[0])
    plot_list.append(design_values)

  ax.bar(x_locs + offset, plot_list[0], width, color = colors[0], label = designs[0], edgecolor='b', linewidth=0.1)
  ax.bar(x_locs, plot_list[1], width, color = colors[1], label = designs[1], edgecolor='b', linewidth=0.1)
  ax.bar(x_locs - offset, plot_list[2], width, color = colors[2], label = designs[2], edgecolor='b', linewidth=0.1)

  ax.set_xticks(x_locs)
  ax.tick_params(axis='both', direction='in')
  ax.grid(color='grey', linestyle='dotted', axis='y', which='major')
  ax.tick_params(axis="x", bottom=False)
  ax.yaxis.set_major_locator(mpl.ticker.MaxNLocator(5))
  ax.set_xticklabels(availabilities)
  ax.set_ylabel("Error (%)")
  ax.set_xlabel("Availability (%)")
  ax.legend(frameon=False)

  plt.tight_layout()
  plt.savefig(output_name) 
  plt.close()

# Similar to getSinglePlotErrVsAvail, except that we only look
# at a single design in this case. 
def getSinglePlotErrVsAvailSingleDesign(base_df, output_name, qid, availabilities, selectivity=-1):
  rc_file('matplotlibrc-fullcolumn') 
  plt.rcParams['figure.figsize'] = [3.4, 1.5]
  width = 0.4
  x_locs = np.arange(1, len(availabilities) + 1)
  designs = ["WD"] 
  fig, ax = plt.subplots()
  colors = sns.color_palette("colorblind", 3)

  plot_list = []
  for d in designs:
    design_values = []
    plot_df = base_df[base_df["design"] == d][["sampling_rate", "error", "selectivity"]]    
    for a in availabilities:
      data = plot_df[plot_df["sampling_rate"] == a]["error"].tolist()
      design_values.append(data[0])
    plot_list.append(design_values)

  ax.bar(x_locs, plot_list[0], width, color = colors[-1], label = designs[0], edgecolor='b', linewidth=0.1)

  ax.set_xticks(x_locs)
  ax.tick_params(axis='both', direction='in')
  ax.grid(color='grey', linestyle='dotted', axis='y', which='major')
  ax.tick_params(axis="x", bottom=False)
  ax.yaxis.set_major_locator(mpl.ticker.MaxNLocator(5))
  ax.set_xticklabels(availabilities)
  ax.set_ylabel("Error (%)")
  ax.set_xlabel("Availability (%)")

  plt.tight_layout()
  plt.savefig(output_name) 
  plt.close()

def plotVariance(data_file, output_name):
  rc_file('matplotlibrc-fullcolumn') 
  plt.rcParams['figure.figsize'] = [6.8, 3.4]
  plt.rcParams['axes.titlesize'] = 13.0
  plt.rcParams['axes.labelsize'] = 13.0
  plt.rcParams['axes.labelsize'] = 13.0
  plt.rcParams['xtick.labelsize'] = 13.0
  plt.rcParams['ytick.labelsize'] = 13.0
  width = 0.2
  data_types = {"combination" : "object",
      "observed variance" : "float64",
      "c-p-s": "float64",
      "c-s-p": "float64",
      "p-c-s": "float64",
      "p-s-c": "float64",
      "s-c-p": "float64",
      "s-p-c": "float64"}
  df = pd.read_csv(data_file, dtype=data_types, header=0, sep="#")
  fig, axes = plt.subplots(nrows=3, ncols=1, sharex=True)
  sequences = df.columns[2:].tolist()
  colors = sns.color_palette("colorblind", len(sequences))
  x_locs = np.arange(1, len(sequences) + 1)
  axes[0].bar(x_locs, df.iloc[0][2:], width, color=colors)
  axes[1].bar(x_locs, df.iloc[1][2:], width, color=colors)
  axes[2].bar(x_locs, df.iloc[2][2:], width, color=colors)
  axes[0].set_title('Combination 1: ' + df.iloc[0][0])
  axes[1].set_title('Combination 2: ' + df.iloc[1][0])
  axes[2].set_title('Combination 3: ' + df.iloc[2][0])

  for ax in axes:
    ax.grid(color='grey', linestyle='dotted', axis='y', which='major')
    #ax.yaxis.set_major_locator(mpl.ticker.FixedLocator([0.33, 0.66, 1.0]))
    ax.set_yticks([0.33, 0.66, 1.0])
    ax.set_xticks(x_locs)
    ax.set_xticklabels(sequences)
  axes[2].set_xlabel("Sequence")
  axes[2].set_xticks(x_locs)
  axes[-1].set_xticklabels(sequences)
  axes[1].set_ylabel("Ratio")
  plt.tight_layout()
  plt.savefig(output_name)
  plt.close()

def masterFn():
  for qid in [3, 6]:  
    uniform_df = getBaseDF(uniform_file, qid)
    uniform_output_name = 'query-'+ str(qid) + '-uniform.pdf'
    getPlot(uniform_df, uniform_output_name)
    skew_df = getBaseDF(skew_file, qid)
    skew_output_name = 'query-'+ str(qid) + '-skew.pdf'
    getPlot(skew_df, skew_output_name, [1, 10, 50], [-1, 1, 20], ["default", "1", "20"])
  getSinglePlotErrVsAvail(getBaseDF(uniform_file, 9), 'q9-uniform-alldesigns-error.pdf', 9, [1, 2, 5, 10, 20, 50])
  getSinglePlotErrVsAvail(getBaseDF(uniform_file, 19), 'q19-uniform-alldesigns-error.pdf', 19, [1, 2, 5, 10, 20, 50])
  getSinglePlotErrVsAvailSingleDesign(getBaseDF(uniform_file, 17), 'q17-wd-error.pdf', 17, [1, 2, 5, 10, 20, 50])
  plotVariance("../variance/results.csv", "variance-plot.pdf")

masterFn()
