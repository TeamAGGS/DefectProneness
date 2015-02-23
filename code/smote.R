library(DMwR)
#Merging n-1 versions for training data
training_datasets <- choose.files(multi = TRUE)
dataset <- do.call("rbind", lapply(training_datasets, read.csv, header = TRUE))

dataset$bug <- factor(ifelse(dataset$bug > 0, 1, 0))
dataset <- dataset[,-c(1,2,3)]
class0 <- length(which(dataset$bug == 0))
class1 <- nrow(dataset) - class0
perc.over = (abs(class0 %/% class1)-1)*100
newData <- SMOTE(bug ~., dataset, perc.over, perc.under=135, k=4)
table(newData$bug)
write.csv(newData, file = "training_data_SMOTE-2.22/ant-training.csv", row.names=FALSE)
