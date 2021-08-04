#!/bin/bash

function execute_queries() {
  DEFAULT_QUERY="ALL"
  for i in $1; do
    query="${i%.*}"
    default_filter_joins_value=true
    filter_joins=${3:-true}
    run_cmd="./run-benchmark.sh quickstep.cfg > "${query}".log"
    sed_cmd3="sed -i 's/QUERIES=\"${DEFAULT_QUERY}\"/QUERIES=\"${query}\"/g' quickstep.cfg"
    reverse_sed_cmd3="sed -i 's/QUERIES=\"${query}\"/QUERIES=\"${DEFAULT_QUERY}\"/g' quickstep.cfg"
    sed_cmd4="sed -i 's/use_filter_joins=${default_filter_joins_value}/use_filter_joins=${filter_joins}/g' quickstep.cfg"
    reverse_sed_cmd4="sed -i 's/use_filter_joins=${filter_joins}/use_filter_joins=${default_filter_joins_value}/g' quickstep.cfg"
    for cmd in "$sed_cmd3" "$sed_cmd4" "$run_cmd" "$reverse_sed_cmd4" "$reverse_sed_cmd3"
    do
	    echo ${cmd}
	    eval ${cmd}
    done
    sleep 5s
  done
} 

sed_cmd1="sed -i 's/RUNS=1005/RUNS=1/g' run-benchmark.sh"
reverse_sed_cmd1="sed -i 's/RUNS=1/RUNS=1005/g' run-benchmark.sh"
sed_cmd2="sed -i 's/120h/10m/g' run-benchmark.sh"
reverse_sed_cmd2="sed -i 's/10m/120h/g' run-benchmark.sh"

echo ${sed_cmd1}
eval ${sed_cmd1}
echo ${sed_cmd2}
eval ${sed_cmd2}

execute_queries "Exact*.sql" "part"

echo ${reverse_sed_cmd2}
eval ${reverse_sed_cmd2}
echo ${reverse_sed_cmd1}
eval ${reverse_sed_cmd1}
