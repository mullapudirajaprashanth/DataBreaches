# Independent study - Raja Prashanth Mullapudi (Z1804496)
## Submitted to Dr. Kishen Iyengar
### Northern Illinois University

# It is important to check the working directory and/or set working directory if required
getwd()

# set working directory
setwd("C:/Users/mulla/Desktop/Summer 2018/Independent Study/Final Submission")

# Installing all the necessary packages
install.packages(c("tm", "ggplot2", "caret", "lattice", 
                   "quanteda", "tidyr", "topicmodels", 
                   "tidytext", "dplyr","ldatuning", "stringr",
                   "readxl", "gdata", "jsonlite"))


install.packages("twitteR")
install.packages("ROAuth")
install.packages("httr")
install.packages("devtools")


## Loading all the necessary libraries 
library(tm)
library(gdata)
library(caret)
library(jsonlite)
library(lattice)
library(quanteda)
library(tidyr)
library(topicmodels)
library(tidytext)
library(dplyr)
library(ldatuning)
library(readxl)
library(stringr)
library(lubridate) #package for date conversion
library(ggplot2)
library(tm)
library(wordcloud)
library(grid) #for pushViewport function

# package twitteR
library("twitteR")   ## key library
library(ROAuth)
require(RCurl)
library("httr")
library(httr)
library(devtools)

# Section - 1


## Reusable Function to Automate Extraction of data
# Future scope for User input using R markdown

download<-function(user_link, ext){
  #if extension is .csv file
  if(ext=="csv"){
    import.data<-read.csv(user_link, stringsAsFactors = FALSE)
    return (import.data)
  }
  
  #if extension is .xlsx file
  else if(ext=="xlsx"){
    #readxl package being used
    import.data<-read_excel(user_link, sheet=1, col_names=TRUE, col_types=NULL, skip=0)
    return (data.frame(import.data))
  }
  
  #if extension is .xls file
  else if(ext=="xls"){
    #gdata package being used
    import.data<-read.xls(user_link)
    return (data.frame(import.data))
  }
  
  #if extension is JSON file, imports into a list (can be converted to df after cleaning)
  else if(ext=="JSON"){
    #jsonlite package being used
    import.data<-fromJSON(user_link)
    return (data.frame(import.data))
  }
  
  else return("NA")
}

# Gather user input - location / name of input data
user_link<-"Data_Breach.csv"
ext<-"csv" 

input_data <- download(user_link, ext)

head(input_data)


# Section 2 

glimpse(input_data)

# we have to format, date to date; total records to numerical, remaining to categorical except description

input_data$Date.Made.Public <- dmy(input_data$Date.Made.Public)

input_data$Company <- as.factor(input_data$Company)
input_data$Location <- as.factor(input_data$Location)
input_data$Type.of.breach <- as.factor(input_data$Type.of.breach)
input_data$Type.of.organization <- as.factor(input_data$Type.of.organization)
input_data$Information.Source <- as.factor(input_data$Information.Source)

input_data$Total.Records <- as.numeric(gsub("\\D", "", input_data$Total.Records)) #removing anything except digits

glimpse(input_data)

#find missing values

#1. checking if there are any missing values in the dataframe
any(is.na(input_data))

#2. count the number of missing values
sum(is.na(input_data))  
length(which(!complete.cases(input_data)))

#3. to check the summary and observe the NA's for each variable
summary(input_data)

#we observed that, only the "total records" columns has 30 missing values
which(is.na(input_data$Total.Records)) #rows with missing "Total records"

#now, we can choose to omit the rows with missing values or replace the missing values
# since, there are just 30 records with missing value of the total 8104 rows, we here choose to omit these rows. 
clean_data <- input_data[(which(complete.cases(input_data))),]

# extracting year from date - using lubridate
clean_data$year <- as.factor(format(as.Date(clean_data$Date.Made.Public, format="%Y/%m/%d"),"%Y"))


summary(clean_data)
View(clean_data)

###ggplot - Data Visualizations - Data Exploration

#PLOT 1 
plot1data <- clean_data %>% 
  group_by(year) %>%
  summarize(TotalRecords = sum(Total.Records),
            TotalBreaches = n())

plot1_1 <- ggplot(plot1data, aes(x=year, y=TotalBreaches, fill = year)) + 
           geom_col() + 
           geom_text(label = plot1data$TotalBreaches, size = 4, position = position_stack(vjust = 1.05)) +
           labs(x = 'Year', y = 'Number of Breaches', 
                title = 'Total Breaches over years') +
           theme(legend.position = "none",
                 panel.grid  = element_blank(),
                 panel.border = element_blank(),
                 plot.title=element_text(hjust = 0.5, size=14, face="bold"))  

plot1_2 <- ggplot(plot1data, aes(x = year, y = TotalRecords, fill = year)) +
           geom_col() +
           geom_text(label = plot1data$TotalRecords, size = 4, position = position_stack(vjust = 1.05)) +
           labs(x = 'Year', y = 'Total Records breached', 
           title = 'Total Records breached over years') +
           theme(legend.position = "none",
                 panel.grid  = element_blank(),
                 panel.border = element_blank(),
                 plot.title=element_text(hjust = 0.5, size=14, face="bold"))


pushViewport(viewport(layout = grid.layout(1, 2)))
print(plot1_1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
print(plot1_2, vp = viewport(layout.pos.row = 1, layout.pos.col = 2))

# PLOT 2

plot2data <- clean_data %>% 
  group_by(Type.of.organization) %>%
  summarize(TotalRecords = sum(Total.Records))

plot2 <- ggplot(plot2data, aes(x="", y=TotalRecords, fill = Type.of.organization)) + 
         geom_bar(width = 1, stat = "identity") + 
         scale_y_log10() + 
         labs(title = 'Number of Records breached by organization - log10 scale') +
         geom_text(aes(label=paste0('Organization: ',plot2data$Type.of.organization, '\n', 
                                     plot2data$TotalRecords, '\n', 
                                     round(plot2data$TotalRecords / sum(plot2data$TotalRecords) * 100, 3),
                                    "%")), 
                   position = position_stack(vjust = 0.5)) +
         coord_polar("y") + 
         theme(legend.position = "none", 
               axis.title.x = element_blank(),
               axis.title.y = element_blank(),
               axis.text = element_blank(),
               axis.ticks = element_blank(),
               panel.grid  = element_blank(),
               panel.border = element_blank(),
               plot.title=element_text(hjust = 0.5, size=14, face="bold")) 

print(plot2)

# PLOT 3

plot3data <- clean_data %>% 
  group_by(Type.of.breach) %>%
  summarize(TotalRecords = sum(Total.Records))

plot3 <- ggplot(plot3data, aes(x="", y=TotalRecords, fill = Type.of.breach)) + 
         geom_bar(width = 1, stat = "identity") + 
         scale_y_log10() + 
         labs(title = 'Number of Records breached by Type of breach - log10 scale') +
         geom_text(aes(label=paste0('Type: ',plot3data$Type.of.breach, '\n', 
                             plot3data$TotalRecords, '\n', 
                             round(plot3data$TotalRecords / sum(plot3data$TotalRecords) * 100, 3),
                             "%")), 
                    position = position_stack(vjust = 0.5)) +
         coord_polar("y") +
         theme(legend.position = "none",
               axis.title.x = element_blank(),
               axis.title.y = element_blank(),
               axis.text = element_blank(),
               axis.ticks = element_blank(),
               panel.grid  = element_blank(),
               panel.border = element_blank(),
               plot.title=element_text(hjust = 0.5, size=14, face="bold"))

print(plot3)


# PLOT 4

plot4data <- clean_data %>% 
  group_by(Type.of.organization, Type.of.breach) %>%
  summarize(TotalRecords = sum(Total.Records),
            Numberofbreaches = n())

plot4 <- ggplot(plot4data, aes(x = Type.of.breach, y = TotalRecords, fill = Type.of.organization)) +
         geom_col() + 
         scale_y_log10() +
         geom_text(aes(label=paste0(plot4data$Numberofbreaches, '\n', 
                             plot4data$TotalRecords)), 
                    position = position_stack(vjust = 0.5)) +
         labs(x = 'Type of Breach', y = 'Number of records breached', 
              title = 'Organization, Breach type, Records') +
         theme( legend.position = "bottom",
                panel.grid  = element_blank(),
                panel.border = element_blank(),
                plot.title=element_text(hjust = 0.5, size=14, face="bold")) +
         guides(fill=guide_legend(title="Organization")) + 
         facet_grid(Type.of.organization~.)

print(plot4)


# PLOT 5

# Function for creating DTM 
funcTDM <- function(input) {
  my_source <- VectorSource(input)
  corpus<-Corpus(my_source)
  corpus<- tm_map(corpus, tolower)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeWords, stopwords("english"))
  corpus<- tm_map(corpus, stemDocument)
  
  #Create the dtm again with the new corpus
  tdm <- TermDocumentMatrix(corpus)
  tdm <- removeSparseTerms(tdm, 0.997)
  input_dmatrix <- as.matrix(tdm)
  
  return(input_dmatrix)
}

# Description - Word cloud
DescTDM <- funcTDM(clean_data$Description.of.incident)
Desc_termfreq <- rowSums(DescTDM)
Desc_wordfreq <- data.frame(terms = names(Desc_termfreq), num = Desc_termfreq)

pal <- brewer.pal(8, "Dark2")

plot5 <- wordcloud(Desc_wordfreq$terms, Desc_wordfreq$num,
          scale = c(7,.3),
          min.freq = 10, max.words = 100,
          random.order = T,
          rot.per = .15,
          colors = pal
)

print(plot5)



# PLOT 6

plot6data <- clean_data %>% 
  group_by(Company) %>%
  summarize(TotalRecords = sum(Total.Records),
            Numberofbreaches = n()) %>% 
  top_n(15, TotalRecords)
 
plot6 <- ggplot(plot6data, aes(x = reorder(Company, TotalRecords),
                               y = TotalRecords, fill = "Dark2")) + 
         geom_col() + 
         geom_text(aes(label=plot6data$Numberofbreaches),position = position_stack(vjust = 0.5)) +
         labs(x = 'Company', y = 'Number of records breached', 
              title = 'Top 15 Companies with most records breached') +
         theme( legend.position = "none",
                 panel.grid  = element_blank(),
                 panel.border = element_blank(),
                 plot.title=element_text(hjust = 0.5, size=14, face="bold")) +
         coord_flip()
  

print(plot6)


# Section 4

# Information from Twitter Developer account
key = "194x2bmgvoGAzEOyny9oC2UHz"
secret = "UkdZAm67OHncpxdKjyllOYKhgaBV5kl4pkNxD94zgQYEEBO1zX"
secrettk = "W2UIL97PrRreYhCGZM86kYLkt88HhiRrKPTFnvn7VVAhL"      #Access Token Secret from Twitter
mytoken = "52714471-US5Z4KYxwNUyVaKNBl4GKRkHxhGpRUaFxTS2GT02U"  #Access token from Twitter

# Cacert.pem is a collection of certificates
download.file(url="http://curl.haxx.se/ca/cacert.pem", 
              destfile="C:/Users/mulla/Desktop/Summer 2018/Independent Study/SocialMedia/cacert.pem",
              method="auto")

# Authentication for Twitter
authenticate <-  OAuthFactory$new(consumerKey=key,
                                  consumerSecret=secret,
                                  requestURL='https://api.twitter.com/oauth/request_token',
                                  accessURL='https://api.twitter.com/oauth/access_token',
                                  authURL='https://api.twitter.com/oauth/authorize')

authenticate$handshake(cainfo="C:/Users/mulla/Desktop/Summer 2018/Independent Study/SocialMedia/cacert.pem")

# Inserting PIN from Twitter Authentication Handshake
5636451

save(authenticate, file="twitter authentication.Rdata")

# Setting up Twitter Authentication
setup_twitter_oauth(key, secret, mytoken, secrettk) # (1) choose direct authentication

# Lets start with the Twitter scraping - and check the latest tweets of Equifax

tweets = searchTwitter("#Equifax", n=1000)

userTimeline("Equifax")

class(tweets)
length(tweets)
head(tweets)

list <- sapply(tweets, function(x) x$getText()) 
corpus <- VCorpus(VectorSource(list)) 
corpus <- tm_map(corpus, function(x) iconv(x, "latin1", "ASCII", sub=""))
corpus <- tm_map(corpus, tolower) 
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus,
                 function(x)removeWords(x,stopwords())) # remove stopwords (meaningless words)

# to trasform to plain text which wordcloud can use
corpus <- tm_map(corpus, PlainTextDocument)

pal <- brewer.pal(8, "Dark2")

plot7 <- wordcloud(corpus, 
                   scale = c(7,1),
                   min.freq = 4, max.words = 45,
                   random.order = F,
                   rot.per = .15,
                   colors = pal
)

print(plot7)


# changing to a tdm
tdm <- TermDocumentMatrix(corpus)

tdm  #sparisty tells us how the tweets and documents are related to each other
     # high - tweets are not related to each other

# frequent terms
findFreqTerms(tdm, lowfreq=20)

# SENTIMENT ANALYSIS

pos = readLines("positive_words.txt")
neg = readLines("negative_words.txt")

tweet_df <- as.data.frame(list)

require("plyr")
require("stringr")

#sentiment analysis function
score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  # Parameters
  # sentences: vector of text to score
  # pos.words: vector of words of postive sentiment
  # neg.words: vector of words of negative sentiment
  # .progress: passed to laply() to control of progress bar
  
  # create simple array of scores with laply
  scores = laply(sentences,
                 function(sentence, pos.words, neg.words)
                  {
                    # split sentence into words with str_split (stringr package)
                    word.list <- str_split(sentence, "\\s+")
                    words <- unlist(word.list)
                    
                    # compare words to the dictionaries of positive & negative terms
                    pos.matches <- match(words, pos)
                    neg.matches <- match(words, neg)
                    
                    # get the position of the matched term or NA
                    # we just want a TRUE/FALSE
                    pos.matches <- !is.na(pos.matches)
                    neg.matches <- !is.na(neg.matches)
                    
                    # final score
                    score <- sum(pos.matches) - sum(neg.matches)
                    return(score)
                  }, pos.words, neg.words, .progress=.progress )
  # data frame with scores for each sentence
  scores.df <- data.frame(text=sentences, score=scores)
  return(scores.df)
}


sentiment_score <- score.sentiment(list, pos, neg, .progress='text')
summary(sentiment_score)
View(sentiment_score)

#Convert sentiment scores from numeric to character to enable the gsub function 
sentiment_score$sentiment <- as.character(sentiment_score$score)

#After looking at the summary(sentiment_Score$sentiment) decide on a threshold for the sentiment labels
sentiment_score$sentiment <- gsub("^0$", "Neutral", sentiment_score$sentiment)
sentiment_score$sentiment <- gsub("^1$|^2$|^3$|^4$", "Positive", sentiment_score$sentiment)
sentiment_score$sentiment <- gsub("^5$|^6$|^7$|^8$|^9$|^10$|^11$|^12$|^13$|^14$|^15$|^16$|^17$|^18$|^19$|^20$|^21$|^22$|^23$|^24$|^25$", "Very Positive", sentiment_score$sentiment)
sentiment_score$sentiment <- gsub("^-1$|^-2$|^-3$|^-4$", "Negative", sentiment_score$sentiment)
sentiment_score$sentiment <- gsub("^-5$|^-6$|^-7$|^-8$|^-9$|^-10$|^-11$|^-12$", "Very Negative", sentiment_score$sentiment)

View(sentiment_score)

#adding sentiment to train
tweet_df$Sentimentscore <- sentiment_score[,2]
tweet_df$SentimentLabel <- sentiment_score[,3]
View(tweet_df)


# Data breach day - 0
# Gather user input - location / name of input data
user_link<-"master_equifax.csv"
ext<-"csv" 

breach_tweets <- download(user_link, ext)

head(breach_tweets)
glimpse(breach_tweets)

# Calculating the sentiment score
sentiment_score <- score.sentiment(breach_tweets$comments.message, pos, neg, .progress='text')
summary(sentiment_score)
View(sentiment_score)

#Convert sentiment scores from numeric to character to enable the gsub function 
sentiment_score$sentiment <- as.character(sentiment_score$score)

#After looking at the summary(sentiment_Score$sentiment) decide on a threshold for the sentiment labels
sentiment_score$sentiment <- gsub("^0$", "Neutral", sentiment_score$sentiment)
sentiment_score$sentiment <- gsub("^1$|^2$|^3$|^4$", "Positive", sentiment_score$sentiment)
sentiment_score$sentiment <- gsub("^5$|^6$|^7$|^8$|^9$|^10$|^11$|^12$|^13$|^14$|^15$|^16$|^17$|^18$|^19$|^20$|^21$|^22$|^23$|^24$|^25$", "Very Positive", sentiment_score$sentiment)
sentiment_score$sentiment <- gsub("^-1$|^-2$|^-3$|^-4$", "Negative", sentiment_score$sentiment)
sentiment_score$sentiment <- gsub("^-5$|^-6$|^-7$|^-8$|^-9$|^-10$|^-11$|^-12$", "Very Negative", sentiment_score$sentiment)

View(sentiment_score)

#adding sentiment to train
breach_tweets$SentimentLabel <- sentiment_score[,3]
View(breach_tweets)
