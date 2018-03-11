CC=g++
CFLAGS=-I../include
%.o : %.cpp
	$(CC) $(CFLAGS) -c $< -o $@  -g

misc: misc.o
	$(CC) $^ -o $@ -g -pthread -lleveldb -lverify

clean:
	rm -rf *.o misc
