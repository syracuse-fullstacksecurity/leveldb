#include "../include/leveldb/db.h"
#include <iostream>
int main() {
  std::cout<<"Open db" << std::endl;
  leveldb::Options options;
  leveldb::DB* db_;
  options.create_if_missing = true;
  leveldb::Status status = leveldb::DB::Open(options, "/tmp/ss_test", &db_);
  std::cout<<status.ToString()<<std::endl;
  std::string ret;
  db_->GetProperty("leveldb.stats",&ret);
  std::cout<<ret<<std::endl;
  assert(status.ok()); 


  char key[20];
  char val[200];
  leveldb::WriteOptions wo;
  leveldb::ReadOptions ro;
  snprintf(key, sizeof(key), "%016d", 1);
  snprintf(val, sizeof(val), "%0100d", 1);
  db_->Put(wo,key,val);
  ro.snapshot = db_->GetSnapshot();
  for(int i=2;i<100000;i++) {
  snprintf(val, sizeof(val), "%0100d", i);
  db_->Put(wo,key,val);
  }

  std::string res;
  db_->Get(ro,key,&res);
  std::cout<<"res="<<res<<std::endl;  
  ro.snapshot = db_->GetSnapshot();
  db_->Get(ro,key,&res);
  std::cout<<"res="<<res<<std::endl;  
  db_->GetProperty("leveldb.stats",&ret);
  std::cout<<ret<<std::endl;
}
