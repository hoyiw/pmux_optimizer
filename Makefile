YOSYS_CONFIG ?= yosys-config
CXX := $(shell $(YOSYS_CONFIG) --cxx)
CXXFLAGS := $(shell $(YOSYS_CONFIG) --cxxflags) -Wall -Wextra
LDFLAGS := $(shell $(YOSYS_CONFIG) --ldflags)
LIBS := $(shell $(YOSYS_CONFIG) --libs)
YOSYS := $(shell $(YOSYS_CONFIG) --bindir)/yosys
PLUGIN := build/pmux_opt.so

.PHONY: all clean test

all: $(PLUGIN)

$(PLUGIN): src/pmux_opt.cc
	mkdir -p build
	$(CXX) $(CXXFLAGS) -shared -fPIC -o $@ $< $(LDFLAGS) $(LIBS)

test: $(PLUGIN)
	$(YOSYS) -m $(abspath $(PLUGIN)) -s tests/equivalence.ys

clean:
	rm -rf build
