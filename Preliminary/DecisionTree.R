
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
#subset2 <- dataset[sample(remaining, subset.size, replace=F)]
#remaining <- setdiff(remaining, subset2)
#subset3 <- dataset[sample(remaining, subset.size, replace=F)]
#remaining <- setdiff(remaining, subset3)
#subset4 <- dataset[sample(remaining, subset.size, replace=F)]
#remaining <- setdiff(remaining, subset4)
#subset5 <- dataset[remaining]

################# End of Pre-processing and partition ################

precision <- rep(0,5)
recall <- rep(0,5)
fmeasure <- rep(0,5)

subset1.train <- sample(subset1, abs(0.90*length(subset1)), replace=F)
subset1.test <- setdiff(subset1, subset1.train)

CrossValidation <- function(data, k){
  n <- nrow(data)
  c.error <- 0
  data.train <- sample(1:nrow(data), abs(0.9*nrow(data)), replace=F)
  data.test <- setdiff(1:nrow(data), data.train)
  fold <- rep(0,length(data.train))
  c <- 0
  for (i in 1:(n %/% k)) {
    for (j in 1:k) {
      fold[c] <- j
      c <- c + 1
    }
  }
  fold <- fold[sample(1:length(fold), length(fold), replace=F)]
  
  m.error <- 100
  m.tree <- 0
  
  for(i in 1:k) {
    test.index = which(fold == i)
    train.index = setdiff(data.train,test.index)
       
    tree = rpart(as.factor(data[train.index,ncol(data)]) ~., data[train.index,], method="class", parms=list(split='gini'), control=rpart.control(minsplit=1,minbucket=1,cp=0))
    pred <- predict(tree, data[test.index,], type="class")
    cm <- confusion(pred, factor(data[test.index,ncol(data)], levels=c(0,1)))
    cm <- table(observed=data[test.index,ncol(data)], predicted = pred)
    c.error <- as.numeric(as.character(attr(cm, "error")))
 
    if(c.error < m.error) {
      m.error <- c.error
      m.tree <- tree
    }
  }
  m.tree
}

# Store errors and trees for all 5 subsets
error <- rep(0,5)
dtree <- rep(0,5)

# For subset1
data <- dataset[subset1.train,]
CrossValidation(data, 10)
pred <- predict(m.tree, dataset[subset1.test,], type="class")
cm <- confusion(pred, factor(dataset[subset1.test,ncol(dataset)], levels=c(0,1)))
cm <- table(observed=dataset[subset1.test,ncol(dataset)], predicted = pred)
error[1] <- as.numeric(as.character(attr(cm, "error")))




