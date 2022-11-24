# Materials and methods

All data access, analysis, result visualisation and document compilation outlined here was automated using a toolkit based on *Python* scripts using *pandas* and *geopandas* for data management and *matplotlib* for charting. Execution and dependencies were managed by the build tool *make*, which generated an archivable output which was attached to each analytical repository. *Github actions* were used to download analysis results and to compile the article document using *pandoc* and *latex*. 

## Data sources

**World Checklist of Vascular Plants** (WCVP, https://wcvp.science.kew.org/) is a globally comprehensive taxonomy for vascular plants indicating taxonomic acceptance and details of synonymy, along with native and introduced distributions for accepted species using level 3 (region) of the hierarchical Biodiversity Information Standards (TDWG) data standard World Geographical Scheme for Recording Plant Distributions (WGSRPD). It is editorially coordinated by the Royal Botanic Gardens, Kew, with a global network of expert contributors and reviewers. 

**International Plant Names Index** (IPNI, https://www.ipni.org) is an editorially-managed nomenclatural database containing the name and basic bibliographic details about the first publication of the names of vascular plants (Tracheophyta) as governed by the International Code of Nomenclature for algae, fungi and plants (ICNafp). The project started compiling data in the 1880s as *Index Kewensis*, with an editorial team based at the Royal Botanic Gardens, Kew, funded by a legacy from Charles Darwin. The base data recorded for a single nomenclatural event has expanded a number of times over the years, and two key points are relevant to this analysis: in 1997 type citation data from the protologue was added for taxonomic novelties at rank of species or below; in 2012 information about the electronic publishing of nomenclatural acts added: the Digital Object Identifier (DOI) of the containing article, a flag to indicate if the containing article was published electronically and a flag to indicate if the description or diagnosis was written in English. (Prior to 2012 Latin was the only permissible language for description or diagnosis). IPNI data are available online via a user facing website and also via a programmatic API (*pykew*).

**Global Biodiversity Information Facility** (GBIF, https://www.gbif.org) is an intergovernmental organisation created in response to OECD megascience forum [@noauthor_final_1999]. It has a secretariat based in Copenhagen, Denmark and runs a portal which provides access to data through a user-facing website and an API (https://www.gbif.org/developer/summary). Many of the products of the digitisation efforts from the world's herbarium collections are mobilised through GBIF as *occurrences*, with basis of record set to *preserved_specimen*, often including a specimen image (TODO: add numbers of vascular plant specimens, and percentage which claim availability of media type = still image). GBIF produce a synthetic "backbone taxonomy" which is used to organise aggregated content. This backbone taxonomy is also available as a downloadable resource. Since 2016, GBIF have labelled downloads with Digital Object Identifiers (DOIs). Usage of these is tracked when the DOI is cited in the references section of a published work. This technical and literature monitoring work has been accompanied by a [#CiteTheDOI campaign](https://twitter.com/GBIF/status/1427590252219322394) on social media, to raise awareness of the practice amongst authors, editors and reviewers. The bibliographic details of these citing articles are used to populate a literature resource (https://www.gbif.org/resource/search?contentType=literature). Metadata describing the membership of the GBIF network and the technical details of the publishing organisations, their locations and endorsement by national or regional networks is available in a registry, this metadata is also accessible both through a user-facing website and via a programmatic API. 

**Index Herbariorum** (IH, http://sweetgum.nybg.org/science/ih/) TODO populate

**Crossref** (https://www.crossref.org) is an official DOI registration agency run by the Publishers International Linking Association providing deposit and query services for DOIs. Members assign DOIs to their own content and where possible use DOIs to link out from the references sections of the materials that they publish.

**Directory of Open Access Journals (DOAJ)**


**Unpaywall** (https://unpaywall.org/) is an open database of scholarly articles organised by DOI. It offers a flag to indicate if the content is available open access, a link to the content (if available) and a further categorisation to indicate what kind of open access model is used. 

## Data processing

### Category assignment

```{.mermaid caption="Category assignment"}
graph TD
    Start[fa:fa-user Look at nomenclatural acts] --> HasDOI
    HasDOI{"Has DOI?"}
    HasDOI --> |Yes|IsOA{"Is OA?"}
    HasDOI --> |No|fa fa-stop-circle-o NoDOI[<b>Undiscoverable</b>]
    IsOA -->|No|fa:fa-lock Closed["<b>Closed</b><br/>Requires subscription or <br/>one-off per-article payment"]
    IsOA -->|Yes|fa:fa-unlock Open{<b>Open</b><br/>What kind of OA?}
    Open -->|Gold|fa:fa-money Gold["<b>Author pays</b> article<br/> processing charge,<br/> free to read, all <br/>articles in journal are OA"]
    Open -->|Green|fa:fa-archive Green["<b>Author archives</b><br/> copy in <br/>institutional <br/>repository"]
    Open -->|Bronze|fa fa-question-circle-o Bronze["Available on <br/>publisher's site, <br/>not formally <br/>licensed for reuse."]
    Open -->|Hybrid|fa:fa-money Hybrid["<b>Author pays</b> article<br/> processing charge to make <br/>article open, journal includes <br/>a mix of OA and closed <br/>articles & charges subscription fees"]
    Open -->|Diamond|fa:fa-diamond Diamond["Free to <br/>publish & read"]
    
    classDef Gold fill:#fde769;
    class Gold Gold;

  classDef Green fill:#79be78;
    class Green Green;

  classDef Bronze fill:#d29766;
    class Bronze Bronze;
    
    classDef Hybrid fill:#feb352;
    class Hybrid Hybrid;


```

## Analyses 

We conducted the following analyses using the datasets as decribed above. 

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

DOIs from IPNI were used to assess the open access availability of literature, by looking up the DOI in the unpaywall dataset using the python package unpywall. Two pieces of data were recorded for each DOI lookup - if the literature was available open access, and if so, which open access status (green, gold etc) was used. WCVP was used to add distribution to see if availability varies regionally. The date range for this study is 2012 - 2020.

#### Literature availability comparators

Open access takeup compared to that in (i) gbif-literature and (ii) in the articles published in the major journal Phytotaxa.

