
file=file.choose()
data <- read.csv(file, na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")

names(data) <- c("A","B","Dataset","Learner","Value")
learners <- c("RandomForest", "DecisionTree", "SVM", "Which", "NaiveBayesian")

writedata <- ""

for (i in 1:length(learners)) {
  newdata <- data[ which(data$Learner==learners[i]), ]
  quantiles <- quantile(newdata$Value, c(0.25, 0.5, 0.75),names = T)
  quantiles <- c(learners[i], quantiles)
  writedata <- rbind(quantiles, writedata)
}

write.csv(writedata, file="xalan_result.csv", row.names=F)


