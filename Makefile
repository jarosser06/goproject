INSTALLPRE = /usr/local
GOLIST = $(shell go list ./... | grep -v /vendor/)
COMMAND_NAME = GOPROJECT
SUPPORTED_SYSTEMS = linux windows darwin

all: build

build: clean
		@echo "Building binary..."
		GO15VENDOREXPERIMENT=1 go build -o bin/${COMMAND_NAME}

test:
		@test -z "$(gofmt -s -l . | tee /dev/stderr)"
		@test -z "$(golint $(GOLIST) | tee /dev/stderr)"
		@GO15VENDOREXPERIMENT=1 go test -race -test.v $(GOLIST)
		@go vet $(GOLIST)

clean:
		@echo "Cleaning up..."
		rm -rf bin

install:
		@echo "Installing to $(INSTALLPRE)..."
		cp bin/$(COMMAND_NAME) $(INSTALLPRE)/bin/

cross_compile: linux windows darwin

linux:
		@mkdir -p bin/linux
		GO15VENDOREXPERIMENT=1 GOOS=linux go build -v -o bin/linux/$(COMMAND_NAME)

windows:
		@mkdir -p bin/windows
		GO15VENDOREXPERIMENT=1 GOOS=windows go build -v -o bin/windows/$(COMMAND_NAME).exe

darwin:
		@mkdir -p bin/darwin
		GO15VENDOREXPERIMENT=1 GOOS=darwin go build -v -o bin/darwin/$(COMMAND_NAME)
