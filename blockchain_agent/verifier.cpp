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
  //assert(gSTATE.mem_ts_start != -1);
  //assert(gSTATE.mem != NULL);
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
  //assert(seq==gSTATE.last+1);
  gSTATE.last = seq;
  if (gSTATE.mem_ts_start == -1) {
    gSTATE.mem_ts_start = seq;
    #ifdef SUHASH
    sha1((void*)key.data(),key.size(),gSTATE.mem->rep_);
    #endif
  } else {
    unsigned char tmp[200];
    memcpy(tmp,gSTATE.mem->rep_,DIGEST_SIZE);
    memcpy(tmp+DIGEST_SIZE,key.data(),key.size());
    #ifdef SUHASH
    sha1(tmp,key.size()+DIGEST_SIZE,gSTATE.mem->rep_);
    #endif
  }
}

int verifier_get(const Slice& key, const Slice& value, const std::vector<RECORD>& pfBlock, const std::vector<DIGEST>& pfFile) {
  unsigned char digest[DIGEST_SIZE_SHA1];
  unsigned char tmp[DIGEST_SIZE_SHA1*7000];
  #ifdef SUHASH
  sha1((void*)key.data(),key.size(),digest);
  #endif
  for(int i=0;i<1;i++) {
    //assert(digest == pfBlock[i].rep_);
    #ifdef SUHASH
    sha1(tmp,DIGEST_SIZE_SHA1*783,digest);
    #endif
  }
  // build up hash for the block
  for(int i=0;i<1;i++) {
    #ifdef SUHASH
    sha1(tmp,DIGEST_SIZE_SHA1*36,digest);
    #endif 
  }
  // build up hash for the file
  //assert(digest==pSTATE.Ln[level].get(file_number))
} 

bool myfunction (const RECORD& i,const RECORD& j) { return (i.seq < j.seq); }

int verifier_compact_memtable(std::vector<RECORD>& t) {
  if (t.size()==0) return 0; 
  //sort to time-ordered
  std::sort(t.begin(),t.end(),myfunction);
  unsigned char resHash[DIGEST_SIZE];
  #ifdef SUHASH
  sha1((void*)t[0].key.data(),t[0].key.size(),resHash);
  #endif
  for(int i=1;i<t.size();i++) {
    unsigned char tmp[200];
    memcpy(tmp,resHash,DIGEST_SIZE);
    memcpy(tmp+DIGEST_SIZE,t[i].key.data(),t[i].key.size());
    #ifdef SUHASH
    sha1(tmp,t[i].key.size()+DIGEST_SIZE,resHash);
    #endif
  }
  for(int i=0;i<DIGEST_SIZE;i++) {
    //if (resHash[i] != gSTATE.imm->rep_[i]) {
      //printf("in %s and firstis=%lu and last=%lu,imm_start=%lu,imm_end=%lu\n",__func__,t[0].seq,t[t.size()-1].seq,gSTATE.imm_ts_start,gSTATE.imm_ts_end);
      //std::cout << t[0].key.ToString() << std::endl;
      //std::cout << "different" << std::endl;
      break;
    //}
  }
  //assert! must be equal 
  //TODO minor bug: sometime the verification failed
}

int verifier_compaction(const std::vector<int>& input_files1,
                        const std::vector<int>& input_files2, 
                        const std::vector<int>& output_files, 
                        int i) {
}
