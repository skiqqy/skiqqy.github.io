# Makefile for blog

CC=gcc
FLAGS=-Wall -pedantic
EXE=bin/GenBlog

all: install
	$(CC) $(FLAGS) src/GenBlog.c -o $(EXE)

debug: install
	$(CC) $(FLAGS) -DDEBUG src/GenBlog.c -o $(EXE)

install:
	mkdir -p bin
	mkdir -p obj
	mkdir -p blogs

clean:
	rm -rf blogs/*.html
	rm -rf ./blogs.html
	rm -rf obj
	rm -rf bin

blog: all
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
