# Compiler and flags
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -O2

# Project name
NAME = scop

# Directories
SRC_DIR = srcs
GLAD_SRC_DIR = glad/src
GLAD_INC_DIR = glad/include
OBJ_DIR = obj

# Source files
SRCS = $(SRC_DIR)/main.cpp $(GLAD_SRC_DIR)/glad.c
OBJS = $(OBJ_DIR)/main.o $(OBJ_DIR)/glad.o

# Include directories
INCLUDES = -I$(GLAD_INC_DIR)

# Libraries and frameworks
LIBS = -lglfw
FRAMEWORKS = -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo

# GLFW path (adjust if needed)
# If installed via Homebrew on M1 Mac
GLFW_PATH = /opt/homebrew
GLFW_INCLUDES = -I$(GLFW_PATH)/include
GLFW_LIBS = -L$(GLFW_PATH)/lib

# Complete flags
ALL_INCLUDES = $(INCLUDES) $(GLFW_INCLUDES)
ALL_LIBS = $(GLFW_LIBS) $(LIBS) $(FRAMEWORKS)

# Default target
all: $(NAME)

# Create object directory
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Compile main.cpp
$(OBJ_DIR)/main.o: $(SRC_DIR)/main.cpp | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) $(ALL_INCLUDES) -c $< -o $@

# Compile glad.c (note: using clang for C file)
$(OBJ_DIR)/glad.o: $(GLAD_SRC_DIR)/glad.c | $(OBJ_DIR)
	clang $(ALL_INCLUDES) -c $< -o $@

# Link executable
$(NAME): $(OBJS)
	$(CXX) $(OBJS) $(ALL_LIBS) -o $(NAME)

# Clean build files
clean:
	rm -rf $(OBJ_DIR)

# Clean everything
fclean: clean
	rm -f $(NAME)

# Rebuild
re: fclean all

# Run the program
run: $(NAME)
	./$(NAME)

# Debug build
debug: CXXFLAGS += -g -DDEBUG
debug: $(NAME)

# Check if GLFW is installed
check-glfw:
	@echo "Checking GLFW installation..."
	@if [ -d "$(GLFW_PATH)/include/GLFW" ]; then \
		echo "✓ GLFW found at $(GLFW_PATH)"; \
	else \
		echo "✗ GLFW not found. Install with: brew install glfw"; \
		exit 1; \
	fi

.PHONY: all clean fclean re run debug check-glfw