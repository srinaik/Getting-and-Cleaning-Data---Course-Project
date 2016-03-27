getwd()

file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file, destfile = "Dataset.zip", method = "libcurl")

#Unzip the file

unzip(zipfile = "Dataset.zip", exdir = getwd())
path <- file.path(getwd(), "UCI HAR Dataset")
files <- list.files(path, recursive = TRUE)
files

#Reads the files of the dataset

ActivityTest <- read.table(file.path(path, "test", "Y_test.txt"), header = FALSE)
ActivityTrain <- read.table(file.path(path, "train", "Y_train.txt"), header = FALSE)
SubjectTest <- read.table(file.path(path, "test", "subject_test.txt"), header = FALSE)
SubjectTrain <- read.table(file.path(path, "train", "subject_train.txt"), header = FALSE)
FeaturesTest <- read.table(file.path(path, "test", "X_test.txt"), header = FALSE)
FeaturesTrain <- read.table(file.path(path, "train", "X_train.txt"), header = FALSE)

#Checks for the attributes of the dataset

str(ActivityTest)
str(ActivityTrain)
str(SubjectTest)
str(SubjectTrain)
str(FeaturesTest)
str(FeaturesTrain)

#Concatenation of data tables 

dataSubject <- rbind(SubjectTest, SubjectTrain)
dataActivity <- rbind(ActivityTest, ActivityTrain)
dataFeatures <- rbind(FeaturesTest, FeaturesTrain)

#Setting names to variables

names(dataSubject) <- c("subject")
names(dataActivity) <- c("activity")
dataFeaturesNames <- read.table(file.path(path, "features.txt"), head = FALSE)
names(dataFeatures) <- dataFeaturesNames$V2

#Merging of the data to get the new merged data

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#Extracting the mean and standard deviation for measurements

subdataFeaturesNames <- dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames <- c(as.character(subdataFeaturesNames), "subject", "activity")
Data <- subset(Data, select = selectedNames)
str(Data)

#Assigning descriptive activity names

activityLabels <- read.table(file.path(path, "activity_labels.txt"), header = FALSE)
head(Data$activity, 30)

#Assigning descriptive variable names

names(Data) <- gsub("^t", "time", names(Data))
names(Data) <- gsub("^f", "frequency", names(Data))
names(Data) <- gsub("Acc", "Accelerometer", names(Data))
names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("Mag", "Magnitude", names(Data))
names(Data) <- gsub("BodyBody", "Body", names(Data))

names(Data)

#Create tidy data
install.packages("plyr")
Data1 <- aggregate(.~subject + activity, Data, mean)
Data1 <- Data1[order(Data1$subject, Data1$activity),]
write.table(Data1, file = "tidydata.txt", row.name = FALSE)
