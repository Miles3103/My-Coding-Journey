#!/usr/bin/env bash
# Shows the four stages gcc runs for you. Usage: bash pipeline.sh
set -e
cd "$(dirname "$0")"
T=$(mktemp -d)
echo "1) PREPROCESS: expand #include and #define  (gcc -E)"
gcc -E hello.c -o "$T/hello.i"
echo "   hello.c is $(wc -l < hello.c) lines; hello.i is $(wc -l < "$T/hello.i") lines (all of stdio.h pasted in)"
echo "2) COMPILE: C -> assembly  (gcc -S)"
gcc -S "$T/hello.i" -o "$T/hello.s"
echo "   first lines of assembly:"; head -n 8 "$T/hello.s" | sed 's/^/      /'
echo "3) ASSEMBLE: assembly -> machine code object file  (gcc -c)"
gcc -c "$T/hello.s" -o "$T/hello.o"
echo "   hello.o is $(wc -c < "$T/hello.o") bytes. 'T main' = defined here; 'U puts' = Undefined, the linker must find it (gcc turned printf into puts):"
nm "$T/hello.o" | sed 's/^/      /'
echo "4) LINK: combine with the C library -> runnable program"
gcc "$T/hello.o" -o "$T/hello"
"$T/hello"; echo "   exit status = $?"
rm -rf "$T"
