
ASCIIDOC = asciidoc

HTML_SOURCES = 	\
	index.asciidoc	\
	source.asciidoc \
	binaries.asciidoc \
	hcl.asciidoc	\
	presentation.asciidoc	\
	contributing.asciidoc	\
	about.asciidoc \
	contact.asciidoc \
	c4.asciidoc \
	class.asciidoc

HTML_GEN_FILES = $(HTML_SOURCES:.asciidoc=.html)

HTML_FILES = $(HTML_GEN_FILES) \
	index-jumboinfo.html \
	navinfo.html

IMAGE_FILES =	\
	favicon.ico	\
	images/42ITy-SW-arch.png	\
	images/Eaton-IPC.png

STYLESHEET_FILES =	\
	css/42ity.css	\
	css/asciidoc-bootstrap.min.css

SCRIPT_FILES =	\
	js/42ity.js	\
	js/bootstrap.min.js	\
	js/jquery.min.js \
	js/asciidoc.js
# TODO: do we actually need the following?
#	js/html5shiv.min.js	\
#	js/respond.min.js
#	js/ie8-responsive-file-warning.js
#	js/ie-emulation-modes-warning.js
#	js/npm.js

REST_DOC_SOURCE = doc/rest/42ity_rest_api.raml
REST_DOC_HTML = doc/rest/42ity_rest_api.html
#REST_DOC_PDF = doc/rest/42ity_rest_api.pdf
REST_DOCS = $(REST_DOC_HTML)

# Common files that triggers a rebuild of the pages
COMMON_REQS = bootstrap.conf navinfo.html

# Submodule where to install files
OUTDIR = 42ity.github.io

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
	--attribute icons \
	--attribute iconsdir=images/icons/ \
	-f bootstrap.conf

all: $(HTML_FILES) $(IMAGE_FILES) $(STYLESHEET_FILES) $(SCRIPT_FILES)

%.html : %.asciidoc $(COMMON_REQS)
	$(ASCIIDOC) $(ADOC_PARAMS_COMMON) -o $@ $<

# index.html has some specifics (a jumbotron at least)
index.html: index.asciidoc $(COMMON_REQS) index-jumboinfo.html
	$(ASCIIDOC) $(ADOC_PARAMS_COMMON) -a jumbotron -a jumboinfo -o $@ $<

# These page have table of content, as a right panel
presentation.html: presentation.asciidoc $(COMMON_REQS)
	$(ASCIIDOC) $(ADOC_PARAMS_COMMON) -o $@ -a toc2 -a toc-placement=right -a toclevels=3 $<

class.html: class.asciidoc $(COMMON_REQS)
	$(ASCIIDOC) $(ADOC_PARAMS_COMMON) -o $@ -a toc2 -a toc-placement=right -a toclevels=3 $<

# RAML (REST API) generation
$(REST_DOC_HTML): $(REST_DOC_SOURCE)
	raml2html $< > $@

# Install files to the submodule that points to https://github.com/42ity/42ity.github.io.git
install:
	# submodule init/update/sync...
	@echo "Initializing the submodules..."
	git submodule init
	@echo "Updating the submodules..."
	git submodule update
	@echo "Copying websites files..."
	cp -f $(HTML_FILES) $(OUTDIR)/
	$(foreach image,$(IMAGE_FILES),cp -f $(image) $(OUTDIR)/$(image);)
	$(foreach css,$(STYLESHEET_FILES),cp -f $(css) $(OUTDIR)/$(css);)
	$(foreach js,$(SCRIPT_FILES),cp -f $(js) $(OUTDIR)/$(js);)
	$(foreach file,$(REST_DOCS),cp -f $(file) $(OUTDIR)/$(REST_DOCS);)

clean:
	rm -f $(HTML_GEN_FILES)
