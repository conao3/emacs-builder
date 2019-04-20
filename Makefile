all:

include Makefunc.mk

SSHKEY ?= ~/.ssh/rsync-files-conao3_rsa
EMACS_VERSION ?= master

##################################################

all: build

build: .work $(EMACS_VERSION:%=.work/emacs-%)

.work:
	mkdir -p $@

.work/emacs-%: fetch
	cp -a .work/emacs $@
#	cd $@ && make

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
