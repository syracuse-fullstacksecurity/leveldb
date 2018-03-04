#include "../include/verifier.h"
#include "../include/sha3.h"
#include <iostream>
#include <stdio.h>
STATE gSTATE;

int main() {
  return 0;
}

int verifier_flip_mem() {
  gSTATE.mem_ts_start = gSTATE.last;
  assert(gSTATE.mem_ts_start != -1);
  assert(gSTATE.mem != NULL);
  gSTATE.imm_ts_start = gSTATE.mem_ts_start;
  gSTATE.imm_ts_end = gSTATE.mem_ts_end;
  gSTATE.mem_ts_start = -1;
  gSTATE.imm_ts_start = -1;
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
  if (gSTATE.mem_ts_start = -1) {
    gSTATE.mem_ts_start = seq;
    sha3_update((const unsigned char *)key.data(),key.size());
    sha3_final((unsigned char *)gSTATE.mem->rep_,DIGEST_SIZE);
  } else {
    unsigned char tmp[200];
    memcpy(tmp,gSTATE.mem->rep_,DIGEST_SIZE);
    memcpy(tmp+DIGEST_SIZE,key.data(),key.size());
    sha3_update(tmp,key.size()+DIGEST_SIZE);
  }
  sha3_final((unsigned char *)gSTATE.mem->rep_,DIGEST_SIZE);
}
int verifier_get() {
  printf("%s called\n",__func__);
} 
int verifier_compact_memtable() {
  printf("%s called\n",__func__);
}
int verifier_compaction() {
  printf("%s called\n",__func__);
}
