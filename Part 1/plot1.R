##Plot1 will create a histogram of the Global active power on Feb 1st and 2nd 2007
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

##Create png file device for Histogram, plot it and then exit the device
png(file="plot1.png")
hist(dataneed$Global_active_power, main = "Global Active Power", 
     xlab="Global Active Power(kilowatts)",col="red")
dev.off()

##You will now have plot1.png in your working directory
print("Script complete - Check working directory for file")