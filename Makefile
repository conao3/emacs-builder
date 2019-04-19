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

dist: emacs.tar.gz
emacs.tar.gz:
	echo emacs > $@
test:

##############################

push: emacs.tar.gz
	scp -v -i /tmp/.ssh/rsync-files-conao3_rsa -o 'StrictHostKeyChecking=no' -o 'UserKnownHostsFile=/dev/null' emacs.tar.gz conao3@files.conao3.com:~/www/files/

##############################

clean:
