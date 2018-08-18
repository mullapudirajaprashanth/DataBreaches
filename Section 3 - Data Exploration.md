# Section 3: DATA EXPLORATION

Data exploration is an important step in data analysis wherein visual exploration tools help us in better understanding the given data set, it’s characteristics and relations. We will be using ‘ggplot2’, ‘wordcloud’ packages for creating visualizations and understand the data better. 

## Plot 1
### This plot of our study focuses on the number of records and breaches occurred lost over the years.

  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/pl1.png)


From the above plot, we observe that, the year **2012** has the highest number of breaches **(882)** reported. However, we see that the number of records compromised in that year are very minimal. The year **2016** has the highest number of records i.e., **4,61,96,27,058** being compromised in the 812 breaches that were reported during the year. 

Also, we can observe that over the years the number of records breached has increased and is at the peak during the last few years. The hackers have become more innovative and the firms need to increase data protection to keep the information secure(Deborah, n.d.). According to Ponemon Institute over 43% of the companies in USA experienced a data breach in 2014. 

The R code that was used to generate the above plot is below:
```
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
```

## Plot 2
### This plot of our study focuses on the number of records breached by organization. 
We are plotting the data using a pie chart and have used log10 scale on the y-axis for better visualizations. 
  
  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/pl2.png)

The types of organization we have in our data are:
-	BSF – Businesses (Financial and Insurance Services)
-	BSO – Businesses (Others)
-	BSR – Businesses (Retail/Merchant - Including Online Retail)
-	EDU – Educational Institutions
-	GOV – Government & Military
-	MED – Healthcare, Medical Providers & Medical Insurance Services
-	NGO – Nonprofits

From the pie chart, we observe that the Businesses have the highest number of records lost and ‘BSO’ in particular has over **8.5 Billion records** breached over the last 14 years. 

The R code that was used to generate the above plot is below:
```
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
```

## Plot 3
### This plot of our study focuses on the number of records breached by the type of breach occurred.  
We are plotting the data using a pie chart and have used log10 scale on the y-axis for better visualizations. 
  
  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/pl3.png)
  
We can better understand the different types of breaches that take place (Privacy Rights Taxonomy, n.d.)

-	Payment Card Fraud (CARD): Fraud involving debit and credit cards that is not accomplished via hacking. For example, skimming devices at point-of-service terminals.
-	Hacking or Malware (HACK): Hacked by outside party or infected by malware
-	Insider (INSD): Insider (someone with legitimate access intentionally breaches information – such as an employee, contractor or customer)
-	Physical Loss (PHYS): Includes paper documents that are lost, discarded or stolen (non-electronic)
-	Portable Device (PORT): Lost, discarded or stolen laptop, PDA, smartphone, memory stick, CDs, hard drive, data tape, etc.
-	Stationary Device (STAT): Stationary computer loss (lost, inappropriately accessed, discarded or stolen computer or server not designed for mobility)
-	Unintended Disclosure (DISC): Unintended disclosure (not involving hacking, intentional breach or physical loss – for example: sensitive information posted publicly, mishandled or sent to the wrong party via publishing online, sending in an email, sending in a mailing or sending via fax)
-	Unknown (UNKN)

From the pie chart, we can observe that **HACK** is the number one method used during data breaches. The **highest** (75.027 %) number of records were compromised using **Hacking** and the **least** 0.089% records compromised using **Card Frauds**.  

The R code that was used to generate the above plot is below:
```
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
```

## Plot 4
### This plot of our study focuses on giving details about the organization type and type of breach together  
We have used log10 scale on the y-axis for better visualizations. 
  
  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/pl4.png)

From the above plot, we can go into details about the type of breach in each organization. For example, for the **BSO** organization type, it is the **Hacking** that results in most of their data being lost. The **Card frauds** for all the organizational types are minimal and as we observe, the **Government** and **NGOs** have **no** breaches using the **card fraud** type.

The R code that was used to generate the above plot is below:

```
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
```

## Plot 5
### This plot of our study focuses on creating a basic word cloud that represents a maximum of 100 words has been created based on the “Description.of.Incident” column from the data frame.

  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/pl5.png)
  
The top 7 significant words that appear are: 
-	“inform”
-	“breach”
-	“number”
-	“secur”
-	“name”
-	“employe”
-	“social”

The R code that was used to generate the above plot is below:
```
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
```

## Plot 6
### This plot of our study on the top 15 organizations with most records breached over the years along with the number of times the company experienced breaches.  

  ![alt text](https://github.com/mullapudirajaprashanth/DataBreaches/blob/master/Images/pl6.png)

From the plot above, we can observe that **Yahoo** company has the highest number of breached records compromised. Over a Billion records were breached at Yahoo and the breaches occurred 2 times. The plot above displays the top 15 breaches of all time, and although most companies in the list faced breaches only once there are companies like Yahoo, MySpace and Ebay that have 2 breaches in a period of 14 years. The recent major breach of **Equifax** Corporation also makes to the list being in the 11th position where around 143 Million records were compromised. 

The R code that was used to generate the above plot is below:
```
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
```

