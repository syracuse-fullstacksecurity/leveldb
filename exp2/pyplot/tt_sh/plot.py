#!/usr/bin/env python
import numpy as np
import matplotlib
matplotlib.rcParams['pdf.fonttype'] = 42
matplotlib.rcParams['ps.fonttype'] = 42
matplotlib.use('PS');
import matplotlib.pyplot as pp
import sys
#switch off the default Type-3 setting
pp.rc('pdf',fonttype = 42)
pp.rc('ps',fonttype = 42)

#check cmdline argument
if (len(sys.argv) != 5): #len(sys.argv)==1, when no argument, index start with 0, but note meaningful arg start with index=1
    print "format: ./plot.py file_name yscale[log|linear]+(#=#metrics) legend_loc[upper|lower right|left]+(#=#metrics) output_dir"
    print "example1: ./plot.py raw_results/data_to_read.dat log 'upper right' analysis/figures"
    print "example2: ./plot.py raw_results/data_to_read.dat log;linear 'upper right' analysis_results/figures"
    sys.exit(1)

################################################################################
#################          CONFIG ZONE         #################################
################################################################################

config_marksizes = ['12', '10', '12', '12', '12', '12', '12', '12', '12', '12']
config_scaling = 1
config_font_size='x-large'; 
  #it can be [ size in points | xx-small | x-small | small | medium | large | x-large | xx-large ]
  #f:http://matplotlib.org/examples/pylab_examples/filledmarker_demo.html
config_fmts = ['+-', 'x-', 'v-', 'o-', '*-', '<-', '>-', 's-', 'd-', '^-']
config_colors = ['red', 'blue', 'black', 'magenta', 'cyan', 'green']
max_y = []
min_y = 0 #always start from 0.
#prev:    min_y = 1e308 #biggest value of double precision floats in python

################################################################################
################################################################################
################################################################################

yscales_str = sys.argv[2]
yscales = yscales_str.split(';')

#series patterns
for yscale in yscales:
    if ((yscale != 'log') & (yscale != 'linear')):
        print "yscale (2nd argument) should be [linear|log]" 
        sys.exit(1)

legend_locs_str = sys.argv[3]
legend_locs = legend_locs_str.split(';')

#read file to fill data
file_name = sys.argv[1]
output_dir = sys.argv[4]
file = open(file_name,'r')
x_data = []
metrics = [];
y_data_series_metrics = [] #[series_idx][metric_idx][x]
yerr_data_series_metrics = [] #[series_idx][metric_idx][x]
series_labels = []

series_idx = -1
num_metrics = 0
while (2 > 1):
    firstline = file.readline();
    while(firstline.isspace()):
        firstline = file.readline()
    if(len(firstline) == 0):
        break # reach EOF
    #FORDEBUG: print "first_line=" + firstline 
    y_data_series_metrics.append([])
    yerr_data_series_metrics.append([])
    series_idx = series_idx + 1
    if(not 'null' in firstline):
        #var firstline may contain newline character
        series_labels.append(firstline)
        #else, don't show legend
    metric_index_plusone = 0
    secondline = file.readline();
    raw_words_secondline = secondline.strip().split('\t'); #strip() is used to avoid 'hidden' whitespace or tab in the line end in data file.
    #raw word may contains \n, since it's split by \t only.
    words_secondline = [a_word.strip('\n') for a_word in raw_words_secondline] 
    #FORDEBUG:    print "content_line=" + secondline + ", num_of_words=" + str(len(words_secondline))
    for word in words_secondline:
        metric_index_plusone = metric_index_plusone + 1
        if(metric_index_plusone == 1):
            x_label = word
        else:
            if(series_idx == 0):
                metrics.append(word)
                num_metrics = metric_index_plusone - 1 # minus one due to X
                max_y = [-1e308] * num_metrics
            y_data_series_metrics[series_idx].append([])
            yerr_data_series_metrics[series_idx].append([])
    while (2 > 1):
        line = file.readline();
        if(line.isspace() or len(line) == 0):
            break
        raw_words = line.strip().split('\t')#strip() is used to avoid 'hidden' whitespace or tab in the line end in data file.
        #use list comprehension in python to create list in concise way
        #now words without newline in them
        words = [a_word.strip('\n') for a_word in raw_words] 
        #FORDEBUG:         print "content_line=" + line + ", num_of_words=" + str(len(words))
        if(series_idx == 0):
            word = float(words[0])
            if(word.is_integer()):
                x_data.append(int(word))
            else:
                x_data.append(word)
        for metric_idx in xrange(1, len(words)): # inclusive in array end
            #data file disable plotting one position by setting value to null
            split_idx = words[metric_idx].find('|')
            if(split_idx!=-1): #found
                if(words[metric_idx][0:split_idx] == 'null'):
                    word = float('nan')
                    err = float('nan')
                else:
                    word = float(words[metric_idx][0:split_idx])
                    err = float(words[metric_idx][split_idx+1:])
            else:
                if(words[metric_idx] == 'null'):
                    word = float('nan')
                else:
                    word = float(words[metric_idx])
            if(split_idx!=-1): #found
                y_data_series_metrics[series_idx][metric_idx-1].append(word)
                yerr_data_series_metrics[series_idx][metric_idx-1].append(err)
            else:
                y_data_series_metrics[series_idx][metric_idx-1].append(word)

if (len(yscales) != 1 and len(yscales) != num_metrics):
    print "# of yscales (by cmdline argument 2, e.g., log;log)=" + str(len(yscales)) + " should be equal to neither 1 or # of metrics (which is " + str(num_metrics) + ")"
    sys.exit(1)

if (len(legend_locs) != 1 and len(legend_locs) != num_metrics):
    print "# of legend_locs is neither 1 or # of metrics (which is " + str(num_metrics) + ")"
    sys.exit(1)

#x_data = ['1', '2', '3', '4', '5', '6']
x_len = len(x_data)

#plot
for metric_idx in xrange(0, num_metrics):
    #plot series 
    pp.cla() #clear axis
    pp.clf() #clear figure
    for idx_series in xrange(0, len(y_data_series_metrics)):
        x_len_per_series = len(y_data_series_metrics[idx_series][metric_idx])
        if len(series_labels) == 0:
            if(len(yerr_data_series_metrics[idx_series][metric_idx]) > 0):
                pp.errorbar(xrange(0, x_len_per_series), y_data_series_metrics[idx_series][metric_idx][0:x_len_per_series], yerr=yerr_data_series_metrics[idx_series][metric_idx][0:x_len_per_series], fmt=config_fmts[idx_series], color=config_colors[idx_series], markersize=config_marksizes[idx_series])
            else:
                pp.plot(xrange(0, x_len_per_series), y_data_series_metrics[idx_series][metric_idx][0:x_len_per_series], config_fmts[idx_series], color=config_colors[idx_series], markersize=config_marksizes[idx_series])
        else:
            #error bar
            if(len(yerr_data_series_metrics[idx_series][metric_idx]) > 0):
                pp.errorbar(xrange(0, x_len_per_series), y_data_series_metrics[idx_series][metric_idx][0:x_len_per_series], yerr=yerr_data_series_metrics[idx_series][metric_idx][0:x_len_per_series], fmt=config_fmts[idx_series], label=series_labels[idx_series], color=config_colors[idx_series], markersize=config_marksizes[idx_series])
            else:
                pp.plot(xrange(0, x_len_per_series), y_data_series_metrics[idx_series][metric_idx][0:x_len_per_series], config_fmts[idx_series], label=series_labels[idx_series], color=config_colors[idx_series], markersize=config_marksizes[idx_series])
        if(len(yerr_data_series_metrics[idx_series][metric_idx]) > 0):
            a = y_data_series_metrics[idx_series][metric_idx]
            b = yerr_data_series_metrics[idx_series][metric_idx]
            c = [-1] * len(a)
            for i in xrange(len(a)): c[i] = a[i] + b[i]
            max_y_cur = np.nanmax(c)
        else:
            max_y_cur = np.nanmax(y_data_series_metrics[idx_series][metric_idx])

        if max_y[metric_idx] < max_y_cur:
            max_y[metric_idx] = max_y_cur
#min_y is always start from 0
#        min_y_cur = np.nanmin(y_data_series_metrics[idx_series][metric_idx])
#        if min_y > min_y_cur:
#            min_y = min_y_cur

    if len(legend_locs) > 1:
        legend_loc = legend_locs[metric_idx]
    else: 
        legend_loc = legend_locs[0]
    if( len(series_labels) != 0 ):
        leg = pp.legend( series_labels, loc=legend_loc, prop={'size':config_font_size} )
    pp.axis([-0.5, x_len-0.5, min_y*0.8, max_y[metric_idx]*1.1])   
    t_xlabel = x_label 
    pp.xlabel(t_xlabel, fontsize=config_font_size)
    pp.ylabel(metrics[metric_idx], fontsize=config_font_size)
    xticks = []
    xticklabels = []
    for idx in xrange(0,x_len):
        if idx % config_scaling == 0:
            xticks.append(idx)
            xticklabels.append(x_data[idx])
        else:
            if idx * 2 % config_scaling == 0:
              xticks.append(idx)
              xticklabels.append('');
    pp.axes().set_xticks(xticks[0:len(xticks)]);
    pp.axes().set_xticklabels(xticklabels[0:len(xticklabels)])
    # the above make sure two x_axes ticks get one labeled.
    if len(yscales) > 1:
        yscale = yscales[metric_idx]
    else:
        yscale = yscales[0]
    if (yscale == 'log') & (min_y == 0) : #handle case where y=0, which log scaled y axis can't normally show properly
        pp.yscale('symlog')
    else:
        pp.yscale(yscale);

    #remove (, which is not acceptable to be in file name.
    #file name is metric name (y axis) plus x axis name.
    raw_filename = str(metrics[metric_idx]).split('(')[0] + '-' + t_xlabel.split('(')[0]
    filename = raw_filename.replace(" ", "") #raw_filename may contain whitespace

    pp.axes().tick_params(labelsize=config_font_size);
    #pp.suptitle('main title', fontsize=config_font_size)

    pp.savefig(output_dir + '/' + 'exp-' + filename + '.eps')

