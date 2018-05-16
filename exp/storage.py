#!/usr/bin/env python2
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
from collections import namedtuple
from matplotlib.patches import Ellipse, Polygon


n_groups = 2

means_baseline = (1,1)

means_lpad = (1.22,1.13)

means_btree = (1.61,1.57)

fig, ax = plt.subplots()

index = np.arange(n_groups)
bar_width = 0.2

opacity = 0.4
error_config = {'ecolor': '0.3'}

rects1 = ax.bar(index, means_baseline, bar_width,
                color = 'white', edgecolor='black',
                 error_kw=error_config,
                label='Ideal')

rects2 = ax.bar(index + bar_width, means_lpad, bar_width,
                color = 'white', edgecolor='black',
                 error_kw=error_config,
                label='LPAD')

rects3 = ax.bar(index + bar_width + bar_width, means_btree, bar_width,
                color = 'white', edgecolor='black',
                 error_kw=error_config,
                label='B-tree');

for bar in rects1.get_children():
#	bar.set_hatch("-");
        bar.set_facecolor("black");
for bar in rects2.get_children():
#	bar.set_hatch("o");
        bar.set_facecolor("grey");
for bar in rects3.get_children():
	bar.set_hatch("//");

ax.set_xlabel('Number of records')
ax.set_ylabel('Normalized Storage Size')
ax.set_title('Storage size comparison (Single record size: 116 bytes)')
ax.set_xticks(index + bar_width)
ax.set_xticklabels(('100 million', '1000 million'))
ax.legend()

#fig.tight_layout()
plt.show()
#plt.savefig('storage.ps')
