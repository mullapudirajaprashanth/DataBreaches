# Section 1: Attempt to Automate Data Extraction and/or Cleaning

In this project an attempt was made to build a function to automate the process of Data Extraction and/or Cleaning. The first objective of building an automated function code was achieved, where in a user only needs to provide the data link (“user_link”) and file format (“ext”). The data is imported and stored as a dataframe. Multiple packages are used to achieve this function. Data formats like: **.csv, .xlsx, .xls & .json** can be extracted and stored. 
 
 ```
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
```
 

After multiple efforts, I realized that building a universally acceptable function to clean data is not possible. Data cleaning requires manual intervention to perform specific actions depending on the individual analytical requirement like transformation, creating new calculated variables, etc.

