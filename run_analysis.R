library(dplyr)
file1 <- "Assignmentw4.zip"
if(!file.exists(file1)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, file1, method="curl")
}
if(!file.exists("UCI HAR Dataset")){
        unzip(file1)
}

activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code","activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("i","functions"))
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
xtest <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
ytest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

X <- rbind(xtrain, xtest)
Y <- rbind(ytrain, ytest)
subject <- rbind(subjecttrain,subjecttest)
merged <- cbind(subject, Y, X)

extracted <- merged %>% select(subject, code, contains("mean"), contains("std"))

extracted$code <- activitylabels[extracted$code, 2]

names(extracted)[2] = "activity"
names(extracted) <- gsub("Acc", "Accelerometer", names(extracted))
names(extracted) <- gsub("Gyro", "Gyroscope", names(extracted))
names(extracted) <- gsub("BodyBody", "Body", names(extracted))
names(extracted) <- gsub("Mag", "Magnitude", names(extracted))
names(extracted) <- gsub("^t", "Time", names(extracted))
names(extracted) <- gsub("^f", "Frequency", names(extracted))
names(extracted) <- gsub("tBody", "TimeBody", names(extracted))
names(extracted) <- gsub("-mean()", "Mean", names(extracted), ignore.case = TRUE)
names(extracted) <- gsub("-std()", "STD", names(extracted), ignore.case = TRUE)
names(extracted) <- gsub("-freq()", "Frequency", names(extracted), ignore.case = TRUE)
names(extracted) <- gsub("angle", "Angle", names(extracted))
names(extracted) <- gsub("gravity", "Gravity", names(extracted))

tidydata <- extracted %>%
        group_by(subject, activity) %>%
        summarise_all(list(mean))
write.table(tidydata, "tidydata.txt", row.names = FALSE)

                         



                
