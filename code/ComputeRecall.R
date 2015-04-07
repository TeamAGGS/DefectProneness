#Program to compute Recall value for a dataset

#Reading the data csv file
dataset = read.csv(file="ant_with_learners.csv", header = TRUE)

writedata <- ""

# RF
num = length(which(dataset$bug == 1 & dataset$RF == 1))
den = length(which(dataset$RF==1))
recall = num/den
writedata <- paste(writedata,(paste("Random Forest: ", recall)))

# DT
num = length(which(dataset$bug == 1 & dataset$DT == 1))
den = length(which(dataset$DT==1))
recall = num/den
writedata <- paste(writedata,(paste("\nDecision Tree: ", recall)))

# NB
num = length(which(dataset$bug == 1 & dataset$NB == 1))
den = length(which(dataset$NB==1))
recall = num/den
writedata <- paste(writedata,(paste("\nNaive Bayesian: ", recall)))

# SVM
num = length(which(dataset$bug == 1 & dataset$SVM == 1))
den = length(which(dataset$SVM==1))
recall = num/den
writedata <- paste(writedata,(paste("\nSVM: ", recall)))

# WHICH
num = length(which(dataset$bug == 1 & dataset$WHICH == 1))
den = length(which(dataset$WHICH==1))
recall = num/den
writedata <- paste(writedata,(paste("\nWHICH: ", recall)))

writeLines(writedata, "Recall.txt")




