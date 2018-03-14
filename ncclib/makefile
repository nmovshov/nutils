# Test makefile for ncclib
CC = g++
CFLAGS = -c -O3 -m64
LFLAGS = -Wall
OBJS = test.o ncclib.o

test.out: $(OBJS) makefile
	$(CC) $(LFLAGS) $(OBJS) -o test.out

test.o: test.cpp ncclib.h makefile
	$(CC) $(CFLAGS) test.cpp

ncclib.o: ncclib.cpp ncclib.h makefile
	$(CC) $(CFLAGS) ncclib.cpp

makefile:

clean:
	rm -rf *.o *.out *~
