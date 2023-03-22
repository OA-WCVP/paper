# Results

Our dataset extracted from IPNI comprised $nomenclatural_act_count$ nomenclatural act records published in $publications_total$ different publications between $year_min$ and $year_max$. $dois_from_ipni$ of these had DOIs recorded in IPNI, $dois_from_col$ were backfilled with DOIs recorded in the Catalogue of Life. We found that each year, the IPNI dataset include acts published in an average of $publications_annual_mean$ different publications (n=$number_of_years$). $nomenclatural_act_proportion_in_serial$% of names are published in serials. The spike in numbers of nomenclatural acts published for 2018 was caused by the large volume of combinations ($nomenclatural_act_glovap_count$) published in GLOVAP [@christenhusz_global_2018]. 
On average each year, less than one quarter ($oa_annual_pc_avg$%) of nomenclatural acts are published open access. We did not observe a trend towards open access throughout the time period analysed (figure  @fig:fig2 (a)). When looking at the kinds of open access used (figure  @fig:fig2 (b)), we find that *gold* dominates. Here we do find a small difference through time, with *green* (self-archiving) showing a slightly greater representation in the earlier years in the study.
When analysing the IPNI data, we find that many journals active in the publication of nomenclatural acts are undiscoverable - the containing bibliographic work is not labelled with a DOI. (figure  @fig:fig3 - or the acts are labelled with a DOI which is now unresolvable ($dois_unresolvable$ in total, in $publications_w_unresolvable_dois$ different publications).

![Open access takeup and status](ipni-oa-composite.png){#fig:fig2}

![Bibliographic works containing nomenclatural events published between 2019 and 2021 and their use of open access, coverage of top 80% of dataset](ipni-oatrend-publ-2019-2021.png){#fig:fig3 height=90% }

## Open access takeup by distribution

Africa, South America and South Asia, some of the botanically most diverse areas, have the greatest proportion of undiscoverable nomenclatural acts (figure  @fig:fig4 (i)), whereas Europe, North America and Australia have the lowest proportion.  When considering only the discoverable literature using DOIs (figure  @fig:fig4 (ii)), South America and South Asia have the lowest proportion of open publication of nomenclatural acts, though Africa  has a higher proportion.

![Findability and OA ratio, TDWG level 2](wcvp-map-composite-level-2.png){#fig:fig4}

## Availability of digitised type material

When considering the availability of open access digitised type specimens $taxa2gbiftypeavailability.taxa_with_types_available_pc$% taxa have type material available $taxa2gbiftypeavailability.taxa_with_types_available_count$ of $taxa2gbiftypeavailability.taxon_count$) in GBIF.  Examination of the intersection of the location of the data provider with the native range of the taxon shows that as the geographic scale narrows the percentage of taxa with type material mobilised from within the native range of the taxon drops, from $taxa2nativerangetypeavailability.continent_code_l1.taxon_represented_pc$%  at continent level to $taxa2nativerangetypeavailability.area_code_l3.taxon_represented_pc$% at country level.
