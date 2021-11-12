# Test Project - Finding keywords
## Overview
This test project is to generate keywords for a systematic review search. The code is based on the R Package Litsearchr.
It is based on initially performing a naive search for articles and then followingly applying a
Rapid Automatic Keyword Extraction Algorithm to search for additional keywords in the articles from the naive search.

The previous code has been rewritten into functions for easier general reproduction.

## Installation


- PG = project-generated
- HW = human-writable
- RO = read only
```
.
+-- .gitignore
+-- CITATION.md
+-- LICENSE.md
+-- README.md
+-- requirements.txt
+-- bin                <- Compiled and external code, ignored by git (PG)
¦   +-- external       <- Any external source code, ignored by git (RO)
+-- config             <- Configuration files (HW)
+-- data               <- All project data, ignored by git
¦   +-- processed      <- The final, canonical data sets for modeling. (PG)
¦   +-- raw            <- The original, immutable data dump. (RO)
¦   +-- temp           <- Intermediate data that has been transformed. (PG)
+-- docs               <- Documentation notebook for users (HW)
¦   +-- manuscript     <- Manuscript source, e.g., LaTeX, Markdown, etc. (HW)
¦   +-- reports        <- Other project reports and notebooks (e.g. Jupyter, .Rmd) (HW)
+-- results
¦   +-- figures        <- Figures for the manuscript or reports (PG)
¦   +-- output         <- Other output for the manuscript or reports (PG)
+-- src                <- Source code for this project (HW)

```


## License

This project is licensed under the terms of the [MIT License](/LICENSE.md)
