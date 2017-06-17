# Quantified Self data processing
# Data obtained using Workflow for iOS

## Packages
library("ggplot2")

## Load from source
selfData <- read.csv("/Users/robsafar/Library/Mobile\ Documents/iCloud~is~workflow~my~workflows/Documents/quantifiedSelf.txt",header=FALSE,na.strings="")

## Cleaning
names(selfData) <- c("DateTime","Postcode","Activity","Notes")
YY <- as.character(selfData$DateTime)
for (i in 1:length(selfData$DateTime)) {
    YY[i] <- paste(substr(selfData$DateTime[i],1,22),substr(selfData$DateTime[i],24,25),sep="")
}
selfData$DateTime <- as.POSIXct(YY, format="%Y-%m-%dT%H:%M:%S%z")
rm(YY)

## Export updated raw data to working directory
write.csv(selfData, file="rawData.csv")

## Manipulating
### Weekdays
wdays <- weekdays(selfData$DateTime)
wdays <- factor(wdays, levels=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"))
selfData$Weekday <- wdays
rm(wdays)
