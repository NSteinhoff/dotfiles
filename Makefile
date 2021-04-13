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
crawl_repo := $(dev)/crawl
crawl_bin := $(crawl_repo)/crawl-ref/source/crawl

ifdef BUILD
crawl: $(crawl_key) $(crawl_bin)
.PHONY: crawl
else
crawl: $(crawl_key)
.PHONY: crawl
endif


uncrawl:
	rm -rf $(crawl_key) $(crawl_bin)
.PHONY: uncrawl

$(crawl_key): | $(crawld)
	curl https://crawl.develz.org/cao_key 2>/dev/null > $(crawl_key)
	chmod 600 $(crawl_key)

$(crawld):
	mkdir -p $(crawld)

$(crawl_bin): crawl_pull
	cd $(crawl_repo)/crawl-ref/source && make -j4

crawl_pull: | $(crawl_repo)
	cd $(crawl_repo) && git pull && git submodule update --init
.PHONY: crawl_pull

$(crawl_repo): | $(dev)
	git clone git@github.com:crawl/crawl.git $(crawl_repo)

# ---------------------------------- Brogue -----------------------------------
brogued := $(share)/brogue
brogue_url := https://github.com/tmewett/BrogueCE/releases/download/v1.8.3/BrogueCE-1.8.3-linux-x86_64.tar.gz
brogue_tar := $(brogued)/brogue_ce.tar.gz
brogue_bin := $(brogued)/brogue
brogue_desktop := $(applications)/brogue.desktop

brogue: $(brogue_desktop)
.PHONY: brogue

unbrogue:
	rm -f $(brogue_desktop)
	rm -rf $(brogued)
.PHONY: unbrogue

$(brogue_desktop): $(brogue_bin)
	$(brogued)/make-link-for-desktop.sh
	mv $(brogued)/brogue.desktop $@

$(brogue_bin): $(brogue_tar) | $(brogued)
	tar -C $(brogued) -xzf $<
	touch $@

$(brogue_tar): | $(brogued)
	curl -sSfL $(brogue_url) -o $@

$(brogued):
	mkdir -p $(brogued)


# ---------------------------------- Neovim -----------------------------------
nvim_url := https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
nvim_bin := $(bin)/nvim

nvim: $(nvim_bin)
.PHONY: nvim

unnvim:
	rm -rf $(nvim_bin)
.PHONY: unnvim

$(nvim_bin): | $(bin)
	curl -fsSL $(nvim_url) -o $@
	chmod u+x $@


# ----------------------------------- Dirs ------------------------------------
$(bin):
	mkdir -p $(bin)

$(dev):
	mkdir -p $(dev)

.stamps/:
	mkdir -p .stamps
