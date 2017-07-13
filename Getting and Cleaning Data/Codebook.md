## About source data

One of the most exciting areas in all of data science right now is wearable computing - see for example this article.
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users.
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.
A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## About R script
R code "run_analysis.r" follows below 5 steps. 
1. Merging the training and the test sets to create one data set
  - First, import data from downloaded files
  - Second, add column names
  - Third, apply column names
  - Fourth, merge all data
2. Extracting only the measurements on the mean and standard deviation for each measurement 
  - Extracting features including only mean and standard deviation by using grepl statement
3. Using descriptive activity names to name the activities in the data set   
4. Appropriately labeling the data set with descriptive variable names
  - step 3~4 → Merge data made in step 2 and activity labels
5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject 
  - calculate sum by subject and activity, and write tidy data in working directory
 
## About variables   
* "x_train", "y_train", "x_test", "y_test", "subject_train" and "subject_test" contain the data from the downloaded files.
* "merge_train" and "merge_test" are merged data of each original dataset, and "merge_all_data" is the data merging train and test dataset.
* "features" and "activity_labels" include column names' information
* "tidy_data" is data to contain sum by group(activity by subject)

