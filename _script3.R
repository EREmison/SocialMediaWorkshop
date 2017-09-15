library(magrittr)
library(dplyr)
library(readr)


# Tell R the name of the file that contains the data
inname = 'mytweets.csv'


# Read the datasheet into R
dat <- read_csv(inname)

# Set three search terms
search1 <- ""
search2 <- ""
search3 <- ""

# Make three data frames, one for each search term
search1.id <- grep(search1,
                   dat$text, 
                   ignore.case = T)
search1.df <- dat[search1.id,]

search2.id <- grep(search2,
                   dat$text, 
                   ignore.case = T)
search2.df <- dat[search2.id,]

search3.id <- grep(search3,
                   dat$text, 
                   ignore.case = T)
search3.df <- dat[search3.id,]

keywords <- c(search1, search2, search3)
occurrences <- c(nrow(search1.df), nrow(search2.df), nrow(search3.df))

plotname <- paste0('barplot-', search1, '-', search2, '-' ,search3, '.png')
plottitle <- paste(search1, search2, search3)

png(plotname, width = 455, height = 440)
barplot(occurrences, names.arg = keywords,
        xlab = NULL, 
        ylab = 'occurrences',
        axes = T, 
        main = plottitle, 
        sub = 'Territory: NW',           ##### Adjust this subtitle! #####
        col = palette()
        )
dev.off()

cat("Graphic file ", plotname, " has been written to ", getwd(), ".", sep ='')

# rm(list = ls())
