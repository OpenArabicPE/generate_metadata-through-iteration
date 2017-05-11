---
title: ": read me"
author: Till Grallert
date: 2017-05-11 22:56:14 +0200
---

The main stylesheet in this repository generates bibliographic metadata for periodicals based on an TEI XML input file and information on the publication schedule. The output is also a TEI XML file with `<biblStruct>` children which can then be converted to MODS or Sente XML for use and import into reference management software.

# workflow

1. Input:
	- Input is a TEI file with at least one `<biblStruct>` element upon which the iteration is run.
2. Iteration:
	- Based on the input file
	- A small set of parameters (that could potentially be integrated into the TEI input):
        + step for iteration: daily, some days in the week, weekly, fortnightly, monthly
3. Output:
    - add a `<listBibl>` with `<biblStruct>` children based on the input file
    - save everything as TEI xml
