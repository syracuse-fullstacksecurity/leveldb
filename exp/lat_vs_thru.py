#!/usr/bin/env python2
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
#line_up ,= plt.plot([2862,5450,10044,18658], [349.4,366.8,398.1,428.3], '-bD') 
#line_down ,= plt.plot([3192,5649,10283,19029],[313.3,354,388.8,420], '-rp')
#plt.axis([2000, 20000, 300, 450])
ideal ,= plt.plot([4192,7235,14311,18938], [201,274,277,419], '-bD') 
lpad ,= plt.plot([770,1075,1549,1884],[1294,1856,2573,4230], '-rx')
#naive_read ,= plt.plot([3005,4011,4401,4425,4431,4454], [148,252,400,450,560,630], '-cD') 
plt.axis([750, 19000, 190, 4240])
plt.xlabel('Throughput(Ops/sec)')
plt.ylabel('Latency(usec)')
#plt.annotate('T=2', xy=(0.55,0.45), xycoords='axes fraction')
plt.legend( [ideal,lpad], ['Unsecure (Ideal)','LPAD'], loc='best' )
#plt.show()
#plt.savefig('/Users/chenju2k6/Downloads/plot_figure/zipfian_newtpad.ps')


#line_up ,= plt.plot([5702,8345,11575,18387], [175.4,239.7,345.3,434.8], '-bD') 
#line_down ,= plt.plot([6352,9115,12674,19760],[157.4,219.4,315.4,404.7], '-rp')
#plt.axis([5000, 20000, 100, 450])
#plt.xlabel('Latency(usec)')
#plt.ylabel('Throughput(Ops/sec)')
#plt.annotate('T=2', xy=(0.55,0.45), xycoords='axes fraction')
#plt.legend( [line_up,line_down], ['Baseline','TrustKV'], 'best' )
#plt.savefig('/Users/chenju2k6/Downloads/conrww.eps')
