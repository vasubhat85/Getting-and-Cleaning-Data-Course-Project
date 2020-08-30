if(!file.exists("./data")){dir.create("./data")}
#Projecr data below:
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

#unzip dataset
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Step 1: Merge the training and the test sets to create one data set.

#Reading file
#Reading training tables:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Reading testing tables:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#Reading feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt')

#Reading activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Column name assigning
colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#Merging all data into a common set:
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

#dim(setAllInOne)
#[1]  10299   563

#Step 2: Extracts only the measuremnets on the mean and standard deviation for each measurement

#Reading column names:

colNames <- colnames(setAllInOne)

#Create vector for defining ID, mean and std. deviation

mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames)
)

#Making subset from setAllInOne:

setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

#Step 3: Use descriptive activity names to name the activities in the data set

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

#step 4: Appropriately labels the data set with descriptive variable names.

#Done in previous steps, see 1, 2 and 3

#Step 5: From the data step 4, create a second, independent tidy data set with the verage of each variable for each activity and each subject.

#Making a second tidy data set

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

# Writing second tidy data set in txt file

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)


                 





