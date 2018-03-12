CC=g++
CFLAGS=-I../include -fPIC -g -DSUHASH
%.o : %.cpp
	$(CC) $(CFLAGS) -c $< -o $@ 

verifier: verifier.o sha3.o sha1.o
	$(CC) $^ -o $@ -shared 

clean:
	rm -rf *.o verifier
