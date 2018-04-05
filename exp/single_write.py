#!/usr/bin/env python2
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
from collections import namedtuple


n_groups = 2

means_baseline = (8.302,6.961)

means_lpad = (17.646,15.656)

means_btree = (132.101,125.102)

fig, ax = plt.subplots()

index = np.arange(n_groups)
bar_width = 0.2

opacity = 0.4
error_config = {'ecolor': '0.3'}

rects1 = ax.bar(index, means_baseline, bar_width,
                alpha=opacity, color='b',
                 error_kw=error_config,
                label='Baseline')

rects2 = ax.bar(index + bar_width, means_lpad, bar_width,
                alpha=opacity, color='r',
                 error_kw=error_config,
                label='LPAD')

rects3 = ax.bar(index + bar_width + bar_width, means_btree, bar_width,
                alpha=opacity, color='y',
                 error_kw=error_config,
                label='B-tree')
for bar in rects1.get_children():
        bar.set_hatch("-");
for bar in rects2.get_children():
        bar.set_hatch("o");
for bar in rects3.get_children():
        bar.set_hatch("*");

ax.set_xlabel('Number of records (16-byte key, 100-byte)')
ax.set_ylabel('Latency (micro-seconds)')
ax.set_title('Single thread write latency')
ax.set_xticks(index + bar_width)
ax.set_xticklabels(('100 million', '1 million'))
ax.legend()

#fig.tight_layout()
plt.show()
plt.savefig('single_write.ps')
