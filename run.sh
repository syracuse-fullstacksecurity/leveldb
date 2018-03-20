proof/out-static/db_bench --benchmarks=fillseq --num=1000000 
proof/out-static/db_bench --benchmarks=readrandom --num=1000000 --use_existing_db=1 --db=/tmp/leveldbtest-1002/dbbench
