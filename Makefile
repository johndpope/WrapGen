CFLAGS := -I/usr/local/Cellar/llvm/4.0.0_1/include
LDFLAGS := -L/usr/local/Cellar/llvm/4.0.0_1/lib

SFLAGS=-Xcc $(CFLAGS) -Xlinker $(LDFLAGS)

DBGLIB=.build/debug/WrapGen
RELLIB=.build/release/WrapGen

all: $(DBGLIB)

$(DBGLIB): Sources/*
	swift package  $(SFLAGS)   generate-xcodeproj

release: $(RELLIB)

$(RELLIB): Sources/*
	swift build -c release $(SFLAGS)

test: $(DBGLIB)
	swift test $(SFLAGS)

clean:
	rm -rf $(DBGLIB) $(RELLIB)
	swift build --clean
