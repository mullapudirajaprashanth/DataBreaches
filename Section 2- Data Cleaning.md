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
