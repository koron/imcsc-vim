
all: plugin/uim-ctl.so

plugin/uim-ctl.so: plugin/uim-ctl.c
	gcc -Wall -fPIC -shared -o plugin/uim-ctl.so -I/usr/local/include plugin/uim-ctl.c -L/usr/local/lib -luim -lpthread

install: plugin/uim-ctl.so plugin/uim-ctlso.vim
	cp plugin/uim-ctl.so ~/.vim/plugin
	cp plugin/uim-ctlso.vim ~/.vim/plugin

clean:
	rm plugin/uim-ctl.so

.PHONY: install clean
