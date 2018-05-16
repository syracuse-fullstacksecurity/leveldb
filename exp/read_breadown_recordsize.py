#!/usr/bin/env python2
import numpy as np
import matplotlib.pyplot as plt
c_1 = np.array([[2.874, 3.936],
                    [1.926,2.464],
                    [9.736,11.750]]);
c_1_colors = ['black', 'grey', 'white']
c_1_hatches = ['', '', '//']
c_1_labels = ['Data path', 'Proof preparation', 'Verification']
c_2 = np.array([[1.700,1.810],
                    [8.900,8.906],
                    [1.000,2.200]]);
#c_2_colors = ['skyblue', 'brown', 'y', 'blue']
#c_2_labels = ['PAL Code', 'Bash', 'App', 'Kernel']
ind = np.arange(2)    
width = 0.2    
f,ax = plt.subplots()
#f.subplots_adjust(bottom=0.2) #make room for the legend
plt.yticks(np.arange(0,18,5))
plt.xticks([0,0.25,1,1.25], ('LPAD (124-byte record)', 'B-tree (124-byte record)','LPAD (1240-byte record)','B-tree (1240-byte record)'))
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
ax.set_ybound(0, 20) # add buffer at the top of the bars
f.legend(((x[0] for x in p)), # bar properties
(c_1_labels), 
bbox_to_anchor=(0.5, 0), 
loc='lower center',
ncol=3)
plt.show()
