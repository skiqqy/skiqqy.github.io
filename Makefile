# Makefile for blog

CC=gcc
FLAGS=-Wall -pedantic
EXE=bin/GenBlog

all: comp blog build

demo: comp blog buildd

comp: install
	$(CC) $(FLAGS) src/GenBlog.c -o $(EXE)

debug: install
	$(CC) $(FLAGS) -DDEBUG src/GenBlog.c -o $(EXE)

install:
	mkdir -p bin
	mkdir -p blogs

clean:
	rm -rf blogs/*.html
	rm -rf ./blogs.html
	rm -rf bin

build:
	./build.sh

buildd:
	./build.sh -d

blog: comp
	@# Reset all blogs to start build.
	@# Setup boilerplate html files for blog files
	-@for blog in ./blogs/RawBlogs/*.blog ; do \
		blog=$$(echo $$blog | cut -c 17- | cut -d "." -f 1); \
		cp ./blogs/preamble/start.html ./blogs/$$blog.html; \
		done
	-@cp ./blogs/preamble/start.html ./blogs.html
	./bin/GenBlog
	@# Append the end of the file once done
	-@for blog in ./blogs/RawBlogs/*.blog ; do \
		blog=$$(echo $$blog | cut -c 17- | cut -d "." -f 1); \
		cat ./blogs/preamble/end.html >> ./blogs/$$blog.html; \
		done
	-@cat ./blogs/preamble/end.html >> ./blogs.html
