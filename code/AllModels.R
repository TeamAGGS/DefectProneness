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


files <- list.files(path="C:/defect_proness/DefectProneness/data/training_shivani", recursive=F, full.names=T)
DTauc = NBauc = RFauc = SVMauc = WHICHauc = 0
DTmodel = NBmodel = RFmodel = SVMmodel = WHICHmodel = ""
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
      outputs <- DecisionTree(train, test, 'gini')
      if(outputs[[1]] > RFauc) {
        DTauc <- outputs[[1]]
        DTmodel <- outputs[[2]]
      }
      mortal <- outputs[[1]]/god
      out <- paste(out, mortal, sep = ",")
      result <- paste(result, out, sep="\n")
      
      #out <- ""
      #out <- printUtility(repetition, i, datasetName, "NaiveBayesian", out)
      #print("NaiveBayesian")
      #mortal <- NaiveBayesian(train, test)
      #mortal <- mortal/god
      #out <- paste(out, mortal, sep = ",")
      #result <- paste(result, out, sep="\n")
      
      out <- ""
      out <- printUtility(repetition, i, datasetName, "RandomForest", out)
      print("RandomForest")
      outputs <- RandomForest(train, test)
      if(outputs[[1]] > RFauc) {
        RFauc <- outputs[[1]]
        RFmodel <- outputs[[2]]
      }
      mortal <- outputs[[1]]/god
      out <- paste(out, mortal, sep = ",")
      result <- paste(result, out, sep="\n")
      
      out <- ""
      out <- printUtility(repetition, i, datasetName, "SVM", out)
      print("SVM")
      outputs <- SVM(train, test, kernel, scale)
      if(outputs[[1]] > RFauc) {
        SVMauc <- outputs[[1]]
        SVMmodel <- outputs[[2]]
      }
      mortal <- outputs[[1]]/god
      out <- paste(out, mortal, sep = ",")
      result <- paste(result, out, sep="\n")
      
      #out <- ""
      #out <- printUtility(repetition, i, datasetName, "Which", out)
      #print("Which")
      #mortal <- modelWhich(train, test, threshold)
      #mortal <- mortal/god
      #out <- paste(out, mortal, sep = ",")
      #result <- paste(result, out, sep="\n")
      
    }
  }
  write(result, file=resultFilename)
}

# Read ant.csv testing data
testdata <- read.csv(file=file.choose(), na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
testdata <- testdata[,-c(1,2,3)]
testdata$bug <- factor(ifelse(testdata$bug > 0, 1, 0))

# Run best random forest model on testing
RF <- predict(RFmodel, testdata, type="class")
cm <- confusion(RF, factor(testdata$bug, levels=c(0,1)))
cm
writedata <- cbind(testdata, RF)

# Run best decision tree model on testing
DT <- predict(DTmodel, testdata, type="class")
cm <- confusion(DT, factor(testdata$bug, levels=c(0,1)))
cm
writedata <- cbind(writedata, DT)

# Write file
write.csv(writedata, file="ant_with_learners.csv", row.names=F)
