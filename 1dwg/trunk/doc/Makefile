#   File: Makefile

# LICENSE

########### SVN repository information ###################
# $Date: 2008$
# $Author$
# $Revision$
# $HeadURL$
# $Id$
########### SVN repository information ###################

# purpose:
#	manage various resources in this directory

# Usage:
#	make		default (1st) rule: same as "make all"
#	make all	builds docbook and BaseClassSections.xml
#	make docbook	builds all DocBook sections
#	make clean	removes files built in this directory
#	make rebuild	does a make clean then make all

RELEASE = 1.0
TARGET = cansas-1d-$(RELEASE)-Manual.pdf
TARGET = manual.pdf

CLEANING_LIST += $(TARGET)
#CLEANING_LIST += *.pdf
#CLEANING_LIST += *.html
#CLEANING_LIST += *.ps

# === Rules ===

all: docbook

docbook : $(TARGET)

test ::
	@echo $(CLEANING_LIST)

# dblatex.sf.net can be used to build a PDF version of the manual
dblatex manual.pdf ::
	@#dblatex -P table.in.float=0 -ttex manual.xml
	dblatex -P table.in.float=0 -b pdftex -tpdf manual.xml
	@#pdftops $< temporary-manual.ps
	@#ps2pdf temporary-manual.ps $<

manual.ps ::manual.pdf
	pdftops $<

clean ::
	/bin/rm -f $(CLEANING_LIST)

rebuild :: clean all
