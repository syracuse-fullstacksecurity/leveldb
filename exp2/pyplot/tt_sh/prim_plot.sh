#!/bin/bash
if [ $# -ne 4 ]; then
  echo -e "./tt_sh/prim_plot.sh input_file output_figure_dir curve_type legend_loc"
  echo -e "./tt_sh/prim_plot.sh input_file output_figure_dir \"linear;log;linear\" \"center right; right; left\""
  exit 1
fi

input_file=$1
output_figure_dir=$2
curve_type=$3
legend_loc=$4

rm -rf $output_figure_dir
mkdir -p $output_figure_dir

./tt_sh/plot.py $input_file "$curve_type" "$legend_loc" $output_figure_dir
if [ $? -ne 0 ]; then
  exit $?
fi 

cd $output_figure_dir
for f in ./*.eps; do
  ps2pdf $f
done 

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Ubuntu
    sudo -u $(whoami) evince *.pdf &
else 
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    open -a Preview *.pdf &
  fi
fi

