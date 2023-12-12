uname := $(shell uname -s)
share := $(HOME)/.local/share
bin := $(HOME)/.local/bin

# ----------------------------------- Stow ------------------------------------
stowlist := $(shell ls stow)
stowtargets := $(filter-out %-mac, $(stowlist))

ifeq ($(uname), Darwin)
    stowtargets += $(filter %-mac, $(stowlist))
endif

install: stow
uninstall: unstow

stow: install-stow
	stow -vvv $(stowtargets)
.PHONY: stow

unstow: install-stow
	stow -D $(stowtargets)
.PHONY: unstow

ifeq ($(uname), Linux)
install_cmd := apt-get install -y
else ifeq ($(uname), Darwin)
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

clangd: $(crawl_key)
ifeq ($(uname), Darwin)
	mkdir -p $(HOME)/Library/Preferences/clangd
	ln -sf $(PWD)/stow/clang/.config/clangd/config.yaml $(HOME)/Library/Preferences/clangd/config.yaml
endif
.PHONY: clangd

# ---------------------------------- Crawl ------------------------------------
crawld := $(share)/crawl
crawl_key := $(crawld)/crawl_key

crawl: $(crawl_key)
ifeq ($(uname), Darwin)
	ln -sf $(PWD)/stow/crawl/.config/crawl/crawlrc $(HOME)/Library/Application\ Support/Dungeon\ Crawl\ Stone\ Soup/init.txt
endif
.PHONY: crawl

uncrawl:
	rm -rf $(crawld)
.PHONY: uncrawl

$(crawl_key): | $(crawld)
	curl https://crawl.develz.org/cao_key 2>/dev/null > $(crawl_key)
	chmod 600 $(crawl_key)

$(crawld): | $(share)
	mkdir -p $(crawld)

# ----------------------------------- Dirs ------------------------------------
$(share):
	mkdir -p $(share)

$(bin):
	mkdir -p $(bin)

.stamps/:
	mkdir -p .stamps
