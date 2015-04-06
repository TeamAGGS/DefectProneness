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


files <- list.files(path="../data/training_shivani", recursive=F, full.names=T)
DTmg = NBmg = RFmg = SVMmg = WHICHmg = 0
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
  for(repetition in 1:2) {
    
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
      mortalgod <- outputs[[1]]/god
      if(mortalgod > DTmg) {
        DTmg <- mortalgod
        DTmodel <- outputs[[2]]
      }
      out <- paste(out, mortalgod, sep = ",")
      result <- paste(result, out, sep="\n")
      
      out <- ""
      out <- printUtility(repetition, i, datasetName, "NaiveBayesian", out)
      print("NaiveBayesian")
      outputs <- NaiveBayesian(train, test)
      mortalgod <- outputs[[1]]/god
      if(mortalgod > NBmg) {
        NBmg <- mortalgod
        NBmodel <- outputs[[2]]
      }
      out <- paste(out, mortalgod, sep = ",")
      result <- paste(result, out, sep="\n")
      
      out <- ""
      out <- printUtility(repetition, i, datasetName, "RandomForest", out)
      print("RandomForest")
      outputs <- RandomForest(train, test)
      mortalgod <- outputs[[1]]/god
      if(mortalgod > RFmg) {
        RFmg <- mortalgod
        RFmodel <- outputs[[2]]
      }
      out <- paste(out, mortalgod, sep = ",")
      result <- paste(result, out, sep="\n")
      
      out <- ""
      out <- printUtility(repetition, i, datasetName, "SVM", out)
      print("SVM")
      outputs <- SVM(train, test, kernel, scale)
      mortalgod <- outputs[[1]]/god
      if(mortalgod > SVMmg) {
        SVMmg <- mortalgod
        SVMmodel <- outputs[[2]]
      }
      out <- paste(out, mortalgod, sep = ",")
      result <- paste(result, out, sep="\n")
      
      out <- ""
      out <- printUtility(repetition, i, datasetName, "Which", out)
      print("Which")
      outputs <- modelWhich(train, test, threshold)
      #print(outputs[[2]])
      mortalgod <- outputs[[1]]/god
      if(mortalgod > WHICHmg) {
        WHICHmg <- mortalgod
        WHICHrule <- outputs[[2]]
      }
      out <- paste(out, mortalgod, sep = ",")
      result <- paste(result, out, sep="\n")
      
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

# Run best SVM model on testing
SVM <- predict(SVMmodel, testdata)
cm <- confusion(SVM, factor(testdata$bug, levels=c(0,1)))
cm
writedata <- cbind(writedata, SVM)

# Run best Naive Bayesian on testing
NB <- predict(NBmodel, testdata)
cm <- confusion(NB, factor(testdata$bug, levels=c(0,1)))
cm
writedata <- cbind(writedata, NB)

# Run best rule of WHICH on testing
WHICH <- numeric(nrow(testdata))
writedata <- cbind(writedata, WHICH)
for(rule in WHICHrule@attributes) {
  att <- rule@name
  lower <- rule@lower
  upper <- rule@upper
  writedata$WHICH[which(writedata[,att] > lower & writedata[,att] <= upper)] <- 1
}

# Write file
write.csv(writedata, file="ant_with_learners.csv", row.names=F)
