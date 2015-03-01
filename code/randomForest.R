library(mda)
library(randomForest)

options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)
print(args)

set.seed(123)

file=args[1]
dataset <- read.csv(file, na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
file_name <- basename(file)

bestmodel <- randomForest(as.factor(bug) ~., dataset, ntree=500, replace=T,mtry=35)
bestmodel
modelfile=paste(paste("../models/",file_name, sep=""), ".rda", sep="")
save(bestmodel, file=modelfile)
testdata <- read.csv(file=args[2], na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
pred <- predict(bestmodel, testdata, type="class")
cm <- confusion(pred, factor(testdata$bug, levels=c(0,1)))
cm