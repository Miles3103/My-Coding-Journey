# Builds every lesson example into ./bin  (run from 00_foundations/)
#   make          build all examples
#   make bugs     build the deliberately broken programs (*_bug.c)
#   make clean
CC      ?= gcc
CFLAGS  := -std=gnu11 -Wall -Wextra -Wpedantic -Wshadow -g -O0 -fsanitize=address,undefined -fno-omit-frame-pointer
LDFLAGS := -fsanitize=address,undefined

EXAMPLES := $(filter-out %_bug.c,$(wildcard [0-9][0-9]_*/*.c))
BUGS     := $(wildcard [0-9][0-9]_*/*_bug.c)

all:
	@mkdir -p bin
	@for f in $(EXAMPLES); do n=$$(basename $$f .c); echo "CC  $$f -> bin/$$n"; \
	  $(CC) $(CFLAGS) $$f -o bin/$$n $(LDFLAGS) || exit 1; done
	@$(MAKE) -s -C 11_modules_and_make/stack_demo
	@echo "Done. Run for example:  ./bin/pointers"

bugs:
	@mkdir -p bin
	@for f in $(BUGS); do n=$$(basename $$f .c); echo "CC  $$f -> bin/$$n"; \
	  $(CC) $(CFLAGS) -Wno-unused $$f -o bin/$$n $(LDFLAGS) || exit 1; done
	@echo "Done. These programs are BROKEN on purpose. Run e.g. ./bin/uaf_bug"

clean:
	rm -rf bin
	@$(MAKE) -s -C 11_modules_and_make/stack_demo clean

.PHONY: all bugs clean
