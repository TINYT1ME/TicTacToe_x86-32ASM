ASMEXT=asm
SRC := $(wildcard *.$(ASMEXT))
OBJDIR=obj
OBJ := $(patsubst %.$(ASMEXT), $(OBJDIR)/%.o, $(SRC))
EXE=game

AS=nasm
ASARGS=-f elf32
LD=ld
LDARGS=-m elf_i386

all: pre-build $(EXE)

pre-build:
	mkdir -p $(OBJDIR)

$(EXE): $(OBJ)
	$(LD) $(LDARGS) $(OBJ) -o $(EXE)

$(OBJDIR)/%.o : %.$(ASMEXT)
	$(AS) $(ASARGS) $< -o $@

clean:
	rm -rf $(OBJDIR) $(EXE)



	
