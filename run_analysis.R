# run_analysis.R
# Nick Barker, Coursera JHU Data Science Cert Course 3
# "Getting and Cleaning Data"
# Course Project

run_analysis <- function() {

setwd("C:/Users/Nick/Desktop/coursera/jhu_ds_cert_3_getting&cleaningData/course_project/UCI HAR Dataset")

## read in the activity_labels.txt file, convert to list, to appropriately tag 
## 'activity_code' values later on, after adding an 'activity_name' column.
## Per assignment instructions: "Uses descriptive activity names to name the activities in the data set."
act_labels.df   <- read.csv('activity_labels.txt',
                            header = FALSE,
                            sep = " ",
                            colClasses = "character")
act_labels.list <- list()
for (index in act_labels.df[, 1]) {
                                   act_labels.list[index] <- act_labels.df[, 2][as.numeric(index)]
                                  }

## read in the features.txt file, to appropriately tag columns in the X_test/X_train data frames
## Per assignment instructions: "Appropriately labels the data set with descriptive variable names."
features.df     <- read.csv('features.txt', 
                            header = FALSE, 
                            sep = "",
                            colClasses = "character")
X_colNames      <- features.df[, 2]

## read in/merge the 'train' data
## Per assignment instructions: "Appropriately labels the data set with descriptive variable names."
X_train.df      <- read.csv('train/X_train.txt', 
                            header = FALSE, 
                            sep = "",
                            col.names = X_colNames,
                            colClasses = "numeric",
                            check.names = FALSE)       # to preserve special chars in fieldnames
y_train.df      <- read.csv('train/y_train.txt', 
                            header = FALSE, 
                            sep = "",
                            col.names = c("activity_code"),
                            colClasses = "character")    
subject_train.df<- read.csv('train/subject_train.txt', 
                            header = FALSE, 
                            sep = "",
                            col.names = c("subject_code"),
                            colClasses = "character")
merged_train.df <- cbind(subject_train.df, y_train.df, X_train.df)

## read in/merge the 'test' data
## Per assignment instructions: "Appropriately labels the data set with descriptive variable names."
X_test.df       <- read.csv('test/X_test.txt', 
                            header = FALSE, 
                            sep = "",
                            col.names = X_colNames,
                            colClasses = "numeric",
                            check.names = FALSE)       # to preserve special chars in fieldnames
y_test.df       <- read.csv('test/y_test.txt', 
                            header = FALSE, 
                            sep = "",
                            col.names = c("activity_code"),
                            colClasses = "character")
subject_test.df <- read.csv('test/subject_test.txt', 
                            header = FALSE, 
                            sep = "",
                            col.names = c("subject_code"),
                            colClasses = "character")
merged_test.df  <- cbind(subject_test.df, y_test.df, X_test.df)

## now that the "training"/"test" datasets are 'complete', concatenate them
## Per assignment instructions: "Merges the training and the test sets to create one data set."
all_data.df     <- rbind(merged_train.df, merged_test.df)

## now that we have a single data frame, extract only the columns wanted for the 'tidy' data set
## so, get the mean- and standard dev-related columns from features.df, but don't forget to also
## keep the "activity_code"/"subject_code" columns placed in cols 1,2, as they're needed later
## Per assignment instructions: "Extracts only the measurements on the mean and standard deviation for each measurement."

##look at colnames for all_data.df, create number vector of column indices with "mean"/"std" in them
wanted_cols     <- c()
i               <- 1
for (col in colnames(all_data.df)) {
    if (length(grep("mean()", col, fixed = TRUE)) > 0 | # fixed = TRUE to remove meanFreq() values
        length(grep("std()", col, fixed = TRUE)) > 0) {
        wanted_cols <- c(wanted_cols, i)
    }
    i           <- i + 1
}
wanted_cols     <- c(1,2,wanted_cols) # since I put 'subject_code'/'activity_code' first, add them
subset_data.df  <- all_data.df[, wanted_cols]

## create the tidy_data.df, by averaging all observations of each wanted mean()/std() value
## over all observations for each unique (subject, activity) tuple

## create a sorted vector of all subject_code values appearing in subset_data.df
subjects        <- sort(as.numeric(unique(subset_data.df$subject_code)))

## create a sorted vector of all activity_code values appearing in subset_data.df
activities      <- sort(as.numeric(unique(subset_data.df$activity_code)))

## get names of the columns in subset_data.df, to add additional fields 
## use this to name tidy_data.df
subset_names    <- names(subset_data.df)
tidy_names      <- c(subset_names[c(1, 2)], "activity_name")
for (x in subset_names[c(3: length(subset_names))]) {
    tidy_x <- paste("meanOfAll_", x, sep = "")
    tidy_names  <- c(tidy_names, tidy_x)
}  

## initialize an empty "tidy_data.df" data frame to hold computed values
## set tidy_data.df column names equal to tidy_names
tidy_data.df    <- as.data.frame(matrix(nrow = 0, 
                                        ncol = length(tidy_names)),
                                 check.names = FALSE)
                                        #dimnames = list(NULL, tidy_names)))
names(tidy_data.df)     <- tidy_names

## loop over subjects, activities, create a temp data frame to hold corresponding values
## and compute averages, before rbind-ing results to tidy_data.df
for (subject in subjects) {
    for (activity in activities) {
        act.name            <- act_labels.list[activity]
        temp.df             <- subset_data.df[which(subset_data.df$subject_code == as.character(subject) &
                                          subset_data.df$activity_code == as.character(activity)),
                                          3:ncol(subset_data.df)]
        #print(c(subject,activity,nrow(temp.df),ncol(temp.df))) # testing, to make sure subsetting was right
        avgs.df             <- data.frame()
        avgs                <- colMeans(temp.df)
        #all_values          <- c(subject, activity, act.name, avgs)
        all_values.df       <- as.data.frame(c(subject, activity, act.name, avgs),
                                             check.names = FALSE)
        names(all_values.df)<- tidy_names
        tidy_data.df        <- rbind(tidy_data.df, all_values.df)
     }
 }

## return the tidy_data.df data frame, to do whatever with
return(tidy_data.df)
}

tidy_data.df <- run_analysis()
write.csv(file = "run_analysis_output.csv", x = tidy_data.df)
