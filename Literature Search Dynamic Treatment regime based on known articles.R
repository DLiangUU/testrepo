# https://luketudge.github.io/litsearchr-tutorial/litsearchr_tutorial.html

install.packages("lintr")
install.packages("styler")
install.packages("docstring")
install.packages("renv")
install.packages("conda")
renv::init()
renv::snapshot()
renv::restore()

library(tidyverse)
library(dplyr)
library(ggplot2)
library(ggraph)
library(igraph)
library(readr)
library(devtools)
library(litsearchr)
library(lintr)
library(docstring)
packageVersion("litsearchr")


# Function for generating the initial keywords
GenerateKeywords <- function(Datafile) {
  #'@title Keyword Generator
  #'@description This function will extract the keywords provided by 
  #'author as well as generate keywords based on
  #'Rapid Automatic Keyword Extraction Algorithm
  #'@param Datafile The name of the dataset imported
  #'@return Returns the generated keywords
  keywords <- extract_terms(
    keywords = Datafile[, "keywords"],
    method = "tagged", min_n = 2
  )
  extract_terms(
    text = Datafile[, "title"], method = "fakerake",
    min_freq = 3, min_n = 2
  )
  title_terms <- extract_terms(
    text = Datafile[, "title"],
    method = "fakerake",
    min_freq = 3, min_n = 2
  )
  terms <- unique(c(keywords, title_terms))
  print("These are the generated keywords and terms:")
  return(terms)
}
?GenerateKeywords

GenerateGraphNetwork <- function(Datafile) {
  #All abstracts needs to be combined in single file
  docs <- paste(Datafile[, "title"], Datafile[, "abstract"])
  #A matrix with the records should be created
  dfm <- create_dfm(elements = docs, features = terms)
  dfm[1:3, 1:4]
  g <- create_network(dfm, min_studies = 3)

  # Graphing to see relatedness
  ggraph(g, layout = "stress") +
    coord_fixed() +
    expand_limits(x = c(-3, 3)) +
    geom_edge_link(aes(alpha = weight)) +
    geom_node_point(shape = "circle filled", fill = "white") +
    geom_node_text(aes(label = name), hjust = "outward", check_overlap = TRUE) +
    guides(edge_alpha = FALSE)
}
GenerateFigure <- {
  # Generating strength of the terms
  strengths <- strength(g)

  data.frame(term = names(strengths), strength = strengths, row.names = NULL) %>%
    mutate(rank = rank(strength, ties.method = "min")) %>%
    arrange(strength) ->
  term_strengths

  cutoff_fig <- ggplot(term_strengths, aes(
    x = rank, y = strength,
    label = term
  )) +
    geom_line() +
    geom_point() +
    geom_text(
      data = filter(term_strengths, rank > 5), hjust = "right",
      nudge_y = 20, check_overlap = TRUE
    )

  cutoff_fig

  # Finding the cutoff point
  cutoff_cum <- find_cutoff(g, method = "cumulative", percent = 0.8)

  cutoff_cum

  cutoff_fig +
    geom_hline(yintercept = cutoff_cum, linetype = "dashed")

  get_keywords(reduce_graph(g, cutoff_cum))

  # Change points
  cutoff_change <- find_cutoff(g, method = "changepoint", knot_num = 3)

  cutoff_change

  cutoff_fig +
    geom_hline(yintercept = cutoff_change, linetype = "dashed")
}



# Load the results first
naive_results <- import_results(file = "data/raw/DynTreatReg.bib")
# Using the functions
GenerateKeywords(naive_results)
GenerateGraphNetwork(naive_results)
GenerateFigure

# Reducing the graph
g_redux <- reduce_graph(g, cutoff_change[1])
selected_terms <- get_keywords(g_redux)

selected_terms

# Terms needs to be grouped otherwise the search will be wrong
grouped_terms <- list(
  DynamicTreatment = selected_terms[c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)]
)
grouped_terms

# A new search can be written
write_search(
  grouped_terms,
  languages = "English",
  exactphrase = TRUE,
  stemming = FALSE,
  closure = "left",
  writesearch = TRUE
)

cat(read_file("search-inEnglish.txt"))


lint("Literature Search Dynamic Treatment regime based on known articles.R")
