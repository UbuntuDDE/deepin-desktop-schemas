PREFIX	:= /usr
ARCH    := x86

all: build

bin:
	mkdir -p bin
	env GO111MODULE=off go build -o bin/override_tool tools/override/*.go

build: bin
	@echo build for arch: $(ARCH)
	mkdir -p result
	find schemas -name "*.xml" -exec cp {} result \;
	bin/override_tool -arch $(ARCH)

test: 
	@echo "Testing schemas with glib-compile-shemas..."
	glib-compile-schemas --dry-run result

print_gopath:
	GOPATH="${CURDIR}/${GOPATH_DIR}:${GOPATH}"

install:
	@echo install for arch:$(ARCH)
	mkdir -p $(DESTDIR)$(PREFIX)/share/glib-2.0/schemas
	cp -v result/*.xml result/*.override $(DESTDIR)$(PREFIX)/share/glib-2.0/schemas/
	mkdir -p $(DESTDIR)$(PREFIX)/share/deepin-desktop-schemas
	cp -v result/*-override $(DESTDIR)$(PREFIX)/share/deepin-desktop-schemas


clean:
	-rm -rf bin
	-rm -rf result

.PHONY: bin
