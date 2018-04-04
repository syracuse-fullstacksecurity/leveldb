CC=g++
CFLAGS=-I../include -fPIC -g  
%.o : %.cpp
	$(CC) $(CFLAGS) -c $< -lleveldb -lpthread -o $@  

verifier: verifier.o sim.o sha3.o sha1.o
	$(CC) $^ -o $@ -shared 

clean:
	rm -rf *.o verifier
