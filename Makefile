# This makefile handles the document compilation for the review article
#
# The text for the article is specified in markdown, one file per article section.
# The source is revision controlled using git
# The text is compiled using pandoc, and targets in this makefile define the 
# dependencies of the generated outputs - so that an edit in a source text will 
# trigger the regeneration of the compiled output.

python_launch_cmd=python
python_launch_cmd=winpty python

###############################################################################
# Gather results of archived analytical runs
###############################################################################
# These targets must authenticate to github nd therefore need an access_token 
# which must be stored in an environment variable named "GITHUB_TOKEN"

archived_analyses: downloads/ipni-oa-data.zip downloads/ipni-oa-map-charts-data.zip 

downloads/%-data.zip: util/download-artifact.py
	mkdir -p downloads
	$(python_launch_cmd) util/download-artifact.py $*

data/ipni-oa%.png: downloads/ipni-oa-data.zip
	mkdir -p data
	unzip -o $^ $@

data/findability-wcvp%.png: downloads/ipni-oa-map-charts-data.zip 
	mkdir -p data
	unzip -o $^ $@

data/oaratio-wcvp%.png: downloads/ipni-oa-map-charts-data.zip 
	mkdir -p data
	unzip -o $^ $@

data/wcvp-map-composite%.png: downloads/ipni-oa-map-charts-data.zip 
	mkdir -p data
	unzip -o $^ $@


data/taxa2gbif%.md: downloads/wcvp-gbif-processing-data.zip 
	mkdir -p data
	unzip -o $^ $@

data/taxa2nativerange%.md: downloads/wcvp-gbif-processing-data.zip 
	mkdir -p data
	unzip -o $^ $@

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

data/type-availability-header-all.md:
	mkdir -p data
	echo "### All" > $@
	echo "" >> $@

data/type-availability-header-cbd.md:
	mkdir -p data
	echo "### Convention on biological diversity (post 1992)" > $@
	echo "" >> $@

data/type-availability-header-nagoya.md:
	mkdir -p data
	echo "### Nagoya (post 2014)" > $@
	echo "" >> $@

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
			02-keywords.md \
			03-societal_impact_statement.md \
			04-introduction.md \
			05-materials_and_methods.md \
			06-results.md \
			data/type-availability-header-all.md \
			data/section-separator.md \
			data/taxa2gbiftypeavailability.md \
			data/section-separator.md \
			data/taxa2nativerangetypeavailability.md \
			data/section-separator.md \
			data/type-availability-header-cbd.md \
			data/section-separator.md \
			data/taxa2gbiftypeavailability-cbd.md \
			data/section-separator.md \
			data/taxa2nativerangetypeavailability-cbd.md \
			data/section-separator.md \
			data/type-availability-header-nagoya.md \
			data/section-separator.md \
			data/taxa2gbiftypeavailability-nagoya.md \
			data/section-separator.md \
			data/taxa2nativerangetypeavailability-nagoya.md \
			data/section-separator.md \
			07-discussion.md \
			data/section-separator.md \
			08-acknowledgements.md \
			09-author_contribution.md \
			10-data_availability_statement.md \
			11-conflict_of_interest_statement.md \
			11a-appendix.md \
			12-references.md 

build/article.md: $(article_parts)
	mkdir -p build
	cat $(article_parts) > $@
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
ipni_publ_charts:=build/ipni-oatrend-publ.png
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
build/article.html: pandoc-filters/scholarly-metadata.lua pandoc-filters/author-info-blocks.lua build/article.md $(charts) references.bib
	mkdir -p build
	pandoc 	\
			--lua-filter=pandoc-filters/scholarly-metadata.lua \
			--lua-filter=pandoc-filters/author-info-blocks.lua \
			-F mermaid-filter \
			--variable=date:"$(date_formatted)" \
			--citeproc \
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
build/article.docx: pandoc-filters/scholarly-metadata.lua pandoc-filters/author-info-blocks.lua downloads/reference.docx build/article.md $(charts) references.bib
	mkdir -p build
	pandoc 	\
			--lua-filter=pandoc-filters/scholarly-metadata.lua \
			--lua-filter=pandoc-filters/author-info-blocks.lua \
			-F mermaid-filter \
			--variable=date:"$(date_formatted)" \
			--citeproc \
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
build/article.pdf: pandoc-filters/scholarly-metadata.lua pandoc-filters/author-info-blocks.lua build/article.md $(charts) references.bib
	mkdir -p build
	pandoc 	--lua-filter=pandoc-filters/scholarly-metadata.lua \
			--lua-filter=pandoc-filters/author-info-blocks.lua \
			-F mermaid-filter \
			--variable=date:"$(date_formatted)" \
			--pdf-engine=lualatex \
			--citeproc \
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
