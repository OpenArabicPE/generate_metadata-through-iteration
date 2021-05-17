---
title: "generate_metadata-through-iteration: read me"
author: Till Grallert
date: 2021-05-16
ORCID: orcid.org/0000-0002-5739-8094
---

The main stylesheet in this repository (`xslt/generate_tei-from-biblstruct.xsl`) generates bibliographic metadata for periodicals based on an TEI XML input file and information on the publication schedule. The output is also a TEI XML file with `<biblStruct>` children which can then be converted to various other structured formats for use and import into reference management software or as stub editions.

# workflow

## 1. Input:

- Input is a TEI file with at least one `<biblStruct>` element upon which the iteration is run.
- The input file can either be written manually or
    1. Enter reference data to a Zotero library and make use of the below tagging scheme
    2. Export data from Zotero as MODS
    3. Automatically convert MODS to `<tei:biblStruct>` using [`convert_mods-to-tei_functions.xsl`](https://github.com/OpenArabicPE/convert_tei-to-bibliographic-data/blob/master/xslt/convert_mods-to-tei_functions.xsl) in the repository [https://github.com/OpenArabicPE/convert_tei-to-bibliographic-data](https://github.com/OpenArabicPE/convert_tei-to-bibliographic-data)

## 2. Iteration:

- Based on the input file
- A small set of parameters (that could potentially be integrated into the TEI input):
    + step for iteration: daily, some days in the week, weekly, fortnightly, monthly
    + the particular format of these parameters is for other transformations to then pick them up and map them to tags in Zotero

```xml
<note type="tagList">
    <list>
        <!-- select one of the frequencies -->
        <item>frequency_daily</item>
        <!-- <item>frequency_fortnightly</item> -->
        <!-- <item>frequency_monthly</item> -->
        <!-- frequency_daily also requires a selection of weekdays -->
        <item>days_monday</item>
        <item>days_tuesday</item>
        <item>days_wednesday</item>
        <item>days_thursday</item>
        <item>days_friday</item>
        <item>days_saturday</item>
        <item>days_sunday</item>
        <!-- frequency_monthly can take additional input, for instance each 1st and 15th -->
        <!-- <item>days_01</item> -->
        <!-- <item>days_15</item> -->
    </list>
</note>
```

## 3. Output:

- a `<listBibl>` with `<biblStruct>` children based on the input file
- save everything as TEI xml

## 4. Process output

1. convert to other serialisations of bibliographic metadata using code from the repository [convert_tei-to-bibliographic-data](https://github.com/openarabicpe/convert_tei-to-bibliographic-data).
    - `convert_tei-to-zotero-rdf_bibl.xsl`: Zotero RDF
    - `convert_tei-to-mods_bibl.xsl`: MODS
2. generate TEI files for each issue