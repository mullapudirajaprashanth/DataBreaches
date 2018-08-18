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
-•	BSF – Businesses (Financial and Insurance Services)
-•	BSO – Businesses (Others)
-•	BSR – Businesses (Retail/Merchant - Including Online Retail)
-•	EDU – Educational Institutions
-•	GOV – Government & Military
-•	MED – Healthcare, Medical Providers & Medical Insurance Services
-•	NGO – Nonprofits

From the pie chart, we observe that the Businesses have the highest number of records lost and ‘BSO’ in particular has over 8.5 Billion records breached over the last 14 years. 

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




