
library(randomForest) 
set.seed(123)
dataset <- read.csv(file=choose.files(), na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")

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
trees <- 50
mvars <- 4

subset1.train <- sample(subset1, abs(0.90*length(subset1)), replace=F)
subset1.test <- setdiff(subset1, subset1.train)
data.rf <- randomForest(as.factor(dataset[subset1.train,ncol(dataset)]) ~., dataset[subset1.train,], ntree=trees, replace=T, mtry=mvars)
pred <- predict(data.rf, dataset[subset1.test,])
cm <- table(observed=dataset[subset1.test,ncol(dataset)], predicted = pred)
precision[1] <- cm[4]/(cm[4]+cm[3])
recall[1] <- cm[4]/(cm[4]+cm[2])
fmeasure[1] <- 2*((precision[1]*recall[1])/(precision[1]+recall[1]))

subset2.train <- sample(subset2, abs(0.90*length(subset2)), replace=F)
subset2.test <- setdiff(subset2, subset2.train)
data.rf <- randomForest(as.factor(dataset[subset2.train,ncol(dataset)]) ~., dataset[subset2.train,], ntree=trees, replace=T, mtry=mvars)
pred <- predict(data.rf, dataset[subset2.test,])
cm <- table(observed=dataset[subset2.test,ncol(dataset)], predicted = pred)
precision[2] <- cm[4]/(cm[4]+cm[3])
recall[2] <- cm[4]/(cm[4]+cm[2])
fmeasure[2] <- 2*((precision[2]*recall[2])/(precision[2]+recall[2]))

subset3.train <- sample(subset3, abs(0.90*length(subset3)), replace=F)
subset3.test <- setdiff(subset3, subset3.train)
data.rf <- randomForest(as.factor(dataset[subset3.train,ncol(dataset)]) ~., dataset[subset3.train,], ntree=trees, replace=T, mtry=mvars)
pred <- predict(data.rf, dataset[subset3.test,])
cm <- table(observed=dataset[subset3.test,ncol(dataset)], predicted = pred)
precision[3] <- cm[4]/(cm[4]+cm[3])
recall[3] <- cm[4]/(cm[4]+cm[2])
fmeasure[3] <- 2*((precision[3]*recall[3])/(precision[3]+recall[3]))

subset4.train <- sample(subset4, abs(0.90*length(subset4)), replace=F)
subset4.test <- setdiff(subset4, subset4.train)
data.rf <- randomForest(as.factor(dataset[subset4.train,ncol(dataset)]) ~., dataset[subset4.train,], ntree=trees, replace=T, mtry=mvars)
pred <- predict(data.rf, dataset[subset4.test,])
cm <- table(observed=dataset[subset4.test,ncol(dataset)], predicted = pred)
precision[4] <- cm[4]/(cm[4]+cm[3])
recall[4] <- cm[4]/(cm[4]+cm[2])
fmeasure[4] <- 2*((precision[4]*recall[4])/(precision[4]+recall[4]))

subset5.train <- sample(subset5, abs(0.90*length(subset5)), replace=F)
subset5.test <- setdiff(subset5, subset5.train)
data.rf <- randomForest(as.factor(dataset[subset5.train,ncol(dataset)]) ~., dataset[subset5.train,], ntree=trees, replace=T, mtry=mvars)
pred <- predict(data.rf, dataset[subset5.test,])
cm <- table(observed=dataset[subset5.test,ncol(dataset)], predicted = pred)
precision[5] <- cm[4]/(cm[4]+cm[3])
recall[5] <- cm[4]/(cm[4]+cm[2])
fmeasure[5] <- 2*((precision[5]*recall[5])/(precision[5]+recall[5]))

precision.mean <- sum(precision, na.rm = T)/length(precision)
recall.mean <- sum(recall, na.rm = T)/length(recall)
fmeasure.mean <- sum(fmeasure, na.rm = T)/length(fmeasure)
precision.mean
recall.mean
fmeasure.mean
