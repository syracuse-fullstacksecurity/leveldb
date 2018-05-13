#!/usr/bin/env bash

input=${input-plottable/unalign.dat}
output=${output-plottable/aligned.dat}

awk 'NF != 0 && match($0, /^[0-9.]+\t/) {print $1}' $input | sort -n | uniq > x_values
#sort -n: numeric sroting
#uniq: remove duplicated

awk '
BEGIN{
  series_idx=-1
  last_empty_line=1
  file = 0
}

FNR == 1 {
  file++;
}

file == 1 {
  aligned_line_idx=FNR-1
  x_value[aligned_line_idx]=$1
  aligned_line_nr = FNR
  next;
}

file == 2 {
 if (NF == 0) {
   last_empty_line=1
   while(aligned_line_idx < aligned_line_nr){
      print x_value[aligned_line_idx++]"\tnull"
   }
   print "" #empty line to separate series
 } else {
  if(last_empty_line == 1){
    series_idx++
    last_empty_line=0
    cur_series_line_nr=FNR
    aligned_line_idx=0
#print series_idx
  }

  if(match($0, /^[0-9.]+\t/)){ #data line
    while($1 > x_value[aligned_line_idx]){
      print x_value[aligned_line_idx++]"\tnull"
    }
    if($1 == x_value[aligned_line_idx]){
      aligned_line_idx++
    }
    print $0
  } else {
    print $0
  }

 }
}

' x_values $input \
> $output

rm x_values
