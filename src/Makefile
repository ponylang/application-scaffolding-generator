config ?= release

APPLICATION := {%%APPLICATION%%}
COMPILE_WITH := stable env ponyc
FETCH_DEPS_WITH := stable fetch
DEPS_DIR := .deps

BUILD_DIR ?= build/$(config)
SRC_DIR := $(APPLICATION)
tests_binary := $(BUILD_DIR)/$(APPLICATION)

ifdef config
	ifeq (,$(filter $(config),debug release))
		$(error Unknown configuration "$(config)")
	endif
endif

ifeq ($(config),release)
	PONYC = $(COMPILE_WITH)
else
	PONYC = $(COMPILE_WITH) --debug
endif

SOURCE_FILES := $(shell find $(SRC_DIR) -name \*.pony)

$(DEPS_DIR):
	$(FETCH_DEPS_WITH)

test: unit-tests

unit-tests: $(tests_binary)
	$^ --exclude=integration --sequential

$(tests_binary): $(SOURCE_FILES) | $(BUILD_DIR) $(DEPS_DIR)
	$(PONYC) -o ${BUILD_DIR} $(SRC_DIR)

clean:
	rm -rf $(BUILD_DIR)

realclean:
	rm -rf build $(DEPS_DIR)

TAGS:
	ctags --recurse=yes $(SRC_DIR)

all: test

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: all clean realclean TAGS test
