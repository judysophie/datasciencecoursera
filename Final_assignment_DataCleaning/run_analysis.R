## download and store the data in the respective repository
if (!file.exists("./data")){
    dir.create("./data")
}

if (!file.exists("./data/SGS.zip")){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, "./data/SGS.zip", method = "curl")
    unzip("./data/SGS.zip", exdir = "./data/")
}

## list the names of all files, including those in the subfolders
## intertial folders are not used, but the train and test folder
allfiles <- list.files("./data/UCI HAR Dataset", recursive=TRUE)

library(stringr)
## generate the filenames
fntestx <- paste0("./data/UCI HAR Dataset/", allfiles[15])
fntesty <- paste0("./data/UCI HAR Dataset/", allfiles[16])
fntrainx <- paste0("./data/UCI HAR Dataset/", allfiles[27])
fntrainy <- paste0("./data/UCI HAR Dataset/", allfiles[28])
fnsubjtest <- paste0("./data/UCI HAR Dataset/", allfiles[14])
fnsubjtrain <- paste0("./data/UCI HAR Dataset/", allfiles[26])
fncolnames <- paste0("./data/UCI HAR Dataset/", allfiles[3])

measurements <- read.table(fncolnames, stringsAsFactors = FALSE)
colnames(measurements) <- c("id","measurement")

## use the same sytax for all colnames
parts <- str_split(measurements$measurement[555:561],"\\(", simplify=TRUE)
measurements$measurement[555:561] <- paste(parts[,2],parts[,1], sep= "-")
measurements$measurement[555:561] <- gsub("\\)", "",measurements$measurement[555:561])

## clean col names, 1. abbreviations, 2. (), 3. "," to avoid confusions with csv
## due to the complex names, "-" will be kept and "," will be exchanged with "_"
measurements$measurement <- sub("^f", "frequency",measurements$measurement)
measurements$measurement <- sub("^t", "time", measurements$measurement)
measurements$measurement <- sub("\\()", "" , measurements$measurement)
measurements$measurement <- sub(",", "_" , measurements$measurement)

## Duplicate colnames are made unique
duplicate_measurement <- measurements$measurement[duplicated(measurements$measurement)]
measurements$measurement <- make.unique(measurements$measurement)
if (sum(duplicated(measurements$measurement)) > 0){print("Check columnnames")}

## This function is defined to merge the subdatasets in test and training
mergeData <- function(data, activity, subject) {
    ## open data and label columnnames
    TestX <- read.table(data)
    colnames(TestX) <- measurements[,2]
    ## get the activity codes
    TestY <- read.table(activity)
    names(TestY) <- "Activity"
    ## get the subject ids
    SubjTest <- read.table(subject)
    names(SubjTest) <- "Subjectid"
    ## check that the tables are compatible
    if ((nrow(TestX) == nrow(TestY) & nrow(TestX) == nrow(SubjTest)) != TRUE) {
        print("Check data, number of rows does not correspond")}
    Testdata <- cbind(SubjTest, TestY, TestX)
    ## change the numbers into the corresponding activities
    count <- 1
    for (i in Testdata$Activity){
        if (i == 1) {Testdata$Activity[count] <- "walking"}
        if (i == 2) {Testdata$Activity[count] <- "walkingupstairs"}
        if (i == 3) {Testdata$Activity[count] <- "walkingdownstairs"}
        if (i == 4) {Testdata$Activity[count] <- "sitting"}
        if (i == 5) {Testdata$Activity[count] <- "standing"}
        if (i == 6) {Testdata$Activity[count] <- "laying"}
        count <- count+1
    }
    return(Testdata)
}

## merge the sub datasets to get a Test and a Training dataset
Testd <- mergeData(fntestx,fntesty,fnsubjtest)
Trainingd <- mergeData(fntrainx,fntrainy,fnsubjtrain)


## for final merging of the datasets, the subject ids have to be unique
library(dplyr)
Testd  <-  mutate(Testd, Subjectid = paste0("Test-",Subjectid))
Trainingd  <-  mutate(Trainingd, Subjectid = paste0("Train-",Subjectid))

## merge the Test and Training Datasets
completedata <- rbind(Testd, Trainingd)

## Only extract the lower case "mean" and "std" to include only mean and std computations
## on the original data
meanStd  <-  select(completedata, Subjectid, Activity, grep(".+(mean|std).*", colnames(completedata)))

## Now, group the data according to subjectid and activity to be able to compute the
## average for each activity and subject
groupedData <- group_by(meanStd, Subjectid, Activity)
groupedData  <-  summarize_all(groupedData, mean)

## Adjust the column names to make clear that a Mean was computed
colnames(groupedData)[3:ncol(groupedData)] <- paste("OverallMean", colnames(groupedData[3:ncol(groupedData)]), sep = "-")

write.table(groupedData, file= "./Grouped_Data.txt")




