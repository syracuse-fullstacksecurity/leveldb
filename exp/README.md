Show the results
---


```bash
cd exp
./run.sh
```


# (JU) Experiment Results

## Microbench: Server-side,LPAD/TPAD

### Storage Overhead

This experiment compares the storage size for three implementation (unsecure LevelDB, LPAD and B-tree). The experiment is done on two data sets, a large one with one hundred  million records, and a small one with one million records.

Run the below command to generate the graph (storage.ps) in the same directory.

```
./storage.py
```

### Performance

#### Single-Thread client

This experiment compares the read/write latency for three implementation (unsecure LevelDB, LPAD and B-tree) in a single thread setting. 
Run the below command to generate the graph (single_read.ps, single_write.ps) in the same directory.
```
./single_read.py
./single_write.py
```

#### Multi-thread: all 8 for readers (or all 8 for writers)

This experiment compares the read/write latency and throughput for three implementation in a multi-thread setting.
Run the below command to generate the graph (multi_read.ps, multi_write.ps, multi_read_thru.ps, multi_write_thru.ps) in the same directory.

```
./multi_read.py
./multi_write.py
./multi_read_thru.py
./multi_write_thru.py
```

### Record size impact

This experiment study the value size impacts on the performance of the LPAD design.

```
./single_read_vsize.py
./single_write_vsize.py
./multi_read_vsize.py
./multi_write_vsize.py
```

## YCSB benchmark: Server/enclave-client

### Server/enclave-client (reading a merged LSM, writing without merge),LPAD

This experiment studies the performance characteristics under YCSB workloads with varying write/read ratioes. The experiments are done in memory intensive workloads and disk intensive workloads.

```
ycsb_mem.dat
ycsb_disk.dat
```

### Client-only (reading a merged LSM, writing without merge),LPAD/TPAD

This experiment studies the performance of the client side's verification.

```
ycsb_fe.dat
```



