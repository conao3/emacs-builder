all:

include Makefunc.mk

##################################################

all: clone

clone: /tmp/emacs
	git://git.savannah.gnu.org/emacs.git /tmp/emacs

##############################

install:
uninstall:

##############################

dist:
test:

##############################

clean:
