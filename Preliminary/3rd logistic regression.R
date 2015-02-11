
set.seed(123)
subsets <- 5
k <- 10
trees <- 50
mvars <- 4
dataset <- read.csv(file=choose.files(), na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")

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
    
    
    
    glm.fit = glm(bug ~ ., data = subset.train.data[train.index,], family = binomial)
    glm.prob = predict(glm.fit, data = subset.train.data[cv.index,], type = "response")
    glm.pred = rep("0",dim(subset.train.data[cv.index,])[1])
    for(i in 1:dim(subset.train.data[cv.index,])[1]){
      if(glm.prob[i] > 0.5)
        glm.pred[i] = "1"  
    }
    table1=table(glm.pred,subset.train.data[cv.index,]$bug)
    m.error=(table1[1,2]+table1[2,1])/(table1[1,2]+table1[2,1]+table1[1,1]+table1[2,2])
    
    if(c.error < m.error) {
      m.error <- c.error
      m.tree <- glm.fit
    }
  }
  
  # Test on the best model returned by CV
  glm.prob = predict(m.tree, data = subset.test.data, type = "response")
  glm.pred = rep("0",dim(subset.test.data)[1])
  for(i in 1:dim(subset.test.data)[1]){
    if(glm.prob[i] > 0.5)
      glm.pred[i] = "1"  
  }
  table1=table(glm.pred,subset.test.data$bug)
  misclassification=(table1[1,2]+table1[2,1])/(table1[1,2]+table1[2,1]+table1[1,1]+table1[2,2])
  print(misclassification)
  if(misclassification < premisclassification) {
    bestmodel <- m.tree
    premisclassification <- misclassification
  }
}

bestmodel
################# End of Pre-processing and partition ################

testdata <- read.csv(file=choose.files(), na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
testdata <- testdata[,-c(1,2,3)]
pred <- predict(bestmodel, testdata, type="class")
cm <- confusion(pred, factor(testdata$bug, levels=c(0,1)))
writedata <- cbind(testdata, pred)
write.csv(writedata, file="PredictedData/ant-1.7_lr.csv", row.names=F)