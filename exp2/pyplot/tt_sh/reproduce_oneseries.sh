#!/bin/bash
echo -e "./tt_sh/reproduce.sh"
./tt_sh/prim_plot.sh raw_results/data_to_read_oneseries.dat analysis_results/figures "linear;log;log" 'best' #'lower right;right;right'
