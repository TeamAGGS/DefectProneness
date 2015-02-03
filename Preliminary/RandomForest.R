
library(randomForest) 
set.seed(123)
dataset <- read.csv(file="data/xerces-1.2.csv", na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")

########################### Pre-processing ###########################

dataset <- dataset[,-c(1,2,3)]
bugs <- rep(0,nrow(dataset))
bugs[which(dataset$bug > 0)] <- 1
dataset <- dataset[,-ncol(dataset)]
dataset <- cbind(dataset,bugs)

############################# Partition ##############################
subset.size <- abs(0.20*nrow(dataset))
subset1 <- sample(1:nrow(dataset), subset.size, replace=F)
remaining <- setdiff(1:nrow(dataset),subset1)
subset2 <- sample(remaining, subset.size, replace=F)
remaining <- setdiff(remaining, subset2)
subset3 <- sample(remaining, subset.size, replace=F)
remaining <- setdiff(remaining, subset3)
subset4 <- sample(remaining, subset.size, replace=F)
remaining <- setdiff(remaining, subset4)
subset5 <- remaining

################# End of Pre-processing and partition ################

precision <- rep(0,5)
recall <- rep(0,5)
fmeasure <- rep(0,5)

subset1.train <- sample(subset1, abs(0.90*length(subset1)), replace=F)
subset1.test <- setdiff(subset1, subset1.train)
data.rf <- randomForest(as.factor(dataset[subset1.train,ncol(dataset)]) ~., dataset[subset1.train,], ntree=500, replace=T, mtry=4)
pred <- predict(data.rf, dataset[subset1.test,])
cm <- table(observed=dataset[subset1.test,ncol(dataset)], predicted = pred)
precision[1] <- cm[4]/(cm[4]+cm[3])
recall[1] <- cm[4]/(cm[4]+cm[2])
fmeasure[1] <- 2*((precision*recall)/(precision+recall))



