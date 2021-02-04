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
install.packages("reshape2")
library(reshape2)


# set working directory
setwd("C:/Users/btindol/OneDrive - Stryker/Python Scripts/GlobalDatabaseExtractionToMYSQL/CustomerGlobalIntelligenceScripts")


# ############################################################################################
# # WEATHER DATA
# ##########################################################################################################
# 
# 
# b <-riem_networks()
# country <- unique(b$code)
# country1 <- unique(b)
# 
# la <- riem_stations(network ="GD_ASOS") # pick station lousiana was giving problems
# 
# t <-riem_measures(station = "TGPY", date_start = "2020-01-01",
#                   date_end = as.character(Sys.Date()))
# 
# temp1 <-NULL;
# temp2 <- NULL;
# for(i in 1:length(country)){
#   tryCatch({ 
#     temp0 <- country1$name[i]
#     temp1 <- riem_stations(network = country[i])
#     temp1 <- cbind(temp1,temp0)
#     temp2 <- rbind(temp2,temp1)
#     # if an error comes up we continue but we show what was wrong
#   }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
#   
#   print(i)
# }
# worldstations <- temp2
# colnames(worldstations)[5] <- "country"
# 
# st_asos3 <- unique(worldstations$id)
# 
# # loop for dataframe 
# temp_1 <- NULL; #initalize loop variables
# temp_2 <- NULL; # again
# 
# # for each unique station until the last one
# for(i in 1:length(st_asos3)){
#   tryCatch({   # if any errors come up we want to show but continue the loop (no station to aggregate we skip)
#     temp_1 <- NULL;
#     temp_12 <-NULL;
#     # temp_1 this stores weather information for each station starting from beginning of this year 
#     temp_1 <-riem_measures(station = as.character(st_asos3[i]), date_start = "2020-01-01",
#                            date_end = as.character(Sys.Date()))
#     temp_1 = data.frame(temp_1) # then we make data frame varaible out of it
#     temp_1$Date <- date(temp_1$valid) # turn the valid column into a date
#     temp_1$Day <- lubridate::yday(temp_1$valid) # y day gets day of year ( extract the year day of the date column )
#     temp_1$Yearmonthday <- lubridate::ymd(temp_1$Date) # this will be column we use to tell what day it is
#     
#     # Here we aggregate all the columns we want by the month and day and get average of the variable
#     temp_12 <- aggregate(temp_1[,c(5,6,7,8,9)], by =list(temp_1$Yearmonthday), mean, na.action=na.pass, na.rm=TRUE)
#     
#     temp_12$station <-unique(temp_1$station)
#     
#     # if an error comes up we continue but we show what was wrong
#   }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
#   temp_2 <- rbind(temp_2, temp_12) # bind that stations information onto the previous
#   
#   print(i)
# }
# weather <- temp_2 # this is the weather data
# write.csv(temp_2,file="covid_weather.csv")

##################################################################################################################3
# GOOGLE TREND DATA

############################################################
# To get every day change the time range for each day iterate through it

# Dataframe of date ranges the format needed for loop
daterange = read.csv("dateranges.csv");colnames(daterange)[1]<- "daterange";
#us-al state code mapping for loop..
statemapping = read.csv("stateabbriviationmapping.csv");colnames(statemapping)[1]<- "state";

# For short testing..
daterange = daterange[c(1:5),];daterange = data.frame(daterange)
#statemapping = statemapping[-c(1,2,3)];
statemapping = head(statemapping,n=3)
#statemapping = as.vector(statemapping)

############################################################################################
# STARTING TO WORK!!!!!!!!!!!!!!!!!!
#var = "covid";
#JUST PASS IN VAR LIST.


var = c("covid","programming")

# EVEN THOUG DATE CAN ONLY BE BY WEEK THE TIME FRAME WILL STILL PULL THAT DAY AND LABEL DATE AS SIMILAR DATE BECAUSE TIME IS INSIDE DATE WINDOW OF THAT WEEK!!!!!
getdailytrendsbystate <-function(var) {
  
#daterange = read.csv("dateranges.csv");colnames(daterange)[1]<- "daterange";
#statemapping = read.csv("stateabbriviationmapping.csv");colnames(statemapping)[1]<- "state";  
#daterange = daterange[c(1:376),];daterange = data.frame(daterange)
#statemapping = head(statemapping,n=50)
mapping = read.csv("C:/Users/btindol/OneDrive - Stryker/Python Scripts/GlobalDatabaseExtractionToMYSQL/CustomerGlobalIntelligenceScripts/stateabbriviationmapping.csv",encoding = "ISO-8859-1");colnames(mapping) <-c("state","state code","country","geo");
tempinner= NULL;
tempouter = NULL;
tempoutermost = NULL;
for(z in 1:length(unique(var))){ # 
  print(paste("Grabbing variable",var[z]))
  for(i in 1:length(unique(statemapping$statecode))){
    state = statemapping$statecode[i]
    print(paste("For state",state))
    for(j in 1:length(unique(daterange$daterange))){
      res1=NULL;
      tryCatch({
      time = daterange$daterange[j]
      print(paste("for time range",time))
      res1 <- gtrends(c(var[z]), geo=state,time = time)#$interest_by_city IF YOU WANT INFORMATION BY CITY 
      res1 <- data.frame(res1$interest_over_time)  # make that iteration of res1 a dataframe 
      tempinner <- rbind(tempinner,res1) # bind the dataframe to tempinner
      print(paste("done inner loop for var",var,"for state",state,"in time range",time))
      }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
    }
    tempouter <- rbind(tempouter,tempinner)
    print(paste("done binding outter loop for var",var,"state",state,"in the time range",time))
  
  }
  tempoutermost <- rbind(tempoutermost,tempouter)
  
 }
tempoutermost$hits <- gsub("<1",0,tempoutermost$hits);tempoutermost$hits <- as.integer(tempoutermost$hits)
tempoutermost = unique(tempoutermost) # Remove duplicates after all the mess
  #data_wide <- dcast(tempouter, date + time +geo ~ keyword, value.var="hits")
  #data_wide <- merge(mapping,data_wide,by=c("geo"),all.x=TRUE)
  #colnames(data_wide)[1] <-"geo";colnames(data_wide)[2] <-"state";colnames(data_wide)[3] <-"state_code";colnames(data_wide)[4] <-"country";colnames(data_wide)[5] <-"weekof";colnames(data_wide)[6] <-"date";
  #data_wide$id = paste0(data_wide$state,"_",data_wide$date)
   #data_wide = data_wide[-c(1)] # REMOVE GEO
  # make sure working directory is good 
  #setwd("C:/Users/btindol/OneDrive - Stryker/Python Scripts/GlobalDatabaseExtractionToMYSQL/CustomerGlobalIntelligenceScripts")
  #write.csv(data_wide,file="dailytrendsbystate.csv")
  return(tempoutermost)
}
#RUN THIS ONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#################################
#################################
#################################
dailytrendsbystate= getdailytrendsbystate(var)

#################################
#################################
#################################
##CANNOT GET DAILY TRENDS FOR INTEREST BY CITY... NEED TO HAVE DIFFERENT TIME FRAME.. PICK.

time2 ="now 7-d"; 
# c("now 1-H","now 4-H","now 1-d","now 7-d","today 1-m","today 3-m","today 12-m")
##CANNOT GET DAILY TRENDS FOR INTEREST BY CITY... NEED TO HAVE DIFFERENT TIME FRAME.. PICK.
getdailytrendsbycity <-function(var) {
  tempinner= NULL;
  tempouter = NULL;
  for(z in 1:length(unique(var))){
    print(paste("Grabbing variable",var[z]))
    for(i in 1:length(unique(statemapping$statecode))){
      res1 = NULL;
      state = statemapping$statecode[i]
      print(paste("For state",state))
      res1 <- gtrends(c(var[z]), geo=state,time = time2)$interest_by_city 
      res1 <- data.frame(res1)  # make that iteration of res1 a dataframe 
      tempinner <- rbind(tempinner,res1) # bind the dataframe to tempinner
      print(paste("done inner loop for var",var,"for state",state,"in time range",time))
      
     # tempouter <- rbind(tempouter,tempinner)
      #print(paste("done binding outter loop for var",var,"state",state,"in the time range",time))
      
    }
  }
  tempinner[is.na(tempinner)]<- 0;tempinner$hits <- as.integer(tempinner$hits)
  tempinner = unique(tempinner) # Remove duplicates after all the mess
  return(tempinner)
}
trendsbycitylast7days <- getdailytrendsbycity(var)


#########################




devtools::install_github("PMassicotte/gtrendsR")  # only run once

install.packages("gtrendsR")
## load library 
library(gtrendsR)
library(dplyr)

library(httr)    
set_config(use_proxy(url="10.3.100.207",port=8080))


#symptoms <- read.csv("symptoms.csv"); colnames(symptoms)[1] <- "symptoms"
#var <- as.vector(symptoms$symptoms)
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
var <- c("covid-19","corona_virus","shortness of breath","joint replacement","bone repair","head ache","neck pain","fever","Angioplasty","diabetes","Stent","Hysterectomy","Gallbladder Removal","Heart Bypass Surgery","stroke","heart attack","back pain","knee pain","joint replacement","Appendicitis","lung cancer","cancer","asthma","Lower respiratory infections","Chronic obstructive pulmonary disease","Alzheimer's","Tuberculosis","cough","runny nose","high temperature","sore throat","vomit","diarrhea","pelvic pain","numbness","wheezing","swelling")

for(i in 1:length(unique(var))){
  print(i)
  tryCatch({
  res0 <- NULL;  res1 <- NULL;  res2 <- NULL;  res3 <- NULL;  res4 <- NULL;  res5 <- NULL;  res6 <- NULL;  res7 <- NULL;  res8 <- NULL;   res9 <- NULL;
  res0 <- gtrends(c(var[i]), geo=c("US-AL","US-AK","US-AZ","US-AR","US-CA"),time = "2020-01-01 2021-01-30")#$interest_by_city IF YOU WANT INFORMATION BY CITY 
  res1 <- gtrends(c(var[i]), geo=c("US-CO","US-CT","US-DE","US-FL","US-GA"),time = "2020-01-01 2021-01-30")#$interest_by_city IF YOU WANT INFORMATION BY CITY 
  res2 <- gtrends(c(var[i]), geo=c("US-HI","US-ID","US-IL","US-IN","US-IA"),time = "2020-01-01 2021-01-30")#$interest_by_city IF YOU WANT INFORMATION BY CITY 
  res3 <- gtrends(c(var[i]), geo=c("US-KS","US-KY","US-LA","US-ME","US-MD"),time = "2020-01-01 2021-01-30")#$interest_by_city IF YOU WANT INFORMATION BY CITY 
  res4 <- gtrends(c(var[i]), geo=c("US-MA","US-MI","US-MN","US-MS","US-MO"),time = "2020-01-01 2021-01-30")#$interest_by_city IF YOU WANT INFORMATION BY CITY 
  res5 <- gtrends(c(var[i]), geo=c("US-MT","US-NE","US-NV","US-NH","US-NJ"),time = "2020-01-01 2021-01-30")#$interest_by_city IF YOU WANT INFORMATION BY CITY 
  res6 <- gtrends(c(var[i]), geo=c("US-NM","US-NY","US-NC","US-ND","US-OH"),time = "2020-01-01 2021-01-30")#$interest_by_city IF YOU WANT INFORMATION BY CITY 
  res7 <- gtrends(c(var[i]), geo=c("US-OK","US-OR","US-PA","US-RI","US-SC"),time = "2020-01-01 2021-01-30")#$interest_by_city IF YOU WANT INFORMATION BY CITY 
  res8 <- gtrends(c(var[i]), geo=c("US-SD","US-TN","US-TX","US-UT","US-VT"),time = "2020-01-01 2021-01-30")#$interest_by_city IF YOU WANT INFORMATION BY CITY 
  res9 <- gtrends(c(var[i]), geo=c("US-VA","US-WA","US-WV","US-WI","US-WY"),time = "2020-01-01 2021-01-30")#$interest_by_city IF YOU WANT INFORMATION BY CITY 
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
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  print(i)
  
}

temp_3$hits <- gsub("<1",0,temp_3$hits);temp_3$hits <- as.integer(temp_3$hits)
temp_4$hits<- gsub("<1",0,temp_4$hits);temp_4$hits <- as.integer(temp_4$hits) # make na values
temp_5$hits<- gsub("<1",0,temp_5$hits);temp_5$hits <- as.integer(temp_5$hits) # make na values


#write.csv(temp_6,file="symptomtrends.csv")
#write.table(temp_6, file = "symptomtrends.txt", sep = "\t",)

# send them like this make it easier
write.csv(temp_3,file="trends1.csv")
write.csv(temp_4,file="trends2.csv")
write.csv(temp_5,file="trends3.csv")


######################################################################################################
# population data, median age and income data links
# https://worldpopulationreview.com/countries/?fbclid=IwAR00GQH4sXsqgh6VKaI0kbpbUHRWYuLKjBrfwtQ4plSJdZXZNYyObC8-k5o
#https://worldpopulationreview.com/countries/median-income-by-country/?fbclid=IwAR0K0LyRmRUVB6k8NfwlyBHB2Hv5rVNfTb9MI-Vepx6ZMvnDh9Afd0_GUTk
#https://worldpopulationreview.com/countries/co2-emissions-by-country/?fbclid=IwAR2Y2o4gSkkFF8ozMBUU-L9XVsks_9ZyT29HNV7xxYoTqjgohrXa9PcK85I
#https://worldpopulationreview.com/countries/median-age/?fbclid=IwAR0Sd_Y1I6YBIJnv5ubcznYqHUbnQa6dJwwstifGHEbgJ-LBCzNBWe1jPjE

var <- c("covid-19","corona_virus","virus","vaccine","masks")

trends_AL_CA <- function(var) {
  res0 <- NULL;
  temp_1 <-NULL;
  for(i in 1:length(var)){
    print(i)
    res0 <- NULL; 
    tryCatch({
      res0 <- gtrends(c(var[i]), geo=c("US-AL","US-AK","US-AZ","US-AR","US-CA"),time = "2020-01-01 2021-01-30")
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
    res0 <- data.frame(res0$interest_over_time) 
    print(i)
    temp_1 <- rbind(temp_1,res0)
  }
  
}


trends_CO_GA <- function(var) {
  res0 <- NULL;
  temp_2 <-NULL;
  for(i in 1:length(var)){
    print(i)
    tryCatch({
      res0 <- gtrends(c(var[i]), geo=c("US-CO","US-CT","US-DE","US-FL","US-GA"),time = "2020-01-01 2021-01-30")
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
    res0 <- data.frame(res0$interest_over_time) 
    print(i)
    temp_2 <- rbind(temp_2,res0)
  }
}

trends_HI_IA <- function(var) {
  res0 <- NULL;
  temp_3 <-NULL;
  for(i in 1:length(var)){
    print(i)
    res0 <- NULL; 
    tryCatch({
      res0 <- gtrends(c(var[i]), geo=c("US-HI","US-ID","US-IL","US-IN","US-IA"),time = "2020-01-01 2021-01-30")
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
    res0 <- data.frame(res0$interest_over_time) 
    print(i)
    temp_3 <- rbind(temp_3,res0)
  }
}

trends_KS_MD <- function(var) {
  res0 <- NULL;
  temp_4 <-NULL;
  for(i in 1:length(var)){
    print(i)
    tryCatch({
      res0 <- gtrends(c(var[i]), geo=c("US-KS","US-KY","US-LA","US-ME","US-MD"),time = "2020-01-01 2021-01-30")
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
    res0 <- data.frame(res0$interest_over_time) 
    print(i)
    temp_4 <- rbind(temp_4,res0)
  }
}


trends_MA_MO <- function(var) {
  res0 <- NULL;
  temp_5 <-NULL;
  for(i in 1:length(var)){
    print(i)
    res0 <- NULL; 
    tryCatch({
      res0 <- gtrends(c(var[i]), geo=c("US-MA","US-MI","US-MN","US-MS","US-MO"),time = "2020-01-01 2021-01-30")
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
    res0 <- data.frame(res0$interest_over_time) 
    print(i)
    temp_5 <- rbind(temp_5,res0)
  }
}


trends_MT_NJ <- function(var) {
  res0 <- NULL;
  temp_6 <-NULL;
  for(i in 1:length(var)){
    print(i)
    res0 <- NULL; 
    tryCatch({
      res0 <- gtrends(c(var[i]), geo=c("US-MT","US-NE","US-NV","US-NH","US-NJ"),time = "2020-01-01 2021-01-30")
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
    res0 <- data.frame(res0$interest_over_time) 
    print(i)
    temp_6 <- rbind(temp_6,res0)
  }
}

trends_NM_OH <- function(var) {
  res0 <- NULL;
  temp_7 <-NULL;
  for(i in 1:length(var)){
    print(i)
    res0 <- NULL; 
    tryCatch({
      res0 <- gtrends(c(var[i]), geo=c("US-NM","US-NY","US-NC","US-ND","US-OH"),time = "2020-01-01 2021-01-30")
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
    res0 <- data.frame(res0$interest_over_time) 
    print(i)
    temp_7 <- rbind(temp_7,res0)
  }
}

trends_OK_SC <- function(var) {
  res0 <- NULL;
  temp_8 <-NULL;
  for(i in 1:length(var)){
    print(i)
    res0 <- NULL; 
    tryCatch({
      res0 <- gtrends(c(var[i]), geo=c("US-OK","US-OR","US-PA","US-RI","US-SC"),time = "2020-01-01 2021-01-30")
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
    res0 <- data.frame(res0$interest_over_time) 
    print(i)
    temp_8 <- rbind(temp_8,res0)
  }
}


trends_SD_VT <- function(var) {
  res0 <- NULL;
  temp_9 <-NULL;
  for(i in 1:length(var)){
    print(i)
    res0 <- NULL; 
    tryCatch({
      res0 <- gtrends(c(var[i]), geo=c("US-SD","US-TN","US-TX","US-UT","US-VT"),time = "2020-01-01 2021-01-30")
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
    res0 <- data.frame(res0$interest_over_time) 
    print(i)
    temp_9 <- rbind(temp_9,res0)
  }
}

temp_10 <-NULL;

trends_VA_WY <- function(var) {
  res0 <- NULL;
  temp_10 <-NULL;
  for(i in 1:length(var)){
    print(i)
    res0 <- NULL; 
    tryCatch({
      res0 <- gtrends(c(var[i]), geo=c("US-VA","US-WA","US-WV","US-WI","US-WY"),time = "2020-01-01 2021-01-30")
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
    res0 <- data.frame(res0$interest_over_time) 
    print(i)
    temp_10 <- rbind(temp_10,res0)
    temp_10 <- data.frame(temp_10)
  }
  return(temp_10)
  
}

trends_AL_CA(var)
trends_CO_GA(var)
trends_HI_IA(var)
trends_KS_MD(var)
trends_MA_MO(var)
trends_MT_NJ(var)
trends_NM_OH(var)
trends_OK_SC(var)
trends_SD_VT(var)
trends_VA_WY(var)

