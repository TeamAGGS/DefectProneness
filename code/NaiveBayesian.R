NaiveBayesian <- function(train, test) {
  NB <- naiveBayes(as.factor(bug) ~., train, laplace=0)
  pred <- predict(NB, test, type="class")
  
  triggers <- which(pred==1)
  auc <- 0
  if(length(triggers) > 0) {
    auc <- aucPdPf(test, test[triggers,])
  }
  return(list(auc,NB))
}