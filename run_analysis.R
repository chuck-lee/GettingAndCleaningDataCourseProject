# Path for dataset
DATA_DIR <- "UCI HAR Dataset"

# Read common labels
activity_labels <- read.delim(sprintf("%s/activity_labels.txt", DATA_DIR),
                              sep = "",
                              header = FALSE,
                              col.names = c("activity", "label"),
                              colClasses = c("numeric", "character"))
feature_labels <- read.delim(sprintf("%s/features.txt", DATA_DIR),
                             sep = "",
                             header = FALSE,
                             col.names = c("feature", "label"),
                             colClasses = c("numeric", "character"))

# Load data function
LoadMeanStdData <- function(type)
{
    # Read subject
    subject <- read.delim(sprintf("%s/%s/subject_%s.txt", DATA_DIR, type, type),
                          sep = "",
                          header = FALSE,
                          col.names = c("subject"),
                          colClasses = c("numeric"))
    # Read y (activity)
    y <- read.delim(sprintf("%s/%s/y_%s.txt", DATA_DIR, type, type),
                    sep = "",
                    header = FALSE,
                    col.names = c("activity"),
                    colClasses = c("numeric")) %>%
         lapply(function(c) { activity_labels[c,]$label })
    # Read x (Measurements)
    x <- read.delim(sprintf("%s/%s/x_%s.txt", DATA_DIR, type, type),
                    sep = "",
                    header = FALSE,
                    col.names = feature_labels$label,
                    colClasses = rep(c("numeric"), each = dim(feature_labels)[1])) %>%
         # '('' will be replaced by '.' in column name, so the match is "mean."
         # instead of "mean(", "std." instead of "std("
         select(matches("mean\\.|std\\.", ignore.case = FALSE))
    # Assign column name for better readibility
    colnames(x) <- c("tBodyAccMeanX", "tBodyAccMeanY", "tBodyAccMeanZ",
                      "tBodyAccStdX", "tBodyAccStdY", "tBodyAccStdZ",
                      "tGravityAccMeanX", "tGravityAccMeanY", "tGravityAccMeanZ",
                      "tGravityAccStdX", "tGravityAccStdY", "tGravityAccStdZ",
                      "tBodyAccJerkMeanX", "tBodyAccJerkMeanY", "tBodyAccJerkMeanZ",
                      "tBodyAccJerkStdX", "tBodyAccJerkStdY", "tBodyAccJerkStdZ",
                      "tBodyGyroMeanX", "tBodyGyroMeanY", "tBodyGyroMeanZ",
                      "tBodyGyroStdX", "tBodyGyroStdY", "tBodyGyroStdZ",
                      "tBodyGyroJerkMeanX", "tBodyGyroJerkMeanY", "tBodyGyroJerkMeanZ",
                      "tBodyGyroJerkStdX", "tBodyGyroJerkStdY", "tBodyGyroJerkStdZ",
                      "tBodyAccMagMean", "tBodyAccMagStd",
                      "tGravityAccMagMean", "tGravityAccMagStd",
                      "tBodyAccJerkMagMean", "tBodyAccJerkMagStd",
                      "tBodyGyroMagMean", "tBodyGyroMagStd",
                      "tBodyGyroJerkMagMean", "tBodyGyroJerkMagStd",
                      "fBodyAccMeanX", "fBodyAccMeanY", "fBodyAccMeanZ",
                      "fBodyAccStdX", "fBodyAccStdY", "fBodyAccStdZ",
                      "fBodyAccJerkMeanX", "fBodyAccJerkMeanY", "fBodyAccJerkMeanZ",
                      "fBodyAccJerkStdX", "fBodyAccJerkStdY", "fBodyAccJerkStdZ",
                      "fBodyGyroMeanX", "fBodyGyroMeanY", "fBodyGyroMeanZ",
                      "fBodyGyroStdX", "fBodyGyroStdY", "fBodyGyroStdZ",
                      "fBodyAccMagMean", "fBodyAccMagStd",
                      "fBodyAccJerkMagMean", "fBodyAccJerkMagStd",
                      "fBodyGyroMagMean", "fBodyGyroMagStd",
                      "fBodyGyroJerkMagMean", "fBodyGyroJerkMagStd")
    data <- cbind(subject, y, x)

    return(data)
}

# Get combined data, bind train data and test data in row
combinedMeanStdData <- rbind(LoadMeanStdData("train"), LoadMeanStdData("test"))

# Create empty data frame for result
result <- as.data.frame(matrix(nrow = 0, ncol = dim(combinedMeanStdData)[2],
               dimnames = list(NULL, colnames(combinedMeanStdData))))
subjects <- sort(unique(combinedMeanStdData$subject))
for (s in subjects)
{
    for (a in activity_labels$label)
    {
        # Calculate mean per subject per activity as single row, then bind it
        # into result
        row <- cbind(s, a, as.data.frame(lapply(filter(combinedMeanStdData, subject == s, activity == a)[3:68], mean)))
        colnames(row)[1] <- "subject"
        colnames(row)[2] <- "activity"
        result <- rbind(result, row)
    }
}

# write result file
write.table(result, "result.txt", row.names=FALSE)