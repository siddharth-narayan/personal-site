SRC_DIR := source
OUT_DIR := build

MAKO_SRC := $(shell find $(SRC_DIR) -type f -name '*.typ.mako')
TYPST_SRC := $(shell find $(SRC_DIR) -type f -name '*.typ')
GENERATED_TYPST := $(patsubst $(SRC_DIR)/%.typ.mako,$(OUT_DIR)/%.typ,$(MAKO_SRC))

OUT := \
	$(patsubst $(SRC_DIR)/%.typ,$(OUT_DIR)/%.html,$(TYPST_SRC)) \
	$(patsubst $(OUT_DIR)/%.typ,$(OUT_DIR)/%.html,$(GENERATED_TYPST))

# Generate extra typst files from mako templates
$(OUT_DIR)/%.typ: $(SRC_DIR)/%.typ.mako
	mkdir -p $(dir $@)
	mako-render $< > $@

# HTML generated from typst files, both generated and normal typst
$(OUT_DIR)/%.html: $(OUT_DIR)/%.typ
	mkdir -p $(dir $@)
	typst c --features html --root . --format html $< $@

$(OUT_DIR)/%.html: $(SRC_DIR)/%.typ
	mkdir -p $(dir $@)
	typst c --features html --root . --format html $< $@

all: $(OUT)

clean:
	rm -rf $(OUT_DIR)

.PHONY: all clean
