SVM <- function(train, test, kernel) {
  
  # Have a set of cost parameters
  costs <- c(0, 10, 25, 50, 75, 100)
  bestauc <- 0
  for(cost in costs) {
    svm <- ksvm(as.factor(bug) ~ .,
                     data=train,
                     kernel=kernel,
                     C=50,
                     prob.model=TRUE)
    
    pred <- predict(svm, test)
    triggers <- which(pred==1)
    auc <- aucPdPf(test, test[triggers,])
    
    if(auc > bestauc) bestauc = auc
  }
  return(bestauc)
}