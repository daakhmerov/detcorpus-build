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
.PRECIOUS: %.txt %.conllu
#.PHONY: unoconv-listener
udmodel := data/russian-syntagrus-ud-2.5-191206.udpipe
numtopics := 100 200 300
metadatadb=$(SRC)/metadata.sql

## UTILS
gitsrc=git --git-dir=$(SRC)/.git/
db2meta=python3 scripts/db2meta.py --dbfile=meta.db --genres=$(SRC)/genres.csv
udpiper := PYTHONPATH=../udpiper python3 ../udpiper/bin/udpiper 

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
	@echo $(info $*=$($*))

%.txt: %.fb2 | unoconv-listener
	test -d $(@D) || mkdir -p $(@D)
	unoconv -n -f txt -e encoding=utf8 -o $@ $< || pandoc -t plain -o $@ $<

%.txt: %.epub
	pandoc -o $@ $<

%.txt: %.html
	test -d $(@D) || mkdir -p $(@D)
	w3m -dump $< > $@

%.conllu: %.txt
	udpipe --tokenize --tag --parse --output=conllu --outfile=$@ $(udmodel) $<  

%.vert: %.html
	test -d $(@D) || mkdir -p $(@D)
	w3m -dump $< | mystem -n -d -i -g -c -s --format xml $< | sed 's/[^[:print:]]//g' | python3 scripts/mystem2vert.py $@ > $@

%.vert: %.txt
	test -d $(@D) || mkdir -p $(@D)
	mystem -n -d -i -g -c -s --format xml $< | sed 's/[^[:print:]]//g' | python3 scripts/mystem2vert.py $@ > $@

meta.db: $(metadatadb)
	test ! -f $@ || rm -f $@
	sqlite3 $@ < $<

.mrc: meta.db
	test -d mrc || mkdir mrc
	sqlite3 meta.db "select download_link || ' mrc/' || book_id || '.mrc' from books where download_link is not null" | fgrep -v search.rsl | while read link outfile ; do test -f "$$outfile" || wget "$$link" -O "$$outfile" ; done && touch .mrc

.metadata: $(textfiles) $(vertfiles) meta.db
	echo $(textfiles) | tr ' ' '\n' | while read f ; do sed -i -e "1c $$($(db2meta) -f $$f)" $${f%.*}.vert ; done && touch $@

detcorpus.vert: $(vertfiles) .metadata
	rm -f $@
	echo "$(sort $^)" | tr ' ' '\n' | while read f ; do cat "$$f" >> $@ ; done

conllu: $(vertfiles:.vert=.conllu)

export/data/%/word.lex: config/% %.wlda.vert
	rm -rf export/data/$*
	rm -f export/registry/$*
	mkdir -p $(@D)
	mkdir -p export/registry
	mkdir -p export/vert
	encodevert -c ./$< -p $(@D) $*.wlda.vert
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
	mallet import-file --line-regex "^(\S*\t[^\t]*)\t([^\t]*)\t([^\t]*)" --label 3 --name 1 --data 2 --keep-sequence --token-regex "[\p{L}\p{N}-]*\p{L}+" --stoplist-file stopwords.txt --input $< --output $@

lda/model%.mallet: detcorpus.vectors
	mallet train-topics --input $< --num-topics $* --output-model lda/model$*.mallet \
		--num-threads 8 --random-seed 987439812 --num-iterations 1000 --num-icm-iterations 20 \
		--num-top-words 50 --optimize-interval 20 \
		--output-topic-keys lda/summary$*.txt \
		--xml-topic-phrase-report lda/topic-phrase$*.xml \
		--output-doc-topics lda/doc-topics$*.txt --doc-topics-threshold 0.05 \
		--diagnostics-file lda/diag$*.xml

lda/state%.gz: lda/model%.mallet
	mallet train-topics --input-model $< --no-inference --output-state $@

lda/labels%.txt: lda/summary%.txt
	sort -nr -k2 -t"	" $< | gawk -F"\t" '{match($$3, /^([^ ]+ [^ ]+ [^ ]+)/, top); gsub(" ", "_", top[1]); printf "%d %d %s\n", NR, $$1, top[1]}' > $@

lda/dtfull%.tsv: lda/model%.mallet
	mallet train-topics --input-model $< --no-inference --output-doc-topics $@

lda: $(patsubst %, lda/model%.mallet, $(numtopics))

detcorpus.wlda.vert: detcorpus.vert lda $(patsubst %, lda/labels%.txt, $(numtopics))
	python3 scripts/addlda2vert.py -l $(patsubst %,lda%,$(numtopics)) -t $(patsubst %,lda/labels%.txt,$(numtopics)) -d $(patsubst %,lda/doc-topics%.txt,$(numtopics)) -i $< -o $@

## NAMES (for the record)
names:
	cat lda/doc-topics50.txt | awk '{for (f=4; f<=NF;f++) {if ($f<0.05) {$f=0} else {$f=1}}; print $0}' > lda/doc-topics50i.txt
