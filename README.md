### Introduction

Read [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](Human Activity Recognition Using Smartphones Dataset), and generate tidy
data set based on following steps:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### How to Use

0. Create an empty folder and set it as working directory using setwd().
1. Download run_analysis.R to working directory.
2. Download dataset and extract to working directory.
3. Modify DATA_DIR in run_analysis.R to the directory name of dataset containing README.txt
4. run command: source("run_analysis.R"), the result file will be result.txt