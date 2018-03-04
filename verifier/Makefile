CC=g++
CFLAGS=-I../include -fPIC
%.o : %.cpp
	$(CC) $(CFLAGS) -c $< -o $@ 

verifier: verifier.o sha3.o
	$(CC) $^ -o $@ -shared 

clean:
	rm -rf *.o verifier
