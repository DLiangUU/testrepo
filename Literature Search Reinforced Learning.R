#https://luketudge.github.io/litsearchr-tutorial/litsearchr_tutorial.html

library(tidyverse)
library(dplyr)
library(ggplot2)
library(ggraph)
library(igraph)
library(readr)
library(devtools)
library(litsearchr)
packageVersion("litsearchr")

naive_results <- import_results(file="pubmed-Reinforced-set.nbib")
nrow(naive_results)
colnames(naive_results)
naive_results[1, "title"]
#Two ways of generating keywords#
#First way
naive_results[1, "keywords"]
#This show the ones that already contains keywords
sum(is.na(naive_results[, "keywords"]))
#This is extracting keywords in the keywords field in the articles
extract_terms(keywords=naive_results[, "keywords"], method="tagged")
?extract_terms

keywords <- extract_terms(keywords=naive_results[, "keywords"], method="tagged", min_n=2)

keywords

#Another way is to use the RAKE methodology. 
extract_terms(text=naive_results[, "title"], method="fakerake", min_freq=3, min_n=2)

title_terms <- extract_terms(
  text=naive_results[, "title"],
  method="fakerake",
  min_freq=3, min_n=2
)

title_terms

terms <- unique(c(keywords, title_terms))

#You can also use network analysis to identify keywords
#First combine all abstracts to 1 file
docs <- paste(naive_results[, "title"], naive_results[, "abstract"])
docs[]
#Now we create a matrix with the records
dfm <- create_dfm(elements=docs, features=terms)
dfm[1:3, 1:4]
g <- create_network(dfm, min_studies=3)

#Graphing it
ggraph(g, layout="stress") +
  coord_fixed() +
  expand_limits(x=c(-3, 3)) +
  geom_edge_link(aes(alpha=weight)) +
  geom_node_point(shape="circle filled", fill="white") +
  geom_node_text(aes(label=name), hjust="outward", check_overlap=TRUE) +
  guides(edge_alpha=FALSE)

#Generating strenght of the terms
strengths <- strength(g)

data.frame(term=names(strengths), strength=strengths, row.names=NULL) %>%
  mutate(rank=rank(strength, ties.method="min")) %>%
  arrange(strength) ->
  term_strengths

term_strengths

cutoff_fig <- ggplot(term_strengths, aes(x=rank, y=strength, label=term)) +
  geom_line() +
  geom_point() +
  geom_text(data=filter(term_strengths, rank>5), hjust="right", nudge_y=20, check_overlap=TRUE)

cutoff_fig

#Finding the cutoff point
cutoff_cum <- find_cutoff(g, method="cumulative", percent=0.8)

cutoff_cum

cutoff_fig +
  geom_hline(yintercept=cutoff_cum, linetype="dashed")

get_keywords(reduce_graph(g, cutoff_cum))

#Change points
cutoff_change <- find_cutoff(g, method="changepoint", knot_num=3)

cutoff_change

cutoff_fig +
  geom_hline(yintercept=cutoff_change, linetype="dashed")

#Reducing the graph
g_redux <- reduce_graph(g, cutoff_change[1])
selected_terms <- get_keywords(g_redux)

selected_terms

#It is suggested to group the terms into groups
#grouped_terms <-list(
#  medication=selected_terms[c(14, 28)],
#  cbt=selected_terms[c(4, 6, 7, 17, 24, 25, 26, 29, 30)],
#  phobia=selected_terms[c(2, 3, 9, 12, 15, 19, 20, 21, 23, 27)]
#)
grouped_terms <-list(
  AI=selected_terms[c(1,2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
                      18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37,
                      38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56,
                      57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75,
                      76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95,
                      96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107,  108, 109, 110, 111,
                      112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132,
                      133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148 )]
)
grouped_terms

#A new search can be written
write_search(
  grouped_terms,
  languages="English",
  exactphrase=TRUE,
  stemming=FALSE,
  closure="left",
  writesearch=TRUE
)

cat(read_file("search-inEnglish.txt"))

#Against gold standard results
important_titles <- c(
  "Efficacy of treatments for anxiety disorder: A meta-analysis",
  "Cognitive behaviour therapy for health anxiety: A systematic review and meta-analysis",
  "A systematic review and meta-analysis of treatments for agrophobia"
)

data.frame(check_recall(important_titles, new_results[, "title"]))