
#  Tidy data:
##  We install the packages data.table, reshape2, dplyr and tidyr
##  Import the appropriate files and merge the training and test sets to create a new data set
##  Extract the measurements of interest(mean and standard deviation)
##  Name the activities in the data set with descriptive names
##  Label the data set with descriptive variable names
##  Create a second tidy data set with the average of each variable for each activity and each subject

install.packages("data.table")
library(data.table)
install.packages("reshape2")
library(reshape2)
library(dplyr)
library(tidyr)

activity_labels <- read.table("C:/Users/user/Desktop/project cleaning/UCI HAR Dataset/activity_labels.txt", quote="\"")[,2]
features <- read.table("C:/Users/user/Desktop/project cleaning/UCI HAR Dataset/features.txt", quote="\"")[,2]

X_test <- read.table("C:/Users/user/Desktop/project cleaning/UCI HAR Dataset/test/X_test.txt", quote="\"")
y_test <- read.table("C:/Users/user/Desktop/project cleaning/UCI HAR Dataset/test/y_test.txt", quote="\"")
subject_test <- read.table("C:/Users/user/Desktop/project cleaning/UCI HAR Dataset/test/subject_test.txt", quote="\"")
names(X_test) = features

X_train <- read.table("C:/Users/user/Desktop/project cleaning/UCI HAR Dataset/train/X_train.txt", quote="\"")
y_train <- read.table("C:/Users/user/Desktop/project cleaning/UCI HAR Dataset/train/y_train.txt", quote="\"")
subject_train <- read.table("C:/Users/user/Desktop/project cleaning/UCI HAR Dataset/train/subject_train.txt", quote="\"")
names(X_train) = features

X_test<-select(X_test,matches(c("mean|std"),ignore.case = TRUE))
X_test<-select(X_test,-matches("Freq",ignore.case=TRUE))
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

X_train<-select(X_train,matches(c("mean|std"),ignore.case = TRUE))
X_train<-select(X_train,-matches("Freq",ignore.case=TRUE))
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"
train_data <- cbind(as.data.table(subject_train), y_train, X_train)


data = rbind(test_data, train_data)
id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt")
