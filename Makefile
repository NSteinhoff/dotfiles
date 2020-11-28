uname := $(shell uname -s)

share := $(HOME)/.local/share
bin := $(HOME)/.local/bin
man := /usr/share/man
applications := $(share)/applications


# --------------------------------- Install -----------------------------------
# List of common install targets
targets := stow

# Packages installed via OS package manager
targets += pkg-vim pkg-tmux pkg-htop pkg-tree pkg-highlight pkg-jq

# OS specific install targets
ifeq ($(uname), Linux)
    targets += crawl brogue
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
crawl_apt_src := deb https://crawl.develz.org/debian crawl 0.25
crawl_apt_updated := $(crawld)/apt-updated
crawl_bin := /usr/games/crawl

crawl: $(crawl_key) $(crawl_bin)
.PHONY: crawl

uncrawl:
	rm -rf $(crawld)
	apt-get remove -y crawl
.PHONY: uncrawl

$(crawl_key): | $(crawld)
	curl https://crawl.develz.org/cao_key 2>/dev/null > $(crawl_key)
	chmod 600 $(crawl_key)

$(crawld):
	mkdir -p $(crawld)

$(crawl_bin): $(crawl_apt_updated)
	apt-get install -y crawl
	touch $@

$(crawl_apt_updated):
	# Install source repository
	grep "$(crawl_apt_src)" /etc/apt/sources.list &>/dev/null || (echo "$(crawl_apt_src)" | tee -a /etc/apt/sources.list)
	# Install the DCSS signing key
	curl https://crawl.develz.org/debian/pubkey | apt-key add -
	# update your package list
	apt-get update
	touch $@


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

$(nvim_bin): | bin
	curl -fsSL $(nvim_url) -o $@
	chmod u+x $@


# ----------------------------------- fff -------------------------------------
fff_url := https://github.com/dylanaraps/fff/archive/2.1.tar.gz
fff_tar := /tmp/fff.tar.gz
fff_src := /tmp/fff-2.1
fff_bin := $(bin)/fff
fff_man := $(man)/man1/fff.1

fff: $(fff_bin) $(fff_man)
.PHONY: fff

unfff:
	rm -rf $(fff_bin)
	rm -rf $(fff_man)
	mandb
.PHONY: unfff

$(fff_bin): $(fff_src) | bin
	install $</fff $@

$(fff_man): $(fff_src)
	cp $</fff.1 $@
	mandb

$(fff_src): $(fff_tar)
	tar -C /tmp -xvf $<
	touch $@

$(fff_tar):
	curl -sSfL $(fff_url) -o $@


# ----------------------------------- Bin -------------------------------------
bin:
	mkdir -p $(bin)

.stamps/:
	mkdir -p .stamps
