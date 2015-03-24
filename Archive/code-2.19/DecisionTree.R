library(rpart) 
set.seed(123)
subsets <- 5
k <- 10
file=file.choose()
dataset <- read.csv(file, na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
file_name <- basename(file)
############################# Partition ##############################

dataset.class0 <- which(dataset$bug == 0)
dataset.class1 <- which(dataset$bug == 1)
perc = 1/subsets
bestmodel <- ""
premisclassification <- 100

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
  
  subset.train.data <- dataset[subset.train,]
  subset.test.data <- dataset[subset.test,]
  
  n <- nrow(subset.train.data)
  fold <- rep(0,n)
  c <- 0
  for (i in 1:(n %/% k)) {
    for (j in 1:k) {
      fold[c] <- j
      c <- c + 1
    }
  }
  fold <- fold[sample(1:length(fold), length(fold), replace=F)]
  
  # Perform k-fold Cross Validation
  
  m.error <- 100
  m.tree <- ""
  
  for(i in 1:k) {
    cv.index = which(fold == i)
    train.index = setdiff(1:length(fold),cv.index)
    
    tree = rpart(bug ~., subset.train.data[train.index,], method="class", parms=list(split='gini'), control=rpart.control(minsplit=10,minbucket=3,cp=0))
    pred <- predict(tree, subset.train.data[cv.index,], type="class")
    cm <- confusion(pred, factor(subset.train.data[cv.index,"bug"], levels=c(0,1)))
    c.error <- as.numeric(as.character(attr(cm, "error")))
    
    if(c.error < m.error) {
      m.error <- c.error
      m.tree <- tree
    }
  }
  
  # Test on the best model returned by CV
  
  pred <- predict(m.tree, subset.test.data, type="class")
  cm <- confusion(pred, factor(subset.test.data$bug, levels=c(0,1)))
  misclassification <- as.numeric(as.character(attr(cm, "error")))
  print(misclassification)
  if(misclassification < premisclassification) {
    bestmodel <- m.tree
    premisclassification <- misclassification
  }
}

bestmodel
################# End of Pre-processing and partition ################

testdata <- read.csv(file=paste("data/",file_name, sep=""), na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
testdata <- testdata[,-c(1,2,3)]
testdata$bug <- factor(ifelse(testdata$bug > 0, 1, 0))
pred <- predict(bestmodel, testdata, type="class")
cm <- confusion(pred, factor(testdata$bug, levels=c(0,1)))
cm
plot(bestmodel)
writedata <- cbind(testdata, pred)
write.csv(writedata, file=paste("PredictedData/",file_name, sep=""), row.names=F)