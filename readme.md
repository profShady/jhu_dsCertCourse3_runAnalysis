---
title: "readme.md for run_analysis.R"
output: html_document
---

This R Markdown document contains the study design and code book related to the accompanying **run_analysis.R** script, which was used to process the UC Irvine dataset "Human Activity Recognition Using Smartphones". 

Study Design
==========================================

The UC Irvine dataset (a full explanation of which is available at <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>) contains raw data on 30 different study subjects and their performance of 6 different physical activities, along with multiple observations of 561 different variables during this activity.  Using the dataset downloaded from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>, the goal of run_analysis.R script is to create a tidy dataset that only includes the mean measurement of 66 different variables from this initial set of 561 variables, namely those that include the mean or standard deviation of their associated raw observations. *Notably, the number of raw observations per variable were not consistent across subject/activity combinations*, so taking the mean of all observations for each subject/activity pair is an important step in normalizing the data before making comparisions.

Also of note, while the original dataset had divided the total dataset into test and training datasets, the tidy dataset combines all observations together. And to reiterate, while the original data contained 561 unique variables, the tidy dataset contains only 66 of these, i.e. those variables that measured the mean or standard deviation of other variables. In addition to 66 columns that contain the mean of all observations per subject/activity pair in the dataset for these variables, there are 3 additional fields at the beginning of the dataset that note, in order: the code for the subject that performed the activity (*subject_code*), the code for the activity performed (*activity_code*), and the human-readable name of the activity performed (*activity_name*).

The run_analysis.R script contains a single function ('run_analysis()') that performs the following process, assuming that the user's working directory contains the unzipped version of the dataset mentioned above:

1) reads in the 'activitylabels.txt' file so that activity_codes in records can be properly labeled with human readable activity_names (per assignment instructions: "Uses descriptive activity names to name the activities in the data set.")

2) reads in the features.txt file, to appropriately tag columns in the X_test/X_train data frames (per assignment instructions: "Appropriately labels the data set with descriptive variable names.")

3) read in and merge together the "train" datasets: X_train.txt, y_train.txt, and subject_train.txt

4) read in and merge together the "test" datasets: X_test.txt, y_test.txt, and subject_test.txt

5) combine the train/test datasets to create a single dataset

6) from this combined dataset, extract only those variables that contain a mean()/std() measurement (per assignment instructions: "Extracts only the measurements on the mean and standard deviation for each measurement.")

7) create the tidy dataset ("tidy_data.df") by averaging all observations of each wanted mean()/std() value over all observations for each unique (subject, activity) combination

8) return tidy_data.df from the run_analysis() function

Code Book
==========================================

This information on the raw data used in the analysis can be found in the 'features_info.txt' file in the downloaded dataset:

*The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.*

*Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).*

*Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain >signals).*

*These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.*

As noted above in **Study Design**, the 66 variables contained in the tidy dataset merely calculate the mean of all noted observations for the kept variables from the initial dataset. Therefore, the units of measurement are the same as those in the initial dataset, as described above. To illustrate the new variable names and how they were derived from the variable names in the initial dataset, see below, where the name on the left of the => arrow is the name of the variable in the initial dataset, and the name on the right is the name of the corresponding mean variable in the tidy dataset:

>              fBodyAcc-mean()-X => meanOfAll_fBodyAcc-mean()-X
>              fBodyAcc-mean()-Y => meanOfAll_fBodyAcc-mean()-Y
>              fBodyAcc-mean()-Z => meanOfAll_fBodyAcc-mean()-Z
>               fBodyAcc-std()-X => meanOfAll_fBodyAcc-std()-X
>               fBodyAcc-std()-Y => meanOfAll_fBodyAcc-std()-Y
>               fBodyAcc-std()-Z => meanOfAll_fBodyAcc-std()-Z
>          fBodyAccJerk-mean()-X => meanOfAll_fBodyAccJerk-mean()-X
>          fBodyAccJerk-mean()-Y => meanOfAll_fBodyAccJerk-mean()-Y
>          fBodyAccJerk-mean()-Z => meanOfAll_fBodyAccJerk-mean()-Z
>           fBodyAccJerk-std()-X => meanOfAll_fBodyAccJerk-std()-X
>           fBodyAccJerk-std()-Y => meanOfAll_fBodyAccJerk-std()-Y
>           fBodyAccJerk-std()-Z => meanOfAll_fBodyAccJerk-std()-Z
>             fBodyAccMag-mean() => meanOfAll_fBodyAccMag-mean()
>              fBodyAccMag-std() => meanOfAll_fBodyAccMag-std()
>     fBodyBodyAccJerkMag-mean() => meanOfAll_fBodyBodyAccJerkMag-mean()

etc.
