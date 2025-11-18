SRC_DIR := source
OUT_DIR := build

SRC := $(shell find $(SRC_DIR) -type f -name '*.typ')
OUT := $(patsubst $(SRC_DIR)/%.typ,$(OUT_DIR)/%.html,$(SRC))

all: $(OUT)

$(OUT_DIR)/%.html: $(SRC_DIR)/%.typ
	mkdir -p $(dir $@)
	typst c --features html --root . --format html $< $@

clean:
	rm -rf $(OUT_DIR)

.PHONY: all clean
