OPTIMIZE = -O3
CFLAGS   = -std=c11 -Wall -pedantic -Iinclude $(OPTIMIZE)
LDFLAGS  = -lm $(OPTIMIZE)
SOURCES  = $(wildcard src/*.c)
TARGET   = lib/libeuler.a

build: $(TARGET)

# clean temporary files from compilation and the target
clean:
	$(RM) src/*.o test/*_test
	$(RM) $(TARGET)

# build and run all tests. every src/*.c file must have a corresponding
# test/*_test.c file, which are all built and run.
test: $(SOURCES:src/%.c=test/%_test)
	@cd test && ./all.sh

# runs the clang-format code formatter for all files in this lib.
fmt: $(wildcard include/**.h src/*.c test/*.c)
	clang-format -i $^

# generates documentation in ../../doc/lib/c
doc:
	doxygen config.doxygen

# take the sources and produce a library file
$(TARGET): $(SOURCES:%.c=%.o)
	ar cr $@ $^
	ranlib $@

# build a given test, test/*_test, from test/*_test.c and src/*.c
test/%_test: test/%_test.o $(SOURCES:%.c=%.o)
	$(CC) -o $@ $^ $(LDFLAGS)

.PHONY: build test clean fmt doc
