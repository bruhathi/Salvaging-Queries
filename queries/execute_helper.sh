#!/bin/bash

function execute_queries() {
  for i in $1; do
    filename="${i%.*}"
    filter_join=${3:-true}
    cmd="./driver.sh ${filename} $2 ${filter_join}"
    echo ${cmd}
    eval ${cmd}
  done
} 

execute_queries "SdWithRedundancy*_03.sql" "lineitem"
execute_queries "SdWoRedundancy*_03.sql" "customer"
execute_queries "WD*_03.sql" "customer"
execute_queries "SdWithRedundancy*_06.sql" "lineitem"
execute_queries "SdWoRedundancy*_06.sql" "customer"
execute_queries "WD*_06.sql" "part"
execute_queries "SdWithRedundancy*_09.sql" "lineitem"
execute_queries "SdWoRedundancy*_09.sql" "customer,part" "false"
execute_queries "WD*_09.sql" "part"
execute_queries "WD*_17.sql" "part"
execute_queries "SdWithRedundancy*_19.sql" "lineitem"
execute_queries "SdWoRedundancy*_19.sql" "customer,part"
execute_queries "WD*_19.sql" "part"
