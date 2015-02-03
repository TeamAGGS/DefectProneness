
library(randomForest) 
set.seed(123)
dataset <- read.csv(file="data/xerces-1.2.csv", na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
dataset <- dataset[,-c(1,2,3)]
dataset.buggy <- dataset[which(dataset$bug > 0),]
dataset.notbuggy <- dataset[which(dataset$bug == 0),]
dataset.buggy <- dataset.buggy[,-ncol(dataset.buggy)]
dataset.notbuggy <- dataset.notbuggy[,-ncol(dataset.notbuggy)]
classes <- c(rep(1,nrow(dataset.buggy)))
dataset.buggy <- cbind(dataset.buggy, classes)
classes <- c(rep(0,nrow(dataset.notbuggy)))
dataset.notbuggy <- cbind(dataset.notbuggy, classes)

train.buggy <- sample(1:nrow(dataset.buggy), 0.70*nrow(dataset.buggy), replace = F)
train.notbuggy <- sample(1:nrow(dataset.notbuggy), 0.70*nrow(dataset.notbuggy), replace = F)
test.buggy <- setdiff(1:nrow(dataset.buggy), train.buggy)
test.notbuggy <- setdiff(1:nrow(dataset.notbuggy), train.notbuggy)

train <- rbind(dataset.buggy[train.buggy,], dataset.notbuggy[train.notbuggy,])
test <- rbind(dataset.buggy[test.buggy,], dataset.notbuggy[test.notbuggy,])

data.rf <- randomForest(as.factor(train$classes) ~., train, ntree=500, replace=T, mtry=4)
pred <- predict(data.rf, test)
cm <- table(observed=test$classes, predicted = pred)
precision <- cm[4]/(cm[4]+cm[3])
recall <- cm[4]/(cm[4]+cm[2])
fmeasure <- 2*((precision*recall)/(precision+recall))
precision
recall
fmeasure
