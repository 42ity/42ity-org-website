
ASCIIDOC = asciidoc

HTML_SOURCES = 	\
	index.asciidoc	\
	source.asciidoc \
	binaries.asciidoc \
	hcl.asciidoc	\
	presentation.asciidoc	\
	contributing.asciidoc	\
	about.asciidoc \
	contact.asciidoc

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
	js/jquery.min.js
# TODO: do we actually need the following?
#	js/html5shiv.min.js	\
#	js/respond.min.js
#	js/ie8-responsive-file-warning.js
#	js/ie-emulation-modes-warning.js
#	js/npm.js

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
	-f bootstrap.conf

all: $(HTML_FILES) $(IMAGE_FILES) $(STYLESHEET_FILES) $(SCRIPT_FILES)

%.html : %.asciidoc $(COMMON_REQS)
	$(ASCIIDOC) $(ADOC_PARAMS_COMMON) -o $@ $<

# index.html has some specifics (a jumbotron at least)
index.html: index.asciidoc $(COMMON_REQS) index-jumboinfo.html
	$(ASCIIDOC) $(ADOC_PARAMS_COMMON) -a jumbotron -a jumboinfo -o $@ $<

# These page have table of content
#presentation.html: presentation.asciidoc $(COMMON_REQS)
#	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ -a toc $<
#
#contributing.html: contributing.asciidoc $(COMMON_REQS)
#	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ -a toc $<

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

clean:
	rm -f $(HTML_GEN_FILES)
