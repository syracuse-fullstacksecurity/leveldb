cd verifier
make clean
make
sudo cp verifier /usr/lib/libverify.so
cd ../proof
make
#out-static/db_bench
