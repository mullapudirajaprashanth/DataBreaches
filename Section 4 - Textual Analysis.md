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
