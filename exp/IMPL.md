# Implementation and Experiment

##  Implementation
---


At a high level, our system stores the authenticated data structure as three components: 1,  the hash chain embedded in the in-memory table (Level Zero), 2,  the Merkle B-trees embedded in all on-disk tables (Non-zero Levels) and 3,  the MHT embedded in the manifest file which lists all on-disk tables.

Specifically, at Level Zero, we augment each record with a hash digest field which stores the hash chain head, where the hash chain is built by temporally sorting the records. At Non-zero levels, we augment all the B-tree nodes with hash digests where a hash digest in the leaf node digest the record itself and a hash digest in the non-leaf node digest the sum of all the children. Finally, we persist all the root hashes in the manifest file and (re)construct an MHT in the main memory.

On the write path, the proof-store writes the hash head together with each key-value pair to the in-memory table. On the compaction path, the proof-store builds and embeds the Merkle B-trees in the newly created files. The proof-store also adds the root hashes for the newly created files to the manifest file. On the read path, if the answer is found in the in-memory table, the proof returns the full hash chain, if the answer is found in the on-disk files, the proof returns the full hash chain and the corresponding Merkle proofs. 


##  Experiment
---

### 1, Storage Size 

