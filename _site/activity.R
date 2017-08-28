# Activity processing
## This script is dependent upon objects created in script.R

library(XML)
library(lubridate)
library(reshape2)

if(!exists("activity")) {
    if(!file.exists("~/Downloads/apple_health_export/export.xml")) {
        unzip("export.zip")
    }
    ## Credit to https://gist.github.com/ryanpraski/ba9baee2583cfb1af88ca4ec62311a3d for this (now modified) snippet:
    #load apple health export.xml file
    xml <- xmlParse("~/Downloads/apple_health_export/export.xml")
    #transform xml file to data frame - select the Record rows from the xml file
    activity <- XML:::xmlAttrsToDataFrame(xml["//Record"])
    rm(xml)
    #make value variable numeric
    activity$value <- as.numeric(as.character(activity$value))
    #make endDate in a date time variable POSIXct using lubridate with time zone
    activity$endDate <-ymd_hms(activity$endDate,tz="Europe/London")
    activity$date<-format(activity$endDate,"%Y-%m-%d")
    
    ## Only activity data that corresponds to consumption dates
    activity <- subset(activity, date == rownames(dailyTotals))
}

caloriesActive <- subset(activity, type == "HKQuantityTypeIdentifierActiveEnergyBurned")
caloriesActive <- data.frame(tapply(caloriesActive$value, caloriesActive$date, sum))
colnames(caloriesActive) <- "kcals"

dailyTotals <- merge(dailyTotals, caloriesActive, by="row.names", all.x=TRUE)
dailyTotals$weekday <- NULL
colnames(dailyTotals)[1] <- "date"

activityVsConsumption <- melt(dailyTotals[1:length(colnames(dailyTotals))-1])
activityVsConsumption$kcals <- rep(dailyTotals$kcals, length(levels(selfData$Activity)))