dataset <- read.csv(file=file.choose(), na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
file_name <- basename(file)
dataset <- dataset[,-c(1,2,3)]
attributes = ncol(dataset)-1
for (attribute in (1:attributes)) { 
  quantiles <- c(0, quantile(dataset[,attribute], c(0.20, 0.40, 0.60, 0.80, 1.00)))
  for (i in 2:6) {
    rows <- which(dataset[,attribute] <= quantiles[i] & dataset[,attribute] > quantiles[i-1])
    if(length(rows) > 0) {
      recall <- length(which(dataset[rows,"bug"] > 0))
      loc <- sum(dataset[rows, "loc"])
      print(paste(quantiles[i-1], " < ", colnames(dataset)[attribute], " <= ", quantiles[i], ": , Recall/LOC =  ", recall/loc))
    } 
  }
}

