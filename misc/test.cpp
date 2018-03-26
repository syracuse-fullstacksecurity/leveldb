#include <iostream>
#include <stdio.h>
#include <vector>
typedef struct digest_ {
  unsigned char rep_[20];
} DIGEST, *pDIGEST;
int main() {
  DIGEST cur;
  std::vector<DIGEST> my;
  for(int i=0;i<20;i++)
    cur.rep_[i] = 1;
  my.push_back(cur);
  for(int i=0;i<20;i++)
    cur.rep_[i] = 2;
  my.push_back(cur);
  for(int i=0;i<20;i++)
    cur.rep_[i] = 3;
  my.push_back(cur);
  printf("%d\n",my[0].rep_[0]);
}
