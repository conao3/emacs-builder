all:

include Makefunc.mk

##################################################

all: clone

clone: /tmp/emacs fetch
/tmp/emacs:
	git clone https://git.savannah.gnu.org/git/emacs.git /tmp/emacs
fetch: /tmp/emacs
	cd /tmp/emacs && git fetch --all

##############################

install:
uninstall:

##############################

dist:
test:

##############################

clean:
