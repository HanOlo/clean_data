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







## Part 4 - Label the data set with descriptive variable names
#







## Part 5 - Create a data set with the average for each variable for each activity and each subject