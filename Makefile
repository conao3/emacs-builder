all:

include Makefunc.mk

ROOTDIR := $(shell pwd)

SSHKEY        ?= ~/.ssh/rsync-files-conao3_rsa
EMACS_VERSION ?= 26.2

MAKEDIRS := source build dist push
DIRS := $(MAKEDIRS:%=.make/%)

DATE       := $(shell date +%Y-%m-%d)
DATEDETAIL := $(shell date +%Y-%m-%d:%H-%M-%S)

##################################################

.PRECIOUS: .make/build/emacs-% .make/build/emacs-master .make/build/emacs-% .make/source/emacs-master .make/source/emacs-%.tar.gz

all: $(DIRS) dist

$(DIRS):
	mkdir -p $@

##############################

build: $(EMACS_VERSION:%=.make/build/emacs-%)

configure-options=--with-ns --with-modules --prefix=$(ROOTDIR)/$@

.make/build/emacs-master: .make/source/emacs-%
	cp -rf $< $@
	cd $@ && if [ -e autogen.sh ]; then ./autogen.sh; fi
	cd $@ && ./configure $(configure-options)
	$(MAKE) -C $@
	$(MAKE) install -C $@

.make/build/emacs-%: .make/source/emacs-%.tar.gz
	tar -zxf $< -C $(@D)
	cd $@ && if [ -e autogen.sh ]; then ./autogen.sh; fi
	cd $@ && ./configure $(configure-options)
	$(MAKE) -C $@
	$(MAKE) install -C $@

.make/source/emacs-master:
	git clone --depth=1 https://git.savannah.gnu.org/git/emacs.git $@

.make/source/emacs-%.tar.gz:
	curl -L https://ftp.gnu.org/pub/gnu/emacs/$(@F) > $@

##############################

dist: $(EMACS_VERSION:%=.make/dist/emacs-%.tar.gz)

.make/dist/emacs-%.tar.gz: .make/build/emacs-%
	tar -zcf $@ $^

##############################

push: $(EMACS_VERSION:%=.make/push/push-emacs-%)

.make/push/push-emacs-%: .make/dist/emacs-%.tar.gz
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
	rm -rf $(filter-out .make/source,$(DIRS))

clean:
	rm -rf $(DIRS)
