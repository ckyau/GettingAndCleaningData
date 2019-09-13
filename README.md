# Getting and Cleaning Data - Coursera Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `cleaningData.R`, does the following:

1. Download the dataset if it does not already exist in the working directory
2. Loads all the data that would be needed, this includes the outcome (y) and features (x) for both test and train datasets, the outcome labels, then alse the feature names and the subject data for both train and test data
3. Binding the training and testing data together giving the resulting dataframe the feature names
4. Selecting the features that only include mean or std in the description
5. After the features from step 4 has been selected, we add on the outcome as well (called "outcome_enc" temporarily)
6. The outcome labels (loaded in step 2) is then merged with the data from step 5 and this results in a new dataframe which includes the activity label instead of the encoding. After the merge is complete, the encoding variable is removed
7. Clean up the names to be more interpretable
8. The subject data is combined to the data from step 7
9. The mean is calculated for each variable by the activity and subject
10. The data is written to a file `tidy.txt`

Some notes:

1. The binding and appending of data should not be considered as a problem, since there is never any shuffling of rows that occur
2. The tidyverse package is used throughout the code

The end result is shown in the file `tidy.txt`.