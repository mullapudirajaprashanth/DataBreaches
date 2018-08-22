# Section 4: Textual Analysis

We plan to perform textual analysis on the customer’s tweets post Equifax declaring about the data breach. The first step in this process would be to extract all the relevant tweets from Twitter’s API. Post cleaning the data we would like to perform sentiment analysis on the customer reactions. There also other metrics we wish to measure that are explained below.

## 1) Twitter Extraction:

To scrape tweets from Twitter API, I first set up my Twitter Developer account, which provides access tokens and allows for R-Twitter Authentication handshake.  
```
# Section 4

# Information from Twitter Developer account
key = "194x2bmgvoGAzEOyn####Hz"
secret = "UkdZAm67OHncpxdKjyllOYKhgaBV#####kNxD94zgQYEEBO1zX"
secrettk = "W2UIL97PrRreYhCGZM86kYL#####iRrKPTFnvn7VVAhL"      #Access Token Secret from Twitter
mytoken = "52714471-US5Z4KYxwNUyVaKNBl4G#####GpRUaFxTS2GT02U"  #Access token from Twitter

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
5####51

save(authenticate, file="twitter authentication.Rdata")

# Setting up Twitter Authentication
setup_twitter_oauth(key, secret, mytoken, secrettk) # (1) choose direct authentication
```

## 2) Extracting Tweets:

Using ‘searchTwitter’ function, 1000 tweets were requested based on the hashtag “#Equifax”. The extracted tweets are stored in the list tweets. 

```
tweets = searchTwitter("#Equifax", n=1000)

userTimeline("Equifax")

class(tweets)
length(tweets)
head(tweets)
```

Here, it is observed that, although we requested for 1000 documents, we get only 406. This is because, Twitter allows data scraping only for the recent few days i.e., the last 15 days. 

  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/tw1.png)

## 3) Cleaning Extracted Data:

The tweets that are stored in the list are cleaned and formatted. The list is initially converted into a corpus, then functions like transforming text lo lower, removing punctuations, removing stopwords are performed. 

```
list <- sapply(tweets, function(x) x$getText()) 
corpus <- VCorpus(VectorSource(list)) 
corpus <- tm_map(corpus, function(x) iconv(x, "latin1", "ASCII", sub=""))
corpus <- tm_map(corpus, tolower) 
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus,
                 function(x)removeWords(x,stopwords())) # remove stopwords (meaningless words)

# to trasform to plain text which wordcloud can use
corpus <- tm_map(corpus, PlainTextDocument)
```

## 4) Word Cloud:

For the present extracted Twitter data, a ‘Word Cloud’ is generated. 

  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/tw2.png)
  
From the above Word Cloud the Top 5 significant words that appear are:

-	 “equifax”
-	“breach”
-	“data”
-	“security”
-	“credit”

The R code used for generating the above Word Cloud is shown below:
```
pal <- brewer.pal(8, "Dark2")

plot7 <- wordcloud(corpus, 
                   scale = c(7,1),
                   min.freq = 4, max.words = 45,
                   random.order = F,
                   rot.per = .15,
                   colors = pal
)

print(plot7)
```

The sparsity tells us the relation between tweets and documents. Here, it is observed that the **sparsity** for the extracted data is **99%**. 

  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/tw3.png)

The Terms in the data extracted with a minimum frequency of 20 are shown below:

  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/tw4.png)

## 4) Sentiment Analysis:

On conducting sentiment analysis on the recent extracted data, we observe the following sentiment scores. The **minimum** score being **-3.0** and **maximum** score being **+3.0** with a **mean** of **-0.1626**.

  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/tw5.png)
  
The R code used to obtain the above results is as follows. An **user-defined** function **score.sentiment** is defined to perform the necessary job. 

```
# SENTIMENT ANALYSIS

pos = readLines("positive_words.txt")
neg = readLines("negative_words.txt")

tweet_df <- as.data.frame(list)

require("plyr")
require("stringr")
```

```
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
```
```
sentiment_score <- score.sentiment(list, pos, neg, .progress='text')
summary(sentiment_score)
View(sentiment_score)
```

```
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
```

From the sentiment analysis conducted on the extracted data, I hereby conclude that the sentiments are not so positive and not so negative. The average sentiment score is near neutral. 

