BINARY_NAME = VulkanTest
FILES = 
COMPILER = g++
OPTIMIZATION = O2

CFLAGS = -std=c++17 -$(OPTIMIZATION)
LDFLAGS = -lglfw -lvulkan -ldl -lpthread -lX11 -lXrandr -lXi

INCLUDE_DIR = include
SOURCE_DIR = src
OBJECT_DIR = src/obj
BUILD_DIR = build
TEST_DIR = test

dummy_build_directory := $(shell mkdir -p $(OBJECT_DIR))
dummy_build_directory := $(shell mkdir -p $(BUILD_DIR))

CFLAGS += -I$(INCLUDE_DIR)
HEADERS = $(patsubst %, $(INCLUDE_DIR)/%.hpp, $(FILES))
OBJECTS = $(patsubst %, $(OBJECT_DIR)/%.o, main $(FILES))

$(OBJECT_DIR)/%.o: $(SOURCE_DIR)/%.cpp $(HEADERS)
	$(COMPILER) -c -o $@ $< $(CFLAGS)

$(BUILD_DIR)/$(BINARY_NAME): $(OBJECTS)
	$(COMPILER) -o $@ $^ $(CFLAGS) $(LDFLAGS)

.PHONY: run clean test

run: $(BUILD_DIR)/$(BINARY_NAME)
	$(BUILD_DIR)/$(BINARY_NAME)

clean:
	@trash $(OBJECT_DIR) $(BUILD_DIR)

test:
	@echo "Testing Makefile not implemented"
