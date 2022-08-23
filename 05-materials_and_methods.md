# Materials and methods

## Data sources

### World Checklist of Vascular Plants (WCVP)

The World Checklist of Vascular Plants is a globally comprehensive taxonomy for vascular plants indicating taxonomic acceptance and details of synonymy, along with native and introduced distributions for accepted species using level 3 (region) of the hierarchical Biodiversity Information Standards (TDWG) data standard World Geographical Scheme for Recording Plant Distributions (WGSRPD). It is editorially coordinated by Rafael Govaerts at Royal Botanic Gardens, Kew, with a global network of expert contributors and reviewers. The WCVP data (taxonomy and distribution) used in this study were made available as structured datafiles, through written agreement with RBG Kew.

### International Plant Names Index (IPNI)
 
The International Plant Names Index (IPNI) is an editorially-managed nomenclatural database containing the name and basic bibliographic details about the first publication of the names of vascular plants (Tracheophyta) as governed by the International Code of Nomenclature for algae, fungi and plants (ICNafp). The project started compiling data in the 1880s as *Index Kewensis*, with an editorial team based at the Royal Botanic Gardens, Kew, funded by a legacy from Charles Darwin. The base data recorded for a single nomenclatural event has expanded over the years at the following points:

- **1997** - Type citation data from the protologue added for taxonomic novelties at rank of species or below
- **2012** - Information about the electronic publishing of nomenclatural acts added - the Digital Object Identifier (DOI) of the containing article, a flag to indicate if the containing article was published electronically and a flag to indicate if the description or diagnosis was written in English (prior to 2012 Latin was the only permissible language for description or diagnosis).

IPNI data are available online at https://www.ipni.org and via a programmatic API (pykew), this study used programmatic access to the data using the pykew package.

### Global Biodiversity Information Facility (GBIF)

The Global Biodiversity Information Facility (GBIF) is an intergovernmental organisation created in response to OECD megascience forum. It has a secretariat based in Copenhagen, Denmark and runs a portal which provides access to data through a user-facing website (https://www.gbif.org) and an API (https://www.gbif.org/developer/summary). Many of the products of the digitisation efforts from the world's herbarium collections are mobilised through GBIF as *occurrences*, with basis of record set to *preserved_specimen*, often including a specimen image (TODO: add numbers of vascular plant specimens, and percentage which claim availability of media type = still image). Since ????, both routes to the data are able to create DOI-labelled data downloads, and usage of these is tracked when the DOI is cited in the references section of a published work. The bibliographic details of these citing articles are used to populate a literature resource (https://www.gbif.org/resource/search?contentType=literature). Metadata describing the membership of the GBIF network and the technical details of the publishing organisations, their locations and endorsement by national or regional networks is available in a registry, this metadata is also accessible both through a user-facing website and via a programmatic API.
The GBIF-mediated data used in this study was accessed using the GBIF API.

### Index Herbariorum
TODO populate

### Crossref

Crossref (https://www.crossref.org) is an official DOI registration agency run by the Publishers International Linking Association providing deposit and query services for DOIs. Members assign DOIs to their own content and where possible use DOIs to link out from the references sections of the materials that they publish.

### Unpaywall

Unpaywall is an "open database of 32.7 million free scholarly articles" (https://unpaywall.org/). 
Ref "The State of OA: A large-scale analysis of the prevalence and impact of Open Access articles"

## Data integration
WCVP was used to give a globally comprehensive taxonomy with distribution. as each scientific name in WCVP is accompanied by an identifier for the scientific name in IPNI, two classes of additional data are added: 

1. Type citation data (for the data published since 1997).
1. Digital object identifiers (DOIs) for the containing article (for data published since 2012). 

## Analyses

### Availability of specimens

#### General - "holder claims" type status

A general assessment of the availability of type specimen material was made using the WCVP taxonomy as a lookup to the type specimens mobilised as GBIF occurrence data.

1. The **GBIF backbone taxonomy** was downloaded, filtered for the content identified as Tracheophyta (vascular plants) and integrated with the WCVP taxonomy. Note that this integration process was fairly conservative as it did not include any kind of "fuzzy matching" of the scientific names.
1. **Occurrences** were downloaded from GBIF using a search for specimens identified as "Tracheophyta", with basis of record set to "preserved specimen" and specifying a non-null value in typeStatus. Those records with a typeStatus of "NOT_A_TYPE" were dropped and removed from subsequent processing.
1. The GBIF-WCVP integrated taxonomy (from step 1) was linked to the GBIF mediated occurrence dataset (from step 2) using the taxonKey property of the occurrence record as the link to the GBIF backbone taxonomy.
1. A report was made using the WCVP taxonomy to indicate how many WCVP taxa had type material mobilised through GBIF.
1. The publishing organisation responsibile for the mobilisation of each occurrence record was identified, and used to lookup publisher metadata in the GBIF registry, retrieving the latitude and longitude of the physical location of the publisher. A spatial join was made with the shape files representing the World Geographical Scheme for Recording Plant Distributions to determine the WGSRPD level 3 region in which the publisher was located.
1. Native distributions from WCVP were added to each taxon and an assessment was made to indicate if the publisher was located within the native distribution of the taxon
1. A report was made using the WCVP taxonomy to indicate how many WCVP taxa have type material mobilised through GBIF published by an organisation in the native range of the taxon.

#### Specific - "author cites" type material

Type citation data from IPNI was used to assess the digital availability of type specimens, using GBIF as a datasource. The date range for this study is 1997 - 2020

1. Tax nov nomenclatural acts were downloaded from IPNI using the pykew IPNI API. The ipniutil package was used to process type citation statements, extracting the type holder, type of type (holotype, isotype etc) and type_id (catalog number, if available).
1. As a single tax. nov. nomenclatural act can include multiple type specimens (from the same collecting event but lodged in different herbaria) this step explodes each type specimen to its own row.The data is then prepared for linking by: 
    1. Extracting a year from the IPNI field `collectionDate1`
    1. Using the Bionomia team name parsing to extract the first family name from the IPNI field `collectorTeam`
    1. Translating any text herbarium names to their Index Herbariorum codes
1. For each of the exploded types that have a catalog number available, a lookup is made using the GBIF API to assess if the catalog number can facilitate access to digitised specimen metadata.
1. Reports were made on (i) the population of catalog numbers in published protologues and (ii) their utility in facilitating access to digitised specimen metadata

#### Specimen availability comparators

On a regional level (using distributions from WCVP), these will be compared to the total number of specimens available using numbers derived from metadata records in Index Herbariorum (see specimen-distribution). 

### Availability of literature

- What proportion of IPNI monitored nomenclatural acts are published open access, and how is this changing over time?
- What OA statuses (green, gold, bronze, hybrid etc) are reported, and how are these changing over time?
- Do these trends vary with the WCVP distribution of the species?

DOIs from IPNI were used to assess the open access availability of literature, by looking up the DOI in the unpaywall dataset using the python package unpywall. Two pieces of data were records for each DOI lookup - if the literature was available open access, and if so, which open access status (green, gold etc) was used. WCVP was used to add distribution to see if avilability varies regionally. The date range for this study is 2012 - 2020.

#### Literature availability comparators

Open access takeup compared to that in (i) gbif-literature and (ii) in the articles published in the major journal Phytotaxa.
