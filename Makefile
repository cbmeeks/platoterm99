# Paths to TMS9900 compilation tools 
# ( Set in environment to override paths )
TMS9900_DIR?=/cygdrive/d/tms9900/bin
ELF2EA5_DIR?=/usr/local/bin
EA5_SPLIT_DIR?=/usr/local/bin
CLASSIC99_DSK1?=/cygdrive/d/classic99/DSK1

# Full paths to the executables used
GAS=$(TMS9900_DIR)/tms9900-as
LD=$(TMS9900_DIR)/tms9900-ld
CC=$(TMS9900_DIR)/tms9900-gcc
AR=$(TMS9900_DIR)/tms9900-ar
ELF2EA5=$(ELF2EA5_DIR)/elf2ea5
EA5_SPLIT=$(EA5_SPLIT_DIR)/ea5split
LIBTI99_DIR=/home/thomc/Workspace/libti99

LDFLAGS_EA5=\
  --script=linkfile

# output file
NAME=libti99.a

CFLAGS=\
  -O2 -DRS232 -std=c99 -s --save-temp -I$(TMS9900_DIR)/lib/gcc/tms9900/4.4.0/include -I$(LIBTI99_DIR) -fno-builtin

# List of compiled objects used in executable
OBJECT_LIST=\
	src/crt0_ea5.o \
	src/main.o \
	src/io.o \
	src/keyboard.o \
	src/protocol.o \
	src/screen.o \
	src/terminal.o \
	src/touch.o

# Recipe to compile the library
all: plato

plato: $(OBJECT_LIST)
	$(LD) $(OBJECT_LIST_EA5) $(OBJECT_LIST) $(LDFLAGS_EA5) -L$(LIBTI99_DIR) -lti99 -o plato.ea5.elf > ea5.map
	$(ELF2EA5) plato.ea5.elf plato.ea5.bin
	$(EA5_SPLIT) plato.ea5.bin
	cp PLAT* $(CLASSIC99_DSK1)

# Recipe to clean all compiled objects
.phony clean:
	-rm -f *.o
	-rm -f *.a
	-rm -f *.s
	-rm -f *.i
	-rm -f *.elf
	-rm -f *.map
	-rm -f *.bin
	-rm -f PLAT*
	-rm -f src/*.o
	-rm -f src/*.a
	-rm -f src/*.s
	-rm -f src/*.i
	-rm -f src/*.elf
	-rm -f src/*.map
	-rm -f src/*.bin
	-rm -f src/PLAT*


# Recipe to compile all assembly files
%.o: %.asm
	$(GAS) $< -o $@

# Recipe to compile all C files
%.o: %.c
	$(CC) -c $< $(CFLAGS) -o $@
