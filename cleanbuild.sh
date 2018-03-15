cd blockchain_agent
make clean
make
sudo cp verifier /usr/lib/libverify.so
cd ../proof
make clean
make 
#out-static/db_bench
