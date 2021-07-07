This is the WK4 HW for JHUs COURSERA “Getting and Cleaning Data”.

The files included are run_analysis.R, code_book.md and this readme.

run_analysis.R is broken up into the 5 major sections of the project.
Preface – loads the tidyverse and lubridate libraries.  Tidyverse includes dplyr and stringr
Import Data – Imports data in 2 sections, train and test.  Each are called by the file they were pulled from x_sub; x_x and x_activity.
Features copies the features from the features.txt files and will perform the following modifications:
-	Removes names from features
-	Updates column names with updated feature names

Part 1 – Merges training and test sets
Combines training and test data through bind rows

Part 2 – Extracts measurements on the mean and standard deviation
Uses str_detect to select the subject, activity, data_source, mean and std columns (logical)

Part 3 – Use descriptive activity names for activities
Uses mutate and recode_factor to update activities from numerical values to character from the activity_labels.txt

Part 4 – Label the data set with descriptive variable names
Uses str_replace_all to perform the following functions:
-	t to time_
-	f to freq_
-	Body to body_
-	Gravity to gravity_
-	Acc- or Acc to accelerometer_
-	Gyro- or Gyro to gyroscope_
-	Removes ()- and – with _
-	Removes remaining _ from the end of colnames
-	Converts all text to lower case

Part 5 – Create a data set with the average for each variable for each activity and each subject
Use group_by for activity and subject
Uses summarize to select columns with numeric values, applies the mean function to each column and adds “mean_” to each column name
