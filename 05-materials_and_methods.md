# Materials and methods

We downloaded name data from the International Plant Names Index (IPNI, https://www.ipni.org) using the pykew API. We used a date range of 2012 - 2021 for the analysis, as the data entry guidelines [] were revised in 2012 to include the recording of a digital object identifer (DOI) for the bibliographic work if one were available. We attempted to backfill any missing DOIs using a dataset from the Catalogue of Life []. We passed each DOI to the unpaywall service using the *unpywall* library. Unpaywall is an open database of scholarly articles organised by DOI. It offers a flag to indicate if the content is available open access, a link to the content (if available) and a further categorisation to indicate what kind of open access model is used. We recorded and analysed results at two levels of granularity - the **takeup** of open access and what **kind** of open access is used (green, gold etc).
We attached the World Checklist of Vascular Plants (WCVP, https://wcvp.science.kew.org/) dataset (comprising taxonomy and distribution) to the IPNI data extract to enable the analysis of open access **takeup** by the distribution of the taxon, which is recorded using the TDWG World Geographic Scheme for Recording Plant Distributions (WGSRPD) level 1-3. We also examined open access **takeup** by publication for those publications covering 80% of the original dataset. 
To look at the open access availability of digitised type material, we used the Global Biodiversity Information Facility (GBIF, https://www.gbif.org) to download a dataset of all vascular plant occurrences based on preserved specimens with a type status. We used the GBIF registry to determine the spatial coordinates of the data provider for each record. We integrated the GBIF backbone taxonomy (used to organise the occurrence records) with WCVP to allow us to determine if the type specimen occurrence was mobilised to GBIF from within its native range. To make this assessment we executed a spatial join between the point location of the data provider, and the WGSRPD polgyons comprising the native range of the taxon. We conducted this analysis for the whole dataset, and for two time periods - post the Convention on Biological Diversity (1992-2021) and post Nagoya protocol (2014-2021). For the two temporally defined analyses, we only examined taxa which were first published in that date range.

```{.mermaid caption="Category assignment - all records"}
graph TD
    Start[fa:fa-user Look at nomenclatural acts] --> HasDOI
    HasDOI{"Has DOI?"}
    HasDOI --> |Yes|IsOA{"Is OA?"}
    HasDOI --> |No| Undiscoverable["fa:fa-stop <b>Undiscoverable</b><br/> May be hard copy only (e.g. a book) <br/>or online without article identifier"]
    IsOA -->|No| Closed[fa:fa-lock <b>Closed</b><br/>Requires subscription or <br/>one-off per-article payment]
    IsOA -->|Yes| Open[fa:fa-unlock <b>Open</b><br/>A version is available <br/>for the reader to access]

classDef Undiscoverable fill:white;
    class Undiscoverable Undiscoverable;

classDef Closed fill:#c5c5c5;
    class Closed Closed;

classDef Open fill:#79be78;
    class Open Open;

```

```{.mermaid caption="Category assignment - records with DOIs"}
graph TD
    WithDoi[Articles with DOIs]-->IsOA{"Is open <br/>access?"}
    IsOA -->|No| Closed[fa:fa-lock <b>Closed</b><br/>Requires subscription or <br/>one-off per-article payment]
    IsOA -->|Yes| WhereBest{Where is <br/>best copy of <br/>article located?}
    WhereBest-->|repository| Green[fa:fa-archive <b>Green</b> Author submits preprint <br/>or archives copy<br/> in institutional repository]
    WhereBest-->|publisher| FullyOA{Is the article <br/>published in a<br/> fully-OA journal?}
    FullyOA-->|yes| Gold[fa:fa-dollar <b>Gold</b> Journal funded by <br/>article processing charges <br/>or sponsorship]
    FullyOA-->|no| Licence{Is the article <br/>published under an<br/> open license?}
    Licence-->|yes| Hybrid[fa:fa-dollar <b>Hybrid</b> Author pays for OA<br/>users pay for subscription]
    Licence-->|no| Bronze[fa:fa-question <b>Bronze</b> Author pays for OA<br/>users pay for subscription<br/>Reuse terms unclear.]
    
    classDef Gold fill:#fde769;
    class Gold Gold;

  classDef Green fill:#79be78;
    class Green Green;

  classDef Bronze fill:#d29766;
    class Bronze Bronze;
    
    classDef Hybrid fill:#feb352;
    class Hybrid Hybrid;

classDef Diamond fill:#e5e4e2;
    class Diamond Diamond;

classDef Undiscoverable fill:white;
    class Undiscoverable Undiscoverable;

classDef Closed fill:#c5c5c5;
    class Closed Closed;

classDef Open fill:#79be78;
    class Open Open;
```
