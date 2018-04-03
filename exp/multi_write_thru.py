#!/usr/bin/env python2
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
from collections import namedtuple


n_groups = 2

means_baseline = (13.2,14.3)

means_lpad = (4.8,6.1)

means_btree = (0.9,1)

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

ax.set_xlabel('Number of records (16-byte key, 100-byte)')
ax.set_ylabel('Throughput (MB/s)')
ax.set_title('Multi-thread write througput')
ax.set_xticks(index + bar_width)
ax.set_xticklabels(('100 million', '1 million'))
ax.legend()

#fig.tight_layout()
#plt.show()
plt.savefig('multi_write_thru.ps')
