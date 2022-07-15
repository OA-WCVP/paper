# paper
Article draft for "Global access to botanical resources: assessing the digital availability of types and specimens and open access literature"

## Abstract

The study of vascular plants has benefitted from recent efforts in digitisation, with 83.4 million records mobilised through the GBIF network (as of 2022-01-31) and c. 2500 species newly described each year (statistics from ipni.org, 2022-01-31). Alongside the effort to mobilise these primary specimen-derived data, a complementary approach is expanding the use of literature as a data source, using text-mining approaches and the recent adoption of the "material citation" concept (a reference to a specimen in literature). As these data come onstream, work has started to improve the linkages between these data items, examples include the experimental work in the GBIF data portal to "cluster" related records: e.g. specimens gathered from a shared collecting event, specimens and their "material citation" references in literature, or specimens and observations arising from the same field research activities. Though a wealth of data is available digitally and eligible for linking, this still represents a fraction of the total available (Index Herbariorum 2021 report suggests 396 million herbarium specimens extant worldwide). The release of the WCVP taxonomy with distribution now offers a comprehensive index with which these digitally available data can be analysed. This study will use the WCVP taxonomy, its underpinning nomenclature and geographic distribution as a key integration tool to analyse the digital availability of the key resources needed to effectively research vascular plant taxonomy (types, specimens and literature, and ready availability of these data through open access publishing), and how access to these varies across different regions. The integration of these different datasets will identify gaps in the availability of data on vascular plant diversity at a national, regional and global level. Understanding this variation in access will help form effective policy recommendations to focus future activities.

## How to use this repository

### Project structure

This article repository is part of the OA-WCVP github organisation. Its sibling repositories ([gbif-literature](https://github.com/OA-WCVP/gbif-literature), [catalog-number-access](https://github.com/OA-WCVP/catalog-number-access) etc) are responsible for data access and analysis; this repository integrates their archived analytical runs into the paper output. 

### Article structure

A separate markdown file holds the text for each of the sections in the article:

- Summary
- Keywords
- Societal Impact Statement
- Introduction
- Materials and Methods
- Results
- Discussion
- Acknowledgements
- Author Contribution
- Data Availability Statement
- Conflict of Interest Statement 
- References

The document compilation process concatenates these together to form a single output.

### Document compilation

#### Automated compilation

A github action compiles the output document when a tag is applied to the repository. The PDF version of the article is made available as a build artifact.

#### Local document compilation

##### Pre-requisites

The article text is formatted in `Markdown` and is compiled to an output format (PDF, word etc) using `pandoc`. Execution of the compilation process is managed with the build tool `make`.
Ensure that `make`, `pandoc` and `lualatex` are installed and available from your `PATH`, ie that you can execute the following in a shell:
- `make -v`
- `pandoc -v`
- `lualatex -v`

##### How to run the compilation

The article can be compiled into several formats, ie pdf, docx and html.

- PDF format: `make build/article.pdf` or shorthand `make pdf`
- docx format: `make build/article.docx` or shorthand `make docx`
- HTML format: `make build/article.html` or shorthand `make html`
- All formats: `make all`

##### Cleaning up downloaded and processed files

- `make clean`
- `make sterilise`

## Useful links

- Plants, People, Planet author guidelines: https://nph.onlinelibrary.wiley.com/hub/journal/25722611/about/author-guidelines

## Contact information

[Nicky Nicolson](https://github.com/nickynicolson), RBG Kew (n.nicolson@kew.org)
