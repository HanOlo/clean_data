library(tidyverse)
library(lubridate)

## IMPORT DATA
# Import Training Data
train_sub <- read_table("~/R Projects/Coursera/Cleaning Data (Mod 3)/UCI HAR Dataset/train/subject_train.txt", col_names = FALSE)
train_x <- read_table("~/R Projects/Coursera/Cleaning Data (Mod 3)/UCI HAR Dataset/train/X_train.txt", col_names = FALSE)
train_activity <- read_table("~/R Projects/Coursera/Cleaning Data (Mod 3)/UCI HAR Dataset/train/y_train.txt", col_names = FALSE)

# Import Test Data
test_sub <- read_table("~/R Projects/Coursera/Cleaning Data (Mod 3)/UCI HAR Dataset/test/subject_test.txt", col_names = FALSE)
test_x <- read_table("~/R Projects/Coursera/Cleaning Data (Mod 3)/UCI HAR Dataset/test/X_test.txt", col_names = FALSE)
test_activity <- read_table("~/R Projects/Coursera/Cleaning Data (Mod 3)/UCI HAR Dataset/test/y_test.txt", col_names = FALSE)

# Pull Features List
features <- read_table("~/R Projects/Coursera/Cleaning Data (Mod 3)/UCI HAR Dataset/features.txt", col_names = FALSE)

# Remove numbers from name
feature_names <- gsub("[0-9]+ ", "", features$X1)


# Update names from feature text file
colnames(test_x) <- feature_names
colnames(train_x) <- feature_names

# Update names
colnames(train_sub) <- "Subject"
colnames(test_sub) <- "Subject"
colnames(train_activity) <- "Activity"
colnames(test_activity) <- "Activity"


## PART 1 - Merge Training and Test Sets
# Combine columns and add a data set identification column
train_df <- bind_cols(train_sub, train_activity, train_x) %>% 
  mutate(data_source = "train")
test_df <- bind_cols(test_sub, test_activity, test_x) %>% 
  mutate(data_source = "test")

# Combine dataframes by rows
combined_df <- bind_rows(train_df, test_df)

# remove temporary dataframes
rm(list=setdiff(ls(), "combined_df"))

## PART 2 - Extract measurements on the Mean and Standard Deviation
#

comb_names <- names(combined_df)
comb_names_keep <- str_detect(comb_names, "Subject|Activity|data_source|mean|std")
part2_df <- combined_df[,comb_names_keep]

## PART 3 - Use descriptive activity names for activities in the data set
#

part3_df <- part2_df %>% 
  mutate(Activity = recode_factor(Activity, 
                                  `1` = "WALKING", 
                                  `2` = "WALKING_UPSTAIRS",
                                  `3` = "WALKING_DOWNSTAIRS",
                                  `4` = "SITTING",
                                  `5` = "STANDING",
                                  `6` = "LAYING"))


## Part 4 - Label the data set with descriptive variable names
#

new_col_names <- names(part3_df)

new_names_keep <- new_names %>% 
  str_replace_all("^t", "time_") %>% 
  str_replace_all("^f", "freq_") %>% 
  str_replace_all("Body", "body_") %>% 
  str_replace_all("Gravity", "gravity_") %>% 
  str_replace_all("Acc-|Acc", "accelerometer_") %>% 
  str_replace_all("Gyro-|Gyro", "gyroscope_") %>% 
  str_replace_all("\\(\\)-|\\(\\)", "_") %>% # replaces ()- and - with _ 
  str_replace("_$", " ") %>% # removes special cases where _ is at end
  str_to_lower() # makes all lower case

part4_df <- part3_df # copies dataframe from part 2 to part3_df
colnames(part4_df) <- new_names_keep # applies new names to colmn names


## Part 5 - Create a data set with the average for each variable for each activity and each subject
#

part5_df <- part4_df %>% 
  group_by(activity, subject) %>% 
  summarize(across(where(is.numeric), mean, .names = "mean_{.col}"))

write.table(part5_df, "part5.txt", row.names = FALSE)
