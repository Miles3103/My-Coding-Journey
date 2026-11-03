# Project 4: `tinyhttpd`, a Multithreaded HTTP Web Server

**Level:** Intermediate → Advanced | **Estimated time:** 3 weeks | **Prev:** [Project 3](../03_bmp_parser/README.md) | **Next:** [Project 5](../05_allocator/README.md)

---

## 1. Overview

You will build a static-file HTTP/1.1 server using only POSIX APIs: raw sockets, `pthread`, and a **thread pool** fed by a bounded work queue.

```bash
./tinyhttpd --port 8080 --root ./www --threads 8
curl -i http://localhost:8080/index.html
curl -i http://localhost:8080/../../etc/passwd     # must be refused (403/404)
ab -n 20000 -c 100 http://localhost:8080/index.html
```

### Why this project matters for a C developer

Servers combine *every* hard problem in systems programming at once:

- **Networking:** byte streams, partial reads/writes, protocol parsing.
- **Concurrency:** shared state, races, deadlocks, memory visibility.
- **Resource management:** file descriptors are finite; leaks kill servers.
- **Security:** every byte arriving on a socket is hostile until proven otherwise.
- **Signals and lifecycle:** graceful shutdown without losing in-flight work.

You will also see why C remains the language of choice for network infrastructure (nginx, Redis, memcached) and why it needs discipline.

---

## 2. Core C Concepts Learned

- [ ] POSIX sockets: `socket`, `setsockopt`, `bind`, `listen`, `accept`, `recv`, `send`, `close`, `shutdown`
- [ ] `getaddrinfo`, `struct sockaddr`, `sockaddr_in`, `htons`/`ntohs`, IPv4/IPv6 basics
- [ ] TCP as a **byte stream** (no message boundaries!)
- [ ] `pthread_create`, `pthread_join`, `pthread_mutex_t`, `pthread_cond_t`
- [ ] Bounded producer/consumer queue (ring buffer)
- [ ] Signal handling: `sigaction`, `volatile sig_atomic_t`, `SIGPIPE`, `SIGINT`
- [ ] Robust I/O helpers: handling `EINTR`, short reads/writes
- [ ] HTTP/1.x request parsing in a fixed-size buffer
- [ ] Filesystem safety: `realpath`, `open`, `fstat`, `O_RDONLY`, path-traversal defense
- [ ] Thread-safe programming: reentrant functions (`localtime_r`, `strerror_r`)
- [ ] Timeouts: `SO_RCVTIMEO`, `poll`
- [ ] Atomics (`<stdatomic.h>`) for counters
- [ ] ThreadSanitizer and Helgrind

---

## 3. Prerequisites & Lessons to Study First

| Topic | What to understand |
|-------|-------------------|
| **TCP vs UDP** | Streams vs. datagrams; 3-way handshake; `TIME_WAIT` and why `SO_REUSEADDR` matters |
| **Client/server socket lifecycle** | The exact call order on each side. Read **Beej's Guide** chapters 1-7 |
| **Network byte order** | Big-endian on the wire; `htons`/`htonl` |
| **HTTP/1.1 basics (RFC 9112)** | Request line, headers, CRLF, blank line terminator, status codes, `Content-Length`, `Connection: close` vs. keep-alive |
| **File descriptors** | Per-process table, limits (`ulimit -n`), what `accept` returns |
| **`read`/`write` semantics** | Returning fewer bytes than requested is **normal** |
| **Threads vs. processes** | Shared address space; what's shared, what's per-thread (stack, `errno`) |
| **Mutexes & condition variables** | Why `pthread_cond_wait` needs a **loop**; spurious wakeups; lost wakeups |
| **Data races & memory model** | Why "it's just an int" is not safe; what a race is formally |
| **Deadlock** | Four Coffman conditions; lock ordering |
| **Signals** | Async-signal-safe functions only; why handlers should just set a flag |
| **Path traversal attacks** | `../`, URL-encoding (`%2e%2e`), symlinks, absolute paths |

---

## 4. Repository Directory Layout

```text
04_http_server/
├── README.md
├── Makefile
├── include/
│   ├── net.h            # listen_socket(), read_request(), write_all()
│   ├── http.h           # Request/Response types, parse, status text
│   ├── queue.h          # bounded blocking queue
│   ├── pool.h           # thread pool
│   ├── files.h          # path resolution + MIME types
│   └── log.h            # thread-safe logging
├── src/
│   ├── main.c           # config, signals, accept loop
│   ├── net.c
│   ├── http.c
│   ├── queue.c
│   ├── pool.c
│   ├── files.c
│   └── log.c
├── www/                 # sample site: index.html, style.css, image.png, big.bin
├── tests/
│   ├── test_queue.c     # multi-threaded queue stress test
│   ├── test_http_parse.c
│   ├── test_paths.c
│   └── smoke.sh         # curl/nc-based integration tests
└── notes.md
```

Link with `-pthread` (not just `-lpthread`): it sets both compile and link flags correctly.

---

## 5. Step-by-Step Parts

| Part | Goal |
|------|------|
| 1 | Single-threaded echo/"hello" server: sockets from scratch |
| 2 | HTTP request parser (robust to partial reads and garbage) |
| 3 | Static file serving, MIME types, directory-traversal protection |
| 4 | Thread pool + bounded blocking queue |
| 5 | Hardening: signals, graceful shutdown, timeouts, limits, logging |

---

### Part 1: Single-Threaded Server

#### Tasks

- [ ] Create a listening TCP socket on a configurable port.
- [ ] `setsockopt(SO_REUSEADDR)` **before** `bind`.
- [ ] Accept connections in a loop; for each, read some bytes and reply with a fixed `200 OK` response containing "hello"; close the connection.
- [ ] Handle every error return with `perror` and appropriate cleanup.
- [ ] Ignore `SIGPIPE` (or use `MSG_NOSIGNAL`). Understand *why* a write to a closed socket kills your process by default.
- [ ] Write `write_all()` that loops until all bytes are sent.

#### Milestone skeleton: `src/net.c`

```c
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

/* Returns listening fd, or -1 (errno set). */
int listen_socket(uint16_t port, int backlog)
{
    int fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) return -1;

    int yes = 1;
    if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof yes) < 0)
        goto fail;

    struct sockaddr_in addr;
    memset(&addr, 0, sizeof addr);          /* zero padding bytes too */
    addr.sin_family      = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_ANY);
    addr.sin_port        = htons(port);     /* HOST → NETWORK byte order */

    if (bind(fd, (struct sockaddr *)&addr, sizeof addr) < 0) goto fail;
    if (listen(fd, backlog) < 0) goto fail;
    return fd;
fail: {
        int saved = errno;                  /* close() may clobber errno */
        close(fd);
        errno = saved;
        return -1;
    }
}

/* Writes exactly len bytes unless an error occurs. 0 = ok, -1 = error. */
int write_all(int fd, const void *buf, size_t len)
{
    const char *p = buf;
    while (len > 0) {
        ssize_t n = send(fd, p, len, MSG_NOSIGNAL);
        if (n < 0) {
            if (errno == EINTR) continue;   /* interrupted by signal: retry */
            return -1;
        }
        p   += n;                           /* partial write is NORMAL */
        len -= (size_t)n;
    }
    return 0;
}
```

> **Why `SO_REUSEADDR`?** After you kill the server, the kernel keeps the port in `TIME_WAIT` for up to ~60 s. Without this option, restarting gives `Address already in use`, and every beginner hits this.

> **Why `htons`?** Network byte order is big-endian; your CPU is probably little-endian. Forgetting `htons(8080)` binds you to port 36895 (`0x1F90` byte-swapped). `htons` is a no-op on big-endian machines, so you can't "test" for it only on your own computer, which is why it's in your muscle memory.

> **Why the `errno` save in `fail`?** `close()` can overwrite `errno` with its own result, so the caller would see a misleading error. Preserving the first error is idiomatic C error handling.

#### Checkpoint 1

```bash
./tinyhttpd --port 8080 &
curl -v http://localhost:8080/        # sees "hello"
ss -tlnp | grep 8080                   # confirm it's listening
echo "hi" | nc localhost 8080
```

---

### Part 2: HTTP Request Parser

#### Tasks

- [ ] Read from the socket **until** you find `\r\n\r\n` (end of headers) into a fixed buffer (e.g., 8 KB). Because TCP is a stream, a single `recv` may return half a request, or two pipelined ones.
- [ ] If the buffer fills before the terminator arrives → respond `431`/`400` and close.
- [ ] Parse the **request line**: `METHOD SP TARGET SP VERSION`. Support `GET` and `HEAD`; reply `405` for others, `400` for malformed, `505` for unsupported versions.
- [ ] Parse headers into a small array of `(name, value)` slices (pointers into the buffer plus lengths). Header names are case-insensitive.
- [ ] Reject: NUL bytes, bare `\n`, over-long lines, too many headers.
- [ ] Parse as **slices** (pointer + length) rather than copying strings. Zero allocations per request.

#### Milestone skeleton: `include/http.h`

```c
#include <stddef.h>

#define MAX_HEADER_BYTES 8192
#define MAX_HEADERS      32

typedef struct { const char *ptr; size_t len; } Slice;   /* NOT NUL-terminated */

typedef struct {
    Slice method, target, version;
    struct { Slice name, value; } headers[MAX_HEADERS];
    size_t nheaders;
} HttpRequest;          /* all Slices point INTO the raw request buffer */

typedef enum {
    PARSE_OK, PARSE_INCOMPLETE, PARSE_BAD_REQUEST,
    PARSE_TOO_LARGE, PARSE_BAD_VERSION
} ParseResult;

/* buf[0..len) holds bytes received so far. Does not modify buf. */
ParseResult http_parse_request(const char *buf, size_t len, HttpRequest *out);
```

#### Milestone skeleton: reading until headers complete

```c
/* Returns total bytes read (headers complete), 0 on clean close, -1 on error,
 * -2 if the header section exceeded cap. */
ssize_t read_request(int fd, char *buf, size_t cap)
{
    size_t used = 0;
    while (used < cap) {
        ssize_t n = recv(fd, buf + used, cap - used, 0);
        if (n == 0)  return used ? -1 : 0;          /* peer closed */
        if (n < 0) {
            if (errno == EINTR) continue;
            return -1;                              /* incl. EAGAIN on timeout */
        }
        used += (size_t)n;
        /* search for "\r\n\r\n" (only needs to scan the last n+3 bytes) */
        if (find_header_end(buf, used)) return (ssize_t)used;
    }
    return -2;
}
```

> **Why slices instead of `strdup`'d strings?** The request buffer already contains the bytes. Pointing into it avoids a `malloc`/`free` per field, which is faster, has no leak surface, and a *lifetime* rule that's easy to state: "slices are valid as long as the buffer is." The cost is that you must carry lengths, since these aren't NUL-terminated and `strlen`/`strcmp` don't work on them. Use `memcmp` and `strncasecmp` with explicit lengths.

> **Security note:** HTTP request smuggling, header injection, and buffer overflows all begin with sloppy parsers. Be **strict**: when in doubt, reject with 400.

---

### Part 3: Serving Static Files Safely

#### Tasks

- [ ] Map `GET /path` → `<root>/path`; `/` → `/index.html`.
- [ ] **URL-decode** `%XX` and **then** validate. Reject `%00`, and reject `..` segments after decoding.
- [ ] Resolve with `realpath()` and verify the result begins with `<root_realpath>/`. This also defeats symlink escapes.
- [ ] `open()` the file, `fstat()` the **fd** (not the path), and reject non-regular files (directories → 403/404).
- [ ] Send headers: `Content-Type` (by extension), `Content-Length` (from `st_size`), `Connection: close`, `Date`.
- [ ] Stream the body with a fixed-size buffer (64 KB) via `read` + `write_all`. **Do not** load whole files into memory.
- [ ] `HEAD` returns headers only.
- [ ] Optional: `sendfile(2)` for zero-copy transfer; measure the difference.

#### Milestone skeleton: path safety

```c
#include <limits.h>
#include <stdlib.h>
#include <string.h>

/* Returns 0 and fills out_path (resolved, inside root) or -1 on rejection.
 * root_real must itself be the realpath() of the document root, computed once
 * at startup. */
int resolve_path(const char *root_real, const char *decoded_target,
                 char *out_path, size_t out_cap)
{
    char joined[PATH_MAX];
    int n = snprintf(joined, sizeof joined, "%s%s", root_real, decoded_target);
    if (n < 0 || (size_t)n >= sizeof joined) return -1;      /* truncated */

    char *real = realpath(joined, NULL);       /* malloc'd result (POSIX.1-2008) */
    if (!real) return -1;                      /* nonexistent or unreadable */

    size_t rl = strlen(root_real);
    int ok = strncmp(real, root_real, rl) == 0 &&
             (real[rl] == '/' || real[rl] == '\0');   /* "/www" vs "/www-secret"! */
    if (ok && strlen(real) < out_cap) strcpy(out_path, real); else ok = 0;
    free(real);
    return ok ? 0 : -1;
}
```

> **Why the `real[rl] == '/'` check?** A naive prefix test would let `/srv/www-secret/key` pass for a root of `/srv/www`. Always compare **path components**, not raw string prefixes.

> **Why `fstat` on the open fd rather than `stat` on the path?** Between `stat(path)` and `open(path)` an attacker can swap the file for a symlink. This is a **TOCTOU** (time-of-check-to-time-of-use) race. Opening first, then checking the *descriptor*, closes the window. (`O_NOFOLLOW` and `openat2` give stronger options. Research them.)

---

### Part 4: Thread Pool & Bounded Queue

#### Architecture

```text
            ┌────────────┐   fd   ┌──────────────────┐   fd   ┌──────────────┐
 clients ──▶│ accept loop│──push─▶│ bounded FD queue │──pop──▶│ worker 1..N  │
            │ (main thd) │        │ mutex + 2 condvars│        │ handle(fd)   │
            └────────────┘        └──────────────────┘        └──────────────┘
```

**Why a pool, not thread-per-connection?** Thread creation costs time and stack memory (≈8 MB virtual each). Unbounded threads let an attacker exhaust memory or hit `RLIMIT_NPROC`. A fixed pool bounds resources; the **bounded queue** gives you *backpressure* (when the queue is full, you can reject with `503` instead of dying).

#### Tasks

- [ ] Implement a fixed-capacity ring-buffer queue of `int` fds with `mutex`, `not_empty`, `not_full`.
- [ ] `queue_push` blocks when full (or provide `queue_try_push` for the 503 path). `queue_pop` blocks when empty.
- [ ] Support **shutdown**: after `queue_close()`, pops drain remaining items then return "closed"; pushes fail. Wake all waiters with `pthread_cond_broadcast`.
- [ ] Create N worker threads at startup; each loops `pop → handle_connection → close`.
- [ ] Make logging thread-safe (a mutex around `fprintf`, or one `write` call per log line).
- [ ] Keep a global `atomic_ulong requests_served`; expose via `/status`.

#### Milestone skeleton: `include/queue.h` and `src/queue.c`

```c
#include <pthread.h>
#include <stdbool.h>
#include <stddef.h>

typedef struct {
    int             *items;      /* ring buffer, capacity slots */
    size_t           cap, head, tail, count;
    bool             closed;
    pthread_mutex_t  mu;
    pthread_cond_t   not_empty;
    pthread_cond_t   not_full;
} FdQueue;

int  fdq_init(FdQueue *q, size_t cap);
void fdq_destroy(FdQueue *q);
int  fdq_push(FdQueue *q, int fd);   /* 0 ok; -1 if closed */
int  fdq_pop (FdQueue *q, int *fd);  /* 0 ok; -1 if closed AND empty */
void fdq_close(FdQueue *q);
```

```c
int fdq_push(FdQueue *q, int fd)
{
    pthread_mutex_lock(&q->mu);
    while (q->count == q->cap && !q->closed)          /* WHILE, not IF */
        pthread_cond_wait(&q->not_full, &q->mu);
    if (q->closed) { pthread_mutex_unlock(&q->mu); return -1; }

    q->items[q->tail] = fd;
    q->tail = (q->tail + 1) % q->cap;
    q->count++;
    pthread_cond_signal(&q->not_empty);
    pthread_mutex_unlock(&q->mu);
    return 0;
}

int fdq_pop(FdQueue *q, int *fd)
{
    pthread_mutex_lock(&q->mu);
    while (q->count == 0 && !q->closed)
        pthread_cond_wait(&q->not_empty, &q->mu);
    if (q->count == 0) { pthread_mutex_unlock(&q->mu); return -1; }  /* closed+empty */
    /* TODO: take items[head], advance head, count--, signal not_full */
    pthread_mutex_unlock(&q->mu);
    return 0;
}
```

> **Why `while` and not `if` around `pthread_cond_wait`?** Condition variables can wake **spuriously**, and another thread may have consumed the item between the signal and your wakeup. The predicate must be **re-checked under the lock**. `if` here is the most common concurrency bug in beginner C code.

> **Why does `pthread_cond_wait` take the mutex?** It atomically *releases* the mutex and sleeps, then *re-acquires* it on wake. If those steps weren't atomic, a signal sent between "unlock" and "sleep" would be lost forever (a *lost wakeup*).

> **Who owns the fd?** Document it: the accept loop owns it until `push` succeeds; then the worker owns it and **must** `close` it on every path. An fd leak under load shows up as `accept: Too many open files`. Test with `ls /proc/$(pidof tinyhttpd)/fd | wc -l` before/after a load test.

#### Checkpoint 4

```bash
ab -n 20000 -c 100 http://localhost:8080/index.html      # 0 failed requests
ls /proc/$(pidof tinyhttpd)/fd | wc -l                   # roughly constant, not growing
```

---

### Part 5: Hardening & Graceful Shutdown

#### Tasks

- [ ] **Signals:** install `SIGINT`/`SIGTERM` handlers with `sigaction` (no `SA_RESTART`, so `accept` returns `EINTR`) that only set a `volatile sig_atomic_t stop` flag.
- [ ] On shutdown: stop accepting → `fdq_close` → `pthread_join` all workers (they finish in-flight requests) → free resources → exit `0`.
- [ ] **Timeouts:** `setsockopt(SO_RCVTIMEO/SO_SNDTIMEO)` ~5 s so a client who connects and sends nothing (**Slowloris**) can't pin a worker forever.
- [ ] **Limits:** max header bytes, max headers, max URL length; reject with proper status codes.
- [ ] **Backpressure:** if queue is full → `503 Service Unavailable` immediately and close.
- [ ] **Logging:** one line per request: time (`localtime_r`/`gmtime_r`), peer IP (`inet_ntop`), method, path, status, bytes, thread id.
- [ ] *(Stretch)* HTTP/1.1 keep-alive with an idle timeout.

#### Milestone skeleton: signals & accept loop

```c
static volatile sig_atomic_t g_stop = 0;

static void on_signal(int sig) { (void)sig; g_stop = 1; }   /* nothing else! */

static void install_signals(void)
{
    struct sigaction sa;
    memset(&sa, 0, sizeof sa);
    sa.sa_handler = on_signal;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;                       /* no SA_RESTART: let accept() see EINTR */
    sigaction(SIGINT,  &sa, NULL);
    sigaction(SIGTERM, &sa, NULL);
    signal(SIGPIPE, SIG_IGN);              /* or use MSG_NOSIGNAL everywhere */
}

/* accept loop */
while (!g_stop) {
    struct sockaddr_storage peer; socklen_t plen = sizeof peer;
    int cfd = accept(lfd, (struct sockaddr *)&peer, &plen);
    if (cfd < 0) {
        if (errno == EINTR) continue;                    /* re-check g_stop */
        if (errno == EMFILE || errno == ENFILE) { /* out of fds: back off briefly */ }
        perror("accept"); continue;
    }
    set_socket_timeouts(cfd, 5);
    if (fdq_push(&queue, cfd) < 0) { close(cfd); break; }
}
```

> **Why can a signal handler only set a flag?** Handlers interrupt your program at an arbitrary instruction, possibly *inside* `malloc` or `printf`. Calling those again from the handler can deadlock or corrupt state. Only **async-signal-safe** functions (see `man 7 signal-safety`) are allowed, and a `volatile sig_atomic_t` write is the canonical safe action.

> **Why `volatile sig_atomic_t`?** `volatile` stops the compiler from caching `g_stop` in a register so the loop never sees the update; `sig_atomic_t` guarantees the write/read isn't torn. (`volatile` is **not** a substitute for atomics or locks between *threads*. Use `<stdatomic.h>` there.)

---

## 6. Common Bugs & Pitfalls

| Bug | Symptom | Prevention |
|-----|---------|-----------|
| **Assuming one `recv` = one request** | Works on localhost, fails over a real network | Loop until `\r\n\r\n` |
| **Assuming `send` writes everything** | Truncated big files | `write_all` loop |
| **Forgetting `SIGPIPE`** | Server dies when a client disconnects mid-response | `signal(SIGPIPE, SIG_IGN)` / `MSG_NOSIGNAL` |
| **`if` instead of `while` with condvar** | Rare crashes/hangs under load | Always re-check predicate in a loop |
| **Signal without holding lock / wrong order** | Lost wakeups, hangs | Pattern: lock → modify state → signal → unlock |
| **Not closing fds on error paths** | `EMFILE` after hours | One owner; `close` in a single exit path |
| **Passing pointer to a stack `int` to `pthread_create`** | Threads see changed/garbage value | Pass heap-allocated arg, or an index into a long-lived array |
| **Using `strtok`, `localtime`, `strerror`, `inet_ntoa`** | Races between threads, garbled logs | `_r` variants (`strtok_r`, `localtime_r`, `strerror_r`, `inet_ntop`) |
| **Unsynchronized shared counter (`count++`)** | Lost updates (data race = UB) | `atomic_fetch_add` or mutex |
| **Locking order inversion** | Deadlock | Document lock order; avoid holding two locks |
| **Holding the queue lock while doing I/O** | Serializes the whole server | Hold locks for the shortest time possible |
| **Path traversal (`../`, `%2e%2e`, symlinks)** | Arbitrary file disclosure | Decode → `realpath` → prefix + separator check |
| **Header buffer overflow** | Memory corruption | Track `used`/`cap` rigorously; never `strcpy` request data |
| **Using `Content-Length` from a request blindly** | Memory exhaustion | Cap it (even if you only support GET) |
| **Using `volatile` for thread sync** | Still racy | Use mutexes/atomics |
| **Forgetting `pthread_join`** | Use-after-free at shutdown | Join all workers before freeing shared structs |
| **Logging with unbounded `%s` of attacker input** | Log injection (`\r\n` forges lines) | Escape control characters |
| **`accept` loop spinning on `EMFILE`** | 100% CPU | Brief sleep / shed load |

---

## 7. Testing & Verification Exercises

### 7.1 Unit tests (no network needed)

- [ ] **Queue stress test:** 4 producers push 1M integers total; 4 consumers pop; verify sum and count match (nothing lost/duplicated). Run for several seconds under TSan.
- [ ] **Parser tests:** valid GET/HEAD; missing version; lowercase method; header with no colon; 9 KB header; `\n`-only line endings; embedded NUL; tab/space edge cases.
- [ ] **Path tests:** `/`, `/a/../b`, `/%2e%2e/etc/passwd`, `/%00`, `//etc/passwd`, `/symlink-to-/etc`, a very long path.

### 7.2 Integration tests with `curl` & `nc`

```bash
curl -i  http://localhost:8080/index.html                  # 200 + correct Content-Length
curl -I  http://localhost:8080/index.html                  # HEAD: headers only
curl -i  --path-as-is http://localhost:8080/../etc/passwd  # must NOT succeed
curl -i  http://localhost:8080/%2e%2e/%2e%2e/etc/passwd    # must NOT succeed
curl -i  -X POST http://localhost:8080/                    # 405
curl -s  http://localhost:8080/big.bin | sha256sum         # equals sha256sum www/big.bin

printf 'GET / HTTP/1.1\r\nHost: x\r\n'  | nc localhost 8080   # incomplete → timeout
printf 'GARBAGE\r\n\r\n'                | nc localhost 8080   # 400
python3 -c "print('GET /' + 'A'*100000 + ' HTTP/1.1\r\n\r\n')" | nc localhost 8080   # 414/431/400
```

### 7.3 Concurrency & load

```bash
ab -n 50000 -c 200 http://localhost:8080/index.html     # ApacheBench
wrk -t4 -c200 -d30s http://localhost:8080/index.html    # if installed
# Slowloris-style: open 100 idle connections; the server should still serve others
for i in $(seq 100); do (sleep 30 | nc localhost 8080 &) ; done; curl localhost:8080/
```

With `--threads 4` and 100 idle sockets, can new requests still be served after the 5 s timeouts fire? Explain why or why not in `notes.md`. (This is the key limitation of thread-per-connection designs, and the motivation for `epoll`.)

### 7.4 Sanitizers & Valgrind

```bash
# ThreadSanitizer cannot be combined with ASan: use separate builds
make clean && make CFLAGS_EXTRA="-fsanitize=thread -g -O1" LDFLAGS="-fsanitize=thread"
./tinyhttpd --port 8080 & ab -n 20000 -c 50 http://localhost:8080/index.html; kill -INT %1

valgrind --tool=helgrind ./tinyhttpd --port 8080 --threads 4    # lock-order & races
valgrind --leak-check=full ./tinyhttpd --port 8080              # SIGINT then check report
```

**Goal:** TSan reports **0 data races**; Valgrind shows no leaks after graceful shutdown; fd count stays flat under load.

### 7.5 Debugging with GDB

```bash
gdb -p $(pidof tinyhttpd)
(gdb) info threads
(gdb) thread apply all bt        # where is every thread blocked? (diagnose deadlocks)
```

**Exercise:** Deliberately introduce a deadlock (lock order inversion) and a lost wakeup (replace `while` with `if`, remove a `signal`). Use `thread apply all bt` and TSan/Helgrind to diagnose each. Write up what you saw.

### 7.6 Strace for ground truth

```bash
strace -f -e trace=network,read,write,close -p $(pidof tinyhttpd)
```

Watch your server's real syscalls: confirm one `accept` per connection, a matching `close`, and observe short `write`s on large files.

---

## 8. Stretch Goals

- [ ] **Keep-alive** connections and request pipelining
- [ ] Switch to **`poll`/`epoll`** event loop (single-threaded, thousands of connections) and compare with the pool under 10k idle clients
- [ ] `Range` requests and `If-Modified-Since` / `ETag` caching
- [ ] IPv6 via `getaddrinfo` (dual-stack)
- [ ] Simple **CGI** support using `fork`/`execve`/pipes (and carefully sanitized environment)
- [ ] TLS via OpenSSL/mbedTLS
- [ ] Per-IP rate limiting with the hash table from Project 2
- [ ] Use your Project 5 allocator via `LD_PRELOAD` under load

## 9. Definition of Done

- [ ] Serves files correctly, with correct headers and MIME types, including large (>1 GB sparse) files
- [ ] Rejects traversal attacks and malformed requests with proper status codes
- [ ] 50k requests @ 200 concurrency: 0 failures, flat fd count, flat memory
- [ ] **ThreadSanitizer-clean**; no leaks after graceful `SIGINT` shutdown
- [ ] Idle/slow clients can't hold a worker indefinitely
- [ ] `notes.md` documents ownership of fds, lock hierarchy, and your findings from the deliberate-deadlock exercise

➡️ **Next:** [Project 5: Memory Allocator](../05_allocator/README.md)
