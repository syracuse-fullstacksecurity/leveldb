#include "../include/leveldb/db.h"
#include <iostream>
int main() {
  std::cout<<"Open db" << std::endl;
  leveldb::Options options;
  leveldb::DB* db_;
  options.create_if_missing = true;
  leveldb::Status status = leveldb::DB::Open(options, "/tmp/leveldbtest-1002/dbbench", &db_);
  std::cout<<status.ToString()<<std::endl;
  std::string ret;
  db_->GetProperty("leveldb.stats",&ret);
  std::cout<<ret<<std::endl;
  assert(status.ok()); 
}
