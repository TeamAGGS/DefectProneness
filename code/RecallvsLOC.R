modelWhich <- function(train, test) {
  setClass("AttributeRange",
           slots=list(name = "character", lower = "numeric", upper = "numeric"))
  
  setClass("Rule",
           slots=list(attributes = "vector", rl = "numeric"))
  
  rules.all <- c()
  numattributes = ncol(dataset)-1
  
#   Perform binning for all attributes and generate corresponding singleton rules
  for (attribute in (1:numattributes)) { 
    quantiles <- c(min(dataset[,attribute]), quantile(dataset[,attribute], c(0.20, 0.40, 0.60, 0.80, 1.00)))
    for (i in 2:6) {
      rows <- which(dataset[,attribute] <= quantiles[i] & dataset[,attribute] > quantiles[i-1])
      if(length(rows) > 0) {
        recall <- length(which(dataset[rows,"bug"] > 0))
        loc <- sum(dataset[rows, "loc"])
        print(paste(quantiles[i-1], " < ", colnames(dataset)[attribute], " <= ", quantiles[i], ": , Recall/LOC =  ", recall/loc))
        att <- new("AttributeRange", name = colnames(dataset)[attribute], lower = quantiles[i-1], upper = quantiles[i])
        newrule <- new("Rule", attributes = c(att), rl = recall/loc)
        rules.all <- c(rules.all, newrule)
      } 
    }
  }
  
#   Be sure to include sortrules and all the functions in getbestrule.R before proceeding.
#   You can do that by selecting everything from that file and executing them.
#   Call getbestrule to get the best rule
  newrules <- getbestrule(rules.all, dataset, 0.25)
  newrules <- sortrules(newrules)
  print(paste("Total rules generated = ", length(newrules)))
  
#   Now pick the top of the stack and return its rl
  return(newrules[[1]]@rl)
  
#   for(i in 1:(length(newrules))) {
#     rl <- newrules[[i]]@rl
#     numAtt <- length(newrules[[i]]@attributes)
#     print(paste("Rule:",i))
#     print(paste(paste("Num Attributes=", numAtt), paste("Recall/LOC=", rl), sep=" ,"))
#   }
}


  
