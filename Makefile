TARGET = bin/Gocker
SRC = $(wildcard src/*.go)

run: clean build
		@./$(TARGET)

default: ./$(TARGET)

clean:
		@rm -f bin/*

build:
	@go build -o $(TARGET)
