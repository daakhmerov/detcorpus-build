# SETUP PATHS
ROOT=..
SRC=$(ROOT)/detcorpus
vpath %.txt $(SRC)
vpath %.fb2 $(SRC)
vpath %.html $(SRC)
vpath %.csv $(SRC)
vpath %.epub $(SRC)
#
# SETUP CREDENTIALS
HOST=detcorpus
# CHROOTS
TESTING=testing
PRODUCTION=production
ROLLBACK=rollback
TESTPORT=8098
PRODPORT=8099
BUILT=built
RSYNC=rsync -avP --stats -e ssh
#
## corpora
corpbasename := detcorpus
corpsite := detcorpus
corpora := detcorpus
corpora-vert := $(addsuffix .vert, $(corpora))
compiled := $(patsubst %,export/data/%/word.lex,$(corpora))
## Remote corpus installation data
corpsite-detcorpus := detcorpus
#
#
## SETTINGS
SHELL := /bin/bash
.PRECIOUS: %.txt
#.PHONY: unoconv-listener
udmodel := data/ru-ud23.udpipe
numtopics := 50 100 150 200 250 300

## UTILS
gitsrc=git --git-dir=$(SRC)/.git/
db2meta=python3 scripts/db2meta.py --dbfile=$(SRC)/meta.db --genres=$(SRC)/genres.csv

## HARDCODED FILELIST TWEAKS
duplicatesrc := $(shell $(gitsrc) ls-files dups)
skipfiles := emolemmas.txt emowords.txt $(shell $(gitsrc) ls-files depot oldscripts algfio docs) 
## STANDARD SOURCE FILELISTS
gitfiles := $(shell $(gitsrc) ls-files)
srcfiles := $(filter-out $(duplicatesrc) $(skipfiles), $(gitfiles))
txtfiles := $(filter %.txt, $(srcfiles))
srchtmlfiles := $(filter %.html, $(srcfiles))
srctxtfiles := $(filter-out $(fb2files:.fb2=.txt) $(srchtmlfiles:.html=.txt), $(txtfiles))
srcfb2files := $(filter %.fb2, $(srcfiles))
srcepubfiles := $(filter %.epub, $(srcfiles))
textfiles := $(srctxtfiles) $(srcfb2files) $(srchtmlfiles) $(srcepubfiles)
vertfiles := $(srcfb2files:.fb2=.vert) $(srctxtfiles:.txt=.vert) $(srchtmlfiles:.html=.vert) $(srcepubfiles:.epub=.vert)

help:
	 @echo 'Makefile for building detcorpus                                           '
	 @echo '                                                                          '
	 @echo 'Corpus texts source files are expected to be found at: $(SRC)             '
	 @echo '                                                                          '
	 @echo '                                                                          '
	 @echo 'Dependencies: git, python, unoconv, w3m, awk, mystem,                     '
	 @echo '              manatee-open, pandoc                                        '
	 @echo '                                                                          '
	 @echo 'Usage:                                                                    '
	 @echo '   make convert	    convert all sources (fb2, html) into txt              '
	 @echo '   make compile      prepare NoSke indexes for all corpora for upload     '
	 @echo '                                                                          '

## remote operation scripts
include remote.mk

print-%:
	$(info $*=$($*))

%.txt: %.fb2 | unoconv-listener
	test -d $(@D) || mkdir -p $(@D)
	unoconv -n -f txt -e encoding=utf8 -o $@ $<

%.txt: %.epub
	pandoc -o $@ $<

%.txt: %.html
	test -d $(@D) || mkdir -p $(@D)
	w3m -dump $< > $@

%.conllu: %.txt
	udpiper -m $(udmodel) -i $< -o $@

%.vert: %.html
	test -d $(@D) || mkdir -p $(@D)
	w3m -dump $< | mystem -n -d -i -g -c -s --format xml $< | sed 's/[^[:print:]]//g' | python scripts/mystem2vert.py $@ > $@

%.vert: %.txt
	test -d $(@D) || mkdir -p $(@D)
	mystem -n -d -i -g -c -s --format xml $< | sed 's/[^[:print:]]//g' | python scripts/mystem2vert.py $@ > $@

.metadata: $(textfiles) $(vertfiles)
	echo $(textfiles) | tr ' ' '\n' | while read f ; do sed -i -e "1c $$($(db2meta) -f $$f)" $${f%.*}.vert ; done && touch $@

detcorpus.vert: $(vertfiles) .metadata
	rm -f $@
	echo "$(sort $^)" | tr ' ' '\n' | while read f ; do cat "$$f" >> $@ ; done

export/data/%/word.lex: config/% %.vert
	rm -rf export/data/$*
	rm -f export/registry/$*
	mkdir -p $(@D)
	mkdir -p export/registry
	mkdir -p export/vert
	encodevert -c ./$< -p $(@D) $*.vert
	cp $< export/registry
ifneq ("$(wildcard config/$*.subcorpora)","")
	echo "no subcorpora defined for $*:: $(wildcard config/$*.subcorpora)"
else
	mksubc ./export/registry/$* export/data/$*/subcorp config/$*.subcorpora
endif
	sed -i 's,./export,/var/lib/manatee/,' export/registry/$*

export/detcorpus.tar.xz: $(compiled)
	rm -f $@
	bash -c "pushd export ; tar cJvf detcorpus.tar.xz --mode='a+r' * ; popd"

unoconv-listener:
	unoconv --listener &
	sleep 10

compile: $(compiled)

convert: $(vertfiles:.vert=.txt) 

parse: $(vertfiles:.vert=.conllu)

## LDA

detcorpus.slem: detcorpus.vert
	gawk -f scripts/vert2lemfragments.gawk $< > $@

detcorpus.vectors: detcorpus.slem
	mallet import-file --line-regex "^(\S*\t[^\t]*)\t[^\t]*\t([^\t]*)\t([^\t]*)" --label 3 --name 1 --data 2 --keep-sequence --token-regex "[\p{L}\p{N}-]*\p{L}+" --stoplist-file stopwords.txt --input $< --output $@

lda/model%.mallet: detcorpus.vectors
	mallet train-topics --input $< --num-topics $* --output-model lda/model$*.mallet \
		--num-threads 4 --random-seed 3219 --num-iterations 1000 --num-icm-iterations 20 \
		--num-top-words 50 --optimize-interval 20 \
		--output-topic-keys lda/summary$*.txt \
		--xml-topic-phrase-report lda/topic-phrase$*.xml \
		--output-doc-topics lda/doc-topics$*.txt --doc-topics-threshold 0.05 \
		--diagnostics-file lda/diag$*.xml

lda: $(patsubst %, lda/model%.mallet, $(numtopics))