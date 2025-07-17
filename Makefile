OS := $(shell uname -s)
SHARE_DIR := $(HOME)/.local/share
BIN_DIR := $(HOME)/.local/bin

# ----------------------------------- Stow ------------------------------------
STOW_LIST_ALL := $(shell ls stow)
STOW_TARGETS := $(filter-out %-mac, $(STOW_LIST_ALL))

ifeq ($(OS), Darwin)
    STOW_TARGETS += $(filter %-mac, $(STOW_LIST_ALL))
endif

install: stow
uninstall: unstow

stow: install-stow
	stow -vvv $(STOW_TARGETS)
.PHONY: stow

unstow: install-stow
	stow -D $(STOW_TARGETS)
.PHONY: unstow

ifeq ($(OS), Linux)
install_cmd := apt-get install -y
else ifeq ($(OS), Darwin)
install_cmd := brew install
install: clangd
else
install_cmd := @echo unknown OS: trying to install
endif

install-stow: .stamps/stow-installed
.PHONY: install-stow
.stamps/stow-installed: | .stamps/
	$(install_cmd) stow
	@touch $@

clangd:
ifeq ($(OS), Darwin)
	mkdir -p $(HOME)/Library/Preferences/clangd
	ln -sf $(PWD)/stow/clang/.config/clangd/config.yaml $(HOME)/Library/Preferences/clangd/config.yaml
endif
.PHONY: clangd

# ---------------------------------- Crawl ------------------------------------
CRAWL_DIR := $(SHARE_DIR)/crawl
CRAWL_KEY := $(CRAWL_DIR)/crawl_key

crawl: $(CRAWL_KEY)
ifeq ($(OS), Darwin)
	ln -sf $(PWD)/stow/crawl/.config/crawl/crawlrc $(HOME)/Library/Application\ Support/Dungeon\ Crawl\ Stone\ Soup/init.txt
endif
.PHONY: crawl

uncrawl:
	rm -rf $(CRAWL_DIR)
.PHONY: uncrawl

$(CRAWL_KEY): | $(CRAWL_DIR)
	curl https://crawl.develz.org/cao_key 2>/dev/null > $(CRAWL_KEY)
	chmod 600 $(CRAWL_KEY)

$(CRAWL_DIR): | $(SHARE_DIR)
	mkdir -p $(CRAWL_DIR)

# ----------------------------------- Dirs ------------------------------------
$(SHARE_DIR):
	mkdir -p $(SHARE_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

.stamps/:
	mkdir -p .stamps
