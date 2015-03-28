getbestrule <- function(rules.all, dataset, threshold) {
  # Implement the algorithm
  previousBest <- 0
  gen <- 0
  # Sort the rules in descending order of their "rl" value
  rules.all <- sortrules(rules.all)
  
  while(previousBest < rules.all[[1]]@rl & length(rules.all) > 1) {
    # Proceed with next generation while we can still improve. Update prevoiusBest to stack top
    previousBest <- rules.all[[1]]@rl
    gen <- gen + 1
    
    # Get rid of useless rules
    rules.all <- pruneRules(rules.all, threshold)
    
    sum <- sumRL(rules.all)
    totalrules <- length(rules.all)
    
    # It's possible that none of selected pairs could ever be merged.
    # To prevent going into an infinite loop, loop for 5*totalrules times (magic number!)
    totalTrials <- 5*totalrules
    numTrial <- 1
    print(paste("Generation", gen))
    print(paste("Rules:", totalrules))
    
    # Create a matrix such than an entry [i,j] = 1 if rules.all[[i]] & rules.all[[j]] has already been processed together
    visited <- matrix(0, totalrules, totalrules)
    
    while(totalrules > 1 & length(rules.all) <= 2*totalrules & numTrial <= totalTrials) {
      numTrial <- numTrial + 1
      # Randomly get index of two rules. Choose indexes at random based on their "rl" value.
      # Higher the value of rl, more likely is it that the rule will be selected.
      rule1.index <- getIndex(rules.all, sum)
      rule2.index <- rule1.index
      while(rule2.index == rule1.index)
        rule2.index <- getIndex(rules.all, sum)
      #print(paste(rule1.index, rule2.index))
      
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
        
		# Skip this rule if it gives rl = 0. These will be anyway pruned in the next generation
        if(rl == 0) next
        else {
          # Create a new rule by combining these two rules and add it to the set of rules
          newrule <- new("Rule", attributes = c(rule.first, rule.second), rl = rl)
          rules.all <- c(rules.all, newrule)
          
          # Add a row and column for this rule in visited matrx
          v <- rep(0, nrow(visited))
          visited <- cbind(visited, v)
          v <- c(v, 0)
          visited <- rbind(visited, v)
        }
      }
    }
    # Sort the rules at the end of a generation so we can see if we have improved the stack top
    rules.all <- sortrules(rules.all)
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
        if(att@name == att2@name & att@lower == att2@lower & att@upper == att2@upper) return(F)
        else return(T)
      }
    }
  }
  else {
    # Rule-1 might be contained in Rule-2
    for(i in 1:(length(rule.first))) {
      att <- rule.first[[i]]
      for(j in 1:(length(rule.second))) {
        att2 <- rule.second[[j]]
        if(att@name == att2@name) {
          if(att@lower == att2@lower & att@upper == att2@upper) return(F)
          else return(T)
        } 
      }
    }
  }
  return(F)
}

pruneRules <- function(rules.all, threshold){
  top <- rules.all[[1]]@rl
  ignoreAfter <- top*threshold
  for(i in 1:(length(rules.all))) {
    if(rules.all[[i]]@rl < ignoreAfter) {
      return(rules.all[1:(i-1)])
    }
  }
  return(rules.all)
}

sumRL <- function(rules.all) {
  sum <- 0
  for(i in 1:(length(rules.all))) {
    sum <- sum + rules.all[[i]]@rl
  }
  return(sum)
}

getIndex <- function(rules.all, sum) {
  lower <- 0
  upper <- 0
  rand <- runif(1,0,sum)
  for(i in 1:(length(rules.all))) {
    upper <- upper + rules.all[[i]]@rl
    if(rand >= lower & rand <= upper)
      return(i)
    else
      lower <- lower + rules.all[[i]]@rl
  }
}