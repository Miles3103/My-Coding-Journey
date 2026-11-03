include ../common/Makefile.common
TARGET := tinyhttpd
SRCS   := $(wildcard src/*.c)
OBJS   := $(SRCS:src/%.c=build/%.o)
CFLAGS += -Iinclude -pthread
LDFLAGS += -pthread

all: $(TARGET)
$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)
build/%.o: src/%.c | build
	$(CC) $(CFLAGS) -c $< -o $@
build:
	mkdir -p build
clean:
	rm -rf build $(TARGET)
.PHONY: all clean
