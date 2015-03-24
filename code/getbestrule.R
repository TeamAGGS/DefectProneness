getbestrule <- function(rules.all, dataset) {
  # Implement the algorithm
  threshold <- 0.00001
  bestvalue <- rules.all[[1]]@rl
  numiter <- 100
  totalrules <- length(rules.all)
  
  # Create a matrix such than an entry [i,j] = 1 if rules.all[[i]] & rules.all[[j]] has already been processed together
  visited <- matrix(0, totalrules, totalrules)
  
  # TODO: Ideally we would want this to continue until we can't improve enough.
  # Have a variable "bestvalue = rules.all[[1]]@rl". Update this value if the rule
  # generated in the next iteration gives a better value. Continue generating
  # rules until you can't improve by a factor of "threshold"
  for(iter in 1:numiter) {
    
    # randomly get index of two rules
    # TODO: Choose indexes at random based on their "rl" value.
    # Higher the value of rl, more likely is it that the rule will be selected.
    rule1.index <- round(runif(1, 1, totalrules))
    rule2.index <- round(runif(1, 1, totalrules))
    
    # Check if they have already been seen before as a pair. If not, mark them visited
    if(visited[rule1.index,rule2.index] == 1) next
    visited[rule1.index,rule2.index] = 1
    visited[rule2.index,rule1.index] = 1
    
    # Get the actual rules
    rule.first <- rules.all[[rule1.index]]@attributes
    rule.second <- rules.all[[rule2.index]]@attributes
         
    # Check is one rule is a subset of the other rule
    if(isSubset(rule.first, rule.second)) next
    
    # Check if the attributes in both the rules are the same.
    # This will give us an empty set
    if(hasSameAttributes(rule.first, rule.second)) next
      
    # Now these two rules can be combined and added to the set of rules
    datadup = dataset
    # Apply all the rules in Rule-1
    for(i in 1:(length(rule.first))) {
      attribute <- rule.first[[i]]@name
      upper <- rule.first[[i]]@upper
      lower <- rule.first[[i]]@lower
      datadup <- datadup[which(datadup[,attribute] > lower & datadup[,attribute] <= upper),]
    }
    for(i in 1:(length(rule.second))) {
      attribute <- rule.second[[i]]@name
      upper <- rule.second[[i]]@upper
      lower <- rule.second[[i]]@lower
      datadup <- datadup[which(datadup[,attribute] > lower & datadup[,attribute] <= upper),]
    }
    # Check if the intersection of these two rule give us an empty set
    if(nrow(datadup) == 0) next
    else {
      # Find the recall/loc of this new rule
      recall <- length(which(datadup[,"bug"] > 0))
      loc <- sum(datadup[,"loc"])
      rl <- recall/loc;
      
      # If rl is better than betvalue update bestvalue
      if(rl > bestvalue)
        bestvalue <- rl
      
      # Create a new rule by combining these two rules and add it to the set of rules
      newrule <- new("Rule", attributes = c(rule.first, rule.second), rl = rl)
      rules.all <- c(rules.all, newrule)
      
      # TODO: Add this rule to its proper place in rules.all based on its "rl" value.
      # This will be required when we choose rules at random based on their "rl" value.
      
      # Add a row and column for this rule in visited matrx
      v <- rep(0, nrow(visited))
      visited <- cbind(visited, v)
      v <- c(v, 0)
      visited <- rbind(visited, v) 
    }
  }
  return(rules.all)
}


hasSameAttributes <- function(rule.first, rule.second) {
  att.first <- c()
  att.second <- c()
  for(i in 1:(length(rule.first)))
    att.first <- c(att.first, rule.first[[i]]@name)
  for(i in 1:(length(rule.second)))
    att.second <- c(att.second, rule.second[[i]]@name)
  if(setequal(att.first, att.second))
    return(T)
  else
    return(F)
}

isEmptySet <- function(rule.first, rule.second, dataset) {
  # Apply all the rules in Rule-1
  for(i in 1:(length(rule.first))) {
    attribute <- rule.first[[i]]@name
    upper <- rule.first[[i]]@upper
    lower <- rule.first[[i]]@lower
    dataset <- dataset[which(dataset[,attribute] > lower & dataset[,attribute] <= upper),]
  }
  for(i in 1:(length(rule.second))) {
    attribute <- rule.second[[i]]@name
    upper <- rule.second[[i]]@upper
    lower <- rule.second[[i]]@lower
    dataset <- dataset[which(dataset[,attribute] > lower & dataset[,attribute] <= upper),]
  }
  if(nrow(dataset) > 0)
    return(F)
  else
    return(T)
}


isSubset <- function(rule.first, rule.second, data) {
  if(length(rule.first) > length(rule.second)) {
    # Rule-2 might be contained in Rule-1
    for(i in 1:(length(rule.second))) {
      att <- rule.second[[i]]
      for(j in 1:(length(rule.first))) {
        att2 <- rule.first[[j]]
        if(att@name == att2@name & att@lower == att2@lower & att@upper == att2@upper)  {
          return(T)
        }
      }
    }
  }
  else {
    # Rule-1 might be contained in Rule-2
    for(i in 1:(length(rule.first))) {
      att <- rule.first[[i]]
      for(j in 1:(length(rule.second))) {
        att2 <- rule.second[[j]]
        if(att@name == att2@name & att@lower == att2@lower & att@upper == att2@upper)  {
          return(T)
        }
      }
    }
  }
  return(F)
}