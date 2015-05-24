#Course Project


##Making sense of the data to create the complete dataset
#Reading all the files in 

feattest<-read.table("test/X_test.txt")
feattrain<-read.table("train/X_train.txt")
featnames<-read.table("features.txt")[,2]

subtest<-read.table("test/subject_test.txt")
subtrain<-read.table("train/subject_train.txt")

acttrain<-read.table("train/Y_train.txt")
acttest<-read.table("test/Y_test.txt")
actlabels<-read.table("activity_labels.txt")


#1. Merging the Training and Test datasets

features<-rbind(feattrain,feattest)

activity<-rbind(acttrain,acttest)

subject<-rbind(subtrain,subtest)

#Adding variable names

names(activity)<-c("activity")
names(subject)<-c("subject")

names(features)<-featnames

#Combine them all

combine<-cbind(subject,activity)
data<-cbind(combine,features)


#2. Extracting only the measurements on the mean and standard deviation for each measurement. 

required<-featnames[grep("mean\\(\\)|std\\(\\)", featnames)]
names<-c("subject", "activity", as.character(required))
datareq<-subset(data, select = names)

#3. Using descriptive activity names to name the activities in the data set
names(actlabels)<-c("id", "activity")
colnames(datareq)[2]<-c("activity.id")

data_complete<-merge(datareq, actlabels, by.x = "activity.id", by.y = "id")
data_complete[3000,c(1,2,69)]  #Checking to see if it has worked


#4. Appropriately labelling the data set with descriptive variable names


names(data_complete)



names(data_complete)<-gsub("^t", "time", names(data_complete))
names(data_complete)<-gsub("^f", "frequency", names(data_complete))
names(data_complete)<-gsub("Acc", "Accelerometer", names(data_complete))
names(data_complete)<-gsub("Gyro", "Gyroscope", names(data_complete))
names(data_complete)<-gsub("Mag", "Magnitude", names(data_complete))
names(data_complete)<-gsub("BodyBody", "Body", names(data_complete))


names(data_complete)   #Checking to see if it has worked.

#5. Create a tidy dataset

tidy<-aggregate(. ~subject + activity, data_complete, mean)
tidy<-tidy[order(tidy$subject,tidy2$activity),]
write.table(tidy, file = "tidydata.txt",row.name=FALSE)
