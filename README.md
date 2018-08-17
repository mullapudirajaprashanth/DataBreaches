# DataBreaches
## STUDY ON DATA BREACHES AND IMPACTS ON CUSTOMERS, USING R

This project is an attempt to analyze and study data breaches in general, and the customer reactions post the Organizations’ statement declaring about the data breaches. Data from two sources are being used here, the first is Privacy Rights Clearinghouse’s dataset about all the 8,638 DATA BREACHES made public since 2005. The other data we will be using for our analysis is Twitter’s user tweets about an Organization (here, “Equifax”). Analyzed and compared the user tweets exactly after the Organization declaring about the breach (Day-0) and the tweets from the present day. Also, those tweet’s sentiments were analyzed.

An Automation function was built that can be re-used to extract data and store in a dataframe. Data can be downloaded from either online, or loaded from the desktop folder, and file formats like .xlsx, .xls, .csv, .json can be extracted. The future scope for this function would be to include other sources like SAS files, SQL Server connection, etc. 

Data Cleaning, Transformation, exploration, Visualization and Word Cloud were built on the Data Breaches data set. Following are the conclusions: 
i) 2016 had the highest number of individual records that were breached, 
ii) BSO (Other Business Organizations) have the highest share of records breached by organization type, 
iii) Most number of records breached by type of breach is HACK technique, 
iv) for organization type like BSO, HACK is the type of breach wherein highest number of records were lost and CARD type of breach has the lowest amongst Govt and NGOs, 
v) Word Cloud based on “Description of Incidents” is generated with significant words, 
vi) Yahoo has the highest number of records breached over all time and also faced multiple data breaches (2 times). 

 Textual Analysis on Customer reactions (tweets) was performed, and tweets were compared. The Day-0 tweets were highly negative compared to the present day’s tweets. 
 
There needs to be a change in the attitudes of business and Government leaders internationally to take the threat of data breaches seriously by improving cybersecurity measures. Consumers who bear the brunt of all types of attacks need to be addressed and remedies provided by the companies.  Organization’s top Management will be under heavy scrutiny, Healthcare will be the next big area for data breaches, IoT has increased the risk for data security (Experian, 2015) 

## INTRODUCTION

### Data Science Process

Data Science is the study of the generalizable extraction of knowledgeable information from data (Dhar, n.d.).  Data Science involves techniques from multiple fields using scientific methods, algorithms and processes (“Data science,” 2018) which helps in transforming raw data into actionable insights for better decision making.  

 ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/image.png)

A typical Data Science model can be explained from the above figure. The first step as a part of any data analysis process would be to extract the data. Importing data into R is not complicated because of the standard libraries and other custom libraries that help in extracting data from multiple sources like files (.xls, .xlsx, .csv, .txt), Databases, JSON, SAS files, Web API, etc. The extracted data can be stored in a dataframe (or a list) for performing analysis. 

After importing the data, we need to tidy (clean) it, to the required form for maintaining consistency. Operations like, removing duplicate information, removing blanks/NA’s, formatting the variables and ensuring each column is a variable and every row an observation. Transformation of data is also done where new variables can be created that can be calculated from the existing data. 

Data Exploration through visualization is the next step in the process, as it can answer the basic questions we pose regarding the data. Visualization helps decision makers to identify patterns and guide us in the process of building a good model. The best way to represent visualization is through plots, charts and graphs.

The next stage in the analytical process is models, they can be custom built according to the requirement for answering the questions precisely. Multiple statistical and other techniques are used in model building. 

The last stage in a data science project is communication to the stakeholders (marketing team, senior management, public, etc.) Data Scientists/ Analysts need to efficiently explain how a conclusion was reached through an easily understandable story and providing insights, highlighting the business impact and opportunity. And finally suggest the next course of action.
