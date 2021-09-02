In this task I used the dataset from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Steps:

1.
I downloaded the files
I created a train dataset and a test dataset
I joined both datasets in a new dataset: "data_total"

2.
I found all the variables whose names had the word "mean" or "std", and I added the ID variables
I usded the grep() function
Then I selected these variables from the original "data_total"
I named the new dataset "data_selected"

3.
I added lebels to the activity variable using "activity_labels.txt"
I used the factor() function

4.
I tidied the variables names using the sub() and the str_trim() functions

5.
I summarise using the group_by() function


Script:


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




Data information:

==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are 
ed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
