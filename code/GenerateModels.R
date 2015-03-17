rm(list = ls())

# RecallVsLOC dataset
file=file.choose()
data <- read.csv(file, na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")

# Original dataset
file=file.choose()
dataset <- read.csv(file, na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")

n <- nrow(data)-1

for (i in (1:n)) { 
  # Get range for first attribute
  start1 <- data[i,"start"]
  end1 <- data[i,"end"]
  att1 <- data[i,"attribute"]
  
  # Get range for next attribute
  start2 <- data[i+1,"start"]
  end2 <- data[i+1,"end"]
  att2 <- data[i+1,"attribute"]
  
  # Find all rows within ranges for both attributes
  rows <- which(dataset[,toString(att1)] > start1 & dataset[,toString(att1)] <= end1 & dataset[,toString(att2)] > start2 & dataset[,toString(att2)] <= end2)
  
  #print(dataset[rows,c(toString(att1), toString(att2))])
  
  # Calculate recall vs LOC
  if(length(rows) > 0) {
    recall <- length(which(dataset[rows,"bug"] > 0))
    #print(recall)
    loc <- sum(dataset[rows, "loc"])
    #print(loc)
    RLVal <- recall/loc
    print(RLVal)
  }
  
  # TODO: Insert in data in decreasingly sorted order
}
