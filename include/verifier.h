#ifndef _CHAIN_AGENT_
#define _CHAIN_AGENT_
#include <vector>
#include "leveldb/slice.h"
using namespace leveldb;
typedef struct {
	unsigned char rep_[32];
} DIGEST,*pDIGEST;
typedef struct digest_state {
    unsigned long last;
    pDIGEST mem;
    unsigned long mem_ts_start;
    unsigned long mem_ts_end;
    pDIGEST imm;
    unsigned long imm_ts_start;
    unsigned long imm_ts_end;
    std::vector<std::vector<DIGEST> > LN;
} STATE, *pSTATE;

typedef struct record{
  Slice key;
  unsigned long seq;
  unsigned long type;
  Slice val;
} RECORD, *pRECORD;

typedef struct irecord {
  //std::string key;
  std::string value;
} IRECORD, *pIRECORD;

int verifier_init();
int verifier_flip_mem();
int verifier_put(const Slice& key, unsigned long seq, const Slice& value);
int verifier_get(const Slice& key, const Slice& value, 
                const std::vector<IRECORD>& pfBlock, 
                const std::vector<DIGEST>& pfFile);
int verifier_compact_memtable(std::vector<RECORD>& t);
int verifier_compaction(const std::vector<int>& input_files1,
                        const std::vector<int>& input_files2, 
                        const std::vector<int>& output_files, 
                        int i);
#endif
