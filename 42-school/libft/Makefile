# ============================================================================ #
#  libft - Makefile                                                            #
#  Layout:  include/  headers   src/  sources   build/  objects (generated)    #
# ============================================================================ #

NAME		:= libft.a

CC			:= cc
CFLAGS		:= -Wall -Wextra -Werror
CPPFLAGS	:= -Iinclude -MMD -MP
AR			:= ar rcs

SRC_DIR		:= src
BUILD_DIR	:= build

SRCS		:= ft_isalpha.c ft_isdigit.c ft_isalnum.c ft_isascii.c ft_isprint.c \
			   ft_toupper.c ft_tolower.c ft_strlen.c ft_memset.c ft_bzero.c \
			   ft_memcpy.c ft_memmove.c ft_strlcpy.c ft_strlcat.c ft_strchr.c \
			   ft_strrchr.c ft_strncmp.c ft_memchr.c ft_memcmp.c ft_strnstr.c \
			   ft_atoi.c ft_calloc.c ft_strdup.c ft_substr.c ft_strjoin.c \
			   ft_strtrim.c ft_split.c ft_itoa.c ft_strmapi.c ft_striteri.c \
			   ft_putchar_fd.c ft_putstr_fd.c ft_putendl_fd.c ft_putnbr_fd.c \
			   ft_lstnew.c ft_lstadd_front.c ft_lstsize.c ft_lstlast.c \
			   ft_lstadd_back.c ft_lstdelone.c ft_lstclear.c ft_lstiter.c \
			   ft_lstmap.c

OBJS		:= $(SRCS:%.c=$(BUILD_DIR)/%.o)
DEPS		:= $(OBJS:.o=.d)

all: $(NAME)

$(NAME): $(OBJS)
	$(AR) $@ $(OBJS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(BUILD_DIR):
	mkdir -p $@

# Standalone test suite (not part of the submission). Uses sanitizers.
test: $(NAME)
	$(CC) -g -fsanitize=address,undefined -Wall -Wextra $(CPPFLAGS) \
		tests/test_libft.c $(NAME) -o $(BUILD_DIR)/test_libft
	./$(BUILD_DIR)/test_libft

clean:
	rm -rf $(BUILD_DIR)

fclean: clean
	rm -f $(NAME)

re: fclean all

bonus: all

.PHONY: all clean fclean re bonus test

-include $(DEPS)
