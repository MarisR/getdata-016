##########################################################
# script run_analysis.R is one of 4 files 
# for course getdata-016 project, December 2014
# https://www.coursera.org/course/getdata

# README.md describes how the script works
# codeBook.md describes the variables of result file 
# tidyData.txt is result file

# R is a language and environment for statistical computing
# and graphics. More information at http://www.r-project.org/

##########################################################
# set working directory where are downloaded and unzipped data from
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# my working directory is
setwd("D:/M2014/!DataScienceCourses/GettingData/Project/UCI HAR Dataset")

# load packages
if(!require(plyr)){
  install.packages("plyr")
  library(plyr)
}

##########################################################
# read training data and combine at one dataset by colomns
trainData <- read.table("train/X_train.txt")
trainSubj <- read.table("train/subject_train.txt")
trainActi <- read.table("train/Y_train.txt")
trainDataComb <- cbind(trainSubj,trainActi,trainData)

# read test data and combine at one dataset by colomns
testData <- read.table("test/X_test.txt")
testSubj <- read.table("test/subject_test.txt")
testActi <- read.table("test/Y_test.txt")
testDataComb <- cbind(testSubj,testActi,testData)

# combine training and test data by rows
combinedData <- rbind(trainDataComb,testDataComb)

# read features.txt and assign to column titles
features <- read.table("features.txt")
colNames <- c("Subject","Activity",as.character(features[,2]))
names(combinedData) <- colNames

##########################################################
# extracts only the measurements on the mean 
# and standard deviation for each measurement
# (not meanFreq, gravityMean)

#gets the indexes of columns with "-mean" or "-std" in them
colGood <-grep("[-]std|[-]mean[(]",colNames)
dataSubset <- combinedData[,c(1:2,colGood)]

##########################################################
# Use descriptive activity names 
# to name the activities in the data set

## Read activity names from activity_labels.txt
activities <- read.table("activity_labels.txt")

##########################################################
# label the data set with descriptive activity names
dataSubset$Activity <- factor(dataSubset$Activity, levels = activities[, 1], labels = activities[, 2])

# label the data set with descriptive measurement names
# Remove parentheses
names(dataSubset) <- gsub('\\(|\\)',"",names(dataSubset), perl = TRUE)
# Make syntactically valid names
names(dataSubset) <- make.names(names(dataSubset))
# Make clearer names
names(dataSubset) <- gsub('^t', "TimeDomain.", names(dataSubset))
names(dataSubset) <- gsub('^f', "FrequencyDomain.", names(dataSubset))

names(dataSubset) <- gsub('Acc', "Acceleration", names(dataSubset))
names(dataSubset) <- gsub('GyroJerk', "AngularAcceleration", names(dataSubset))
names(dataSubset) <- gsub('Gyro', "AngularSpeed", names(dataSubset))
names(dataSubset) <- gsub('Mag',"Magnitude", names(dataSubset))

names(dataSubset) <- gsub('BodyBody', "Body", names(dataSubset))

##########################################################
# Create a second, independent tidy data set with the average
# of each variable for each activity and each subject

tidyData = ddply(dataSubset, c("Subject","Activity"), numcolwise(mean))

# output data to  txt file
write.csv(tidyData, "tidyData.txt", row.names = FALSE)
