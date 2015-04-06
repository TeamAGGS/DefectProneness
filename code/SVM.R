SVM <- function(train, test, kernel, scale) {
  
  # Have a set of cost parameters
  costs <- c(10, 20, 40, 60, 80, 100)
  bestauc <- 0
  bestmodel <- ""
  for(cost in costs) {
    if(!scale) {
      svm <- svm(as.factor(bug) ~ .,
                 data=train,
                 C=cost,
                 prob.model=TRUE, scale=FALSE)
    } else {
      svm <- ksvm(as.factor(bug) ~ .,
                  data=train,
                  kernel=kernel,
                  C=cost,
                  prob.model=TRUE)
    }
    pred <- predict(svm, test)
    triggers <- which(pred==1)
    auc <- 0
    if(length(triggers) > 0) {
      auc <- aucPdPf(test, test[triggers,])
    }
    
    if(auc > bestauc) {
      bestauc <- auc 
      bestmodel <- svm
    } 
  }
  return(list(bestauc,bestmodel))
}