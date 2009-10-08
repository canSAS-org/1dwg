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
#	make dblatex	builds the manual

# === Rules ===

OPTS = -P table.in.float=0 -b pdftex

all: dblatex

# dblatex.sf.net builds the PDF version of the manual
dblatex cansas-1d-1_0-manual.pdf ::
	dblatex $(OPTS) -tpdf manual.xml
	mv -f manual.pdf ../cansas-1d-1_0-manual.pdf

test :: Makefile test.xml
	dblatex $(OPTS) -tpdf test.xml
