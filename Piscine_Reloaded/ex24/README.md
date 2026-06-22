# 42 Piscine: C Module - Makefile (libft.a)
A small guide to a Makefile that builds `libft.a` from sources in `srcs/`, headers in `includes/`, with the library produced at the root of the exercise directory.
## 📋 The Assignment
Create the Makefile that'll compile your `libft.a`. Source files come from the `srcs` directory, header files come from the `includes` directory, and the lib ends up at the root of the exercise. Implement `all`, `clean`, `fclean`, and `re`. `fclean` does the equivalent of a `make clean` and also erases the binary created during the make; `re` does the equivalent of a `make fclean` followed by a `make`. Only this Makefile gets fetched and tested against the grader's own files — for this exercise, only 5 mandatory functions have to be handled: `ft_putchar`, `ft_putstr`, `ft_strcmp`, `ft_strlen`, `ft_swap`. Watch out for wildcards!
### 🛠️ Allowed Functions
* None
---
## 💡 The Solution
This is the content of the `Makefile`:
```makefile
NAME		=	libft.a

CC			=	cc
CFLAGS		=	-Wall -Wextra -Werror
AR			=	ar rcs

SRCS_DIR	=	srcs
INC_DIR		=	includes
OBJS_DIR	=	objs

SRCS		=	$(wildcard $(SRCS_DIR)/*.c)
OBJS		=	$(SRCS:$(SRCS_DIR)/%.c=$(OBJS_DIR)/%.o)

all: $(NAME)

$(NAME): $(OBJS)
	$(AR) $(NAME) $(OBJS)

$(OBJS_DIR)/%.o: $(SRCS_DIR)/%.c | $(OBJS_DIR)
	$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

$(OBJS_DIR):
	mkdir -p $(OBJS_DIR)

clean:
	rm -rf $(OBJS_DIR)

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re
```
### 🔍 Detailed Code Breakdown
* **`SRCS = $(wildcard $(SRCS_DIR)/*.c)`**: This is what the subject's "watch out for wildcards!" hint is about. Since the grader tests this Makefile against their own `srcs/` directory, hardcoding a file list would silently ignore anything you didn't anticipate. `$(wildcard ...)` picks up every `.c` file actually present at build time instead.
* **`OBJS = $(SRCS:$(SRCS_DIR)/%.c=$(OBJS_DIR)/%.o)`**: Turns each `srcs/foo.c` path into a matching `objs/foo.o` path.
* **Pattern rule `$(OBJS_DIR)/%.o: $(SRCS_DIR)/%.c`**: One rule compiles *any* source file into its matching object file. `| $(OBJS_DIR)` makes sure the output directory exists first without forcing unnecessary rebuilds.
* **`$(NAME): $(OBJS)` → `$(AR) $(NAME) $(OBJS)`**: Archives all compiled object files into `libft.a`, placed at the root since there's no directory prefix on `$(NAME)`.
* **`clean`**: Removes only `objs/`, leaving the finished `libft.a` untouched.
* **`fclean: clean` then `rm -f $(NAME)`**: Also removes `libft.a` itself, matching "erases the binary created during the make."
* **`re: fclean all`**: A full rebuild from scratch.
> ⚠️ **Important Note for Submission:** Only the `Makefile` itself gets turned in — `srcs/`, `includes/`, and their contents are not part of what you submit; the grader supplies their own.
---
## 🛠️ Compilation and Testing
```bash
make all      # builds libft.a
make clean    # removes objs/ only
make fclean   # removes objs/ and libft.a
make re       # fclean + all
```
---
## 📦 Submission
Ensure your exercise directory contains **only** the `Makefile` before committing and pushing your code changes to Git.
