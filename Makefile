# Project Settings
NAME := cjson_fuzz_target
SRC_DIR := src
BUILD_DIR := build
INCLUDE_DIR := include
LIB_DIR := lib
TESTS_DIR := tests
BIN_DIR := bin

# Generate paths for all object files
OBJS := $(patsubst %.c,%.o, $(wildcard $(SRC_DIR)/*.c) $(wildcard $(LIB_DIR)/**/*.c))

# Compiler settings
CC := afl-clang-lto
CXX := afl-clang-lto++
CFLAGS := -gline-tables-only -fno-omit-frame-pointer -O0 -fcoverage-mapping -fprofile-instr-generate
CXXFLAGS := -gline-tables-only -fno-omit-frame-pointer -O0 -fcoverage-mapping -fprofile-instr-generate

# Build executable
$(NAME): dir $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(BIN_DIR)/$@ $(patsubst %, build/%, $(OBJS))

# Build object files and third-party libraries
$(OBJS): dir
	@mkdir -p $(BUILD_DIR)/$(@D)
	@$(CC) $(CFLAGS) -o $(BUILD_DIR)/$@ -c $*.c

dir:
	@mkdir -p $(BUILD_DIR) $(BIN_DIR)

# Clean build and bin directories
clean:
	@rm -rf $(BUILD_DIR) $(BIN_DIR)

.PHONY: dir clean
