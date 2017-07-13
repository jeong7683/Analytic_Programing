## Create one R script called run_analysis.R that does the following:

# set working directory and apply libraries
setwd("C:\\Users\\Hyunjin\\Documents\\GitHub\\Week4-Project");
library(data.table);
library(reshape2);

## 1. Merges the training and the test sets to create one data set.

# Data Import

x_train <- read.table("UCI HAR Dataset\\train\\X_train.txt");
y_train <- read.table("UCI HAR Dataset\\train\\y_train.txt");
subject_train <- read.table("UCI HAR Dataset\\train\\subject_train.txt");

x_test <- read.table("UCI HAR Dataset\\test\\X_test.txt");
y_test <- read.table("UCI HAR Dataset\\test\\y_test.txt");
subject_test <- read.table("UCI HAR Dataset\\test\\subject_test.txt");


# Add Column Names

activity_labels <- read.table("UCI HAR Dataset\\activity_labels.txt"); # Activity Labels

features <- read.table("UCI HAR Dataset\\features.txt");
features <- features[,2]; # Data Column Name

# Apply Column Names
names(x_train) = features;
names(y_train) = "activity_id";
names(subject_train) = "subject_id";

names(x_test) = features;
names(y_test) = "activity_id";
names(subject_test) = "subject_id";

colnames(activity_labels) <- c("activity_id", "activity_type");

# Merge All Data

merge_train <- cbind(y_train, subject_train, x_train);
merge_test <- cbind(y_test, subject_test, x_test);
merge_all_data <- rbind(merge_train, merge_test);


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

extract_features <- grepl("mean|std", colnames(merge_all_data));
only_mean_std <- merge_all_data[,extract_features];
only_mean_std <- cbind(merge_all_data[,1:2], only_mean_std);


## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.

apply_act_names <- merge(only_mean_std, activity_labels, by="activity_id", all.x=T);


## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_data <- aggregate(. ~ subject_id + activity_id, apply_act_names, mean);
tidy_data <- tidy_data[order(tidy_data$subject_id, tidy_data$activity_id),];

write.table(tidy_data, file="tidy_data.txt", row.name=F);
