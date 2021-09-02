# Getting and Cleaning Data 
# Course Project



# 1. Merges the training and the test sets to create one data set. ----------------

library(readr)
url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./data.zip")
unzip("data.zip")

#Features
features = read_csv("./UCI HAR Dataset/features.txt", col_names = FALSE)


#Train
y_train = read_csv("./UCI HAR Dataset/train/y_train.txt", col_names = "activity")
subject_train = read_csv("./UCI HAR Dataset/train/subject_train.txt", col_names = "subject")
X_train = read_delim("./UCI HAR Dataset/train/X_train.txt", 
                    " ", escape_double = FALSE, col_names = features$X1, trim_ws = TRUE)
data_train = cbind(subject_train,y_train,X_train)

#Test
y_test = read_csv("./UCI HAR Dataset/test/y_test.txt", col_names = "activity")
subject_test = read_csv("./UCI HAR Dataset/test/subject_test.txt", col_names = "subject")
X_test = read_delim("./UCI HAR Dataset/test/X_test.txt", 
                   " ", escape_double = FALSE, col_names = features$X1, trim_ws = TRUE)
data_test = cbind(subject_test,y_test,X_test)

#Train + Test
data_total = rbind(data_train,data_test)

#Remove intermediate dataset
rm(list=setdiff(ls(), "data_total"))


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.  -----------------

vector_mean_std = grep("subject|activity|mean\\(\\)|std\\(\\)", names(data_total), value = TRUE)
data_selected = data_total[,vector_mean_std]


# 3. Uses descriptive activity names to name the activities in the data set   -----------------

activity_labels = read_delim("./UCI HAR Dataset/activity_labels.txt", " ", col_names = FALSE)

vector_labels = factor(activity_labels$X1, labels = activity_labels$X2)
data_total$activity = factor(data_total$activity, labels=vector_labels) # in data_total
data_selected$activity = factor(data_selected$activity, labels=vector_labels) #in data_selected


# 4. Appropriately labels the data set with descriptive variable names.   -----------------

names = sub("^[0-9]+", "", names(data_selected)) #delete number
library(stringr)
names = str_trim(names) #delete espace at the begining
names(data_selected) = names #rename

# 5. From the data set in step 4, creates a second, independent tidy data set ---------------
# with the average of each variable for each activity and each subject.

library(tidyverse)
average_subject_activity = data_selected %>% 
  group_by(subject,activity) %>% 
  summarise(across(everything(), mean)) %>% 
  ungroup()



save(average_subject_activity, file="tidy.Rdata")
write.table(average_subject_activity,  row.name=FALSE, file = "tidy.txt") 
