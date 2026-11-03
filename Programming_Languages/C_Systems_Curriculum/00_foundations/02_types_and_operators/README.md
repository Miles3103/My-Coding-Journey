# Lesson 2: Types & Operators

**Time:** ~3 h | **Prev:** [Lesson 1](../01_hello_world/README.md) | **Next:** [Lesson 3](../03_control_flow/README.md)
**File:** [`types.c`](types.c)

## You will be able to
- choose the right integer type and print it with the right `printf` format
- explain overflow, and why signed and unsigned behave differently
- use bitwise operators and explain why `0.1 + 0.2 != 0.3`

---

## 1. Concept: everything is bits with an interpretation

Memory only stores bits. A **type** tells the compiler *how many bits* to use and *how to interpret them*. The same byte `01000001` is the number 65 as an `int` and the letter `'A'` as a `char`.

| Type | Typical size | Use for |
|---|---|---|
| `char` | 1 byte | a byte, or a character |
| `int` | 4 bytes | everyday whole numbers |
| `long` / `long long` | 8 bytes | big whole numbers |
| `float` / `double` | 4 / 8 bytes | approximate decimals (prefer `double`) |
| `size_t` | 8 bytes (64-bit) | sizes and array indexes (**unsigned**) |
| `uint8_t`, `int32_t`, `uint64_t`… (`<stdint.h>`) | exactly as named | binary formats, protocols |

**Why sizes aren't fixed:** C was designed to run on every machine ever built, so `int` is "whatever is natural for the CPU". When the exact size matters, such as a file format or network packet, use `<stdint.h>` types. You'll need them in Project 3.

### Signed vs. unsigned and overflow
An 8-bit **unsigned** number holds 0 to 255. Add 10 to 250 and it **wraps around** to 4. This is well-defined in C.

A **signed** `int` overflowing (`INT_MAX + 1`) is **undefined behavior (UB)**: the standard says anything may happen. Compilers *assume it never happens* and optimize on that assumption, which can silently break your code (Lesson 12).

### Two's complement (how negatives are stored)
To negate a number, flip all bits and add 1. So `-1` is all ones: `0xFFFFFFFF` for 32 bits. This is why mixing signed and unsigned is dangerous: `-1` compared with an unsigned `1u` turns into a huge number.

### Integer division and `%`
`7 / 2` is **3**, since division of two integers truncates toward zero (`-7 / 2` is **-3**). `7 % 2` is the remainder, **1**. If either side is a `double`, you get decimal division: `7 / 2.0` is 3.5.

### Bitwise operators (you'll use these in Projects 3 and 5)
| Op | Meaning | Example (0xF0, 0x3C) |
|---|---|---|
| `&` | AND: bit set in both | `0xF0 & 0x3C = 0x30` |
| `\|` | OR: set in either | `0xFC` |
| `^` | XOR: set in exactly one | `0xCC` |
| `~` | NOT: flip every bit | `~0u` is all ones |
| `<<` `>>` | shift left/right | `1u << 4 = 16` |

Common idioms: `x & (1u << n)` tests bit *n*; `x |= 1u << n` sets it; `x &= ~(1u << n)` clears it; `(n + 15) & ~15u` rounds *n* up to a multiple of 16 (Project 5).

### Floating point is approximate
`0.1` has no exact binary form, just as 1/3 has no exact decimal form. So `0.1 + 0.2` is `0.30000000000000004`. Never compare floats with `==`; compare `fabs(a - b) < epsilon`.

## 2. Run it
```bash
make && ./bin/types
```
**Predict first:** what does `250 + 10` in a `uint8_t` print? What is `-7 / 2`? Then check.

## 3. printf format cheat sheet
| Format | Type | Format | Type |
|---|---|---|---|
| `%d` | `int` | `%zu` | `size_t` (also `sizeof`) |
| `%u` | `unsigned` | `%td` | `ptrdiff_t` (pointer difference) |
| `%ld` / `%lld` | `long` / `long long` | `%f` `%.2f` | `double` |
| `%c` | `char` as a character | `%s` | string (`char *`) |
| `%x` `%02X` | hex | `%p` | pointer (cast to `void *`) |

A wrong format is **undefined behavior**. `-Wall` catches most of these, so read the warnings.

## 4. Common mistakes
- Using `int` for sizes and indexes. Use `size_t`.
- Comparing signed and unsigned values (`-Wextra` warns).
- Assuming `char` is signed. It's implementation-defined, so cast to `unsigned char` before `<ctype.h>` calls.
- `if (x = 5)` (assignment) instead of `if (x == 5)` (comparison). It compiles, with a warning under `-Wall`.
- Using `uint8_t` arithmetic without realizing it's promoted to `int` first: `a + b` is an `int`; cast back to store it.

## 5. Exercises
- [ ] **E1.** Write `my_work/bits.c` with a function `int count_set_bits(unsigned x)`. Test it on 0, 1, 255, `0xFFFFFFFF`.
- [ ] **E2.** Write `bool is_power_of_two(unsigned x)` using only one expression with `&` and `-`. *(Hint: powers of two have exactly one bit set; what does `x & (x - 1)` do?)*
- [ ] **E3.** Print `INT_MAX`, `INT_MIN`, `UINT_MAX`, `SIZE_MAX`, `CHAR_BIT` from `<limits.h>` / `<stdint.h>`.
- [ ] **E4.** Write `round_up(size_t n, size_t align)` for a power-of-two `align` using `(n + align - 1) & ~(align - 1)`. Test with 1, 15, 16, 17 and align 16. *(This is the allocator's alignment trick.)*
- [ ] **E5.** Print the bytes of the `int` 0x01020304 using a `unsigned char *` pointer cast. Are you on a little-endian machine? *(Stretch: do after Lesson 6.)*
- [ ] **E6.** Show `0.1f + 0.2f` vs `0.1 + 0.2`. Which is closer to 0.3?

## 6. Self-check
<details><summary>Questions</summary>

1. What does `-7 / 2` print? What is `-7 % 2`?
2. Why is `INT_MAX + 1` dangerous but `UINT_MAX + 1u` is fine?
3. How do you set bit 3 of `x`? Clear it? Test it?
4. Why shouldn't you compare floats with `==`?

**Answers:** (1) `-3` and `-1` (division truncates toward zero; the remainder keeps the sign of the dividend). (2) Signed overflow is undefined behavior; unsigned overflow wraps by definition. (3) `x |= 1u << 3;` `x &= ~(1u << 3);` `x & (1u << 3)`. (4) Most decimals can't be stored exactly in binary, so results carry tiny errors.
</details>

## 7. Where this shows up later
- **Project 2:** hash functions use `uint64_t`, XOR, multiply and bit masks.
- **Project 3:** headers are read with `uint16_t` / `uint32_t`, shifts and endianness.
- **Project 5:** alignment (`ALIGN_UP`) and flag bits packed into sizes.
