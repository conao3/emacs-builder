all:

include Makefunc.mk

##################################################

all: clone

clone: /tmp/emacs
	git clone https://git.savannah.gnu.org/git/emacs.git /tmp/emacs

##############################

install:
uninstall:

##############################

dist:
test:

##############################

clean:
