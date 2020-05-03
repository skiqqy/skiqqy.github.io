# Makefile for blog

CC=gcc
FLAGS=-Wall -pedantic
EXE=bin/GenBlog

all: install
	$(CC) $(FLAGS) src/GenBlog.c -o $(EXE)

install:
	mkdir -p bin
	mkdir -p obj

clean:
	rm -rf obj
	rm -rf bin

blog: all
	./bin/GenBlog
