# This makefile handles the document compilation for the review article
#
# The text for the article is specified in markdown, one file per article section.
# The source is revision controlled using git
# The text is compiled using pandoc, and targets in this makefile define the 
# dependencies of the generated outputs - so that an edit in a source text will 
# trigger the regeneration of the compiled output.

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
article_parts=00-preamble.md \
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
# Build outputs using pandoc with bibliographic processing
###############################################################################

#------------------------------------------------------------------------------
# HTML version
#------------------------------------------------------------------------------
build/article.html: pandoc-filters/scholarly-metadata.lua pandoc-filters/author-info-blocks.lua build/article.md references.bib
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
			build/article.md

html: build/article.html

#------------------------------------------------------------------------------
# DOCX version
#------------------------------------------------------------------------------
build/article.docx: pandoc-filters/scholarly-metadata.lua pandoc-filters/author-info-blocks.lua build/article.md references.bib
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
			build/article.md
docx: build/article.docx

#------------------------------------------------------------------------------
# PDF version
#------------------------------------------------------------------------------
build/article.pdf: pandoc-filters/scholarly-metadata.lua pandoc-filters/author-info-blocks.lua build/article.md references.bib
	mkdir -p build
	pandoc 	--lua-filter=pandoc-filters/scholarly-metadata.lua \
			--lua-filter=pandoc-filters/author-info-blocks.lua \
			--variable=date:"$(date_formatted)" \
			--pdf-engine=lualatex \
			--citeproc \
			--bibliography references.bib \
			-o $@ \
			--verbose \
			build/article.md

pdf: build/article.pdf

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

sterilise:
	rm -rf build
	rm -rf pandoc-filters
###############################################################################
# End of cleanup section
###############################################################################
