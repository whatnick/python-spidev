# main compiler
CC := gcc

# define the directories
SRCDIR := src
INCDIR := include
BUILDDIR := build
BINDIR := bin
LIBDIR := lib

# define common variables
SRCEXT := c
SOURCES := $(shell find $(SRCDIR) -maxdepth 1 -type f \( -iname "*.$(SRCEXT)" ! -iname "*main-*.$(SRCEXT)" \) )
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))
CFLAGS := -g # -Wall

#INC := $(shell find $(INCDIR) -maxdepth 1 -type d -exec echo -I {}  \;)

PYTHON_VERSION="2.7"

PYINC := "-I/usr/include/python$(PYTHON_VERSION)"
INC := $(PYINC)

LIB := -lpython$(PYTHON_VERSION)

# define specific binaries to create
TARGET := $(LIBDIR)/python$(PYTHON_VERSION)/spidev.so
LEGACY := $(LIBDIR)/spidev.so


## Makefile rules
all: info validate $(TARGET) $(LEGACY)

$(TARGET): $(OBJECTS)
	@echo " Compiling $@"
	@mkdir -p $(dir $@)
	$(CC) -shared -o $@  $^ $(LIB)

# generic: build any object file required
$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(dir $@)
	@echo " $(CC) $(CFLAGS) $(INC) -c -o $@ $<"; $(CC) $(CFLAGS) $(INC) -c -o $@ $<

	
$(LEGACY): $(TARGET)
ifeq ($(PYTHON_VERSION),2.7)
	@echo " Copying to legacy location for backward compatibility"
	@mkdir -p $(dir $@)
	cp $(TARGET) $(LEGACY)
endif

validate:
ifeq ($(PYTHON_VERSION),)
$(info "PYTHON_VERSION variable is not set, defaulting")
else
$(info "Using PYTHON_VERSION $(PYTHON_VERSION)")
endif

info:
	@echo "PYTHON_VERSION = $(PYTHON_VERSION)"
	@echo "PYINC = $(PYINC)"

clean:
	@echo " Cleaning...";
	$(RM) -r $(BUILDDIR) $(BINDIR) $(LIBDIR)
	
wipe:
	@echo " Cleaning just build files...";
	$(RM) -r $(BUILDDIR)

.PHONY: clean
