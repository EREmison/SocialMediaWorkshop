rm(list = ls())
library(ROAuth)
library(streamR)


# Initiate Twitter session
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <-     "xxx"
consumerSecret <-  "yyyyyyy"
my_oauth <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret, 
                             requestURL=requestURL,
                             accessURL=accessURL, authURL=authURL)
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
save(my_oauth, file = "my_oauth.Rdata")

# We will collect all tweets that contain at least one of the following terms:
keywords = c('')

# Here, we define our geolocation bounding box. 
# First SW corner, then NE corner of box.
# If don't care about geolocation, simply set location to NULL.
location = c(lon1, lat1, lon2, lat2)


for (i in c(1:999)){

# Load "my_oauth", a file that contains all our session registration info.
load("my_oauth.Rdata")

# To ensure distinct file naming during the automatically recurring searches, we
# define a file naming routine using the current date and time as per Th. Keller.
current.time <- format(Sys.time(), "%Y-%m-%d-%H-%M")
f <- paste0("collect_Tweets.", current.time, ".json")


# Now we pass the actual search query.
tweets <- try(filterStream(file.name = f,
                           locations = location,
                           timeout = 900, 
                           # language = "en",
                           track = keywords,
                           oauth = my_oauth))
print(paste0("That was attempt no. ", i, "."))
}

rm(list = ls())
