## Coursera Data Science Specialization: Getting and Cleaning Data Course Project
## Xinshi Zheng
## September 27 2015

## File Description:
## This script will perform data cleaning on the UCI Human Activity Recognition Using Smartphones Data Set obtained from:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## Following tasks will be performed:
## 1. Merges the training and the test sets to create one data set;
## 2. Extracts only the measurements on the mean and standard deviation for each measurement; 
## 3. Uses descriptive activity names to name the activities in the data set;
## 4. Appropriately labels the data set with descriptive variable names;
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Empty workspace:
rm(list = ls())

## Import data from files:

# Activity name:
activitylabels <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

# Feature list:
features <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")

# Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30:
subjecttest <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

# Test set:
xtest <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")

# Test labels:
ytest <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt")

# Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30:
subjecttrain <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

# Training set:
xtrain <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")

# Training labels:
ytrain <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt")


## Extracting measurements on the mean and standard deviation for each measurement:
features[,2] <- as.character(features[,2])
meanandstd <- grep(".*mean.*|.*std.*", features[,2])
meanandstdname <- features[meanandstd,2]
meanandstdname <- gsub("-mean", "Mean", meanandstdname)
meanandstdname <- gsub("-std", "Std", meanandstdname)
meanandstdname <- gsub("[-()]", "", meanandstdname)
xtrain <- xtrain[meanandstd]
xtest <- xtest[meanandstd]


## Merging dataset and renaming columns:

train <- cbind(subjecttrain, ytrain, xtrain)
test <- cbind(subjecttest, ytest, xtest)
data <- rbind(train, test)
colnames(data) <- c("Subject", "Activity", meanandstdname)


## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject:
data$Subject <- as.factor(data$Subject)
data$Activity <- factor(data$Activity, levels = activitylabels[,1], labels = as.character(activitylabels[,2]))

library(reshape2)
meltdata <- melt(data, id = c("Subject", "Activity"))
meandata <- dcast(meltdata, Subject + Activity ~ variable, mean)

## Export tidy dataset:
write.table(meandata, "tidydata.txt", row.names = FALSE)
