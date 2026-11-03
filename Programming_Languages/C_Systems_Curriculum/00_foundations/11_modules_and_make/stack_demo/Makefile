# A Makefile is a list of rules:   target: dependencies
#                                  <TAB> command that builds the target
CC      = gcc
CFLAGS  = -std=gnu11 -Wall -Wextra -Wpedantic -g -fsanitize=address,undefined
LDFLAGS = -fsanitize=address,undefined

stack_demo: main.o stack.o                  # link step: .o files -> program
	$(CC) main.o stack.o -o $@ $(LDFLAGS)

%.o: %.c stack.h                            # compile step: one .c -> one .o
	$(CC) $(CFLAGS) -c $< -o $@             # $< = first dependency, $@ = the target

clean:
	rm -f *.o stack_demo

.PHONY: clean
