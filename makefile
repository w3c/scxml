#$Id: makefile,v 1.27 2015/08/31 20:25:09 ashimura Exp $XSL=*.xsl
XML=$(shell find . -name '*.xml')
SPEC=SCXMLNotation.xml
HTML=*.html

this=SCXMLNotation.html
dest=../../../../TR/2015/REC-scxml-20150901
prev=../../../../TR/2015/PR-scxml-20150430
#prev=../../../../TR/2014/WD-scxml-20140529
#prev=../../../../TR/2014/CR-scxml-20140313
#prev=../../../../TR/2013/WD-scxml-20130801
#prev=../../../../TR/2012/WD-scxml-20121206
#prev=../../../../TR/2012/WD-scxml-20120216
#prev=../../../../TR/2011/WD-scxml-20110426
#prev=../../../../TR/2010/WD-scxml-20101216

disp=scxml_DoC.html

#all: html SCXML.rnc SCXML.xsd diff
all: diff install

SCXML.rnc: SCXML.rng
	trang $< $@

SCXML.xsd: SCXML.rng
	trang $< $@

html: SCXMLNotation-Master.xml
	./build.sh

valid: ${XML}
	xmllint --xinclude --noout --valid ${SPEC}

dw:
	@echo "Checking for doubled words. "
	for i in ${XML} ;  do \
	echo $$i ; \
	dw < $$i ; \
	done;

%.txt: %.html
	lynx -dump -nolist $< > $@

check: index-all.txt
	mv .errors .old-errors
	./tex-check $< > .errors
	diff .old-errors .errors > .new-errors
	@echo "See .new-errors for newly found errors."


spell: ${XML}
	mv .spell .old-spell
	cat ${XML} | aspell -H  -l  |sort | uniq > .spell
	diff .old-spell .spell > .new-spell
	@echo "See .new-spell for newly found errors."


egs:
	find . -name '*.scxml' | xargs xmllint --noout  --relaxng SCXML.rng

install :
	cp SCXMLNotation.html ${dest}/Overview.html

#	cp diff.html ${dest}/diff.html
#	cp ${disp} ${dest}
#	cp SCXMLExamples/*.png ${dest}/SCXMLExamples

diff :
	htmldiff.sh ${prev}/Overview.html ${this} > diff.html
	tidy -asxml -utf8 -m diff.html

clean:
	tidy -asxml -utf8 -m ${this}

#jimb=SCXMLNotation-jimB.html
#htmldiff.sh ${jimb} ${this} > diff2.html
#tidy -asxml -utf8 -m diff2.html

# local variables:
# mode: makefile
# end:
