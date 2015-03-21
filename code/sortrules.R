sortrules <- function(rules.all) {
  # Can use Insertion Sort here since we have few rules
  totalrules <- length(rules.all)
 
  for(i in 2:totalrules) {
    currentrule <- rules.all[[i]]
    currentrl <- currentrule@rl
    j <- i-1
    while(j >= 1 && rules.all[[j]]@rl < currentrl) {
      rules.all[[j+1]] = rules.all[[j]] 
      j <- j-1
    }
    rules.all[[j+1]] = currentrule
  }
  
  return(rules.all)
}