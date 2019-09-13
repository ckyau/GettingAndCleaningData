# Load Libraries --------------------------------------------------------------------------------------------------------------------------------------
install.packages("tidyverse")
library(tidyverse)

# Download Data -----------------------------------------------------------
path <- paste0(getwd(), "/UCI_Data.zip")
if (!file.exists(path)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, path, method="curl")
  unzip(path) 
}  

# Load Data -------------------------------------------------------------------------------------------------------------------------------------------
y_train <- read.table(file = "UCI HAR Dataset/train/y_train.txt")
x_train <- read.table(file = "UCI HAR Dataset/train/X_train.txt")

y_test <- read.table(file = "UCI HAR Dataset/test/y_test.txt")
x_test <- read.table(file = "UCI HAR Dataset/test/X_test.txt")

features <- read.table(file = "UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

outcome_labels <- read.table(file = "UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)

subject_test  <- read.table(file = "UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table(file = "UCI HAR Dataset/train/subject_train.txt")

# 1 - Merges the training and the test sets to create one data set ------------------------------------------------------------------------------------
finDat_x <- rbind(x_train, x_test)
finDat_y <- rbind(y_train, y_test)

rm(x_train, x_test, y_train, y_test)

names(finDat_x) <- features$V2

# 2 - Extracts only the measurements on the mean and standard devideviation for each measurement ------------------------------------------------------
mean_std_dat <- finDat_x[, grepl(names(finDat_x), pattern = "mean|std")]

finDat <- cbind(mean_std_dat, finDat_y)
names(finDat) <- c(names(mean_std_dat), "outcome_enc")
rm(mean_std_dat, finDat_x, finDat_y)

# 3 - Uses descriptive activity names to name the activities in the data set --------------------------------------------------------------------------
names(outcome_labels) <- c("outcome_enc", "activity")
finDat <- finDat %>%
  left_join(outcome_labels) %>%
  select(-outcome_enc)

# 4 - Appropriately labels the data set with descriptive variable names -------------------------------------------------------------------------------
names(finDat) <- gsub(x = names(finDat), pattern = "[[:punct:]]", replacement = "")

# 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject ---

# Combine subject data
subject <- rbind(subject_train, subject_test)
finDat$subject <- subject$V1

# Create final dataframe
meansDF <- finDat %>%
  group_by(activity, subject) %>%
  summarise_all(funs(mean))

write.table(meansDF, "tidy.txt", row.names = FALSE, quote = FALSE)

