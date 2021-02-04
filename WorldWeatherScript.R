# Big Covid Data Project
install.packages("riem")
library("riem")
install.packages("dplyr")
library("dplyr")
install.packages("lubridate")
library(lubridate)
install.packages("zoo")
library(zoo)
install.packages("xts")
library(xts)
############################################################################################
# WEATHER DATA
##########################################################################################################
b <-riem_networks()
country <- unique(b$code)
country1 <- unique(b)

la <- riem_stations(network ="GD_ASOS") # pick station lousiana was giving problems

t <-riem_measures(station = "TGPY", date_start = "2020-01-01",
                       date_end = as.character(Sys.Date()))

temp1 <-NULL;
temp2 <- NULL;
for(i in 1:length(country)){
  tryCatch({ 
  temp0 <- country1$name[i]
  temp1 <- riem_stations(network = country[i])
  temp1 <- cbind(temp1,temp0)
  temp2 <- rbind(temp2,temp1)
  # if an error comes up we continue but we show what was wrong
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
 
  print(i)
}
worldstations <- temp2
colnames(worldstations)[5] <- "country"

st_asos3 <- unique(worldstations$id)

# loop for dataframe 
temp_1 <- NULL; #initalize loop variables
temp_2 <- NULL; # again

# for each unique station until the last one
for(i in 1:length(st_asos3)){
  tryCatch({   # if any errors come up we want to show but continue the loop (no station to aggregate we skip)
    temp_1 <- NULL;
    temp_12 <-NULL;
    # temp_1 this stores weather information for each station starting from beginning of this year 
    temp_1 <-riem_measures(station = as.character(st_asos3[i]), date_start = "2020-01-01",
                           date_end = as.character(Sys.Date()))
    temp_1 = data.frame(temp_1) # then we make data frame varaible out of it
    temp_1$Date <- date(temp_1$valid) # turn the valid column into a date
    temp_1$Day <- lubridate::yday(temp_1$valid) # y day gets day of year ( extract the year day of the date column )
    temp_1$Yearmonthday <- lubridate::ymd(temp_1$Date) # this will be column we use to tell what day it is
    
    # Here we aggregate all the columns we want by the month and day and get average of the variable
    temp_12 <- aggregate(temp_1[,c(5,6,7,8,9)], by =list(temp_1$Yearmonthday), mean, na.action=na.pass, na.rm=TRUE)
    
    temp_12$station <-unique(temp_1$station)
    
    # if an error comes up we continue but we show what was wrong
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  temp_2 <- rbind(temp_2, temp_12) # bind that stations information onto the previous
  
  print(i)
}
weather <- temp_2 # this is the weather data
write.csv(temp_2,file="covid_weather.csv")

##################################################################################################################3
# GOOGLE TREND DATA
##############################
# NOW LETS GET GOOGLE TRENDS DATA FOR CORONA VIRUS
devtools::install_github("PMassicotte/gtrendsR")  # only run once

install.packages("gtrendsR")
## load library 
library(gtrendsR)
library(dplyr)

# LOOP TO GET MORE THAN ONE SEARCH TERM AND BIND THEM TOGETHER!!!!!!!!
res0 <- NULL;
res1 <- NULL;
res2 <- NULL;
res3 <- NULL;
res4 <- NULL;
res5 <- NULL;
res6 <- NULL;
res7 <- NULL;
res8 <- NULL; 
res9 <- NULL;
temp_3 <- NULL;
temp_4<- NULL;
temp_5 <- NULL;
temp_6 <- NULL;
var <- c("covid-19","corona_virus","virus","vaccine","masks")

for(i in 1:length(unique(var))){
  res0 <- NULL;
  res1 <- NULL;
  res2 <- NULL;
  res3 <- NULL;
  res4 <- NULL;
  res5 <- NULL;
  res6 <- NULL;
  res7 <- NULL;
  res8 <- NULL; 
  res9 <- NULL;
  res0 <- gtrends(c(var[i]), geo=c("US-AL","US-AK","US-AZ","US-AR","US-CA"),time = "2020-01-01 2020-04-28")
  res1 <- gtrends(c(var[i]), geo=c("US-CO","US-CT","US-DE","US-FL","US-GA"),time = "2020-01-01 2020-04-28")
  res2 <- gtrends(c(var[i]), geo=c("US-HI","US-ID","US-IL","US-IN","US-IA"),time = "2020-01-01 2020-04-28")
  res3 <- gtrends(c(var[i]), geo=c("US-KS","US-KY","US-LA","US-ME","US-MD"),time = "2020-01-01 2020-04-28")
  res4 <- gtrends(c(var[i]), geo=c("US-MA","US-MI","US-MN","US-MS","US-MO"),time = "2020-01-01 2020-04-28")
  res5 <- gtrends(c(var[i]), geo=c("US-MT","US-NE","US-NV","US-NH","US-NJ"),time = "2020-01-01 2020-04-28")
  res6 <- gtrends(c(var[i]), geo=c("US-NM","US-NY","US-NC","US-ND","US-OH"),time = "2020-01-01 2020-04-28")
  res7 <- gtrends(c(var[i]), geo=c("US-OK","US-OR","US-PA","US-RI","US-SC"),time = "2020-01-01 2020-04-28")
  res8 <- gtrends(c(var[i]), geo=c("US-SD","US-TN","US-TX","US-UT","US-VT"),time = "2020-01-01 2020-04-28")
  res9 <- gtrends(c(var[i]), geo=c("US-VA","US-WA","US-WV","US-WI","US-WY"),time = "2020-01-01 2020-04-28")
  res0 <- data.frame(res0$interest_over_time) 
  res1 <- data.frame(res1$interest_over_time) 
  res2 <- data.frame(res2$interest_over_time)
  res3 <- data.frame(res3$interest_over_time) 
  res4 <- data.frame(res4$interest_over_time) 
  res5 <- data.frame(res5$interest_over_time) 
  res6 <- data.frame(res6$interest_over_time)
  res7 <- data.frame(res7$interest_over_time) 
  res8 <- data.frame(res8$interest_over_time)
  res9 <- data.frame(res9$interest_over_time) 
  temp_3 <- rbind(temp_3,res0,res1,res2)
  temp_4 <- rbind(temp_4,res3,res4,res5,res6)
  temp_5 <- rbind(temp_5,res7,res8,res9)
  temp_6 <- rbind(temp_6,temp_5,temp_4,temp_3)
  
  print(i)
}

#Extract the data frame element of list
res0 <- res0$interest_over_time

# Replace <1 values with 0
res0$hits <- gsub("<1",0,res0$hits) # make na values

# Convert to intiger
res0$hits <- as.integer(res0$hits)

######################################################################################################
# population data, median age and income data links
# https://worldpopulationreview.com/countries/?fbclid=IwAR00GQH4sXsqgh6VKaI0kbpbUHRWYuLKjBrfwtQ4plSJdZXZNYyObC8-k5o
#https://worldpopulationreview.com/countries/median-income-by-country/?fbclid=IwAR0K0LyRmRUVB6k8NfwlyBHB2Hv5rVNfTb9MI-Vepx6ZMvnDh9Afd0_GUTk
#https://worldpopulationreview.com/countries/co2-emissions-by-country/?fbclid=IwAR2Y2o4gSkkFF8ozMBUU-L9XVsks_9ZyT29HNV7xxYoTqjgohrXa9PcK85I
#https://worldpopulationreview.com/countries/median-age/?fbclid=IwAR0Sd_Y1I6YBIJnv5ubcznYqHUbnQa6dJwwstifGHEbgJ-LBCzNBWe1jPjE
