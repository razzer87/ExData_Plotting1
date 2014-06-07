##Plot4 will create an image wuth 4 graphs of various readings on Feb 1st and 2nd 2007
##It will download the data into a temp file direct from the URL given in the
##assignment. Note that as this script contains no function definitions, it will
##run when sourced. Also, I did not use fread or filter the file when reading, so
##be wary of memory issues.

##Create a tempfile and download zip file to it
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)

print("File Downloaded")

##File is big, so first we read a bit of the data and determine the column classes

initial <- read.table(unz(temp,"household_power_consumption.txt"),nrows=100,
                      header=TRUE,sep=";",na.strings="?")

classes <- sapply(initial,class)

print("Begining file read")
##Now we read whole file, using classes to make it more efficient
data <- read.table(unz(temp,"household_power_consumption.txt"),
                   colClasses = classes,header=TRUE,sep=";",na.strings="?")
print("File is read")

unlink(temp)

##Extract the days we are interested in.
print("Filtering out days of interest")
dataneed <- subset(data,as.Date("2007-02-01")<=as.Date(data$Date,"%d/%m/%Y") 
                   & as.Date(data$Date,"%d/%m/%Y")<=as.Date("2007-02-02"))

print("Begin Plot")
##Create png file device for plot, plot it and then exit the device
png(file="plot4.png")

## Set to 2x2 grid
par(mfrow = c(2,2))

## Combine date and time strings and use strptime to turn them into timestamps
dataneed$Timestamp <- strptime(paste(dataneed$Date, dataneed$Time), "%d/%m/%Y %H:%M:%S")

## Top left graph
plot(dataneed$Timestamp,dataneed$Global_active_power, type="l", xlab="",ylab="Global Active Power(Kilowatts)")

## Top right graph
plot(dataneed$Timestamp,dataneed$Voltage, type="l", xlab="datetime",ylab="Voltage")

## Bottom left graph
with(dataneed, plot(Timestamp,Sub_metering_1,type="l",xlab="",ylab="Energy sub metering"))
with(dataneed, points(Timestamp,Sub_metering_2,type="l",col="red"))
with(dataneed, points(Timestamp,Sub_metering_3,type="l",col="blue"))
legend("topright",lwd=1,col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       bty="n")

## Bottom right graph
plot(dataneed$Timestamp,dataneed$Global_reactive_power, type="l", xlab="datetime",ylab="Global_reactive_power")



dev.off()

##You will now have plot1.png in your working directory
print("Script complete - Check working directory for file")