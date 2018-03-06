```

db_bench.cc: Benchmark->Run()->RunBenchmark()->CondVar.SignalAll()/Wait()
                                                         |
                                                         +---->WriteRandom()/WriteSeq()->DoWrite->db_.Write()
                                                         +---->...->db_.CompactRange()

db_impl.h: 
       Write()
       Put()
       Get()
       CompactRange()  //compact
       CompactMemTable() //flush


db_impl.cc:DbImpl::
             Put()-...->DbImpl::Write()
                 |
                 +-->MakeRoomForWrite()-#1310(if_full)->MaybeScheduleCompact()
                 +-->log_->AddRecord(WriteBatchInternal::Contents(updates)); logfile_->Sync();
                 +-->WriteBatchInternal::InsertInto(updates, mem_)->MemTable::Add()->SkipList::Insert()@                             

             Get()
              |
              +------->MemTable::Get()
              +-else-versions_[current]--->Version::Get()-->
                       +-->for (int level = 0; level < config::kNumLevels; level++)
                            +-->version_set::table_cache::Get()
              +------->MaybeSccheduleCompact()

             CompactRange()->TEST_ManualCompact()
                 |
                 +-->ManualCompaction manual;
                 +-->MaybeScheduleCompaction();

            
         +-->CompactMemTable()->WriteLevel0Table();
         |
BackgroundCall()
         ^
         |
         +-->MaybeScheduleCompaction();


SkipList::Insert()
  +-->port::AtomicPointer::NoBarrier_Store(void*)
  +-->port::AtomicPointer::Release_Store(void*)
    +->MemoryBarrier() 
       +-[X86/GNUC]-> __asm__ __volatile__("" : : : "memory");
       
```
