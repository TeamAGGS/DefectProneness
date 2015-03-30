DecisionTree <- function(train, test, type) {
# Some parameters for Automatic Tuning
  default_minsplit = 20
  default_minbucket = 7 
  minsplit_values = round(c(default_minsplit/4, default_minsplit/2, default_minsplit, default_minsplit*2, default_minsplit*4))
  minbucket_values = round(c(default_minbucket/4, default_minbucket/2, default_minbucket, default_minbucket*2, default_minbucket*4))
  
  bestauc <- 0
  
  # Start making decision-tree models
  for(i in 1:length(minsplit_values)){
    for(j in 1:length(minbucket_values)){
      
      tree <- rpart(as.factor(bug) ~., 
                    train, 
                    method="class", 
                    parms=list(split=type), 
                    control=rpart.control(minsplit=minsplit_values[i], minbucket=minbucket_values[j], cp=0))
      
      pred <- predict(tree, test, type="class")
      triggers <- which(pred==1)
      auc <- 0
      
      if(length(triggers) > 0) {
        auc <- aucPdPf(test, test[triggers,])
      } 
      if(auc > bestauc) bestauc <- auc
    }
  }
  return(bestauc)
}