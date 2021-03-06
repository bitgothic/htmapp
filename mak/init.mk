
#-------------------------------------------------------------------
# default target
#-------------------------------------------------------------------
.PHONY: default_target
default_target: all

#-------------------------------------------------------------------
# Configure lib paths
#-------------------------------------------------------------------
CFG_LIBROOT := $(PRJ_LIBROOT)
CFG_MAKROOT := $(CFG_LIBROOT)/mak

#-------------------------------------------------------------------
# Parse target
#-------------------------------------------------------------------
include $(CFG_MAKROOT)/init/tgt.mk
include $(CFG_MAKROOT)/init/bld.mk

#-------------------------------------------------------------------
# Version
#-------------------------------------------------------------------
ifneq ($(VER),)
	CFG_VER := $(VER)
	CFG_FVER := $(subst .,_,$(VER))
endif

#-------------------------------------------------------------------
# Configure output paths
#-------------------------------------------------------------------
CFG_ESC_QUOTES = $(subst ",\",$(1))
CFG_ESC_BSLASH = $(subst \,\\,$(1))
CFG_ESC_CMLINE = $(call CFG_ESC_QUOTES,$(call CFG_ESC_BSLASH,$(call CFG_ESC_QUOTES,$(1))))

# Current working directory
#ifneq ($(CYGBLD),)
#	CFG_CUR_ROOT := $(subst \,/,$(shell cmd /c cd))
#else
	CFG_CUR_ROOT := $(shell pwd)
#endif

# Output root
ifneq ($(BINROOT),)
	CFG_BINROOT := $(BINROOT)
else
	CFG_BINROOT := $(CFG_LIBROOT)/../bin
endif
CFG_OUTROOT := $(CFG_BINROOT)/$(TTYPE)
CFG_OBJROOT := $(CFG_OUTROOT)/obj
CFG_PRJROOT := $(CFG_OBJROOT)/$(PRJ_NAME)

#-------------------------------------------------------------------
# Project info
#-------------------------------------------------------------------
CFG_EXTR := $(CFG_EXTR) -DCII_FRWK_$(FRWK)=1 \
						-DCII_FRWK="\"$(FRWK)\"" \
						-DCII_PROJECT=$(PRJ_NAME) \
						-DCII_PROJECT_NAME="\"$(PRJ_NAME)\"" \
						-DCII_PROJECT_DESC="\"$(PRJ_DESC)\""

# Project defines
ifneq ($(PRJ_CIID),)
	CFG_EXTR := $(CFG_EXTR) -DCII_PARAMS="\"$(call CFG_ESC_CMLINE,$(PRJ_CIID))\""
endif

#-------------------------------------------------------------------
# Configure local built tools
#-------------------------------------------------------------------
ifneq ($(LOCAL),)
	CFG_LOCALROOT := $(CFG_BINROOT)/$(LOCAL)
else
	CFG_LOCALROOT := $(CFG_OUTROOT)
endif

#-------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------
$(info =======================================================)
$(info = $(PRJ_NAME) - $(PRJ_DESC) )
$(info =======================================================)

# Add current directory to the list of includes
PRJ_INCS := $(CFG_CUR_ROOT) $(PRJ_INCS)

# Ensure directories
include $(CFG_MAKROOT)/init/dir.mk

#-------------------------------------------------------------------
# Configure Framework
#-------------------------------------------------------------------
ifneq ($(findstring html5,$(PRJ_FRWK)),)
	-include $(CFG_MAKROOT)/init/$(FRWK).mk
endif

#-------------------------------------------------------------------
# Configure gcc
#-------------------------------------------------------------------
include $(CFG_MAKROOT)/init/gcc.mk

# Target filename
CFG_OUTFILE := $(CFG_OUTROOT)/$(CFG_TGT_PRE)$(PRJ_NAME)$(CFG_TGT_EXT)

# Resources?
ifneq ($(PRJ_RESD),)
	include $(CFG_MAKROOT)/init/res.mk
endif
