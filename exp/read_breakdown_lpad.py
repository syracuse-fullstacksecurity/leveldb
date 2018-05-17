#!/usr/bin/env python2
import numpy as np
import matplotlib.pyplot as plt
c_1 = np.array([[2.874,2.874,2.874],          #LPAD data standard standard standard
                    [1.926,1.926,1.926],
                    [9.736,9.736,9.736]]);     #LPAD data standard standard standard
c_1_colors = ['black', 'grey', 'white']
c_1_hatches = ['', '', '//']
c_1_labels = ['Data path', 'Proof preparation','Verification']
c_2 = np.array([[2.612,3.936,3.102],
                    [1.910,2.464,2.011],
                    [0.010,11.750,10.314]]);
#c_2_colors = ['skyblue', 'brown', 'y', 'blue']
#c_2_labels = ['PAL Code', 'Bash', 'App', 'Kernel']
ind = np.arange(3)    
width = 0.2    
f,ax = plt.subplots()
#f.subplots_adjust(bottom=0.2) #make room for the legend
plt.yticks(np.arange(0,22,5))
plt.xticks([0,0.125,0.25,1,1.125,1.25,2,2.125,2.25], ('Yes','\nwith SHA1?', 'No','124','\nrecord size, bytes','1240', '1', '\nmillion records','10'))
plt.suptitle('Read cost breakdown')
p = [] # list of bar properties
def create_subplot(matrix, matrix2, colors, hatches,axis, title):
	bar_renderers = []
	ind = np.arange(matrix.shape[1])
	bottoms = np.cumsum(np.vstack((np.zeros(matrix.shape[1]), matrix)), axis=0)[:-1]
	for i, row in enumerate(matrix):
		r = axis.bar(ind, row, width=0.2, color=colors[i], hatch=hatches[i],edgecolor='black',bottom=bottoms[i])
		bar_renderers.append(r)
	bottoms = np.cumsum(np.vstack((np.zeros(matrix2.shape[1]), matrix2)), axis=0)[:-1]
	for i, row in enumerate(matrix2):
		r1 = axis.bar(ind+0.25, row, width=0.2, color=colors[i], hatch=hatches[i],edgecolor='black',bottom=bottoms[i])
		bar_renderers.append(r1)
	return bar_renderers
        
p.extend(create_subplot(c_1,c_2,c_1_colors, c_1_hatches,ax, '1'))
##p.extend(create_subplot(c_2,c_2_colors, ax[1], '2'))
ax.set_ylabel('Exection Time (micro-seconds)') # add left y label
ax.set_ybound(0, 22) # add buffer at the top of the bars
f.legend(((x[0] for x in p)), # bar properties
(c_1_labels), 
bbox_to_anchor=(0.5, 0.8), 
loc='lower center',
ncol=3)
#plt.show()
plt.savefig("read_breakdown_lpad.ps");
