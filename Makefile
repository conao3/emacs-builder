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

push:
	scp -rv -i /tmp/.ssh/rsync-files-conao3_rsa ../emacs-builder conao3@files.conao3.com:~/www/files/

##############################

clean:
