#include "../include/verifier.h"
#include "../include/sha3.h"
#include <iostream>
#include <algorithm>
#include <stdio.h>
STATE gSTATE1;
unsigned char digest1[20];
int lpad_sim_put() {
  unsigned char tmp[200];
  sha1(tmp,200,digest1);
}

int lpad_sim_get() {
  unsigned char tmp[200];
  for(int i=0;i<28;i++){
    sha1(tmp,200,digest1);
  }
} 

int btree_sim_put() {
  unsigned char tmp[200];
  for(int i=0;i<28;i++)
    sha1(tmp,200,digest1);
}

int btree_sim_get() {
  unsigned char tmp[200];
  for(int i=0;i<28;i++)
    sha1(tmp,200,digest1);
} 


