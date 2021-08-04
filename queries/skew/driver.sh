#!/bin/bash

DEFAULT_QUERY="ALL"
DEFAULT_TABLES="NONE"
default_sampling=0.1
default_filter_joins_value="true"
# Query is the filename without the SQL extension
query=$1
# The tables to be sampled, comma separated, no space.
tables=$2
filter_joins=${3:-true}
for sampling_rate in 0.01 0.02 0.05 0.1 0.2 0.5
do
  sampling_pc=$(bc -l  <<< "$sampling_rate * 100")
  sed_cmd1="sed -i 's/sampling_rate="${default_sampling}"/sampling_rate="${sampling_rate}"/g' quickstep.cfg"
  reverse_sed_cmd1="sed -i 's/sampling_rate="${sampling_rate}"/sampling_rate="${default_sampling}"/g' quickstep.cfg"
  sed_cmd2="sed -i 's/sampling_tables=\"${DEFAULT_TABLES}\"/sampling_tables=\"${tables}\"/g' quickstep.cfg"
  reverse_sed_cmd2="sed -i 's/sampling_tables=\"${tables}\"/sampling_tables=\"${DEFAULT_TABLES}\"/g' quickstep.cfg"
  sed_cmd3="sed -i 's/QUERIES=\"${DEFAULT_QUERY}\"/QUERIES=\"${query}\"/g' quickstep.cfg"
  reverse_sed_cmd3="sed -i 's/QUERIES=\"${query}\"/QUERIES=\"${DEFAULT_QUERY}\"/g' quickstep.cfg"
  sed_cmd4="sed -i 's/use_filter_joins=${default_filter_joins_value}/use_filter_joins=${filter_joins}/g' quickstep.cfg"
  reverse_sed_cmd4="sed -i 's/use_filter_joins=${filter_joins}/use_filter_joins=${default_filter_joins_value}/g' quickstep.cfg"
  run_cmd="./run-benchmark.sh quickstep.cfg > "${query}"-samplingRate"${sampling_pc}"pc.log"
  for cmd in "$sed_cmd1" "$sed_cmd2" "$sed_cmd3" "$sed_cmd4" "$run_cmd" "$reverse_sed_cmd4" "$reverse_sed_cmd3" "$reverse_sed_cmd2" "$reverse_sed_cmd1"
  do
	  echo ${cmd}
	  eval ${cmd}
  done
  sleep 5s
done
