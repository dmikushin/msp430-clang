CC=~/msp430-clang/build/bin/clang
LD=~/msp430-clang/build/bin/ld.lld
GDB=/opt/msp430/bin/msp430-elf-gdb

run: test
	$(GDB) -q -x run.gdb-script test

test: test.o aes.o nanolib.o crt0.o
	$(LD) -T sim.ld-script -o test $^

crt0.o: crt0.S
	$(CC) -integrated-as -c $<

.c.o:
	$(CC) -O2 -integrated-as -c $<

clean:
	rm -f test *.s *.o
