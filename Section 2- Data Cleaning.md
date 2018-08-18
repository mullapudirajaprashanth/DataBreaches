# Section 2: Data Cleaning

Manual data cleaning and transformation is performed on the data by first looking at the data. We can use either the ‘head’ function or ‘glimpse’ function. We run the ‘glimpse’ function from dplyr package, where we can observe that there are 8104 observations (rows) and 9 variables (columns) in the data. Also, all the variables are coded as *‘character’* which is incorrect and not suitable for our analysis.

We must reformat the variables from *‘character’* accordingly to *‘date’, ‘factor’ (categorical)* and *‘integer’ (number)*. 

```
# Section 2 

glimpse(input_data)
```

![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/op1.png)

We reformat the variables: 
•	“Date.Made.Public” to ‘date’ format (‘dmy’ function – ‘lubridate’  package)
•	“Company” to ‘factor’
•	“Location” to ‘factor’
•	“Type.of.Breach” to ‘factor’
•	“Type.of.Organization” to ‘factor’
•	“Information.Source” to ‘factor’
•	“Total.Records” to ‘numeric’ (Remove all symbols and spaces between digits)

```
# we have to format, date to date; total records to numerical, remaining to categorical except description

input_data$Date.Made.Public <- dmy(input_data$Date.Made.Public)

input_data$Company <- as.factor(input_data$Company)
input_data$Location <- as.factor(input_data$Location)
input_data$Type.of.breach <- as.factor(input_data$Type.of.breach)
input_data$Type.of.organization <- as.factor(input_data$Type.of.organization)
input_data$Information.Source <- as.factor(input_data$Information.Source)

input_data$Total.Records <- as.numeric(gsub("\\D", "", input_data$Total.Records)) #removing anything except digits

glimpse(input_data)
```
Now looking at the data, the observations are in the correct format suitable for analysis. 

![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/op2.png)

## Cleaning Incomplete (Missing) Data or NA's

 There are missing values in the data, and a total of 30 observations have missing data or NA’s
  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/op3.jpg)
 
 From the ‘Summary’ we can observe that “Total.Records” variable has the 30 missing values. And the missing rows are below: 
  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/op4.png)
 
 Observing the above Summary output in detail, we see that the Total.Records column contains a few NA’s.
  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/op5.png)
 
 The row indexes with Total.Records as NA are as follows:
  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/op6.png)
 
 The dataframe with only missing data is shown below:
  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/op7.png)
  
Now, we can choose to omit the rows with missing values or replace the missing values with a specific relation with the variable. Here, we choose to delete the rows with missing data and only have complete data. This is stored in a new dataframe ‘data’, and this contains 30 lesser observations than the earlier data at 8074 observations.
```
#now, we can choose to omit the rows with missing values or replace the missing values
# since, there are just 30 records with missing value of the total 8104 rows, we here choose to omit these rows. 
clean_data <- input_data[(which(complete.cases(input_data))),]
```

For better analysis we add a new variable ‘year’ to the dataframe and we convert it to a factor. 
```
# extracting year from date - using lubridate
clean_data$year <- as.factor(format(as.Date(clean_data$Date.Made.Public, format="%Y/%m/%d"),"%Y"))
```

The **Summary** of the **final cleaned data**
 ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/op8.png)
