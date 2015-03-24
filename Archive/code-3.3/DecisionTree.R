library(rpart) 
library(mda)

options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)
print(args)

set.seed(123)
k <- 2 # For 10-fold cross-validation
file=file.choose()
dataset <- read.csv(file, na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
file_name <- basename(file)
 
n <- nrow(dataset)
fold <- rep(0,n)
c <- 0
for (i in 1:(n %/% k)) {
  for (j in 1:k) {
    fold[c] <- j
    c <- c + 1
  }
}
fold <- fold[sample(1:length(fold), length(fold), replace=F)]

############# Perform k-fold Cross Validation ######################
error <- 100
bestmodel <- ""

for(i in 1:k) {
  cv.index = which(fold == i)
  train.index = setdiff(1:length(fold),cv.index)
  
  tree = rpart(bug ~., dataset[train.index,], method="class", parms=list(split=args[1]), control=rpart.control(minsplit=args[2],minbucket=args[3],cp=0))
  pred <- predict(tree, dataset[cv.index,], type="class")
  cm <- confusion(pred, factor(dataset[cv.index,"bug"], levels=c(0,1)))
  c.error <- as.numeric(as.character(attr(cm, "error")))
  
  if(c.error < error) {
    error <- c.error
    bestmodel <- tree
  }
}

bestmodel
############# End of k-fold Cross Validation ######################

# save Model
modelfile=paste(paste("../models/",file_name, sep=""), ".rda", sep="")
save(bestmodel, file=modelfile)

error