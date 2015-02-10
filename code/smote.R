dataset <- read.csv(file=choose.files(), na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
dataset$bug <- factor(ifelse(dataset$bug > 0, 1, 0))
dataset <- dataset[,-c(1,2,3)]
class0 <- length(which(dataset$bug == 0))
class1 <- nrow(dataset) - class0
perc.over = (abs(class0 %/% class1)-1)*100
newData <- SMOTE(bug ~., dataset, perc.over, perc.under=180, k=4)
table(newData$bug)
write.csv(newData, file="data_SMOTE/kalkulator.csv", row.names=F)
