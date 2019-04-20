all:

include Makefunc.mk
ROOTDIR := $(shell pwd)

SSHKEY ?= ~/.ssh/rsync-files-conao3_rsa
EMACS_VERSION ?= 26.2
DIRS := .source .work .dist

##################################################

.PRECIOUS: .source/emacs-%.tar.gz .work/emacs-%

all: $(DIRS) build

build: $(EMACS_VERSION:%=.make-build-emacs-%)

$(DIRS):
	mkdir -p $@

configure-options=--without-x --without-ns --with-modules --prefix=$(ROOTDIR)/.dist/emacs-$*
.make-build-emacs-%: .work/emacs-%
	cd $< && ./configure $(configure-options)
	cd $< && $(MAKE)
	cd $< && $(MAKE) install

.work/emacs-%: .source/emacs-%.tar.gz
	tar -zxf $< -C $(@D)

.source/emacs-%.tar.gz:
	cd $(@D) && curl -O https://ftp.gnu.org/pub/gnu/emacs/$(@F)

fetch: .work/emacs
	cd $< && git fetch --all

.work/emacs:
	git clone https://git.savannah.gnu.org/git/emacs.git $@

##############################

install:
uninstall:

##############################

push:
emacs.tar.gz:
	echo emacs > $@
test:

##############################

push: emacs.tar.gz
	scp -v -i $(SSHKEY) -o 'StrictHostKeyChecking=no' -o 'UserKnownHostsFile=/dev/null' emacs.tar.gz conao3@files.conao3.com:~/www/files/

##############################

clean:
	rm -rf $(DIRS)
