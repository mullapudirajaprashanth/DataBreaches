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


