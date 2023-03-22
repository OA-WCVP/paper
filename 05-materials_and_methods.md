# Materials and methods

We downloaded name data from the International Plant Names Index (IPNI, [www.ipni.org](https://www.ipni.org)) using the pykew Application Programming Interface (API). We used a date range of 2012 - 2021 for the analysis, as the data entry guidelines [] were revised in 2012 to include the recording of a digital object identifer (DOI) for the bibliographic work if one were available. We attempted to backfill any missing DOIs using a dataset from the Catalogue of Life [@roderic_page_2022_7208700]. We passed each DOI to the unpaywall service using the *unpywall* library [@nick_haupka_2020_4085415]. Unpaywall is an open database of scholarly articles organised by DOI. It offers a flag to indicate if the content is available open access, a link to the content (if available) and a further categorisation to indicate what kind of open access model is used. A flowchart of the assignment process for open access takeup and open access status is given in figure @fig:fig1. We recorded and analysed results at two levels of granularity - the **takeup** of open access and what **kind** of open access is used (green, gold etc).

We attached the World Checklist of Vascular Plants (WCVP, [wcvp.science.kew.org/](https://wcvp.science.kew.org/)) dataset (comprising taxonomy and distribution) to the IPNI data extract to enable the analysis of open access **takeup** by the distribution of the taxon, which is recorded using the Biodiversity Information Standards Taxonomic Databases Working Group (TDWG) World Geographic Scheme for Recording Plant Distributions (WGSRPD) levels 1 (continent), 1 (region) and 3 (botanical country) [@brummitt_world_2001]. We also visualised open access **takeup** by publication for those titles including 80% of the names published between 2019 and 2021. 

To look at the open access availability of digitised type material, we used the Global Biodiversity Information Facility (GBIF, [www.gbif.org](https://www.gbif.org)) to download a dataset of all vascular plant occurrences based on preserved specimens with a type status [@occdownload_gbiforg_occurrence_2022]. We used the GBIF registry to determine the spatial coordinates of the data provider for each record. We integrated the GBIF backbone taxonomy [@registry-migrationgbiforg_gbif_2021] (used to organise the occurrence records) with WCVP to allow us to determine if the type specimen occurrence was mobilised to GBIF from within its native range. To make this assessment we executed a spatial join between the point location of the data provider, and the WGSRPD polygons comprising the native range of the taxon. 

```{.mermaid caption="Flowchart depicting category assignment for (i) takeup of open access and (ii) open access status" #fig:fig1}
%%{init: {"flowchart": {"useMaxWidth": false},'theme': 'neutral',"themeVariables": { "fontSize": "36px"} }}%%
flowchart LR
    subgraph  
        direction LR
        subgraph "Category assignment - open access take-up"
        direction LR  %% <-- here
                Start_a["Nomenclatural acts (all)"] -------> HasDOI_a
                HasDOI_a{"Has DOI?"}
                HasDOI_a -------> |Yes|IsOA_a{"Is OA?"}
                HasDOI_a -------> |No| Undiscoverable_a["<b>Undiscoverable</b><br/> May be hard copy only (e.g. a book) <br/>or online without article identifier"]
                IsOA_a ------->|No| Closed_a[<b>Closed</b><br/>Requires subscription or <br/>one-off per-article payment]
                IsOA_a ------->|Yes| Open_a[<b>Open</b><br/>A version is available <br/>for the reader to access]

                classDef clsUndiscoverable fill:black, color:white;
                    class Undiscoverable_a clsUndiscoverable;

                classDef clsClosed fill:#c5c5c5;
                    class Closed_a clsClosed;

                classDef clsOpen fill:#ffffff;
                    class Open_a clsOpen;
        end

        subgraph "Category assignment - what kinds of open access used"
        direction LR  %% <-- here
                WithDoi["Nomenclatural acts (with DOIs)"]-->IsOA{"&nbsp;<br/>Is article <br/>open access?<br/>&nbsp;"}
                IsOA -->|No| Closed[<b>Closed</b><br/>Requires subscription or <br/>one-off per-article payment]
                IsOA -->|Yes| WhereBest{Where is <br/>best copy of <br/>article located?}
                WhereBest-->|repository| Green[<b>Green</b> Author submits preprint <br/>or archives copy<br/> in institutional repository]
                WhereBest-->|publisher| FullyOA{Is the article <br/>published in a<br/> fully-OA journal?}
                FullyOA-->|yes| Gold[<b>Gold</b> Journal funded by <br/>article processing charges <br/>or sponsorship]
                FullyOA-->|no| Licence{Is the article <br/>published under an<br/> open license?}
                Licence-->|yes| Hybrid[<b>Hybrid</b> Author pays for OA<br/>users pay for subscription]
                Licence-->|no| Bronze[<b>Bronze</b> Author pays for OA<br/>users pay for subscription<br/>Reuse terms unclear.]
                
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

        end
    end
```
