#!/bin/bash
function func {
  cp quickstep.cfg tmp.cfg
  probability_cust=$1
  probability_supp=$2
  probability_part=$3
  config_str="display_timing=false -sampling_tables=customer,supplier,part -sampling_rates="${probability_cust}","${probability_supp}","${probability_part}""
  echo ${config_str}
  sed -i "s/display_timing=false/$config_str/g" tmp.cfg

  sed -i "s/probability_cust/$probability_cust/g" *.sql
  sed -i "s/probability_supp/$probability_supp/g" *.sql
  sed -i "s/probability_part/$probability_part/g" *.sql

  ./run-benchmark.sh tmp.cfg 2>&1 | tee $4 

  git checkout -- *.sql
  rm -rf tmp.cfg
}

function funcskew {
  cp quickstep-skew.cfg tmp.cfg
  probability_cust=$1
  probability_supp=$2
  probability_part=$3
  config_str="display_timing=false -sampling_tables=customer,supplier,part -sampling_rates="${probability_cust}","${probability_supp}","${probability_part}""
  echo ${config_str}
  sed -i "s/display_timing=false/$config_str/g" tmp.cfg

  sed -i "s/probability_cust/$probability_cust/g" *.sql
  sed -i "s/probability_supp/$probability_supp/g" *.sql
  sed -i "s/probability_part/$probability_part/g" *.sql

  ./run-benchmark.sh tmp.cfg 2>&1 | tee $4 

  git checkout -- *.sql
  rm -rf tmp.cfg
}

func 0.01 0.8 0.9 valueset-1.log
func 0.8 0.9 0.01 valueset-2.log
func 0.8 0.1 0.7 valueset-3.log

./run-exact.sh exact.cfg 2>&1 | tee exact-result.log 

funcskew 0.01 0.8 0.9 skew-valueset-1.log
funcskew 0.8 0.9 0.01 skew-valueset-2.log
funcskew 0.8 0.1 0.7 skew-valueset-3.log

./run-exact.sh exact-skew.cfg 2>&1 | tee skew-exact-result.log 
