all:

include Makefunc.mk

ROOTDIR := $(shell pwd)

SSHKEY        ?= ~/.ssh/rsync-files-conao3_rsa
EMACS_VERSION ?= 26.2

DIRS := .make .source .build .work .dist

DATE       := $(shell date +%Y-%m-%d)
DATEDETAIL := $(shell date +%Y-%m-%d:%H-%M-%S)

##################################################

.PRECIOUS: .source/emacs-%.tar.gz .work/emacs-%

all: $(DIRS) dist

$(DIRS):
	mkdir -p $@

##############################

build: $(EMACS_VERSION:%=.build/emacs-%)

configure-options=--without-x --without-ns --with-modules --prefix=$(ROOTDIR)/$@
.build/emacs-%: .work/emacs-%
	cd $< && if [ -e autogen.sh ]; then ./autogen.sh; fi
	cd $< && ./configure $(configure-options)
	cd $< && $(MAKE)
	cd $< && $(MAKE) install

.work/emacs-master:
	git clone --depth=1 https://git.savannah.gnu.org/git/emacs.git $@

.work/emacs-%: .source/emacs-%.tar.gz
	tar -zxf $< -C $(@D)

.source/emacs-%.tar.gz:
	cd $(@D) && curl -O https://ftp.gnu.org/pub/gnu/emacs/$(@F)

##############################

dist: $(EMACS_VERSION:%=.dist/emacs-%.tar.gz)

.dist/emacs-%.tar.gz: .build/emacs-%
	tar -zcf $@ $^

##############################

push: $(EMACS_VERSION:%=.make/push-emacs-%)

.make/push-emacs-%: .dist/emacs-%.tar.gz
	scp -v -i $(SSHKEY) \
	  -o 'StrictHostKeyChecking=no' -o 'UserKnownHostsFile=/dev/null' \
	  $^ conao3@files.conao3.com:~/www/files/emacs-builder/
	touch $@

##############################

# for convenience
rsync: dist
	rsync -aP .dist/ \
	  -e "ssh -i $(SSHKEY) -v -o 'StrictHostKeyChecking=no' -o 'UserKnownHostsFile=/dev/null'" \
	  sakura:~/www/files/emacs-builder

##############################

clean-dist:
	rm -rf $(filter-out .source,$(DIRS))

clean:
	rm -rf $(DIRS)
