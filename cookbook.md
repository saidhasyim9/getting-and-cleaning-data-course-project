This is the Code Book for `Tidy_Data.txt`

# File Headers

* `subject`  
* `activity`:
** `WALKING` 
** `WALKING_UPSTAIRS`
** `WALKING_DOWNSTAIRS`
** `SITTING`
** `STANDING`
** `LAYING`

## Test and Tranining Measurements
* `timeBodyAccelerationMeanX`
* `timeBodyAccelerationMeanY`
* `timeBodyAccelerationMeanZ`
* `timeBodyAccelerationStdX`
* `timeBodyAccelerationStdY`
* `timeBodyAccelerationStdZ`
* `timeGravityAccelerationMeanX`
* `timeGravityAccelerationMeanY`
* `timeGravityAccelerationMeanZ`
* `timeGravityAccelerationStdX`
* `timeGravityAccelerationStdY`
* `timeGravityAccelerationStdZ`
* `timeBodyAccelerationJerkMeanX`
* `timeBodyAccelerationJerkMeanY`
* `timeBodyAccelerationJerkMeanZ`
* `timeBodyAccelerationJerkStdX`
* `timeBodyAccelerationJerkStdY`
* `timeBodyAccelerationJerkStdZ`
* `timeBodyGyroscopeMeanX`
* `timeBodyGyroscopeMeanY`
* `timeBodyGyroscopeMeanZ`
* `timeBodyGyroscopeStdX`
* `timeBodyGyroscopeStdY`
* `timeBodyGyroscopeStdZ`
* `timeBodyGyroscopeJerkMeanX`
* `timeBodyGyroscopeJerkMeanY`
* `timeBodyGyroscopeJerkMeanZ`
* `timeBodyGyroscopeJerkStdX`
* `timeBodyGyroscopeJerkStdY`
* `timeBodyGyroscopeJerkStdZ`
* `timeBodyAccelerationMagnitudeMean`
* `timeBodyAccelerationMagnitudeStd`
* `timeGravityAccelerationMagnitudeMean`
* `timeGravityAccelerationMagnitudeStd`
* `timeBodyAccelerationJerkMagnitudeMean`
* `timeBodyAccelerationJerkMagnitudeStd`
* `timeBodyGyroscopeMagnitudeMean`
* `timeBodyGyroscopeMagnitudeStd`
* `timeBodyGyroscopeJerkMagnitudeMean`
* `timeBodyGyroscopeJerkMagnitudeStd`
* `frequencyBodyAccelerationMeanX`
* `frequencyBodyAccelerationMeanY`
* `frequencyBodyAccelerationMeanZ`
* `frequencyBodyAccelerationStdX`
* `frequencyBodyAccelerationStdY`
* `frequencyBodyAccelerationStdZ`
* `frequencyBodyAccelerationMeanFreqX`
* `frequencyBodyAccelerationMeanFreqY`
* `frequencyBodyAccelerationMeanFreqZ`
* `frequencyBodyAccelerationJerkMeanX`
* `frequencyBodyAccelerationJerkMeanY`
* `frequencyBodyAccelerationJerkMeanZ`
* `frequencyBodyAccelerationJerkStdX`
* `frequencyBodyAccelerationJerkStdY`
* `frequencyBodyAccelerationJerkStdZ`
* `frequencyBodyAccelerationJerkMeanFreqX`
* `frequencyBodyAccelerationJerkMeanFreqY`
* `frequencyBodyAccelerationJerkMeanFreqZ`
* `frequencyBodyGyroscopeMeanX`
* `frequencyBodyGyroscopeMeanY`
* `frequencyBodyGyroscopeMeanZ`
* `frequencyBodyGyroscopeStdX`
* `frequencyBodyGyroscopeStdY`
* `frequencyBodyGyroscopeStdZ`
* `frequencyBodyGyroscopeMeanFreqX`
* `frequencyBodyGyroscopeMeanFreqY`
* `frequencyBodyGyroscopeMeanFreqZ`
* `frequencyBodyAccelerationMagnitudeMean`
* `frequencyBodyAccelerationMagnitudeStd`
* `frequencyBodyAccelerationMagnitudeMeanFreq`
* `frequencyBodyAccelerationJerkMagnitudeMean`
* `frequencyBodyAccelerationJerkMagnitudeStd`
* `frequencyBodyAccelerationJerkMagnitudeMeanFreq`
* `frequencyBodyGyroscopeMagnitudeMean`
* `frequencyBodyGyroscopeMagnitudeStd`
* `frequencyBodyGyroscopeMagnitudeMeanFreq`
* `frequencyBodyGyroscopeJerkMagnitudeMean`
* `frequencyBodyGyroscopeJerkMagnitudeStd`
* `frequencyBodyGyroscopeJerkMagnitudeMeanFreq`

# Steps the Tidy Data is Produced

## 1. Merges the training and the test sets to create one data set.

The structure of the final outcome is as follow:

```
Column: feature.txt
Row: x_train.txt, x_test.txt
Column: "Subject"
Row: subject_train.txt, subject_test.txt
Column: "Activity"
Row: y_train.txt, y_test.txt --> These will reference to activity_labels.txt
```

bind X, Y, and Subject training with test sets
```X_data <- rbind(X_train, X_test)
Subject_data <- rbind(Subject_train, Subject_test)
Y_data <- rbind(Y_train, Y_test)
```
Set the column names
```
names(Subject_data) <- c("Subject")
names(Y_data) <- c("Activity")
names(X_data) <- Feature$V2
```
Merge all columns. X_data is merged first so that it will be easily selectable in the #2 step below
```AllData<- cbind(X_data,Y_data, Subject_data)
```

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
Use the grepl function to obtain the logical result of Feature's columns that contain either "mean()" or "std()
```Filtered <- grepl("mean\\(\\)|std\\(\\)", Feature$V2)
FilteredData <- subset(AllData, select = Filtered)
```

## 3. Uses descriptive activity names to name the activities in the data set
set the column name in Activity to be the same as that of Y_data as the identifier before merging both Data Frames
```
colnames(Activity) <- c("Activity","Activity Description")
AllData_Activity <- merge(AllData, Activity, by = "Activity")
```
Drop the primary ID "Activity" (first column), and rename back "Activity Description" (last column) to "Activity"
```
AllData_Activity<-AllData_Activity[,-1]
names(AllData_Activity)[563] 
```

## 4. Appropriately labels the data set with descriptive variable names.

```'t' at the beginning is replaced by "time"
'(t' is replaced by "(time"
'f' at the beginning is replaced by "frequency"
"Acc" is replaced by "Acceleration"
"Gyro" is replaced by "Gyroscope"
"Mag" is replaced by "Magnitude"
"BodyBody" is replaced by "Body"
```
```
names(AllData_Activity) <- gsub("^t", "time", names(AllData_Activity))
names(AllData_Activity) <- gsub("\\(t", "\\(time", names(AllData_Activity))
names(AllData_Activity) <- gsub("^f", "frequency", names(AllData_Activity))
names(AllData_Activity) <- gsub("Acc", "Acceleration", names(AllData_Activity))
names(AllData_Activity) <- gsub("Gyro", "Gyroscope", names(AllData_Activity))
names(AllData_Activity) <- gsub("Mag", "Magnitude", names(AllData_Activity))
names(AllData_Activity) <- gsub("BodyBody", "BodyBody", names(AllData_Activity))
```

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```
Tidy_Data <- aggregate(. ~Subject+Activity, AllData_Activity, mean)
```
Order the data according to the Subject and Activity
```
Tidy_Data <- Tidy_Data[order(Tidy_Data$Subject,Tidy_Data$Activity),]
```
Save the tidy data into a file
```
write.table(Tidy_Data, file = "Tidy_Data.txt")
```

