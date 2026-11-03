# Project 3: `bmpkit`, a BMP Image Parser & Manipulator

**Level:** Intermediate | **Estimated time:** ~2 weeks | **Prev:** [Project 2](../02_kv_store/README.md) | **Next:** [Project 4](../04_http_server/README.md)

---

## 1. Overview

You will write a library and CLI that **reads, validates, transforms, and writes** uncompressed 24-bit BMP images **from raw bytes**, with no image libraries.

```bash
bmpkit info   photo.bmp
bmpkit gray   photo.bmp  out.bmp
bmpkit invert photo.bmp  out.bmp
bmpkit flip   photo.bmp  out.bmp --horizontal
bmpkit blur   photo.bmp  out.bmp --radius 2
bmpkit crop   photo.bmp  out.bmp 10 10 200 150
```

### Why this project matters for a C developer

Parsing binary formats is where C shines, and where C bites hardest. Every network protocol, file format, executable (ELF/PE), and device driver involves interpreting bytes with a precise layout. This project teaches you:

- How data is **physically laid out** in memory: padding, alignment, endianness.
- How to **safely parse untrusted input**: the root of most real-world CVEs.
- **Bitwise operations** and fixed-width integer types.
- How an image is "just" a `uint8_t` array indexed by arithmetic you design.

---

## 2. Core C Concepts Learned

- [ ] `<stdint.h>` fixed-width types (`uint8_t`, `uint16_t`, `uint32_t`, `int32_t`)
- [ ] Struct layout, **padding**, `#pragma pack` / `__attribute__((packed))`, `_Static_assert(sizeof...)`
- [ ] Endianness: reading little-endian data portably
- [ ] Bitwise operators `& | ^ ~ << >>`, masks, and shifts
- [ ] Binary file I/O: `fopen(..., "rb"/"wb")`, `fread`, `fwrite`, `fseek`, `ftell`
- [ ] Two-dimensional data in 1-D buffers: stride and index arithmetic
- [ ] Integer overflow and checked arithmetic with `size_t`
- [ ] Integer promotion and the usual arithmetic conversions
- [ ] Defensive parsing: validate-then-use
- [ ] Function pointers for pluggable image filters
- [ ] `memcpy` for type punning (instead of illegal pointer casts)
- [ ] Hex-dump tooling (`xxd`, `hexdump -C`) for debugging file formats

---

## 3. Prerequisites & Lessons to Study First

| Topic | What to understand |
|-------|-------------------|
| **Number representation** | Two's complement; why `int32_t height` can be negative |
| **Endianness** | Little vs. big endian; how to check yours; why BMP is little-endian |
| **Struct padding & alignment** | Why `sizeof(struct {uint8_t a; uint32_t b;})` is 8, not 5 |
| **Strict aliasing & unaligned access** | Why `*(uint32_t *)buf` can be UB; the `memcpy` workaround |
| **BMP format spec** | File header (14 B), DIB/Info header (40 B), pixel array, row padding, bottom-up storage, BGR byte order |
| **Pixel basics** | RGB, grayscale luminance (`0.299R + 0.587G + 0.114B`), 8-bit channels |
| **Integer promotion** | What happens when you add two `uint8_t` values |
| **Safe size arithmetic** | Multiplication overflow checks before `malloc(w * h * 3)` |
| **2D convolution** | Box blur and sliding windows (for the blur filter) |
| **`xxd` / `hexdump`** | Reading bytes by eye. Do this on a real `.bmp` first |

#### Create a test image and look at the bytes

```bash
convert -size 4x2 xc:red tests/fixtures/red_4x2.bmp   # ImageMagick
# Force 24-bit uncompressed BMP3:
convert -size 4x2 xc:red BMP3:tests/fixtures/red_4x2.bmp
xxd tests/fixtures/red_4x2.bmp
```

Annotate the hex dump by hand in `notes.md`: find the `42 4D` ("BM") signature, the offset to pixel data, the width/height, and the row padding bytes. **Do this before writing any code.**

---

## 4. BMP Format Cheat Sheet

```text
Offset  Size  Field                   Notes
------  ----  ----------------------  ------------------------------------
FILE HEADER (14 bytes)
0       2     signature               'B','M' (0x42 0x4D)
2       4     file_size               total bytes
6       2     reserved1               0
8       2     reserved2               0
10      4     data_offset             where pixel array begins

INFO HEADER / BITMAPINFOHEADER (40 bytes)
14      4     header_size             40
18      4     width                   int32; pixels
22      4     height                  int32; >0 = bottom-up, <0 = top-down
26      2     planes                  must be 1
28      2     bits_per_pixel          24 for this project
30      4     compression             0 = BI_RGB (none)
34      4     image_size              may be 0 for BI_RGB
38      4     x_pixels_per_meter
42      4     y_pixels_per_meter
46      4     colors_used
50      4     colors_important

PIXEL ARRAY (at data_offset)
  row stride = ((width * bpp + 31) / 32) * 4    ← each row padded to 4 bytes
  pixels are stored B, G, R (NOT R, G, B)
  rows are stored bottom-to-top when height > 0
```

---

## 5. Repository Directory Layout

```text
03_bmp_parser/
├── README.md
├── Makefile
├── include/
│   ├── bmp.h            # structs, Image type, load/save API
│   ├── endian_io.h      # le16/le32 read/write helpers
│   └── filters.h        # grayscale, invert, flip, blur, crop
├── src/
│   ├── bmp.c            # parse + serialize
│   ├── filters.c
│   └── main.c           # CLI dispatcher
├── tests/
│   ├── test_bmp.c
│   ├── test_filters.c
│   ├── gen_fixtures.sh  # builds fixtures with ImageMagick
│   ├── fuzz_corrupt.sh  # byte-flip fuzzing
│   └── fixtures/
│       ├── red_4x2.bmp  ├── gradient_5x3.bmp   # odd width → padding!
│       ├── 1x1.bmp      ├── topdown.bmp        # negative height
│       └── truncated.bmp  └── bad_magic.bmp
└── notes.md
```

---

## 6. Step-by-Step Parts

| Part | Goal |
|------|------|
| 1 | Read & validate headers; implement `bmpkit info` |
| 2 | Load pixel data into a heap `Image`; implement save; round-trip test |
| 3 | Pixel-wise filters: grayscale, invert, brightness |
| 4 | Geometric transforms: flip, rotate 90°, crop |
| 5 | Neighborhood filter: box blur (+ performance & bit-tricks) |
| *Bonus* | ELF header reader using the same techniques |

---

### Part 1: Parse & Validate Headers

#### Tasks

- [ ] Read the whole file size via `fseek(END)`/`ftell`, then `rewind`.
- [ ] Read the 14-byte and 40-byte headers **into byte buffers** and decode each field with explicit little-endian helpers (the portable approach), **or** use packed structs plus `_Static_assert` (the pragmatic approach). Implement both and note the trade-offs.
- [ ] Validate **every** field before trusting it: signature, header_size, planes == 1, bpp == 24, compression == 0, width > 0, height ≠ 0, `data_offset >= 54`, `data_offset <= file_size`.
- [ ] Compute row stride and total pixel bytes with **overflow checks**; confirm `data_offset + pixel_bytes <= file_size`.
- [ ] Implement `bmpkit info` to print dimensions, bpp, orientation, stride, and padding bytes per row.

#### Milestone skeleton: `include/bmp.h`

```c
#ifndef BMP_H
#define BMP_H

#include <stdint.h>
#include <stddef.h>

typedef struct {
    uint32_t width;       /* always positive after parsing */
    uint32_t height;      /* always positive; orientation normalized */
    uint8_t *pixels;      /* top-down, tightly packed B,G,R rows (no padding) */
                          /* owned by Image; freed by image_free() */
} Image;

typedef enum {
    BMP_OK = 0,
    BMP_ERR_IO,
    BMP_ERR_NOMEM,
    BMP_ERR_BAD_SIGNATURE,
    BMP_ERR_UNSUPPORTED,   /* bpp != 24, compression, etc. */
    BMP_ERR_CORRUPT,       /* sizes/offsets inconsistent, truncated */
    BMP_ERR_TOO_LARGE
} BmpStatus;

BmpStatus   bmp_load(const char *path, Image *out);   /* out zeroed on failure */
BmpStatus   bmp_save(const char *path, const Image *img);
void        image_free(Image *img);                   /* safe on zeroed Image */
const char *bmp_strerror(BmpStatus s);

#endif
```

> **Design decision, explained:** The in-memory `Image` is **normalized** to top-down, padding-free rows. The messy format details (bottom-up order, row padding) live *only* in `bmp_load`/`bmp_save`. Filters then deal with simple `pixels[(y*w + x)*3 + c]` indexing. Isolating the ugly parts of a format at the boundary is a core systems-design principle.

#### Milestone skeleton: packed headers (pragmatic approach)

```c
#include <assert.h>

#pragma pack(push, 1)                       /* no padding between fields */
typedef struct {
    uint16_t signature;                     /* 0x4D42 when read as LE */
    uint32_t file_size;
    uint16_t reserved1, reserved2;
    uint32_t data_offset;
} BmpFileHeader;

typedef struct {
    uint32_t header_size;
    int32_t  width, height;                 /* SIGNED */
    uint16_t planes, bpp;
    uint32_t compression, image_size;
    int32_t  x_ppm, y_ppm;
    uint32_t colors_used, colors_important;
} BmpInfoHeader;
#pragma pack(pop)

static_assert(sizeof(BmpFileHeader) == 14, "file header must be 14 bytes");
static_assert(sizeof(BmpInfoHeader) == 40, "info header must be 40 bytes");
```

> **Why packed structs are risky:** (1) They assume a little-endian host; on big-endian you must byte-swap. (2) Taking a pointer to a packed member (`&hdr.width`) can produce a misaligned pointer, which is UB on some CPUs. (3) Compilers differ on `#pragma pack`. The portable alternative is `get_u32le(buf + 18)`-style decoding. **Use `_Static_assert` either way**: it turns silent layout bugs into compile errors.

#### Milestone skeleton: `include/endian_io.h`

```c
static inline uint16_t rd_u16le(const uint8_t *p)
{
    return (uint16_t)(p[0] | (p[1] << 8));
}
static inline uint32_t rd_u32le(const uint8_t *p)
{
    return  (uint32_t)p[0]        | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}
static inline int32_t rd_i32le(const uint8_t *p)
{
    uint32_t u = rd_u32le(p);
    int32_t  s;
    memcpy(&s, &u, sizeof s);   /* well-defined reinterpretation */
    return s;
}
/* TODO: wr_u16le / wr_u32le for bmp_save */
```

> **Why cast to `uint32_t` *before* shifting?** `p[3]` is a `uint8_t`, which is promoted to `int`. `p[3] << 24` can shift into the sign bit of a 32-bit `int`: **signed overflow = undefined behavior**. UBSan will flag it. Casting first keeps the arithmetic unsigned and well-defined.

#### Checkpoint 1

```bash
./bmpkit info tests/fixtures/gradient_5x3.bmp
# Size: 5x3   BPP: 24   Orientation: bottom-up
# Row stride: 16 bytes (15 pixel bytes + 1 padding)
./bmpkit info tests/fixtures/bad_magic.bmp   # clear error, exit code != 0, no crash
```

---

### Part 2: Load Pixels & Round-Trip Save

#### Tasks

- [ ] Allocate `width * height * 3` bytes with **checked multiplication**.
- [ ] Read each row from the file using the **padded stride**, copying only the real pixel bytes into your tight buffer; skip padding with `fseek` or read into a scratch row.
- [ ] If `height > 0` (bottom-up), place file row `i` at `img.height - 1 - i`.
- [ ] Implement `bmp_save`: write headers (with computed `file_size`, `data_offset = 54`), then rows **bottom-up with zeroed padding**.
- [ ] **Round-trip test:** `load → save → load → compare pixels` is identical; `cmp` the files for canonical inputs.

#### Milestone skeleton

```c
/* Checked size computation: returns 0 on overflow, 1 on success. */
static int checked_mul_size(size_t a, size_t b, size_t *out)
{
    if (a != 0 && b > SIZE_MAX / a) return 0;
    *out = a * b;
    return 1;
}

static size_t row_stride(uint32_t width)       /* bpp fixed at 24 */
{
    return ((size_t)width * 24 + 31) / 32 * 4;
}

BmpStatus bmp_load(const char *path, Image *out)
{
    *out = (Image){0};
    FILE *fp = fopen(path, "rb");
    if (!fp) return BMP_ERR_IO;

    BmpStatus rc = BMP_ERR_CORRUPT;
    uint8_t  *row = NULL;

    /* 1. read + decode + validate headers (Part 1)
     * 2. compute stride, tight_size = w*h*3 with overflow check
     * 3. enforce a sanity cap, e.g. w,h <= 20000 and tight_size <= 1 GiB
     * 4. fseek(fp, data_offset, SEEK_SET)
     * 5. allocate img.pixels and a stride-sized scratch `row`
     * 6. for each file row: fread(row, 1, stride, fp) == stride ? else truncated
     *      memcpy into correct destination row
     */
    /* ... */
    free(row);
    fclose(fp);
    return rc;
}
```

> **Why cap dimensions even if arithmetic doesn't overflow?** A 40-byte header claiming `65535 x 65535` is valid arithmetic but requests ~12 GB. Untrusted input must never directly control allocation size without a policy limit. That is how decompression-bomb-style denial of service works.

#### Checkpoint 2

```bash
./bmpkit copy in.bmp out.bmp && cmp in.bmp out.bmp && echo "byte-identical"
```

(If the original has non-zero padding or extra header fields, compare via pixel data instead. Explain why in `notes.md`.)

---

### Part 3: Pixel Filters

#### Tasks

- [ ] Define a filter signature and apply it generically:

```c
typedef void (*PixelOp)(uint8_t *b, uint8_t *g, uint8_t *r, void *ctx);

void image_map(Image *img, PixelOp op, void *ctx)
{
    size_t n = (size_t)img->width * img->height;
    uint8_t *p = img->pixels;
    for (size_t i = 0; i < n; i++, p += 3)
        op(&p[0], &p[1], &p[2], ctx);
}
```

- [ ] **Invert:** `255 - v`, or equivalently `~v` (why does `~v` work for `uint8_t`? And what's the integer-promotion catch?)
- [ ] **Grayscale** using integer math, **no floating point**:

```c
/* Rec. 601 luma, scaled by 256: 0.299≈77/256, 0.587≈150/256, 0.114≈29/256 */
uint8_t y = (uint8_t)((77u * r + 150u * g + 29u * b) >> 8);
```

- [ ] **Brightness** with **saturating** add/subtract (clamp to 0-255).
- [ ] **Channel isolate** (`--only red`) and **channel swap** (swap R/B).
- [ ] **Threshold** (black/white) using a comparison and bitmask.

> **Why integer fixed-point instead of `float`?** It's faster on cores without strong FPUs, deterministic across platforms, and teaches you the scaled-integer technique used in codecs and embedded systems. The `>> 8` is a divide-by-256 that costs one instruction.

> **Why saturating arithmetic?** `uint8_t` arithmetic wraps: `250 + 10 == 4`, so a "brighter" pixel turns dark. Clamp explicitly: `int v = a + delta; v = v < 0 ? 0 : v > 255 ? 255 : v;`

---

### Part 4: Geometric Transforms

#### Tasks

- [ ] **Flip horizontal/vertical:** vertical swaps whole rows with `memcpy` through a temp row; horizontal swaps 3-byte pixels within each row.
- [ ] **Rotate 90° clockwise:** needs a **new buffer** of size `h x w` (why can't it be done in-place for non-square images?). Derive the mapping: `dst(x', y') = src(y, h-1-x')`-style, and *prove it on paper* with a 3x2 example.
- [ ] **Crop:** validate the rectangle is entirely inside the image before copying; use `memcpy` per row.
- [ ] **Resize (nearest-neighbor)** as a stretch.

#### Milestone skeleton

```c
static inline uint8_t *px(const Image *img, uint32_t x, uint32_t y)
{
    return img->pixels + ((size_t)y * img->width + x) * 3;
}

BmpStatus image_crop(const Image *src, uint32_t x, uint32_t y,
                     uint32_t w, uint32_t h, Image *dst)
{
    /* Careful: x + w can overflow uint32_t. Compare as: w <= src->width - x */
    if (x >= src->width || y >= src->height) return BMP_ERR_CORRUPT;
    if (w > src->width - x || h > src->height - y) return BMP_ERR_CORRUPT;
    /* TODO: allocate dst, copy h rows of w*3 bytes each */
    return BMP_OK;
}
```

> **Why `w > src->width - x` instead of `x + w > src->width`?** The latter can wrap around for huge `w` and pass the check wrongly. Rearranging so only a *safe subtraction* occurs (after verifying `x < width`) is the standard overflow-safe bounds-check pattern.

---

### Part 5: Box Blur & Performance

#### Tasks

- [ ] Implement an NxN box blur (radius r, window `(2r+1)²`) on a **separate output buffer**.
- [ ] Handle borders by clamping coordinates to the nearest edge.
- [ ] Write the naive O(w·h·r²) version first, verify visually, then optimize to **separable** two-pass O(w·h·r) (horizontal blur then vertical blur).
- [ ] Time with `clock_gettime(CLOCK_MONOTONIC)` and compare naive vs. separable.
- [ ] Build with `BUILD=release` for timing (sanitizers distort performance).

#### Milestone skeleton

```c
static inline int clampi(int v, int lo, int hi)
{
    return v < lo ? lo : (v > hi ? hi : v);
}

/* dst must be a distinct buffer from src, same size. */
void blur_naive(const Image *src, Image *dst, int radius)
{
    int w = (int)src->width, h = (int)src->height;
    int window = (2 * radius + 1) * (2 * radius + 1);
    for (int y = 0; y < h; y++)
        for (int x = 0; x < w; x++)
            for (int c = 0; c < 3; c++) {
                unsigned sum = 0;
                for (int dy = -radius; dy <= radius; dy++)
                    for (int dx = -radius; dx <= radius; dx++) {
                        int sx = clampi(x + dx, 0, w - 1);
                        int sy = clampi(y + dy, 0, h - 1);
                        sum += src->pixels[((size_t)sy * w + sx) * 3 + c];
                    }
                dst->pixels[((size_t)y * w + x) * 3 + c] = (uint8_t)(sum / window);
            }
}
```

> **Why a separate destination buffer?** Blurring in place would read pixels you've *already overwritten* in this pass, so results would depend on traversal order. Neighborhood operations need an immutable source.

> **Cache awareness:** The loops iterate `y` outer, `x` inner, matching row-major memory layout, so memory access is sequential. Swap the loop order and measure: for large images you will see a significant slowdown from cache misses. Record the numbers in `notes.md`.

---

### Bonus: ELF Header Reader

Apply the same discipline to `/bin/ls`. Read `Elf64_Ehdr` manually (don't include `<elf.h>` at first), print: class (32/64-bit), endianness (`e_ident[EI_DATA]`), type, machine, entry point, number of program/section headers. Compare to `readelf -h /bin/ls`.

---

## 7. Common Bugs & Pitfalls

| Bug | Symptom | Prevention |
|-----|---------|-----------|
| **Ignoring row padding** | Image appears skewed / diagonal stripes | Always use `stride`, never `width*3`, when reading the *file* |
| **Rows in wrong order** | Image upside down | Remember bottom-up unless height < 0 |
| **Treating pixels as RGB** | Reds and blues swapped | BMP is **BGR** |
| **`height` as unsigned** | Top-down images rejected or huge allocation | Read as `int32_t`; normalize with `abs` carefully (`INT32_MIN`!) |
| **`abs(INT32_MIN)`** | UB / still negative | Reject `INT32_MIN` explicitly |
| **`fread` short count ignored** | Garbage pixels on truncated files | Compare to expected count; treat as `BMP_ERR_CORRUPT` |
| **`width * height * 3` in `int`** | Overflow → tiny malloc → heap overflow | Use `size_t` + `checked_mul_size` |
| **Trusting `file_size` field** | Lies in header | Compare to real size from `ftell` |
| **Trusting `data_offset`** | Reads outside file or into headers | Validate range |
| **Struct `fread` on packed header w/out `static_assert`** | Silent wrong offsets | `static_assert(sizeof(...) == N)` |
| **Signed shift overflow** | UBSan "left shift of ... cannot be represented" | Cast to `uint32_t` before shifting |
| **uint8_t arithmetic wraparound** | Dark pixels in bright areas | Widen to `int`, clamp, narrow |
| **In-place neighborhood filter** | Smeared / directional artifacts | Separate output buffer |
| **Leaking on error paths** | Valgrind loss in fuzz runs | `goto cleanup` pattern from Project 2 |
| **Using `ftell` result as `int`** | Fails on >2 GB files | Store in `long`/`off_t`, check for -1 |

---

## 8. Testing & Verification Exercises

### 8.1 Fixtures

Generate with ImageMagick in `tests/gen_fixtures.sh`:

```bash
convert -size 1x1   xc:red                    BMP3:fixtures/1x1.bmp
convert -size 5x3   gradient:red-blue         BMP3:fixtures/gradient_5x3.bmp   # padding case
convert -size 4x4   pattern:checkerboard      BMP3:fixtures/checker_4x4.bmp
convert -size 1000x800 plasma:fractal         BMP3:fixtures/big.bmp
```

Include **widths 1, 2, 3, 4, 5** to exercise all four padding amounts (0-3 bytes).

### 8.2 Unit tests

- [ ] `rd_u32le` on known byte patterns, including `0xFF FF FF FF` and `0x00 00 00 80`
- [ ] Stride calculation for widths 1..16: compare with a brute-force formula
- [ ] Round-trip for every fixture
- [ ] Each filter on a 2x2 image with hand-computed expected output (invert twice == identity; flip twice == identity; rotate 4x == identity)
- [ ] Crop boundaries: full-image crop, 1x1 crop at the corner, off-by-one-outside (must fail)

### 8.3 Malformed-input tests: required

Hand-craft or generate and assert **graceful errors, never crashes**:

- [ ] Empty file, 1-byte file, 13-byte file (shorter than the header)
- [ ] Wrong signature
- [ ] `data_offset` beyond EOF; `data_offset` < 54
- [ ] `width = 0`, `width = -5`, `height = INT32_MIN`, `width = 0x7FFFFFFF`
- [ ] Truncated pixel data (header OK, half the rows missing)
- [ ] `bpp = 8` or `32` (unsupported → clean error)
- [ ] `compression != 0`

### 8.4 Byte-flip fuzzing (simple but effective)

```bash
# tests/fuzz_corrupt.sh
for i in $(seq 1 2000); do
    cp fixtures/gradient_5x3.bmp /tmp/fz.bmp
    off=$((RANDOM % 80))                          # focus on header region
    printf "\\x$(printf %02x $((RANDOM % 256)))" | \
        dd of=/tmp/fz.bmp bs=1 seek=$off conv=notrunc 2>/dev/null
    ./bmpkit info /tmp/fz.bmp >/dev/null 2>&1
    rc=$?
    # 0 or 1 is acceptable. 139 (SIGSEGV) or 134 (abort/ASan) is a BUG.
    if [ $rc -ge 128 ]; then cp /tmp/fz.bmp crash_$i.bmp; echo "CRASH $i"; fi
done
```

Under ASan/UBSan, any report fails the run. Fix every crash and keep the file as a regression fixture.

### 8.5 Valgrind & visual verification

```bash
valgrind --leak-check=full --error-exitcode=1 ./bmpkit gray tests/fixtures/big.bmp /tmp/o.bmp
xxd /tmp/o.bmp | head -5                         # inspect headers by eye
compare -metric AE ours.bmp magick_out.bmp diff.png    # compare against ImageMagick's own result
```

For grayscale, allow a tiny tolerance (`-fuzz 2%`) because ImageMagick's coefficients differ slightly.

---

## 9. Stretch Goals

- [ ] Support **32-bit** (BGRA) and **8-bit palettized** BMPs
- [ ] Support the **V4/V5 headers** (`header_size` 108/124)
- [ ] Write a PPM/PGM exporter, then a simple **PNG writer** (stored deflate blocks + CRC32/Adler32)
- [ ] Sobel edge detection (3x3 convolution with signed kernels)
- [ ] Process rows in parallel with `pthread` (preview of Project 4) and measure speedup
- [ ] SIMD-friendly layout and `-O3 -march=native` benchmarks
- [ ] Complete the ELF reader: list section names from `.shstrtab`

## 10. Definition of Done

- [ ] `info`, `gray`, `invert`, `flip`, `rotate`, `crop`, `blur` all work and match expected outputs
- [ ] Parser rejects every malformed fixture cleanly: no crashes, no leaks, no sanitizer reports
- [ ] 2000-iteration byte-flip fuzz run finds no crashes
- [ ] No filter depends on host endianness
- [ ] `notes.md` documents: padding math, why each header field is validated, and benchmark of naive vs. separable blur

➡️ **Next:** [Project 4: Multithreaded HTTP Server](../04_http_server/README.md)
