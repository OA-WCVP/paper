# This makefile handles the document compilation for the review article
#
# The text for the article is specified in markdown, one file per article section.
# The source is revision controlled using git
# The text is compiled using pandoc, and targets in this makefile define the 
# dependencies of the generated outputs - so that an edit in a source text will 
# trigger the regeneration of the compiled output.

###############################################################################
# Define URLs and download for archived analytical runs
###############################################################################
# Note - this is actually stored as part of a github release: 
# https://github.com/OA-WCVP/catalog-number-access/releases/download/v0.1/data-20220701-122423.zip
# Because the repo is currently private, its is not possible to automate its 
# download (it could possibly be done with a python github client, which could 
# authenticate to ensure access. The file has temporarily been copied to dropbox: 
archived_analysis_url_catalog_numbers=https://www.dropbox.com/s/yqmz9qb60k25bwg/catalog-number-access-data-20220823-195702.zip?dl=0
archived_analysis_url_ipni_oa=https://www.dropbox.com/s/i06omvj0i8jn1l1/ipni-oa-data-20220823-195714.zip?dl=0

catalog_numbers_chart_catalognumbertrend=data/catalognumbertrend.png
catalog_numbers_chart_linktrend=data/linktrend.png

downloads/catalog_numbers-analysis.zip:
	mkdir -p downloads
	wget -O $@ $(archived_analysis_url_catalog_numbers)

data/catalognumbertrend.png: downloads/catalog_numbers-analysis.zip
	mkdir -p data
	unzip -o $^ $@

data/linktrend.png: downloads/catalog_numbers-analysis.zip
	mkdir -p data
	unzip -o $^ $@

downloads/ipni-oa-analysis.zip:
	mkdir -p downloads
	wget -O $@ $(archived_analysis_url_ipni_oa)

data/oa%.png: downloads/ipni-oa-analysis.zip
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
			07-discussion.md \
			08-acknowledgements.md \
			09-author_contribution.md \
			10-data_availability_statement.md \
			11-conflict_of_interest_statement.md \
			12-references.md 

build/article.md: $(article_parts)
	mkdir -p build
	cat $^ > $@
###############################################################################
# End of concatenation section
###############################################################################

###############################################################################
# Copy charts to build directory
###############################################################################
build/%.png: data/%.png
	mkdir -p build
	cp $^ $@

charts=build/catalognumbertrend.png build/oatrend.png build/oastatustrend.png build/oatrend-dist-1.png build/oatrend-dist-1-taxnov.png build/oatrend-dist-2.png build/oatrend-dist-2-taxnov.png

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
