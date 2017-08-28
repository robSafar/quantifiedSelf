# quantifiedSelf Data Processing

## Load from source
selfData <- read.csv("~/Library/Mobile\ Documents/iCloud~is~workflow~my~workflows/Documents/quantifiedSelf.txt",header=FALSE,na.strings="")

## Cleaning
names(selfData) <- c("DateTime","Postcode","Activity","Notes")
YY <- as.character(selfData$DateTime)
for (i in 1:length(selfData$DateTime)) {
    YY[i] <- paste(substr(selfData$DateTime[i],1,22),substr(selfData$DateTime[i],24,25),sep="")
}
selfData$DateTime <- as.POSIXct(YY, format="%Y-%m-%dT%H:%M:%S%z")
rm(YY)

### Export clean data to working directory
write.csv(selfData, file="rawData.csv")

## Manipulation
selfData$Date <- as.Date(selfData$DateTime)

### Averages by weekday
dailyTotals <- as.data.frame.matrix(table(selfData$Date, selfData$Activity))
dailyTotals$weekday <- weekdays(as.Date(row.names(dailyTotals)))
dailyTotals$weekday <- factor(dailyTotals$weekday, levels=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"))
wdayAvg <- NULL
for (i in 1:length(levels(selfData$Activity))) {
    wdayAvg <- rbind(wdayAvg,
                     data.frame(
                         rep(colnames(dailyTotals)[i],7),
                         levels(dailyTotals$weekday),
                         tapply(dailyTotals[,i], dailyTotals$weekday, mean)
                     )
    )
}
colnames(wdayAvg) <- c("Activity","Weekday","Average") ; rownames(wdayAvg) <- NULL ; wdayAvg$Weekday <- factor(wdayAvg$Weekday, levels=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"))