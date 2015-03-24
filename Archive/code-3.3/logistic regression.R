options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)
print(args)

set.seed(123)
k <- 10 # For 10-fold cross-validation
file=file.choose()
dataset <- read.csv(file, na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
file_name <- basename(file)
file_name
 
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
  
  glm.fit = glm(bug ~ ., data = dataset[train.index,], family = binomial)
  glm.prob = predict(glm.fit, data = dataset[cv.index,], type = "response")
  glm.pred = rep("0",dim(dataset[cv.index,])[1])
  for(i in 1:dim(dataset[cv.index,])[1]){
    if(glm.prob[i] > 0.5)
      glm.pred[i] = "1"  
  }
  table1=table(glm.pred,dataset[cv.index,]$bug)
  c.error=(table1[1,2]+table1[2,1])/(table1[1,2]+table1[2,1]+table1[1,1]+table1[2,2])
  if(c.error < error) {
    error <- c.error
    bestmodel <- glm.fit
  }
}

bestmodel
############# End of k-fold Cross Validation ######################

# save Model
modelfile=paste(paste("../models/",file_name, sep=""), ".rda", sep="")
save(bestmodel, file=modelfile)

error