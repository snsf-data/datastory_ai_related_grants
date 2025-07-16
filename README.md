# Datastory: *How much of SNSF-funded research is related to artificial intelligence?*

*SNSF-funded research related to AI increased significantly between 2011 and 2024. By applying an approach using key terms to identify AI-related grants, we could illustrate the methods preferred by the different research domains.*

[English](https://data.snf.ch/stories/ai-related-grants-en.html)\
[German](https://data.snf.ch/stories/forschung-mit-ki-bezug-de.html)\
[French](https://data.snf.ch/stories/recherche-financee-liee-a-l-ia-fr.html)

**Author(s)**: Manuel Klaus, Simon Gorin

**Publication date**: 17.07.2025

# Data description

The data used in this data story are available in the folder data. The files
(`data/ai_key_terms_counts.csv` and `data/ai_related_grants.csv`) contain data
on grants written in English from Project and Career funding awarded between
2011 and 2024. The sample includes a total of 21,784 grants, as well as the
counts associated to the AI-related key terms.

## `ai_key_terms_counts.csv`

This dataset contains data on the occurrence of the AI-related key terms in the
grants analysed for this data story. Each row represents, for a given year,
research domain, and key term, the number of grants in which the key term was
detected.

-   `research_domain_en`: the research domain associated to the grant. The SNSF
    distinguishes three major research domains: "social sciences and humanities"
    (SSH); "mathematics, informatics, natural sciences and technology" (MINT);
    "life sciences" (LS). The level "multi-domain" refers to grants in which
    where listed in the application main disciplines from more than one of the
    three research domains.
-   `research_domain_de`: German translation of `research_domain_en` ("Geistes-
    und Sozialwissenschaften" = "social sciences and humanities"; "Mathematik,
    Informatik, Naturwissenschaften und Technik" = "mathematics, informatics,
    natural sciences and technology"; "Lebenswissenschaften" = "life sciences";
    "bereichsübergreifend" = "multi-domain").
-   `research_domain_fr`: French translation of `research_domain_en` ("sciences
    humaines et sociales" = "social sciences and humanities"; "mathématiques,
    informatique, sciences naturelles et technique" = "mathematics, informatics,
    natural sciences and technology"; "sciences de la vie" = "life sciences";
    "multi-domaines" = "multi-domain").
-   `research_domain_en_short`: short version of `research_domain_en` ("SSH";
    "MINT"; "LS"; "multi-domain").
-   `research_domain_de_short`: short version of `research_domain_de` ("GSW" =
    "SSH"; "MINT" = "MINT"; "LW" = "LS"; "bereichsübergreifend" =
    "multi-domain").
-   `research_domain_fr_short`: short version of `research_domain_fr` ("SHS" =
    "SSH"; "MINT" = "MINT"; "SV" = "LS"; "multi-domaines" = "multi-domain").
-   `year`: the [call decision
    year](https://data.snf.ch/about/glossary#calldecisionyear) of the grants in
    which the key term was searched.
-   `key_term`: the AI-related key term.
-   `count`: the number of grants in which the AI-related key term appeared.

## `ai_related_grants.csv`

This dataset contains data on the 21,784 grants we analysed. It includes the
necessary variable to identify the grants, as well as data on funding scheme,
research domain, key term counts, and key terms detected. Grant summaries are
not provided as they would make the dataset too big. However, the grants
identifier can be used to join the corresponding summary from the
[Datasets (see "Grants including scientific abstracts")](https://data.snf.ch/datasets)
available on the SNSF Data Portal.

-   `grant_number`: unique identifier of the grant (can be used in the [SNSF
    Grant Search](https://data.snf.ch/grants)).
-   `title`: the title of the grant.
-   `year`: the [call decision
    year](https://data.snf.ch/about/glossary#calldecisionyear) of the grant.
-   `research_domain_en`: the research domain associated to the grant. The SNSF
    distinguishes three major research domains: "social sciences and humanities"
    (SSH); "mathematics, informatics, natural sciences and technology" (MINT);
    "life sciences" (LS). The level "multi-domain" refers to grants in which
    where listed in the application main disciplines from more than one of the
    three research domains.
-   `research_domain_de`: German translation of `research_domain_en` ("Geistes-
    und Sozialwissenschaften" = "social sciences and humanities"; "Mathematik,
    Informatik, Naturwissenschaften und Technik" = "mathematics, informatics,
    natural sciences and technology"; "Lebenswissenschaften" = "life sciences";
    "bereichsübergreifend" = "multi-domain").
-   `research_domain_fr`: French translation of `research_domain_en` ("sciences
    humaines et sociales" = "social sciences and humanities"; "mathématiques,
    informatique, sciences naturelles et technique" = "mathematics, informatics,
    natural sciences and technology"; "sciences de la vie" = "life sciences";
    "multi-domaines" = "multi-domain").
-   `research_domain_en_short`: short version of `research_domain_en` ("SSH";
    "MINT"; "LS"; "multi-domain").
-   `research_domain_de_short`: short version of `research_domain_de` ("GSW" =
    "SSH"; "MINT" = "MINT"; "LW" = "LS"; "bereichsübergreifend" =
    "multi-domain").
-   `research_domain_fr_short`: short version of `research_domain_fr` ("SHS" =
    "SSH"; "MINT" = "MINT"; "SV" = "LS"; "multi-domaines" = "multi-domain").
-   `key_terms_count`: number of AI-related keywords occurrences detected in the
    grant title, abstract, and keywords.
-   `unique_key_terms_count`: number of unique AI-related keywords detected in
    the grant title, abstract, and keywords.
-   `key_terms_detected`: the list of unique AI-related keywords detected in the
    grant title, abstract, and keywords.
-   `funding_scheme_level_1`: the first level of the SNSF funding scheme
    classification (only "Project" and "Careers" schemes are included in this
    dataset, see
    [here](https://www.snf.ch/en/9o5ezhuSlHENVQxr/page/overview-of-funding-schemes)
    for more details).
-   `funding_scheme_level_2`: the funding scheme of the grant (see [Project
    schemes](https://www.snf.ch/en/s3QpYgUPS2ZEL0k0/page/funding/projects) for
    more details about Project schemes and
    [here](https://www.snf.ch/en/48YVbNHGCW52J2TW/page/funding/careers)).
