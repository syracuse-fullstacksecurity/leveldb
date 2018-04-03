# Experiment Results


## Microbench Experiments


### Storage Overhead

This experiment compares the storage size for three implementation (unsecure LevelDB, LPAD and B-tree). The experiment is done on two data sets, a large one with one hundred  million records, and a small one with one million records.

Run the below command to generate the graph (storage.ps) in the same directory.
```
./storage.py
```

### Performance

#### Single Thread

This experiment compares the read/write latency for three implementation (unsecure LevelDB, LPAD and B-tree) in a single thread setting. 
Run the below command to generate the graph (single_read.ps, single_write.ps) in the same directory.
```
./single_read.py
./single_write.py
```

