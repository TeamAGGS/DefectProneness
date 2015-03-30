library(rpart)
library(mda)
library(randomForest)
library(kernlab)
library(e1071)

rm(list = ls())
source("code/sortrules.R")
source("code/SVM.R")
source("code/RandomForest.R")
source("code/printUtility.R")
source("code/NaiveBayesian.R")
source("code/modelWhich.R")
source("code/getbestrule.R")
source("code/DecisionTree.R")
source("code/aucPdPf.R")


files <- list.files(path="data/training", recursive=F, full.names=T)
folds <- 5
threshold <- 0.25
kernel <- 'rbfdot'
scale <- TRUE
for (file in files) {
  dataset <- read.csv(file=files[1], na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
  datasetName <- basename(file)
  resultFilename <- paste("result",datasetName,sep="/")
  print(resultFilename)
  datasetName <- unlist(strsplit(datasetName, "[.]"))[[1]]
  result <- ""
  # Do everything 5 times
  for(repetition in 1:5) {
    
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
      print(paste(paste("Repetition = ", repetition), paste("Iteration = ", i)))
      
      rlDT = rlNB = rlRF = rlSVM = rlWHICH = 0
      
      test = data[which(fold == i),]
      train = setdiff(data,test)
      
      # TODO: Transform the training data.Maybe perform SMOTE here?
      
      triggered <- test[which(test[,"bug"] == 1),]
      god <- aucPdPf(test, triggered)
      
      out <- ""
      out <- printUtility(repetition, i, datasetName, "DecisionTree", out)
      print("DecisionTree")
      mortal <- DecisionTree(train, test, 'gini')
      mortal <- mortal/god
      out <- paste(out, mortal, sep = ",")
      result <- paste(result, out, sep="\n")
      
      out <- ""
      out <- printUtility(repetition, i, datasetName, "NaiveBayesian", out)
      print("NaiveBayesian")
      mortal <- NaiveBayesian(train, test)
      mortal <- mortal/god
      out <- paste(out, mortal, sep = ",")
      result <- paste(result, out, sep="\n")
      
      out <- ""
      out <- printUtility(repetition, i, datasetName, "RandomForest", out)
      print("RandomForest")
      mortal <- RandomForest(train, test)
      mortal <- mortal/god
      out <- paste(out, mortal, sep = ",")
      result <- paste(result, out, sep="\n")
      
      out <- ""
      out <- printUtility(repetition, i, datasetName, "SVM", out)
      print("SVM")
      mortal <- SVM(train, test, kernel, scale)
      mortal <- mortal/god
      out <- paste(out, mortal, sep = ",")
      result <- paste(result, out, sep="\n")
      
      out <- ""
      out <- printUtility(repetition, i, datasetName, "Which", out)
      print("Which")
      mortal <- modelWhich(train, test, threshold)
      mortal <- mortal/god
      out <- paste(out, mortal, sep = ",")
      result <- paste(result, out, sep="\n")
      
    }
  }
  write(result, file=resultFilename)
}
