library(rpart)
library(mda)
library(randomForest)
library(kernlab)
library(e1071)

dataset <- read.csv(file.choose(), na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
folds <- 5
threshold <- 0.25
kernel <- 'rbfdot'
# Do everything 5 times
for(repetition in 1:5) {
  
  header <- paste("# Repetition: ", repetition)
  result <- paste(result, header, sep="\n\n")
  result <- paste(result, "Fold# | Decision Tree | Naive-Bayesian | Random Forest | SVM | Which", sep="\n")
  result <- paste(result, "--------- | --------- | --------- | --------- | --------- | ---------", sep="\n")
  # Shuffle the data in every repetition
  data <- dataset[sample(nrow(dataset)),]
  
  # Divide data into 5 'folds' for cross-validation
  n <- nrow(data)
  fold <- rep(0,n)
  c <- 0
  for (i in 1:(n %/% folds)) {
    for (j in 1:folds) {
      fold[c] <- j
      c <- c + 1
    }
  }
  fold <- fold[sample(1:length(fold), length(fold), replace=F)]
  
  # Perform 'folds' time cross-validation using all the models
  for(i in 1:folds) {
    
    print("**************************************************")
    
    rlDT = rlNB = rlRF = rlSVM = rlWHICH = 0
    
    test = data[which(fold == i),]
    train = data[setdiff(1:length(fold),test),]
    
    god <- aucPdPf(test, test[which(test[,"bug"] == 1),])
    
    out <- paste("Fold: ", i)
    mortal <- DecisionTree(train, test, 'gini')
    mortal <- mortal/god
    out <- paste(out, mortal, sep = " | ")
    
    mortal <- NaiveBayesian(train, test)
    mortal <- mortal/god
    out <- paste(out, mortal, sep = " | ")
    
    mortal <- RandomForest(train, test)
    mortal <- mortal/god
    out <- paste(out, mortal, sep = " | ")
    
    mortal <- SVM(train, test, kernel)
    mortal <- mortal/god
    out <- paste(out, mortal, sep = " | ")
    
    mortal <- modelWhich(train, test, threshold)
    mortal <- mortal/god
    out <- paste(out, mortal, sep = " | ")
    
    result <- paste(result, out, sep=" \n")
  }
}
write(result, file="allModels.md")