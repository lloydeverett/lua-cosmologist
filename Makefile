
# --- Variables ---
CC          := $(realpath ./cosmocc/bin/cosmocc)
ZIPCOPY     := $(realpath ./cosmocc/bin/zipcopy)
LUA_VERSION := 5.4.8
LUA_DIR     := lua-$(LUA_VERSION)
LUA_SRC_DIR := $(LUA_DIR)/src
BIN_DIR     := bin
TARGET      := $(BIN_DIR)/main

# Flags
LUA_INC     := -I$(LUA_SRC_DIR)
CFLAGS      := $(LUA_INC)
LDFLAGS     :=

# Source files (main.c and all Lua source files except lua.c and luac.c which are for the stand-alone interpreters)
MAIN_OBJ    := main.o
LUA_SRCS    := $(wildcard $(LUA_SRC_DIR)/*.c)

# Exclude lua.c and luac.c from compilation for the library
LUA_LIB_SRCS := $(filter-out $(LUA_SRC_DIR)/lua.c $(LUA_SRC_DIR)/luac.c, $(LUA_SRCS))
LUA_OBJS    := $(patsubst $(LUA_SRC_DIR)/%.c, $(LUA_SRC_DIR)/%.o, $(LUA_LIB_SRCS))

# --- Phony Targets ---
.PHONY: all append-zip build clean clean-link-target rebuild

# --- all Target ---
all: clean-link-target $(TARGET) append-zip

# --- append-zip Target ---
append-zip:
	zip $(BIN_DIR)/embed.zip ./main.lua $(ZIP_EXTRAS) > /dev/null
	$(ZIPCOPY) $(BIN_DIR)/embed.zip $(BIN_DIR)/main

# --- Link Rules ---

$(TARGET): $(MAIN_OBJ) $(LUA_OBJS)
	@echo "Linking..."
	mkdir -p $(BIN_DIR)
	$(CC) $(LDFLAGS) -o $@ $(MAIN_OBJ) $(LUA_OBJS)

# --- Compilation Rules ---

$(MAIN_OBJ): main.c
	@echo "Compiling $<"
	$(CC) $(CFLAGS) -c $<

$(LUA_SRC_DIR)/%.o: $(LUA_SRC_DIR)/%.c
	@echo "Compiling $<"
	(cd $(LUA_SRC_DIR) && $(CC) -c $(notdir $<))

# --- Utility Targets ---

clean-link-target:
	rm -rf $(BIN_DIR)

clean:
	rm -rf $(BIN_DIR)
	rm -f $(MAIN_OBJ)
	rm -f $(LUA_SRC_DIR)/*.o

rebuild: clean all

