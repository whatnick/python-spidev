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

PYINC := "-I/usr/include/python2.7"
INC := $(PYINC)

LIB := -L$(LIBDIR) -lpython2.7

# define specific binaries to create
TARGET := python-spidev


## Makefile rules
all: $(TARGET)

$(TARGET): $(OBJECTS)
	@echo " Compiling $@"
	@mkdir -p $(BINDIR)
	$(CC) -shared -o $@  $^ $(LIB)

# generic: build any object file required
$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(dir $@)
	@echo " $(CC) $(CFLAGS) $(INC) -c -o $@ $<"; $(CC) $(CFLAGS) $(INC) -c -o $@ $<

clean:
	@echo " Cleaning...";
	$(RM) -r $(BUILDDIR) $(BINDIR) $(LIBDIR)

.PHONY: clean
