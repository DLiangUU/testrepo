# Test Project - Finding keywords
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/DLiangUU/testrepo/main)
## Overview
This test project is to generate keywords for a systematic review search. The code is based on the R Package Litsearchr.
It is based on initially performing a naive search for articles and then followingly applying a
Rapid Automatic Keyword Extraction Algorithm to search for additional keywords in the articles from the naive search.

The previous code has been rewritten into functions for easier general reproduction.

## Installation

Prerequisites
 - RStudio Version 1.3.1093

The packages needed for the project to work is the following:
 - install.packages("tidyverse")
 - install.packages("dplyr") 
 - install.packages("ggplot2") 
 - install.packages("ggraph") 
 - install.packages("igraph") 
 - install.packages("readr") 
 - install.packages("devtools") 
 - install.packages("litsearchr") 
 - install.packages("lintr") 
 - install.packages("docstring") 

To use the project, the user can clone the project with git clone. 
The main script is located in the file Literature Search Dynamic Treatment regime based on known articles.R

## Reference
This project is based on the project https://elizagrames.github.io/litsearchr/

## License

This project is licensed under the terms of the [MIT License](/LICENSE.md)
