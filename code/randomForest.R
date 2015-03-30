RandomForest <- function(train, test) {
  
  # Set some parameters for tuning
  trees <- c(10,20,40,80,100)
  bestauc <- 0
  
  for(tree in trees) {
    forest <- randomForest(as.factor(bug) ~., train, ntree=tree, replace=T)
    pred <- predict(forest, test)
    triggers <- which(pred==1)
    auc <- 0
    if(length(triggers) > 0) {
      auc <- aucPdPf(test, test[triggers,])
    }
    
    if(auc > bestauc) bestauc = auc
  }
  return(bestauc)
}