uname := $(shell uname -s)

share := $(HOME)/.local/share
bin := $(HOME)/.local/bin
dev := $(HOME)/dev
applications := $(share)/applications


# --------------------------------- Install -----------------------------------
# List of common install targets
targets := stow

# Packages installed via OS package manager
targets += pkg-vim pkg-tmux pkg-htop pkg-tree pkg-highlight pkg-jq

# OS specific install targets
ifeq ($(uname), Linux)
    targets += pkg-universal-ctags pkg-alacritty
else ifeq ($(uname), Darwin)
endif

untargets := $(patsubst %, un%, $(targets))

install: $(targets)
.PHONY: install

uninstall: $(untargets)
.PHONY: uninstall


# ----------------------------------- Stow ------------------------------------
stowlist := $(shell ls stow)
stowtargets := $(filter-out %-mac, $(stowlist))

ifeq ($(uname), Darwin)
    stowtargets += $(filter %-mac, $(stowlist))
endif

stow: install-stow
	stow -vvv $(stowtargets)
.PHONY: stow

unstow: install-stow
	stow -D $(stowtargets)
.PHONY: unstow
	

# --------------------------------- Packages ----------------------------------
ifeq ($(uname), Linux)
    install := apt-get install -y
    uninstall := apt-get remove -y
else ifeq ($(uname), Darwin)
    install := brew install
    uninstall := brew uninstall
else
    install := echo unknown OS: trying to install
    uninstall := echo unknown OS: trying to uninstall
endif

special-treatment:
ifeq ($(uname), Darwin)
	brew tap universal-ctags/universal-ctags
	brew install --head universal-ctags
endif

install-stow: .stamps/stow-installed
.stamps/stow-installed: | .stamps/
	$(install) stow
	@touch $@

pkg-%: special-treatment
	$(install) $*
.PHONY: pkg-%

unpkg-%:
	$(uninstall) $*
.PHONY: unpkg-%

# ---------------------------------- Crawl ------------------------------------
crawld := $(share)/crawl
crawl_key := $(crawld)/crawl_key
crawlrc := test

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

$(crawld):
	mkdir -p $(crawld)

# ----------------------------------- Dirs ------------------------------------
$(bin):
	mkdir -p $(bin)

$(dev):
	mkdir -p $(dev)

.stamps/:
	mkdir -p .stamps
