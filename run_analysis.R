## Download the zip file
if(!file.exists(".//Wk4_Assignment_File")){dir.create(".//Wk4_Assignment_File")}
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(Url,destfile=".//Wk4_Assignment_File//File.zip")

## Unzip the file
unzip(zipfile=".//Wk4_Assignment_File//File.zip",exdir=".//Wk4_Assignment_File//Data")

## Store all the files
##FileList<-list.files(".//Wk4_Assignment_File//Data//UCI HAR Dataset", recursive=TRUE)

## Set up the structure
## ----------------------------
## Column: feature.txt
## Row: x_train.txt, x_test.txt
## ----------------------------
## Column: "Subject"
## Row: subject_train.txt, subject_test.txt
## ----------------------------
## Column: "Activity"
## Row: y_train.txt, y_test.txt --> These will reference to activity_labels.txt
## ----------------------------
## 
## Read all files
FilePath <- file.path(".//Wk4_Assignment_File//Data//UCI HAR Dataset//")

Feature <- read.table(file.path(FilePath, "features.txt"))
X_train <- read.table(file.path(FilePath, "train/x_train.txt"))
X_test <- read.table(file.path(FilePath, "test/x_test.txt"))

Subject_train <- read.table(file.path(FilePath, "train/subject_train.txt"))
Subject_test <- read.table(file.path(FilePath, "test/subject_test.txt"))

Y_train <- read.table(file.path(FilePath, "train/y_train.txt"))
Y_test <- read.table(file.path(FilePath, "test/y_test.txt"))
Activity <- read.table(file.path(FilePath, "activity_labels.txt"))


## 1. Merges the training and the test sets to create one data set.

##bind X, Y, and Subject training with test sets
X_data <- rbind(X_train, X_test)
Subject_data <- rbind(Subject_train, Subject_test)
Y_data <- rbind(Y_train, Y_test)

## Set the column names
names(Subject_data) <- c("Subject")
names(Y_data) <- c("Activity")
names(X_data) <- Feature$V2

## Merge all columns. X_data is merged first so that it will be easily selectable in the #2 step below
AllData<- cbind(X_data,Y_data, Subject_data)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
Filtered <- grepl("mean\\(\\)|std\\(\\)", Feature$V2)
FilteredData <- subset(AllData, select = Filtered)

## 3. Uses descriptive activity names to name the activities in the data set
## set the column name in Activity to be the same as that of Y_data as the identifier before merging both Data Frames
colnames(Activity) <- c("Activity","Activity Description")
AllData_Activity <- merge(AllData, Activity, by = "Activity")

## Drop the primary ID "Activity" (first column), and rename back "Activity Description" (last column) to "Activity"
AllData_Activity<-AllData_Activity[,-1]
names(AllData_Activity)[563] <- c("Activity")

## 4. Appropriately labels the data set with descriptive variable names.
##
##'t' at the beginning is replaced by "time"
##'(t' is replaced by "(time"
##'f' at the beginning is replaced by "frequency"
##"Acc" is replaced by "Acceleration"
##"Gyro" is replaced by "Gyroscope"
##"Mag" is replaced by "Magnitude"
##"BodyBody" is replaced by "Body"

names(AllData_Activity) <- gsub("^t", "time", names(AllData_Activity))
names(AllData_Activity) <- gsub("\\(t", "\\(time", names(AllData_Activity))
names(AllData_Activity) <- gsub("^f", "frequency", names(AllData_Activity))
names(AllData_Activity) <- gsub("Acc", "Acceleration", names(AllData_Activity))
names(AllData_Activity) <- gsub("Gyro", "Gyroscope", names(AllData_Activity))
names(AllData_Activity) <- gsub("Mag", "Magnitude", names(AllData_Activity))
names(AllData_Activity) <- gsub("BodyBody", "BodyBody", names(AllData_Activity))

##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Tidy_Data <- aggregate(. ~Subject+Activity, AllData_Activity, mean)
## Order the data according to the Subject and Activity
Tidy_Data <- Tidy_Data[order(Tidy_Data$Subject,Tidy_Data$Activity),]

## Save the tidy data into a file
write.table(Tidy_Data, file = "Tidy_Data.txt", row.names = FALSE)

