##Check/set the working directory for the project.
getwd()

##Download and unzip the data sets for the project
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "dataset.zip", method = "curl")

unzip("dataset.zip")

##Read datasets features and activity_labels into R
Features <- read.table("UCI HAR Dataset/features.txt", col.names = c("N","functions"))
head(Features)
tail(Features)

Activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
head(Activities)


##Read training datasets into R
Subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
head(Subject_train)
tail(Subject_train)


X_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = Features$functions)
head(X_train)
tail(X_train)
dim(X_train)

Y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
head(Y_train)
dim(Y_train)

##Read test datasets into R
Subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
head(Subject_test)
tail(Subject_test)


X_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = Features$functions)
head(X_test)
tail(X_test)
dim(X_test)

Y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
head(Y_test)
dim(Y_test)

##Merge training and test datasets to create one dataset.
X <- rbind(X_train, X_test)
dim(X)
Y <- rbind(Y_train, Y_test)
dim(Y)
Subject <- rbind(Subject_train, Subject_test)
dim(Subject)

Merged <- cbind(X, Y, Subject)
dim(Merged)
str(Merged)

head(Merged)

library(dplyr) ##Load the dplyr package 

meannames <- grep("mean", names(Merged), value = TRUE)
stdnames <- grep("std", names(Merged), value = TRUE)

Extracted <- select(Merged, subject, code, all_of(meannames), all_of(stdnames))
head(Extracted)

##Use descriptive activity names to name the activities in the data set
table(Extracted$code)
head(Activities)

Extracted$code <- Activities[Extracted$code, 2]

table(Extracted$code)
head(Extracted)

##Appropriately labels the data set with descriptive variable names
Names1 <- names(Extracted)

Names2 <- gsub("\\...", "_", Names1)
Names3 <- gsub("_an", "_Mean", Names2)
Names4 <- gsub("_d", "_STD", Names3)
Names5 <- gsub("\\..", "", Names4)
Names5[2] <- "Activities"
Names6 <- gsub("BodyBody", "Body", Names5)
Names7 <- gsub("^t", "Time_", Names6)
Names8 <- gsub("^f", "Frequency_", Names7)
Names9 <- gsub("Acc", "_Accelerometer", Names8)
Names10 <- gsub("Gyro", "_Gyroscope", Names9)
Names11 <- gsub("Mag", "Magnitude", Names10)
Names11[1] <- "Subject"
names(Extracted) <- Names11

names(Extracted)

##From the data set in step 4, creates a second, independent tidy data set with 
##the average of each variable for each activity and each subject
str(Extracted)
dataset1 <- group_by(Extracted, Subject, Activities)
str(dataset1)

names(dataset1)
Final_dataset <- summarize_all(dataset1, mean)
head(Final_dataset)
str(Final_dataset)
write.table(Final_dataset, "Final_dataset.txt", row.name = FALSE)
