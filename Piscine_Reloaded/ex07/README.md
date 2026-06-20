# 42 Piscine: C 00 - Exercise 02 / 07 (ft_print_numbers)

An educational guide explaining how to write a basic C function that loops through numeric digit characters in ascending order and prints them to the standard output.

## 📋 The Assignment

The goal is to write a function named `ft_print_numbers` inside a file named `ft_print_numbers.c`. The function must display all digits from `0` to `9` on a single line in ascending order.

### 🛠️ Allowed Functions
* `ft_putchar` (which utilizes the `write` system call underneath).

### 📋 Function Prototype
```c
void ft_print_numbers(void);
```

---

## 💡 The Solution

Just like alphabet letters, digits are represented as character codes in the ASCII table. The character `'0'` corresponds to ASCII value 48, and they continue sequentially up to `'9'` (ASCII 57). We can loop through them cleanly by updating a single `char` variable.

Place this exact code inside your `ft_print_numbers.c` file:

```c
#include <unistd.h>

void	ft_putchar(char c)
{
	write(1, &c, 1);
}

void	ft_print_numbers(void)
{
	char	c;

	c = '0';
	while (c <= '9')
	{
		ft_putchar(c);
		c++;
	}
}
```

> ⚠️ **Important Note for Submission:** Do **NOT** include your `int main(void)` function inside the final `ft_print_numbers.c` file. The 42 Moulinette uses its own main function to compile against your files. Leaving a main function inside your submission file will trigger a "redefinition of 'main'" compilation error, causing a failure.

---

## 🛠️ Compilation and Testing

To verify that your function behaves perfectly without breaking the compilation pipeline, follow these testing steps:

1. **Isolate your main function**: Create a separate file called `main.c` and paste your testing routine there:
   ```c
   void ft_print_numbers(void);

   int main(void)
   {
       ft_print_numbers();
       return (0);
   }
   ```

2. **Compile the files together** using the strict 42 compilation flags:
   ```bash
   gcc -Wall -Wextra -Werror ft_print_numbers.c main.c -o test_numbers
   ```

3. **Run your program**:
   ```bash
   ./test_numbers
   ```

4. **Expected Output**:
   ```bash
   0123456789
   ```

---

## 📦 Submission

Clean up your workspace folder by removing your testing file and executable (`rm main.c test_numbers`). Ensure your `ex07/` directory contains **only** the `ft_print_numbers.c` file before committing and pushing to your repository.

