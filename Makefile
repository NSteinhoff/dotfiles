uname := $(shell uname -s)

share := $(HOME)/.local/share
bin := $(HOME)/.local/bin
man := /usr/share/man
applications := $(share)/applications

targets := stow crawl brogue nvim fff
targets += pkg-tmux pkg-htop pkg-alacritty pkg-tree pkg-universal-ctags
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

stow:
	stow $(stowtargets)
.PHONY: stow

unstow:
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

pkg-%:
	$(install) $*
.PHONY: pkg-%

unpkg-%:
	$(uninstall) $*
.PHONY: unpkg-%

# ---------------------------------- Crawl ------------------------------------
crawld := $(share)/crawl
crawl_key := $(crawld)/crawl_key

crawl: $(crawl_key)
.PHONY: crawl

uncrawl:
	rm -rf $(crawld)
.PHONY: uncrawl

$(crawl_key): | $(crawld)
	curl https://crawl.develz.org/crawl_key 2>/dev/null > $(crawl_key)
	chmod 600 $(crawl_key)

$(crawld):
	mkdir -p $(crawld)


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

$(nvim_bin):
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

$(fff_bin): $(fff_src)
	install $</fff $@

$(fff_man): $(fff_src)
	cp $</fff.1 $@
	mandb

$(fff_src): $(fff_tar)
	tar -C /tmp -xvf $<
	touch $@

$(fff_tar):
	curl -sSfL $(fff_url) -o $@
