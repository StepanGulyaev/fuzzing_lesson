# Project Settings
NAME := cjson_fuzz_target
SRC_DIR := src
BUILD_DIR := build
INCLUDE_DIR := include
LIB_DIR := lib
TESTS_DIR := tests
BIN_DIR := bin

USE_ASAN ?=0
USE_CMPLOG ?=0

SUFFIX_ASAN   := $(if $(filter 1,$(USE_ASAN))    ,_asan)
SUFFIX_CMPLOG := $(if $(filter 1,$(USE_CMPLOG))  ,_cmplog)

ASAN_ENV   := $(if $(filter 1,$(USE_ASAN))    ,AFL_USE_ASAN=1,)
CMPLOG_ENV := $(if $(filter 1,$(USE_CMPLOG))  ,AFL_LLVM_CMPLOG=1,)

REAL_NAME:= $(NAME)$(SUFFIX_ASAN)$(SUFFIX_CMPLOG)


# Generate paths for all object files
OBJS := $(patsubst %.c,%.o, $(wildcard $(SRC_DIR)/*.c) $(wildcard $(LIB_DIR)/**/*.c))

# Compiler settings
CC := afl-clang-lto
CXX := afl-clang-lto++
CFLAGS := -gline-tables-only -fno-omit-frame-pointer -O0 -fcoverage-mapping -fprofile-instr-generate
CXXFLAGS := -gline-tables-only -fno-omit-frame-pointer -O0 -fcoverage-mapping -fprofile-instr-generate

#regular bin

# Build executable
$(REAL_NAME): dir $(OBJS)
	$(ASAN_ENV) $(CMPLOG_ENV) $(CC) $(CFLAGS) $(LDFLAGS) -o $(BIN_DIR)/$@ $(patsubst %, build/%, $(OBJS))

# Build object files and third-party libraries
$(OBJS): dir
	@mkdir -p $(BUILD_DIR)/$(@D)
	@$(ASAN_ENV) $(CMPLOG_ENV) $(CC) $(CFLAGS) -o $(BUILD_DIR)/$@ -c $*.c
dir:
	@mkdir -p $(BUILD_DIR) $(BIN_DIR)

# Clean build and bin directories
clean:
	@rm -rf $(BUILD_DIR) $(BIN_DIR)

.PHONY: dir clean
