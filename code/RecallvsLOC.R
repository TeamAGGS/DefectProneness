dataset <- read.csv(file=file.choose(), na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
file_name <- basename(file)
dataset <- dataset[,-c(1,2,3)]
attributes = ncol(dataset)-1
for (attribute in (1:attributes)) { 
  quantiles <- quantile(dataset[,attribute], c(0.20, 0.40, 0.60, 0.80, 1.00))
  for (quantile in quantiles) {
    rows <- which(dataset[,attribute] <= quantile)
    recall <- length(which(dataset[rows,"bug"] > 0))
    loc <- sum(dataset[rows, "loc"])
    print(paste("Attribute: ", colnames(dataset)[attribute], " <= ", quantile, " , Recall/LOC =  ", recall/loc))
    
  }
}

