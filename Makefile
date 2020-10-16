BINARY_NAME = VulkanTest
FILES = 
COMPILER = g++
OPTIMIZATION = O2

CFLAGS = -std=c++17 -$(OPTIMIZATION) -Wall -Wextra -DDEBUG
LDFLAGS = -lglfw -lvulkan -ldl -lpthread -lX11 -lXrandr -lXi

INCLUDE_DIR = include
SOURCE_DIR = src
OBJECT_DIR = src/obj
RESOURCE_DIR = resources
BUILD_DIR = build
TEST_DIR = tests

$(shell [ -d $(OBJECT_DIR) ] || mkdir -p $(OBJECT_DIR))
$(shell [ -d $(BUILD_DIR) ] || mkdir -p $(BUILD_DIR))
$(shell [ -d $(BUILD_DIR)/shaders ] || mkdir -p $(BUILD_DIR)/shaders)
$(shell [ -d $(RESOURCE_DIR) ] || mkdir -p $(RESOURCE_DIR))
$(shell [ -d $(BUILD_DIR)/$(RESOURCE_DIR) ] || ln -s "$(realpath $(RESOURCE_DIR))" $(BUILD_DIR))

CFLAGS += -I$(INCLUDE_DIR)
HEADERS = $(patsubst %, $(INCLUDE_DIR)/%.hpp, $(FILES))
OBJECTS = $(patsubst %, $(OBJECT_DIR)/%.o, main $(FILES))

SHADERS := $(wildcard *, $(SOURCE_DIR)/shaders/*) 
SHADERS := $(notdir $(SHADERS))
SHADERS := $(subst .,_, $(SHADERS))
SHADERS := $(addsuffix .spv, $(SHADERS))
SHADERS := $(addprefix $(BUILD_DIR)/shaders/, $(SHADERS))

$(BUILD_DIR)/shaders/%_vert.spv: $(SOURCE_DIR)/shaders/%.vert
	glslc -o $@ $<

$(BUILD_DIR)/shaders/%_frag.spv: $(SOURCE_DIR)/shaders/%.frag
	glslc -o $@ $<

$(OBJECT_DIR)/%.o: $(SOURCE_DIR)/%.cpp $(HEADERS)
	$(COMPILER) -c -o $@ $< $(CFLAGS)

$(BUILD_DIR)/$(BINARY_NAME): $(OBJECTS) $(SHADERS)
	$(COMPILER) -o $@ $(OBJECTS) $(CFLAGS) $(LDFLAGS)

.PHONY: run clean test

run: $(BUILD_DIR)/$(BINARY_NAME)
	@./$(BUILD_DIR)/$(BINARY_NAME)

clean:
	@trash $(OBJECT_DIR) $(BUILD_DIR)

test:
	@echo "Testing Makefile not implemented"

