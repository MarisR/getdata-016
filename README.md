

----------

GCD-project
Project for Getting and Cleaning Data, Coursera.

The purpose of this project was to demonstrate our ability to collect, work with, and clean a data set. We had to prepare tidy data that can be used for later analysis. The project has to obtain a non-tidy dataset of accelerometers data from the Samsung Galaxy S smartphone (see: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The course instructions were the following:

You should create one R script called run_analysis.R that does the following.
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive activity names.
Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

This Github repository provides a script (run_analysis.R), a tidy dataset (tidymeans.txt), and a codebook (CodeBook.md).

https://github.com/dgraziotin/GCD-project/blob/master/README.md

----------
# Getting and Cleaning Data Course Project #
for course **getdata-016**, December 2014
 
[https://www.coursera.org/course/getdata](https://www.coursera.org/course/getdata)

The purpose of this project is to demonstrate ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis. Students are required to submit:

1. a tidy data set as described below; 
1. a link to a Github repository with your script for performing the analysis;
1. a code book that describes the variables, the data, and any transformations or work that was performed to clean up the data called CodeBook.md.

Student should also include a README.md in the repo with scripts. This repo explains how all of the scripts work and how they are connected.

----------

This Github repository provides a script **run_analysis.R**, a tidy dataset **tidyData.txt**, acodebook **codeBook.md** and this file **README.md**.

----------

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project: 

    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Student should create one R script called run_analysis.R that does the following:
 
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

----------

My **run_analysis.R**

The script was implemented under Microsoft Windows 7 and RStudio
[http://www.rstudio.com/](http://www.rstudio.com/) using package  plyr [http://plyr.had.co.nz/](http://plyr.had.co.nz/).
Be aware that the script takes some time to complete all the steps (~5 minutes at my computer).

Descriptive part about goal, another files and R language:

    # script run_analysis.R is one of 4 files 
    # for course getdata-016 project, December 2014
    # https://www.coursera.org/course/getdata
    
    # README.md describes how the script works
    # codeBook.md describes the variables of result file 
    # tidyData.txt is result file
    
    # R is a language and environment for statistical computing
    # and graphics. More information at http://www.r-project.org/

This part gives instructions for setting working directory at downloaded and unzipped data directory with **setwd** and loads necessery package with **library** and **install.packages**, if not installed.

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

This part merges training and the test sets using **read.table**, **cbind** and **rbind** and assigns column titles

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
    
This part extracts data subset with only the measurements on the mean and standard deviation for each measurement searching *"-std"* or *"-mean("* with **grep**.

    ##########################################################
    # extracts only the measurements on the mean 
    # and standard deviation for each measurement
    # (not meanFreq, gravityMean)
    
    #gets the indexes of columns with "-mean" or "-std" in them
    colGood <-grep("[-]std|[-]mean[(]",colNames)
    dataSubset <- combinedData[,c(1:2,colGood)]
    
   
This part reads activity names from original data file and labels data rows with them using **factor**.

    ##########################################################
    # Use descriptive activity names 
    # to name the activities in the data set
    
    ## Read activity names from activity_labels.txt
    activities <- read.table("activity_labels.txt")
    
    ##########################################################
    # label the data set with descriptive activity names
    dataSubset$Activity <- factor(dataSubset$Activity, levels = activities[, 1], labels = activities[, 2])

This part edits column names  with syntactically valid and descriptive measurement names, using **gsub**. 

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

This part creates data set with the averages of each variable for each activity and each subject using **ddply** from package **plyr** and outputs tidy data to plain text file **tidyData.txt** with comma-separated values using **write.csv** at working directory. 

    ##########################################################
    # Create a second, independent tidy data set with the average
    # of each variable for each activity and each subject
    
    tidyData = ddply(dataSubset, c("Subject","Activity"), numcolwise(mean))
    
    # output data to  txt file
    write.csv(tidyData, "tidyData.txt", row.names = FALSE)

You can obtain help for each used function entering at console ? and its name, for example *?ddply*.

----------

    
This file **README.md** was created with **MarkdownPad 2** [http://markdownpad.com/](http://markdownpad.com/)