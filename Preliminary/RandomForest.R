
library(randomForest) 
set.seed(123)
subsets <- 5
trees <- 50
mvars <- 4
dataset <- read.csv(file=choose.files(), na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")

############################# Partition ##############################

dataset.class0 <- which(dataset$bug == 0)
dataset.class1 <- which(dataset$bug == 1)
perc = 1/subsets
bestmodel <- ""
premisclassification <- 0
for (subset in 1:(subsets)) {
  subset.class0.start <- round((subset-1)*perc*length(dataset.class0)+1)
  subset.class0.end <- round(subset*perc*length(dataset.class0))
  subset.class0 <- dataset.class0[subset.class0.start:subset.class0.end]
  
  subset.class1.start <- (subset-1)*perc*length(dataset.class1)+1
  subset.class1.end <- (subset)*perc*length(dataset.class1)
  subset.class1 <- dataset.class1[subset.class1.start:subset.class1.end]
  
  subset.total <- c(subset.class0, subset.class1)
  
  subset.train.class0 <- subset.class0[1:round(0.9*length(subset.class0))]
  subset.train.class1 <- subset.class1[1:round(0.9*length(subset.class1))]
  subset.train <- c(subset.train.class0, subset.train.class1)
  subset.test <- setdiff(subset.total, subset.train)
  
  data.rf <- rpart(bug ~., dataset[subset.train,], method="class", parms=list(split='gini'), control=rpart.control(minsplit=20,minbucket=15,cp=0))
  pred <- predict(data.rf, dataset[subset.test,], type="class")
  cm <- confusion(pred, factor(dataset[subset.test,"bug"], levels=c(0,1)))
  misclassification <- (cm[2]+cm[3])/length(subset.test)
  misclassification
  if(subset == 1){
    bestmodel <- data.rf
  }
  if(misclassification < premisclassification) {
    bestmodel <- data.rf
    premisclassification <- misclassification
  }
}

bestmodel
################# End of Pre-processing and partition ################

testdata <- read.csv(file=choose.files(), na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
