
ifneq ($(QTROOT),)
	QTBIN := $(QTROOT)/bin
	SYSINCS := $(SYSINCS) $(QTROOT)/include
	SYSLIBP := $(SYSLIBP) $(QTROOT)/lib
endif

ifneq ($(QTBIN),)
	CFG_QTMOC := $(QTBIN)/moc
else
	CFG_QTMOC := moc
endif

ifneq ($(findstring qt,$(FRWK)),)
	ifeq ($(TGT_PLATFORM),windows)
		PRJ_GUIT := win
	endif
endif
