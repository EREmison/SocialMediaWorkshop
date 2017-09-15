library(magrittr)
library(dplyr)
library(wordcloud)
library(tm)
library(tidytext)
library(readr)

options(warn=-1)


# Tell R the name of the file that contains the data
inname = 'mytweets.csv'

# Read the datasheet into R
dat <- read_csv(inname)

# Set search term
searchword <- ""

# Make three data frames, one for each search term
search.id <- grep(searchword,
                   dat$text, 
                   ignore.case = T)
search.df <- dat[search.id,]


# Prepare stopwords
tw_stop <- data.frame(word = c('amp', 'gt', 't.c', 'rt', 'https', 'miss',
                               'texas', 'tx',
                               'missed', 'missing', 'heb', 'love',
                               't.co', '___', '1', '2', '3', '4', '5', 
                               '6', '7', '8', '9', "i\'m", '15', '30', 
                               '45', '00', '10'), lexicon='whatevs')
data('stop_words')


# Prepare data:
# 1. Remove URLs from the tweet texts
if(nrow(search.df) > 0){
  search.df$text <- 
    gsub(' http[^[:blank:]]+', '', search.df$text)
  
# 2. Unnest and stopword-remove
  tidy_tw <- search.df %>% unnest_tokens(word, text)
  tidy_tw <- tidy_tw %>%
    anti_join(tw_stop)
  tidy_tw <- tidy_tw %>%
    anti_join(stop_words)
  
# 3. Print to screen the table of word frequencies that 
#    will be the data for the cloud
  print(tidy_tw %>% count(word, sort = TRUE)) 
  
# 4. Make the wordcloud
  fig<-tidy_tw %>%
    count(word) %>%
    with(wordcloud(word, n, max.words = 100,
                   colors = brewer.pal(8,'Dark2')))

# What happens if there are no hits for the searchword?  
} else {
  cat('\n\n\nThe dataset', inname, 'did not contain any tweets with keyword', 
      searchword, '\n\nNo wordcloud was plotted\n\n\n\n')
}

options(warn=0)
rm(list = ls())
