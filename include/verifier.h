#ifndef _CHAIN_AGENT_
#define _CHAIN_AGENT_
#include <vector>
typedef struct {
	char rep_[20];
} DIGEST,*pDIGEST;
class chain_agent {
  public:
    int get();
    int set();
  private:
    DIGEST L0;
    std::vector<std::vector<DIGEST> > LN;
};
int verifier_init();
int verifier_put();
int verifier_get();
int verifier_compact_memtable();
int verifier_compaction();
#endif
