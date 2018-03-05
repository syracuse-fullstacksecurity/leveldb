#include "../include/verifier.h"
#include "../include/sha3.h"
#include <iostream>
#include <algorithm>
#include <stdio.h>
STATE gSTATE;

int main() {
  return 0;
}

int verifier_flip_mem() {
  gSTATE.mem_ts_end = gSTATE.last;
  assert(gSTATE.mem_ts_start != -1);
  assert(gSTATE.mem != NULL);
  gSTATE.imm_ts_start = gSTATE.mem_ts_start;
  gSTATE.imm_ts_end = gSTATE.mem_ts_end;
  gSTATE.mem_ts_start = -1;
  gSTATE.mem_ts_end = -1;
  if (gSTATE.imm != NULL)
    delete gSTATE.imm;
  gSTATE.imm = gSTATE.mem;
  gSTATE.mem = new DIGEST;
}

int verifier_init() {
  gSTATE.last = 0 ;
  gSTATE.mem_ts_start = -1;
  gSTATE.mem_ts_end = -1;
  gSTATE.imm_ts_start = -1;
  gSTATE.imm_ts_end = -1;
  gSTATE.mem = new DIGEST;
  gSTATE.imm= NULL;
}
int verifier_put(const Slice& key, unsigned long seq, const Slice& value) {
  //	std::cout << "verifier_put key = " << key.ToString() << std::endl;
  //	std::cout << "verifier_put val = " << value.ToString() << std::endl;
  //std::cout << "verifier_put seq = " << seq << std::endl;
  assert(seq==gSTATE.last+1);
  gSTATE.last = seq;
  if (gSTATE.mem_ts_start == -1) {
    gSTATE.mem_ts_start = seq;
    std::cout << key.ToString() << std::endl;
    sha3_update((const unsigned char *)key.data(),key.size());
  } else {
    unsigned char tmp[200];
    memcpy(tmp,gSTATE.mem->rep_,DIGEST_SIZE);
    memcpy(tmp+DIGEST_SIZE,key.data(),key.size());
    sha3_update(tmp,key.size()+DIGEST_SIZE);
  }
  sha3_final((unsigned char *)gSTATE.mem->rep_,DIGEST_SIZE);
}

int verifier_get() {
} 
bool myfunction (const RECORD& i,const RECORD& j) { return (i.seq < j.seq); }

int verifier_compact_memtable(std::vector<RECORD>& t) {
  if (t.size()==0) return 0; 
  //sort to time-ordered
  std::sort(t.begin(),t.end(),myfunction);
  unsigned char resHash[DIGEST_SIZE];
  sha3_update((const unsigned char *)t[0].key.data(),t[0].key.size());
  sha3_final(resHash,DIGEST_SIZE);
  for(int i=1;i<t.size();i++) {
    unsigned char tmp[200];
    memcpy(tmp,resHash,DIGEST_SIZE);
    memcpy(tmp+DIGEST_SIZE,t[i].key.data(),t[i].key.size());
    sha3_update(tmp,t[i].key.size()+DIGEST_SIZE);
    sha3_final(resHash,DIGEST_SIZE);
  }
  for(int i=0;i<DIGEST_SIZE;i++) {
    if (resHash[i] != gSTATE.imm->rep_[i]) {
      printf("in %s and firstis=%lu and last=%lu,imm_start=%lu,imm_end=%lu\n",__func__,t[0].seq,t[t.size()-1].seq,gSTATE.imm_ts_start,gSTATE.imm_ts_end);
      std::cout << t[0].key.ToString() << std::endl;
      std::cout << "different" << std::endl;
      break;
    }
  }
  //assert! must be equal 
  //TODO minor bug: sometime the verification failed
}

int verifier_compaction() {
}