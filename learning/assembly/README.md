# Assembly

x86-64 programs written with NASM for Linux (raw syscalls, no libc).

| Folder | Program |
|--------|---------|
| `Hello/` | `sys_write` + `sys_exit` — the smallest useful program |
| `Input/` | read from stdin with `sys_read`, echo it back |
| `Random_number_game/` | guess-the-number game (random secret) |
| `small_game/` | earlier iteration of the guessing game (fixed secret) |
| `collect/`, `info26/` | create a directory and copy a file using syscalls (two iterations) |
| `ASSEMBLY/write.asm` | **16-bit DOS** `.COM` program (`int 21h`) — run it in DOSBox |

## Build and run (Linux x86-64)

```bash
nasm -f elf64 Hello/hello.asm -o hello.o
ld hello.o -o hello
./hello
```

## Build the DOS example

```bash
nasm -f bin ASSEMBLY/write.asm -o write.com   # then run write.com in DOSBox
```

Object files and executables are git-ignored; build them locally.
