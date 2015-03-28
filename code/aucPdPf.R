aucPdPf <- function(tests, triggered) {
  loc0 = sum(tests[,"loc"])
  bad0 = nrow(tests)
  auc = loc1 = bad1 = 0
  
  # Take all the buggy item, work up in ascending order
  bad1 = nrow(triggered)
  triggered <- triggered[with(triggered, order(loc)),]
  for(i in 1:nrow(triggered)) {
    pd = bad1/bad0
    loc1 = loc1 + triggered[i,"loc"]
    ploc = loc1/loc0
    score = pd/ploc
    auc = auc + score
  }
  
  rest <- setdiff(tests, triggered)
  rest <- rest[with(rest, order(loc)),]
  for(i in 1:nrow(rest)) {
    loc1 = loc1 + rest[i,"loc"]
    ploc = loc1/loc0
    score = pd/ploc
    auc = auc + score
  }
  return(auc)
  
}