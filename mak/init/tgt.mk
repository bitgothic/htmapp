
# platform
ifneq ($(findstring windows,$(TGT)),)
	TGT_PLATFORM := windows
else
	ifneq ($(findstring mingw,$(PRE)),)
		TGT_PLATFORM := windows
	else
		TGT_PLATFORM := posix
	endif
endif

# Processor type
TGT_PROC := $(strip $(foreach t,x86 x64 arm,$(findstring $(t),$(TGT))))
ifeq ($(TGT_PROC),)
	TGT_PROC := x86
endif

# Link type - static / shared
ifneq ($(findstring static,$(TGT)),)
	TGT_LINK := static
else
	ifneq ($(findstring shared,$(TGT)),)
		TGT_LINK := shared
	endif
endif

# Set a default link type if not specified
ifndef TGT_LINK
	ifeq ($(TGT_PLATFORM),windows)
		TGT_LINK := static
	else
		TGT_LINK := shared
	endif
endif

# If no framework specified
ifeq ($(FRWK),)
	FRWK := $(strip $(foreach t,qt apache cgi srv,$(findstring $(t),$(TGT))))
	ifeq ($(FRWK),)
		FRWK := srv
	endif
endif

# Create a type string
TTYPE := $(TGT_PLATFORM)-$(TGT_PROC)-$(TGT_LINK)-$(FRWK)

# debug
ifneq ($(findstring debug,$(TGT)),)
	DBG := 1
	TTYPE := $(TTYPE)-debug
endif


# Only gcc supported at the moment
TGT_BUILD := gcc

