## download data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","FUCIHARDataset.zip",method="curl")
## uncompress data
unzip("FUCIHARDataset.zip")
## read features.txt file
features <- read.table("UCI HAR Dataset/features.txt",col.names=c("Feature.number","Feature"))
## read subject_test.txt file from test directory
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",col.names="Subject",header=FALSE)
## read y_test.txt file from test directory
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",col.names="Labels",check.names=FALSE)
## read x_test.txt file from test directory
x_test <- read.table("UCI HAR Dataset/test/x_test.txt",col.names=features[,2],check.names=FALSE)
## keep only mean and std deviation columns in x_test
toMatch <- c("mean\\(\\)[-]|std\\(\\)[-]")
matches <- unique(grep(toMatch,features[,2],value=TRUE))
x_test <- subset(x_test,select=matches)
## do the same for train files from train directory
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",col.names="Subject")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",col.names="Labels",check.names=FALSE)
x_train <- read.table("UCI HAR Dataset/train/x_train.txt",col.names=features[,2],check.names=FALSE)
x_train <- subset(x_train,select=matches)
# concatenate datasets in one data frame
test <- cbind(subject_test,y_test,x_test)
subject_test <- NULL
y_test <- NULL
x_test <- NULL
train <- cbind(subject_train,y_train,x_train)
subject_train <- NULL
y_train <- NULL
x_train <- NULL
test_train <- rbind(test,train)
## read activities file
activities <- read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("Activity","Activity.Description"))
df1 <- merge(activities,test_train,by.y="Labels",by.x="Activity",all.x=TRUE,all.y=FALSE)
toMatchMean <- c("mean\\(\\)[-]")
matchesMean <- unique(grep(toMatchMean,features[,2],value=TRUE))
df2 <- subset(df1,select=c("Activity","Activity.Description","Subject",matchesMean))
df2$ActivityDesc <- paste(df2$Activity,df1$Activity.Description,collapse=".")
test <- NULL
test_train <- NULL
train <- NULL