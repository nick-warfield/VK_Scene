BINARY_NAME = VulkanTest
COMPILER = ccache clang++
OPTIMIZATION = O2

CFLAGS = -std=c++17 -$(OPTIMIZATION) -Wall -Wextra -Wno-missing-braces -DDEBUG
LDFLAGS = -lglfw -lvulkan -ldl -lpthread -lX11 -lXrandr -lXi

LIB_DIR = lib
INCLUDE_DIR = include
SOURCE_DIR = src
OBJECT_DIR = src/obj
RESOURCE_DIR = resources
BUILD_DIR = build
TEST_DIR = tests

CFLAGS += -I$(INCLUDE_DIR) -isystem $(LIB_DIR)

HEADERS = $(wildcard *, $(INCLUDE_DIR)/*.hpp)
OBJECTS := main.o $(patsubst %.hpp,%.o, $(notdir $(HEADERS)))
OBJECTS := $(addprefix $(OBJECT_DIR)/, $(OBJECTS))

SHADERS := $(notdir $(wildcard *, $(SOURCE_DIR)/shaders/*))
SHADERS := $(subst .,_, $(SHADERS))
SHADERS := $(addsuffix .spv, $(SHADERS))
SHADERS := $(addprefix $(BUILD_DIR)/shaders/, $(SHADERS))

$(BUILD_DIR)/shaders/%_vert.spv: $(SOURCE_DIR)/shaders/%.vert
	glslc -o $@ $<

$(BUILD_DIR)/shaders/%_frag.spv: $(SOURCE_DIR)/shaders/%.frag
	glslc -o $@ $<

$(OBJECT_DIR)/%.o: $(SOURCE_DIR)/%.cpp $(HEADERS)
	$(COMPILER) -c -o $@ $< $(CFLAGS)

$(BUILD_DIR)/$(BINARY_NAME): init $(OBJECTS) $(SHADERS)
	$(COMPILER) -o $@ $(OBJECTS) $(CFLAGS) $(LDFLAGS)

.PHONY: run clean test init

run: $(BUILD_DIR)/$(BINARY_NAME)
	@./$(BUILD_DIR)/$(BINARY_NAME)

clean:
	@[ ! -d $(OBJECT_DIR) ] || trash $(OBJECT_DIR)
	@[ ! -d $(BUILD_DIR) ] || trash $(BUILD_DIR)

test:
	@echo "Testing Makefile not implemented"

init:
	@[ -d $(OBJECT_DIR) ] \
		|| ( mkdir -p $(OBJECT_DIR); \
		echo "$(OBJECT_DIR) created")
	@[ -d $(BUILD_DIR) ] \
		|| (mkdir -p $(BUILD_DIR); \
		echo "$(BUILD_DIR) created")
	@[ -d $(BUILD_DIR)/shaders ] \
		|| (mkdir -p $(BUILD_DIR)/shaders; \
		echo "$(BUILD_DIR)/shaders created")
	@[ -d $(BUILD_DIR)/$(RESOURCE_DIR) ] || [ ! -d $(RESOURCE_DIR) ] \
		|| (ln -s "$(realpath $(RESOURCE_DIR))" $(BUILD_DIR); \
		echo "$(RESOURCE_DIR) linked to $(BUILD_DIR)/$(RESOURCE_DIR)")
