# 1. Merges the training and the test sets to create one data set.

##   Unzip file located under working directory
unzip("getdata%2Fprojectfiles%2FUCI HAR Dataset.zip")

##   Read test data
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

##   Read train data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

##   Read features and activity
features <- read.table("UCI HAR Dataset/features.txt")
activity <- read.table("UCI HAR Dataset/activity_labels.txt")

##   Merge train and test data into one dataset
X <- rbind(X_test,X_train)
y <- rbind(y_test,y_train)
subject <- rbind(subject_test,subject_train)

##   Check dimensions of new dataset
dim(X)
dim(y)
dim(subject)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

##   Pull features that contain mean() and std() in their name
X_mean_std <- X[,grep("mean\\(\\)|std\\(\\)",features[,2])]

##   Check dimensions of subset
dim(X_mean_std)

# 3. Uses descriptive activity names to name the activities in the data set

##   Replace numeric values with cognate values in activity.txt
y[,1] <- activity[y[,1],2] 

##   Check activity names
head(y) 

# 4. Appropriately labels the data set with descriptive variable names.

##   Retrieve names for variables
names <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),2] 

##   Update column names for new dataset
names(X) <- names 
names(subject) <- "Subject"
names(y) <- "Activity"

single_dataset <- cbind(subject,y,X)

##   Check first 5 columns
head(single_dataset[,c(1:4)]) 

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
names(single_dataset)
tidy_dataset <- aggregate(.~Subject+Activity,single_dataset,mean)
tidy_dataset <- tidy_dataset[order(tidy_dataset$Subject,tidy_dataset$Activity),]
write.table(tidy_dataset,file="tidy_dataset.txt",row.name=FALSE)