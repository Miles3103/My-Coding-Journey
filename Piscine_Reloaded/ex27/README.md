# 42 Piscine: C Module - display_file
A small guide to a program, `ft_display_file`, that prints the content of a single file given as a command-line argument to standard output, and nothing else.
## 📋 The Assignment
Create a program called `ft_display_file` that displays, on standard output, only the content of the file given as argument. The submission directory needs a Makefile with `all`, `clean`, `fclean`. The binary is called `ft_display_file`. `malloc` is forbidden — only a fixed-size array is allowed. Error messages go to their reserved output, followed by a newline: `File name missing.` (no argument), `Too many arguments.` (more than one argument), `Cannot read file.` (file cannot be opened).
### 🛠️ Allowed Functions
* `close`, `open`, `read`, `write`
---
## 💡 The Solution
This is the content of `ft_display_file.c`:
```c
#include <fcntl.h>
#include <unistd.h>

#define BUFFER_SIZE 1024

static void	ft_error(char *msg)
{
	int	i;

	i = 0;
	while (msg[i] != '\0')
		i++;
	write(2, msg, i);
}

static int	ft_check_args(int argc)
{
	if (argc < 2)
	{
		ft_error("File name missing.\n");
		return (1);
	}
	if (argc > 2)
	{
		ft_error("Too many arguments.\n");
		return (1);
	}
	return (0);
}

static void	ft_cat(int fd)
{
	char	buf[BUFFER_SIZE];
	int		nb_read;

	nb_read = read(fd, buf, BUFFER_SIZE);
	while (nb_read > 0)
	{
		write(1, buf, nb_read);
		nb_read = read(fd, buf, BUFFER_SIZE);
	}
}

int	main(int argc, char **argv)
{
	int	fd;

	if (ft_check_args(argc) != 0)
		return (1);
	fd = open(argv[1], O_RDONLY);
	if (fd < 0)
	{
		ft_error("Cannot read file.\n");
		return (1);
	}
	ft_cat(fd);
	close(fd);
	return (0);
}
```
### 🔍 Detailed Code Breakdown
* **`ft_error`**: Writes an error message to file descriptor `2` (`stderr`), the reserved output for errors, computing the message length by hand since `strlen` isn't in the allowed-functions list.
* **`ft_check_args`**: Handles the two argument-count error cases, returning `0` if the count is valid or `1` after printing the relevant error. Split out as its own function partly because the norm caps function bodies at 25 lines.
* **`fd = open(argv[1], O_RDONLY)`**: Attempts to open the file read-only; a negative `fd` means the open failed, triggering `"Cannot read file."`.
* **`ft_cat`**: Reads into a fixed-size `BUFFER_SIZE`-byte stack array (no `malloc`, per the subject's restriction) in a loop, writing each chunk to `stdout`, until `read` returns `0` or less.
* **`close(fd)`**: Releases the file descriptor once done.
> ⚠️ **Important Note for Submission:** Keep it `norminette`-clean: a proper 42 header comment at the top, tabs (not spaces) for indentation, no `for` loops, and the logic split across functions so none exceed the 25-line cap.
---
## 🛠️ The Makefile
```makefile
NAME	=	ft_display_file

CC		=	cc
CFLAGS	=	-Wall -Wextra -Werror

SRCS	=	ft_display_file.c

all: $(NAME)

$(NAME): $(SRCS)
	$(CC) $(CFLAGS) $(SRCS) -o $(NAME)

clean:
	rm -f *.o

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re
```
Only `all`, `clean`, and `fclean` were required by the subject; `re` is included as a convenience.
## 🛠️ Compilation and Testing
1. **Build it**:
   ```bash
   make all
   ```
2. **Run it**:
   ```bash
   ./ft_display_file some_file.txt
   ```
   Expected output: the exact content of `some_file.txt`, byte-for-byte.
3. **Check the error cases**:
   ```bash
   ./ft_display_file               # File name missing.
   ./ft_display_file a b           # Too many arguments.
   ./ft_display_file /no/such/file # Cannot read file.
   ```
4. **Check the norm**:
   ```bash
   norminette ft_display_file.c
   ```
---
## 📦 Submission
Clean your project folder with `make fclean`. Ensure your exercise directory contains the `Makefile` and `ft_display_file.c` before committing and pushing your code changes to Git.
