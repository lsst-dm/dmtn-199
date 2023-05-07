DOCTYPE = DMTN
DOCNUMBER = 199
DOCNAME = $(DOCTYPE)-$(DOCNUMBER)
GSHEET = 1o1jbFP6tHSAzvg_OsNI0-qmzIIQGbe2_rjjM94xic8w

tex = $(filter-out $(wildcard *acronyms.tex) , $(wildcard *.tex */*tex))

GITVERSION := $(shell git log -1 --date=short --pretty=%h)
GITDATE := $(shell git log -1 --date=short --pretty=%ad)
GITSTATUS := $(shell git status --porcelain)
ifneq "$(GITSTATUS)" ""
	GITDIRTY = -dirty
endif

export TEXMFHOME ?= lsst-texmf/texmf

# Add aglossary.tex as a dependancy here if you want a glossary (and remove acronyms.tex)
$(DOCNAME).pdf: $(tex) meta.tex local.bib acronyms.tex aglossary.tex
	xelatex  $(DOCNAME).tex
	bibtex  $(DOCNAME)
	xelatex  $(DOCNAME).tex
	xelatex  $(DOCNAME).tex
	makeglossaries $(DOCNAME)
	xelatex $(SRC)
# For glossary uncomment the 2 lines above


# Acronym tool allows for selection of acronyms based on tags - you may want more than DM
acronyms.tex: $(tex) myacronyms.txt
	$(TEXMFHOME)/../bin/generateAcronyms.py -t "DM" $(tex)

# If you want a glossary you must manually run generateAcronyms.py  -gu to put the \gls in your files.
aglossary.tex :$(tex) myacronyms.txt
	generateAcronyms.py  -t "DM" -g $(tex)


.PHONY: clean
clean:
	latexmk -c
	rm -f $(DOCNAME).{bbl,glsdefs,pdf}
	rm -f meta.tex

.FORCE:

meta.tex: Makefile .FORCE
	rm -f $@
	touch $@
	printf '%% GENERATED FILE -- edit this in the Makefile\n' >>$@
	printf '\\newcommand{\\lsstDocType}{$(DOCTYPE)}\n' >>$@
	printf '\\newcommand{\\lsstDocNum}{$(DOCNUMBER)}\n' >>$@
	printf '\\newcommand{\\vcsRevision}{$(GITVERSION)$(GITDIRTY)}\n' >>$@
	printf '\\newcommand{\\vcsDate}{$(GITDATE)}\n' >>$@


tables: .FORCE
	cd tables; makeTablesFromGoogle.py ${GSHEET}  matrix\!A1:F  cost\!A1:F
