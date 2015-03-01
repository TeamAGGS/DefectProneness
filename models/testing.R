file=file.choose()
dataset <- read.csv(file, na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
load("")
pred <- predict(tree, dataset[cv.index,], type="class")
pred