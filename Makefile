filter_url_scholarly_metadata=https://raw.githubusercontent.com/pandoc/lua-filters/master/scholarly-metadata/scholarly-metadata.lua
filter_url_author_info_blocks=https://raw.githubusercontent.com/pandoc/lua-filters/master/author-info-blocks/author-info-blocks.lua

article_parts=00-preamble.md 01-summary.md 02-keywords.md 03-societal_impact_statement.md 04-introduction.md 05-materials_and_methods.md 06-results.md 07-discussion.md 08-acknowledgements.md 09-author_contribution.md 10-data_availability_statement.md 11-conflict_of_interest_statement.md 12-references.md

date_formatted=$(shell date +"%d %B %Y")

pandoc-filters/scholarly-metadata.lua:
	mkdir -p pandoc-filters
	wget --quiet -O $@ $(filter_url_scholarly_metadata)

pandoc-filters/author-info-blocks.lua:
	mkdir -p pandoc-filters
	wget --quiet -O $@ $(filter_url_author_info_blocks)

build/article.md: $(article_parts)
	mkdir -p build
	cat $^ > $@

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
docx: build/article.docx
html: build/article.html

clean:
	rm -rf build

sterilise:
	rm -rf build
	rm -rf pandoc-filters
