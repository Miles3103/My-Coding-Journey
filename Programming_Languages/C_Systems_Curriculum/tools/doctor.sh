#!/usr/bin/env bash
# Checks your C toolchain. Usage: bash tools/doctor.sh
miss=0
check() {  # label  command  required(1/0)  install-hint
  if command -v "$2" >/dev/null 2>&1; then
    v=$("$2" --version 2>&1 | head -n1)
    case "$v" in *nvalid*|*sage*|"") v=$(command -v "$2");; esac
    printf "  [ok]      %-10s %s\n" "$1" "${v:0:70}"
  elif [ "$3" = 1 ]; then
    printf "  [MISSING] %-10s REQUIRED. Install: %s\n" "$1" "$4"; miss=$((miss+1))
  else
    printf "  [missing] %-10s optional for now. Install: %s\n" "$1" "$4"
  fi
}
echo "Core tools (needed now):"
check gcc      gcc      1 "sudo apt install build-essential   (macOS: xcode-select --install)"
check make     make     1 "sudo apt install build-essential"
check gdb      gdb      1 "sudo apt install gdb   (macOS: use lldb or brew install gdb)"
check valgrind valgrind 0 "sudo apt install valgrind   (not on Apple Silicon; use the sanitizers)"
echo "Needed in later projects:"
check convert  convert  0 "sudo apt install imagemagick      (Project 3 test images)"
check curl     curl     0 "sudo apt install curl             (Project 4)"
check nc       nc       0 "sudo apt install netcat-openbsd   (Project 4)"
check ab       ab       0 "sudo apt install apache2-utils    (Project 4 load tests)"
echo
echo "Compile test with sanitizers:"
T=$(mktemp -d)
printf '#include <stdio.h>\nint main(void){ puts("toolchain works"); return 0; }\n' > "$T/t.c"
if gcc -std=gnu11 -Wall -Wextra -g -fsanitize=address,undefined "$T/t.c" -o "$T/t" 2>"$T/err" && "$T/t"; then
  echo "  [ok] gcc + AddressSanitizer + UBSan"
else
  echo "  [FAIL] sanitizer build failed:"; sed 's/^/        /' "$T/err"; miss=$((miss+1))
fi
rm -rf "$T"
echo
if [ "$miss" -eq 0 ]; then echo "All required tools are ready. Start with 00_foundations/README.md"
else echo "Fix the REQUIRED items above, then run this again."; exit 1; fi
