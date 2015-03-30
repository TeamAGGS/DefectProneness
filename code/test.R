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


data <- read.csv(file.choose(), na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
data <- data[sample(nrow(data)),]

train <- round(0.80*nrow(data))
test <- train+1
traindata <- data[1:train,]
testdata <- data[test:nrow(data),]

triggered <- testdata[which(testdata[,"bug"] == 1),]
god <- aucPdPf(testdata, triggered)

DecisionTree(traindata, testdata, 'gini')/god
modelWhich(traindata, testdata, 0.2)/god
SVM(traindata, testdata, 'rbfdot',TRUE)/god
RandomForest(traindata, testdata)/god
NaiveBayesian(traindata, testdata)/god
