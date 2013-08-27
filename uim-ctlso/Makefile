
all: plugin/uim-ctl.so

plugin/uim-ctl.so: plugin/uim-ctl.c
	gcc -Wall -shared -o plugin/uim-ctl.so -I/usr/local/include plugin/uim-ctl.c -L/usr/local/lib -luim -lpthread

clean:
	rm plugin/uim-ctl.so

