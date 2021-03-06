
.PHONY: all clean

BIBTEX2HTML_FOLDER=bibtex2html
BIBTEX2HTML=$(BIBTEX2HTML_FOLDER)/bibtex2html
BIBTEX2HTML_ARGS=-d -r -nodoc \
	-nf videos videos \
	-nf reviews reviews \
	-nf full-bibliography "full bibliography" \
	-nf bibliography "bibliography" \
	-nf code-v "code (.v)" \
	-nf code-html "code (.html)" \
	-nf code-agda "code (.agda)" \
	-nf artifact-zip "artifact (.zip)" \
	-nf artifact-tar-gz "artifact (.tar.gz)" \
	-nf code-github "project (<img src='media/GitHub-Mark/PNG/GitHub-Mark-32px.png' alt='GitHub' title='GitHub' style='height:1em; vertical-align:text-bottom' />)" \
	-nf artifact-github "artifact (<img src='media/GitHub-Mark/PNG/GitHub-Mark-32px.png' alt='GitHub' title='GitHub' style='height:1em; vertical-align:text-bottom' />)" \
	-nf original-url "original conference submission (.pdf)" \
	-nf presentation-annotated-pptx "presentation (.pptx, annotated with notes)" \
	-nf presentation-pptx "presentation (.pptx)" \
	-nf presentation-youtube "presentation (YouTube)" \
	-nf url-pptx ".pptx" \
	-nf presentation-pdf "presentation (.pdf)" \
	-nf presentation-odp "presentation (.odp)" \
	-nf project-homepage "project homepage" \
	-nf published-url "publication" \
	-nf published-url-springer 'publication (<div style="overflow: hidden; max-width: 1em; display: inline-block; vertical-align: middle"><img src="media/Springer-Mark/PNG/logo.png" alt="Springer" title="Springer" style="height: 1.5em; vertical-align: text-bottom"></div>)' \
	-nf published-url-elsevier-geoderma 'publication (<img src="media/ScienceDirect-Mark/svg/elsevier-non-solus-new-grey.svg" alt="ScienceDirect" title="ScienceDirect" style="height: 1em;vertical-align: text-bottom;">)' \
	-nf acm-authorize-url "<img src='https://dl.acm.org/images/oa.gif' width='25' height='25' border='0' alt='ACM DL Author-ize Publication' title='ACM DL Author-ize Publication' style='vertical-align:middle'/>" \
	-nf dspace-url "DSpace@MIT" \
	# -nf doi "<img src='https://www.doi.org/img/Logo_TM.png' width='25' height='25' border='0' alt='DOI' style='vertical-align:middle'/>"
	#-nf presentation-youtube 'presentation (<img src="https://www.youtube.com/about/static/svgs/icons/brand-resources/YouTube_icon_full-color.svg" alt="YouTube" title="YouTube" style="height:1em; vertical-align:text-bottom" />)'
	#-nf presentation-youtube 'presentation (<img src="https://www.youtube.com/about/static/svgs/icons/brand-resources/YouTube-logo-full_color_light.svg" alt="YouTube" title="YouTube" style="height:1em; vertical-align:text-bottom" />)'

OUTPUTS := jason-gross-drafts-stripped.html jason-gross-stripped.html presentations/coq-8.6-wishlist/jgross-coq-8-6-wishlist-no-pause.pdf presentations/csw-2013/jgross-presentation-no-pause.pdf presentations/popl-2013/jgross-student-talk.pdf presentations/popl-2013/minute-madness.pdf papers/source/coqpl-2021/reification-by-type-inference.pdf resume/resume.pdf papers/category-coq-experience.html jason-gross.html papers/category-coq-experience-filtered.bib presentations/coq-workshop-2014/coq-workshop-proposal-tactics-in-terms.pdf presentations/coq-workshop-2014/html/CoqWorkshop.tactics_in_terms_paper_examples.html presentations/coq-workshop-2018/coq-workshop-proposal-notations.pdf presentations/coq-workshop-2018/html/CoqWorkshop.NotationsCheatSheet.html presentations/coq-workshop-2018/html/CoqWorkshop.Notations.html presentations/coq-workshop-2018/html/CoqWorkshop.NotationsMITPresentation.html presentations/coq-workshop-2018/html/CoqWorkshop.NotationsCoqWorkshop.html
OLD_NO_LONGER_BUILT_OUTPUTS := papers/lob-paper/html/lob.html papers/lob-paper/supplemental-nonymous.zip papers/lob-bibliography.html

all: $(OUTPUTS)

clean:
	rm -f jason-gross_bib.html papers/category-coq-experience_bib.html $(OUTPUTS)

POUND=\#

COMMON_SED_REPS := \
	-e s'/This file/This reference list/g' \
	-e s'/<hr>//g' \
	-e s'/h1/h2/g' \
	-e s'|\[<a name="\([^"]*\)">\([^<]*\)</a>\]|[<a name="\1" href="$(POUND)\1">\2</a>]|g'

jason-gross-stripped.html: jason-gross.html Makefile
	sed $(COMMON_SED_REPS) -e s'/<h2>/<h2 id="publications">/g' $< > $@

jason-gross.html: %.html : %.bib $(BIBTEX2HTML) Makefile
	$(BIBTEX2HTML) $(BIBTEX2HTML_ARGS) --title "Papers and Presentations" -o "$*" "$<"

jason-gross-drafts-stripped.html: jason-gross-drafts.html Makefile
	sed $(COMMON_SED_REPS) -e s'/<h2>/<h2 id="drafts">/g' $< > $@

jason-gross-drafts.html: %.html : %.bib $(BIBTEX2HTML) Makefile
	$(BIBTEX2HTML) $(BIBTEX2HTML_ARGS) --title "Drafts" -o "$*" "$<"

papers/category-coq-experience.html: %.html : %-filtered.bib $(BIBTEX2HTML) Makefile
	$(BIBTEX2HTML) $(BIBTEX2HTML_ARGS) --title "Experience Implementing a Performant Category-Theory Library in Coq: Complete List of References" -o "$*" "$<"

papers/lob-bibliography.html: %.html : %-filtered.bib $(BIBTEX2HTML) Makefile
	$(BIBTEX2HTML) $(BIBTEX2HTML_ARGS) --title "L&ouml;b's Theorem: A functional pearl of dependently typed quining: List of References" -o "$*" "$<"

papers/category-coq-experience-filtered.bib papers/lob-bibliography-filtered.bib: %-filtered.bib : %.bib Makefile
	@echo "FILTER $< > $@"
	@cat "$<" | \
	sed s'/@ELECTRONIC/@MISC/g' | \
	sed s'/@Electronic/@Misc/g' | \
	sed s'/@electronic/@misc/g' | \
	sed s'/-old\s*=\s*/ = /g' | \
	sed s'/\\item/\\\\ \&bull;/g' | \
	sed s'/howpublished\s*=\s*{\\url{\([^}]\+\)}}/url = {\1}/g' | \
	sed s'/month\s*=\s*{1}/month = {January}/g' | \
	sed s'/month\s*=\s*{2}/month = {February}/g' | \
	sed s'/month\s*=\s*{3}/month = {March}/g' | \
	sed s'/month\s*=\s*{4}/month = {April}/g' | \
	sed s'/month\s*=\s*{5}/month = {May}/g' | \
	sed s'/month\s*=\s*{6}/month = {June}/g' | \
	sed s'/month\s*=\s*{7}/month = {July}/g' | \
	sed s'/month\s*=\s*{8}/month = {August}/g' | \
	sed s'/month\s*=\s*{9}/month = {September}/g' | \
	sed s'/month\s*=\s*{10}/month = {October}/g' | \
	sed s'/month\s*=\s*{11}/month = {November}/g' | \
	sed s'/month\s*=\s*{12}/month = {December}/g' | \
	sed s'/month\s*=\s*{Jan}/month = {January}/g' | \
	sed s'/month\s*=\s*{Feb}/month = {February}/g' | \
	sed s'/month\s*=\s*{Mar}/month = {March}/g' | \
	sed s'/month\s*=\s*{Apr}/month = {April}/g' | \
	sed s'/month\s*=\s*{Jun}/month = {June}/g' | \
	sed s'/month\s*=\s*{Jul}/month = {July}/g' | \
	sed s'/month\s*=\s*{Aug}/month = {August}/g' | \
	sed s'/month\s*=\s*{Sep}/month = {September}/g' | \
	sed s'/month\s*=\s*{Oct}/month = {October}/g' | \
	sed s'/month\s*=\s*{Nov}/month = {November}/g' | \
	sed s'/month\s*=\s*{Dec}/month = {December}/g' > $@


$(BIBTEX2HTML): $(BIBTEX2HTML_FOLDER)/Makefile
	cd $(BIBTEX2HTML_FOLDER); $(MAKE)

$(BIBTEX2HTML_FOLDER)/Makefile: $(BIBTEX2HTML_FOLDER)/configure
	cd $(BIBTEX2HTML_FOLDER); ./configure --prefix "$$(readlink -f .)"

$(BIBTEX2HTML_FOLDER)/configure: $(BIBTEX2HTML_FOLDER)/configure.in
	cd $(BIBTEX2HTML_FOLDER); autoconf

resume/resume.pdf: resume/Makefile resume/Resume.tex
	cd resume; $(MAKE)

presentations/coq-8.6-wishlist/jgross-coq-8-6-wishlist-no-pause.pdf: presentations/coq-8.6-wishlist/jgross-coq-8-6-wishlist.tex presentations/coq-8.6-wishlist/Makefile presentations/coq-8.6-wishlist/appendixnumberbeamer.sty
	cd presentations/coq-8.6-wishlist; $(MAKE)

presentations/csw-2013/jgross-presentation-no-pause.pdf: presentations/csw-2013/jgross-presentation.tex presentations/csw-2013/Makefile
	cd presentations/csw-2013; $(MAKE)

presentations/popl-2013/%.pdf: presentations/popl-2013/%.tex presentations/popl-2013/Makefile
	cd presentations/popl-2013; $(MAKE) $(*:=.pdf)

presentations/coq-workshop-2014/%.pdf: presentations/coq-workshop-2014/%.tex presentations/coq-workshop-2014/Makefile
	cd presentations/coq-workshop-2014; $(MAKE) $(*:=.pdf)

papers/source/coqpl-2021/%.pdf: papers/source/coqpl-2021/%.tex papers/source/coqpl-2021/Makefile papers/source/coqpl-2021/reification_by_type_inference_tex.v
	cd papers/source/coqpl-2021; $(MAKE) $(*:=.pdf)

$(filter presentations/coq-workshop-2014/html/CoqWorkshop.%.html,$(OUTPUTS)): coq-workshop-2014-html


COQ_2014:=$(shell pwd)/presentations/coq-workshop-2014-coq
COQBIN_2014:=$(COQ_2014)/bin/

$(COQ_2014)/config/Makefile: $(COQ_2014)/configure
	cd $(COQ_2014); ./configure -local -coqide no

$(COQ_2014)/bin/coqc: $(COQ_2014)/config/Makefile
	cd $(COQ_2014); $(MAKE)

.PHONY: coq-workshop-2014-html
coq-workshop-2014-html: $(COQ_2014)/bin/coqc
	cd presentations/coq-workshop-2014; $(MAKE) COQBIN="$(COQBIN_2014)" html

presentations/coq-workshop-2018/%.pdf: presentations/coq-workshop-2018/%.tex presentations/coq-workshop-2018/Makefile
	cd presentations/coq-workshop-2018; $(MAKE) $(*:=.pdf)

$(filter presentations/coq-workshop-2018/html/CoqWorkshop.%.html,$(OUTPUTS)): coq-workshop-2018-html

COQ_2018:=$(shell pwd)/presentations/coq-workshop-2018-coq
COQBIN_2018:=$(COQ_2018)/bin/

$(COQ_2018)/config/Makefile: $(COQ_2018)/configure
	cd $(COQ_2018); ./configure -local -coqide no

$(COQ_2018)/bin/coqc: $(COQ_2018)/config/Makefile
	cd $(COQ_2018); $(MAKE)

.PHONY: coq-workshop-2018-html
coq-workshop-2018-html: $(COQ_2018)/bin/coqc
	cd presentations/coq-workshop-2018; $(MAKE) COQBIN="$(COQBIN_2018)" html

papers/lob-paper/html/lob.html:
	cd papers/lob-paper; $(MAKE) dependencies && $(MAKE) all

papers/lob-paper/supplemental-nonymous.zip: papers/lob-paper/html/lob.html
	cd papers/lob-paper; $(MAKE) supplemental

.PHONY: deploy
deploy:
	rm -rf build
	mkdir build
	find . -name "*.pdf" -o -name "*.html" | xargs tar -czf - | ( cd build; tar -xzvf - )
