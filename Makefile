all:

include Makefunc.mk

SSHKEY ?= ~/.ssh/rsync-files-conao3_rsa
EMACS_VERSION ?= master
DIRS := .source .work .dist

##################################################

all: build

build: $(DIRS) $(EMACS_VERSION:%=.work/emacs-%)

$(DIRS):
	mkdir -p $@

.work/emacs-%: fetch
	cp -a .work/emacs $@
	cd $@ && git reset $(EMACS_VERSION) --hard
	cd $@ && ./autogen.sh
	cd $@ && ./configure --prefix=$(shell pwd)/.dist/emacs-$*
	cd $@ && $(MAKE)
	cd $@ && $(MAKE) install

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
