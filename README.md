# paper
Article draft for "Global access to botanical resources: assessing the digital availability of types and specimens and open access literature"

This article repository is part of the OA-WCVP github organisation. Its sibling repositories ([gbif-literature](https://github.com/OA-WCVP/gbif-literature), [catalog-number-access](https://github.com/OA-WCVP/catalog-number-access) etc) are responsible for data access and analysis; this repository integrates their archived analytical runs into the paper output. 

## Article structure

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

The document compilation process (described below) concatenates these together to form a single output.

## How to use this repository

### Editorial changes

Edits to the markdown source for the article can be made in github, or by cloning the repository and editing locally (allows for offline working).

### Adding an author

Authors (and their affiliations) are defined in YAML in the preamble document fragment.

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
