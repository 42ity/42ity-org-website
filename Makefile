
ASCIIDOC = asciidoc

HTML_SOURCES = 	\
	index.asciidoc	\
	source.asciidoc \
	binaries.asciidoc \
	hcl.asciidoc \
	presentation.asciidoc \
	about.asciidoc \
	contact.asciidoc

HTML_GEN_FILES = $(HTML_SOURCES:.asciidoc=.html)

HTML_FILES = $(HTML_GEN_FILES) \
	index-jumboinfo.html \
	navinfo.html

IMAGE_FILES =	\
	favicon.ico

STYLESHEET_FILES =	\
	css/42ity.css	\
	css/asciidoc-bootstrap.min.css
#FIXME: which other CSS?

SCRIPT_FILES =	\
	js/42ity.js	\
	js/bootstrap.min.js	\
	js/jquery.min.js
#FIXME: which other JS?

# Common files that triggers a rebuild of the pages
COMMON_REQS = bootstrap.conf navinfo.html

ADOC_PARAMS_COMMON =	\
	--backend=html5	\
	--attribute linkcss	\
	--attribute lang=en	\
	--attribute totop!	\
	--attribute brand="42ITy"	\
	--attribute brandref=./	\
	--attribute stylesdir=css	\
	--attribute scriptsdir=js	\
	--attribute navbar=fixed	\
	--attribute navinfo1	\
	--attribute favicon	\
	--attribute iconsdir=. \
	--attribute script=42ity.js \
	--attribute bootstrapdir=. \
	-f bootstrap.conf

all: $(HTML_FILES) $(IMAGE_FILES) $(STYLESHEET_FILES) $(SCRIPT_FILES)

%.html : %.asciidoc $(COMMON_REQS)
	$(ASCIIDOC) $(ADOC_PARAMS_COMMON) -o $@ $<

# index.html has some specifics (a jumbotron at least)
index.html: index.asciidoc $(COMMON_REQS) index-jumboinfo.html
	$(ASCIIDOC) $(ADOC_PARAMS_COMMON) -a jumbotron -a jumboinfo -o $@ $<

clean:
	rm -f $(HTML_GEN_FILES)
