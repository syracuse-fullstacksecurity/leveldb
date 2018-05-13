#!/usr/bin/env bash
if [ $# -ne 1 ]; then
  echo -e "./tt_sh/reproduce.sh plottable/data_to_read.dat"
  exit
fi

file_result=$1

./tt_sh/prim_plot.sh $file_result analysis_results/figures "log" 'best'

#./tt_sh/prim_plot.sh $file_result analysis_results/figures "linear;log;linear" 'best' #'lower right;right;right'

