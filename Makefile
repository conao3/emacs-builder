all:

include Makefunc.mk

SSHKEY ?= ~/.ssh/rsync-files-conao3_rsa
EMACS_VERSION ?= emacs-26.2
DIRS := .source .work .dist

##################################################

all: $(DIRS) build

build: $(EMACS_VERSION:%=.make-build-%)

$(DIRS):
	mkdir -p $@

.make-build-%: .work/%
#	cd $@ && git reset $(EMACS_VERSION) --hard
#	cd $@ && ./autogen.sh
	cd $@ && ./configure --prefix=$(shell pwd)/.dist/emacs-$*
	cd $@ && $(MAKE)
	cd $@ && $(MAKE) install

.work/%: .source/%.tar.gz
	tar -zxf $^ -C $@

.source/%.tar.gz:
	curl https://ftp.gnu.org/pub/gnu/emacs/$(@F) -o $@

fetch: .work/emacs
	cd $< && git fetch --all

.work/emacs:
	git clone https://git.savannah.gnu.org/git/emacs.git $@

##############################

install:
uninstall:

##############################

dist: emacs.tar.gz
emacs.tar.gz:
	echo emacs > $@
test:

##############################

push: emacs.tar.gz
	scp -v -i $(SSHKEY) -o 'StrictHostKeyChecking=no' -o 'UserKnownHostsFile=/dev/null' emacs.tar.gz conao3@files.conao3.com:~/www/files/

##############################

clean:
