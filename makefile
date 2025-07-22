# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: your_username <your_email@student.42.fr>  +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/01 00:00:00 by your_username    #+#    #+#              #
#    Updated: 2024/01/01 00:00:00 by your_username   ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Program name
NAME = window

# Compiler and flags
CXX = c++
CXXFLAGS = -Wall -Wextra -Werror -std=c++98
INCLUDES = -I./minilibx-linux

# Directories
SRCDIR = srcs
OBJDIR = objs

# Source files
SOURCES = main.cpp
SRCS = $(addprefix $(SRCDIR)/, $(SOURCES))
OBJS = $(SRCS:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)

# MinilibX
MLX_DIR = ./minilibx-linux
MLX = $(MLX_DIR)/libmlx_Linux.a
MLX_FLAGS = -L$(MLX_DIR) -lmlx_Linux -lXext -lX11 -lm -lz

# Colors for pretty output
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[0;33m
BLUE = \033[0;34m
MAGENTA = \033[0;35m
CYAN = \033[0;36m
WHITE = \033[0;37m
RESET = \033[0m

# Rules
all: $(MLX) $(NAME)

$(NAME): $(OBJS) $(MLX)
	@echo "$(CYAN)Linking $(NAME)...$(RESET)"
	@$(CXX) $(OBJS) $(MLX_FLAGS) -o $(NAME)
	@echo "$(GREEN)✓ $(NAME) created successfully!$(RESET)"

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	@mkdir -p $(OBJDIR)
	@echo "$(YELLOW)Compiling $<...$(RESET)"
	@$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

$(MLX):
	@echo "$(MAGENTA)Building MinilibX...$(RESET)"
	@cd $(MLX_DIR) && make clean && make all
	@echo "$(GREEN)✓ MinilibX built successfully!$(RESET)"

clean:
	@echo "$(RED)Cleaning object files...$(RESET)"
	@rm -rf $(OBJDIR)
	@make -C $(MLX_DIR) clean > /dev/null 2>&1

fclean: clean
	@echo "$(RED)Cleaning executable...$(RESET)"
	@rm -f $(NAME)

re: fclean all

# Test rule to run the program
test: $(NAME)
	@echo "$(CYAN)Running $(NAME)...$(RESET)"
	@./$(NAME)

# Help
help:
	@echo "$(BLUE)Available targets:$(RESET)"
	@echo "  $(GREEN)all$(RESET)     - Build the program"
	@echo "  $(GREEN)clean$(RESET)   - Remove object files"
	@echo "  $(GREEN)fclean$(RESET)  - Remove object files and executable"
	@echo "  $(GREEN)re$(RESET)      - Rebuild everything"
	@echo "  $(GREEN)test$(RESET)    - Build and run the program"
	@echo "  $(GREEN)help$(RESET)    - Show this help"

.PHONY: all clean fclean re test help