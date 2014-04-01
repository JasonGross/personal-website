
.PHONY: all clean

BIBTEX2HTML=bibtex2html-1.97/bibtex2html

OUTPUTS := jason-gross-stripped.html presentations/coq-8.6-wishlist/jgross-coq-8-6-wishlist-no-pause.pdf presentations/csw-2013/jgross-presentation-no-pause.pdf presentations/popl-2013/jgross-student-talk.pdf presentations/popl-2013/minute-madness.pdf resume/resume.pdf

all: $(OUTPUTS)

clean:
	rm -f jason-gross.html jason-gross_bib.html $(OUTPUTS)

jason-gross-stripped.html: jason-gross.html Makefile
	sed s'/This file/This reference list/g' $< | sed s'/<hr>//g' | sed s'/h1/h2/g' > $@

jason-gross.html: jason-gross.bib $(BIBTEX2HMTL) Makefile
	$(BIBTEX2HTML) -d -r -nodoc -nf videos videos -nf reviews reviews --title "Papers and Presentations" $<

bibtex2html-1.97/bibtex2html: bibtex2html-1.97/Makefile
	cd bibtex2html-1.97; $(MAKE)

bibtex2html-1.97/Makefile: bibtex2html-1.97/configure
	cd bibtex2html-1.97; ./configure --prefix "$(readlink -f .)"

resume/resume.pdf: resume/Makefile resume/Resume.tex
	cd resume; $(MAKE)

presentations/coq-8.6-wishlist/jgross-coq-8-6-wishlist-no-pause.pdf: presentations/coq-8.6-wishlist/jgross-coq-8-6-wishlist.tex presentations/coq-8.6-wishlist/Makefile presentations/coq-8.6-wishlist/appendixnumberbeamer.sty
	cd presentations/coq-8.6-wishlist; $(MAKE)

presentations/csw-2013/jgross-presentation-no-pause.pdf: presentations/csw-2013/jgross-presentation.tex presentations/csw-2013/Makefile
	cd presentations/csw-2013; $(MAKE)

presentations/popl-2013/%.pdf: presentations/popl-2013/%.tex presentations/popl-2013/Makefile
	cd presentations/popl-2013; $(MAKE) %.pdf
