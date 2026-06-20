# 42 Piscine: C 00 - Exercise 01 / 06 (ft_print_alphabet)

An educational guide explaining how to write a basic C function that iterates through the lowercase alphabet in ascending order and prints it to the standard output.

## 📋 The Assignment

The goal is to write a function named `ft_print_alphabet` inside a file named `ft_print_alphabet.c`. The function must display the lowercase alphabet on a single line in ascending order, starting from `'a'` and ending at `'z'`.

### 🛠️ Allowed Functions
* `ft_putchar` (which utilizes the `write` system call underneath).

### 📋 Function Prototype
```c
void ft_print_alphabet(void);
```

---

## 💡 The Solution

In C, characters (`char`) are stored underneath as integer ASCII values (`'a'` is 97, `'b'` is 98, etc.). Because of this, we can use a standard `while` loop to increment a character variable just like a number until it completes the loop.

Place this exact code inside your `ft_print_alphabet.c` file:

```c
#include <unistd.h>

void	ft_putchar(char c)
{
	write(1, &c, 1);
}

void	ft_print_alphabet(void)
{
	char	c;

	c = 'a';
	while (c <= 'z')
	{
		ft_putchar(c);
		c++;
	}
}
```

### 🔍 Detailed Code Breakdown

* **`#include <unistd.h>`**: Includes the header required for the system `write` function inside `ft_putchar`.
* **`char c = 'a';`**: Initializes our looping iterator variable to the starting character `'a'`.
* **`while (c <= 'z')`**: Evaluates true for every character sequentially up through `'z'` based on ASCII order.
* **`ft_putchar(c);`**: Calls our custom output function to write the individual character out to standard output (`1`).
* **`c++;`**: Increments the character's internal ASCII value by 1 (moving from `'a'` to `'b'`, `'b'` to `'c'`, and so on).

---

## 🛠️ Compilation and Testing

To compile your code and verify it works exactly as expected by the 42 Moulinette, you must create a temporary `main.c` file to call your function.

1. **Create a `main.c` file** in the same directory with this text:
   ```c
   void ft_print_alphabet(void);

   int main(void)
   {
       ft_print_alphabet();
       return (0);
   }
   ```

2. **Compile the files together** using standard 42 flags (`-Wall -Wextra -Werror`):
   ```bash
   gcc -Wall -Wextra -Werror ft_print_alphabet.c main.c -o test_alphabet
   ```

3. **Run your program**:
   ```bash
   ./test_alphabet
   ```

4. **Expected Output**:
   ```bash
   abcdefghijklmnopqrstuvwxyz
   ```
   *(Note: The assignment prompt explicitly states to display the alphabet on a single line. It does **not** ask for a trailing newline `\n` at the end of the execution, so your prompt cursor will append directly to the end of `z`).*

---

## 📦 Submission

Clean up your workspace by removing your temporary testing files (`rm main.c test_alphabet`) so that only `ft_print_alphabet.c` remains inside your `ex06/` directory before pushing to your remote Git repository.

