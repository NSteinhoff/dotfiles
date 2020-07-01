share := $(HOME)/.local/share
bin := $(HOME)/.local/bin
applications := $(share)/applications

targets := stow crawl brogue nvim
untargets := $(patsubst %, un%, $(targets))

install: $(targets)
.PHONY: install

uninstall: $(untargets)
.PHONY: uninstall


# ----------------------------------- Stow ------------------------------------
stowlist := $(shell ls stow)
stowtargets := $(filter-out %-mac, $(stowlist))

ifneq (, $(findstring darwin%, $(OSTYPE)))
    stowtargets += $(filter %-mac, $(stowlist))
endif

stow:
	stow $(stowtargets)
.PHONY: stow

unstow:
	stow -D $(stowtargets)
.PHONY: unstow


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
