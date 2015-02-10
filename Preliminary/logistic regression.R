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
  
  glm.fit = glm(bug ~ ., data = dataset[subset.train,], family = binomial)
  glm.prob = predict(glm.fit, data = dataset[subset.test,], type = "response")
  glm.pred = rep("0",dim(dataset[subset.test,])[1])
  for(i in 1:dim(dataset[subset.test,])[1]){
    if(glm.prob[i] > 0.5)
      glm.pred[i] = "1"  
  }
  table1=table(glm.pred,dataset[subset.test,]$bug)
  misclassification=table1[1,2]+table1[2,1]
  if(subset == 1){
    premisclassification <- misclassification
    bestmodel <- glm.fit
  }
  if (premisclassification>misclassification){
    bestmodel <- glm.fit
    premisclassification <- misclassification
  }
  
}

bestmodel
