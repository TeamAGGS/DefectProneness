library(mda)

# Clear the environment
rm(list = ls())

options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)
print(args)

# Get all the arguments
model.filename <- args[1]
data.filename <- args[2]
result.filename <- args[3]

# Read the model and the test-data
load(file=model.filename)
testdata <- read.csv(file=data.filename, na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")

testdata <- testdata[,-c(1,2,3)]
testdata$bug <- factor(ifelse(testdata$bug > 0, 1, 0))
pred <- predict(bestmodel, testdata, type="class")
cm <- confusion(pred, factor(testdata$bug, levels=c(0,1)))
cm
writedata <- cbind(testdata, pred)
write.csv(writedata, file=result.filename, row.names=F)
