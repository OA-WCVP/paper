# This makefile handles the document compilation for the review article
#
# The text for the article is specified in markdown, one file per article section.
# The source is revision controlled using git
# The text is compiled using pandoc, and targets in this makefile define the 
# dependencies of the generated outputs - so that an edit in a source text will 
# trigger the regeneration of the compiled output.

python_launch_cmd=python
# python_launch_cmd=winpty python

###############################################################################
# Gather results of archived analytical runs
###############################################################################
# These targets must authenticate to github nd therefore need an access_token 
# which must be stored in an environment variable named "GITHUB_TOKEN"

archived_analyses: downloads/ipni-oa-data.zip downloads/ipni-oa-map-charts-data.zip 

downloads/%-data.zip: util/download-artifact.py
	mkdir -p downloads
	$(python_launch_cmd) util/download-artifact.py $*

downloads/ppp.csl:
	mkdir -p downloads
	wget --quiet -O $@ https://raw.githubusercontent.com/citation-style-language/styles/master/new-phytologist.csl

data/ipni-oa%.png: downloads/ipni-oa-data.zip
	mkdir -p data
	unzip -o $^ $@

data/si-%.md: downloads/ipni-oa-data.zip
	mkdir -p data
	unzip -o $^ $@

data/%.yaml: downloads/ipni-oa-data.zip
	mkdir -p data
	unzip -o $^ $@
	$(python_launch_cmd) util/format-numeric-variables.py $@ $@	

data/findability-wcvp%.png: downloads/ipni-oa-map-charts-data.zip 
	mkdir -p data
	unzip -o $^ $@

data/oaratio-wcvp%.png: downloads/ipni-oa-map-charts-data.zip 
	mkdir -p data
	unzip -o $^ $@

data/wcvp-map-composite%.png: downloads/ipni-oa-map-charts-data.zip 
	mkdir -p data
	unzip -o $^ $@

data/taxa2gbif%.yaml: downloads/wcvp-gbif-processing-data.zip 
	mkdir -p data
	unzip -o $^ $@
	$(python_launch_cmd) util/format-numeric-variables.py $@ $@	

data/taxa2nativerange%.yaml: downloads/wcvp-gbif-processing-data.zip 
	mkdir -p data
	unzip -o $^ $@
	$(python_launch_cmd) util/format-numeric-variables.py $@ $@	

###############################################################################
# End of archived analytical runs section
###############################################################################

###############################################################################
# Download pandoc reference docx
###############################################################################
downloads/reference.docx:
	mkdir -p downloads
	pandoc -o $@ --print-default-data-file reference.docx

###############################################################################
# Define URLs and download for pandoc filters
###############################################################################
filter_url_scholarly_metadata=https://raw.githubusercontent.com/pandoc/lua-filters/master/scholarly-metadata/scholarly-metadata.lua
filter_url_author_info_blocks=https://raw.githubusercontent.com/pandoc/lua-filters/master/author-info-blocks/author-info-blocks.lua

pandoc-filters/scholarly-metadata.lua:
	mkdir -p pandoc-filters
	wget --quiet -O $@ $(filter_url_scholarly_metadata)

pandoc-filters/author-info-blocks.lua:
	mkdir -p pandoc-filters
	wget --quiet -O $@ $(filter_url_author_info_blocks)

###############################################################################
# End of pandoc filter section
###############################################################################

data/section-separator.md:
	mkdir -p data
	echo " " > $@
	echo "" >> $@

###############################################################################
# Concatenate all source markdown files to a single output
###############################################################################
# Define variable holding all parts of the article, listed in order
article_parts=00-preamble.yaml \
			01-summary.md \
			data/section-separator.md \
			02-keywords.md \
			data/section-separator.md \
			03-societal_impact_statement.md \
			data/section-separator.md \
			04-introduction.md \
			data/section-separator.md \
			05-materials_and_methods.md \
			data/section-separator.md \
			06-results.md \
			data/section-separator.md \
			07-discussion.md \
			data/section-separator.md \
			08-acknowledgements.md \
			data/section-separator.md \
			09-author_contribution.md \
			data/section-separator.md \
			10-data_availability_statement.md \
			data/section-separator.md \
			11-conflict_of_interest_statement.md \
			data/section-separator.md \
			12-references.md 

build/article.md: $(article_parts) data/article-variables.yaml data/taxa2gbiftypeavailability.yaml data/taxa2nativerangetypeavailability.yaml
	mkdir -p build
	cat $(article_parts) > build/article-temp.md
	pandoc --template build/article-temp.md --metadata-file data/article-variables.yaml --metadata-file data/taxa2gbiftypeavailability.yaml --metadata-file data/taxa2nativerangetypeavailability.yaml build/article-temp.md > $@
	rm build/article-temp.md
	
###############################################################################
# End of concatenation section
###############################################################################

###############################################################################
# Copy charts to build directory
###############################################################################
build/%.png: data/%.png
	mkdir -p build
	cp $^ $@

build/%.md: data/%.md
	mkdir -p build
	cp $^ $@

ipni_oatrends_charts:=build/ipni-oa-composite.png
ipni_publ_charts:=build/ipni-oatrend-publ-2019-2021.png
ipni_wcvp_map_charts_composite:=build/wcvp-map-composite-level-1.png build/wcvp-map-composite-level-2.png build/wcvp-map-composite-level-3.png 

charts=$(ipni_oatrends_charts) $(ipni_publ_charts) $(ipni_wcvp_map_charts_composite)

allcharts: $(charts)

###############################################################################
# End of chart copy section
###############################################################################

###############################################################################
# Build outputs using pandoc with bibliographic processing
###############################################################################

#------------------------------------------------------------------------------
# HTML version
#------------------------------------------------------------------------------
build/article.html: downloads/ppp.csl pandoc-filters/scholarly-metadata.lua pandoc-filters/author-info-blocks.lua build/article.md $(charts) references.bib
	mkdir -p build
	pandoc 	\
			--lua-filter=pandoc-filters/scholarly-metadata.lua \
			--lua-filter=pandoc-filters/author-info-blocks.lua \
			-F mermaid-filter \
			--filter pandoc-xnos \
			--variable=date:"$(date_formatted)" \
			--citeproc \
			--csl downloads/ppp.csl \
			--bibliography references.bib \
			-o $@ \
			--verbose \
			-s \
			--resource-path=build \
			build/article.md

html: build/article.html

#------------------------------------------------------------------------------
# DOCX version
#------------------------------------------------------------------------------
build/article.docx: downloads/ppp.csl pandoc-filters/scholarly-metadata.lua pandoc-filters/author-info-blocks.lua downloads/reference.docx build/article.md $(charts) references.bib
	mkdir -p build
	pandoc 	\
			--lua-filter=pandoc-filters/scholarly-metadata.lua \
			--lua-filter=pandoc-filters/author-info-blocks.lua \
			-F mermaid-filter \
			--filter pandoc-xnos \
			--variable=date:"$(date_formatted)" \
			--citeproc \
			--csl downloads/ppp.csl \
			--bibliography references.bib \
			-o $@ \
			--verbose \
			-s \
			--resource-path=build \
			--reference-doc=downloads/reference.docx \
			build/article.md
docx: build/article.docx

#------------------------------------------------------------------------------
# PDF version
#------------------------------------------------------------------------------
build/article.pdf: downloads/ppp.csl pandoc-filters/scholarly-metadata.lua pandoc-filters/author-info-blocks.lua build/article.md $(charts) references.bib
	mkdir -p build
	pandoc 	--lua-filter=pandoc-filters/scholarly-metadata.lua \
			--lua-filter=pandoc-filters/author-info-blocks.lua \
			-F mermaid-filter \
			--filter pandoc-xnos \
			--variable=date:"$(date_formatted)" \
			--pdf-engine=lualatex \
			--citeproc \
			--csl downloads/ppp.csl \
			--bibliography references.bib \
			-o $@ \
			--verbose \
			--resource-path=build \
			build/article.md

pdf: build/article.pdf

#------------------------------------------------------------------------------
# All versions
#------------------------------------------------------------------------------
all: build/article.html build/article.docx build/article.pdf

###############################################################################
# End of build outputs section
###############################################################################

###############################################################################
# Archive section - zip and timestamp a compilation
###############################################################################
# Formatted date, for use when tagging archived compilations
date_formatted=$(shell date +"%d %B %Y")

# TODO

###############################################################################
# End of archive section
###############################################################################


###############################################################################
# Targets to handle cleanup of compiled / dpwnloaded files
###############################################################################
clean:
	rm -rf build
	rm -rf data

sterilise:
	rm -rf build
	rm -rf data
	rm -rf downloads
	rm -rf pandoc-filters
###############################################################################
# End of cleanup section
###############################################################################
