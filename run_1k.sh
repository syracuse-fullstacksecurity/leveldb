#proof/out-static/db_bench --benchmarks=fillseq --num=16777216 --value_size=1000
#proof/out-static/db_bench --benchmarks=fillseq --num=33554431 --value_size=20
#proof/out-static/db_bench --benchmarks=fillseq --num=134217728
#proof/out-static/db_bench --benchmarks=readrandom --num=134217728 --reads=125000 --use_existing_db=1 --threads=8  --db=/tmp/data128m-proof/dbbench
#proof/out-static/db_bench --benchmarks=readrandom --num=134217728 --reads=125000 --use_existing_db=1 --threads=8 --db=/tmp/data128m-noproof/dbbench
#proof/out-static/db_bench --benchmarks=overwrite --num=134217728  --use_existing_db=1 --threads=8 --db=/tmp/data128m-noproof/dbbench
#proof/out-static/db_bench --benchmarks=overwrite --num=134217728  --use_existing_db=1 --threads=8 --db=/tmp/data128m-proof/dbbench
#proof/out-static/db_bench --benchmarks=readrandom --num=134217728 --reads=125000 --use_existing_db=1 --threads=8 --db=/tmp/data128m-noproof/dbbench --proofdb=/tmp/proof128m/dbbench
#proof/out-static/db_bench --benchmarks=overwrite --num=134217728 --use_existing_db=1 --threads=8 --db=/tmp/data128m-noproof/dbbench --proofdb=/tmp/proof128m/dbbench
#proof/out-static/db_bench --benchmarks=readrandom --num=16777216 --reads=12500 --use_existing_db=1 --threads=8 --db=/tmp/data16m1k-proof/dbbench
#proof/out-static/db_bench --benchmarks=readrandom --num=16777216 --reads=12500 --use_existing_db=1 --threads=8  --db=/tmp/data16m1k-noproof/dbbench
#proof/out-static/db_bench --benchmarks=readrandom --num=16777216 --reads=100000 --use_existing_db=1 --threads=1  --db=/tmp/data16m1k-noproof/dbbench --proofdb=/tmp/proof16m/dbbench
proof/out-static/db_bench --benchmarks=overwrite --num=16777216 --use_existing_db=1 --threads=8 --value_size=1000 --db=/tmp/data16m1k-noproof/dbbench --proofdb=/tmp/proof16m/dbbench
#proof/out-static/db_bench --benchmarks=overwrite --num=16777216  --use_existing_db=1 --threads=8 --value_size=1000 --db=/tmp/data16m1k-noproof/dbbench
#proof/out-static/db_bench --benchmarks=overwrite --num=16777216 --use_existing_db=1 --threads=8 --value_size=1000 --db=/tmp/data16m1k-proof/dbbench
