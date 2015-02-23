library(mda)

# Clear the environment
rm(list = ls())

options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)
print(args)

# Get all the arguments
directory <- args[1]
files <- list.files(path=directory, recursive=F, full.names=T)
result = paste("# g-Measure for every dataset for Decision Tree", "\n\n", sep="")
header <- paste("Dataset | ", " g-Measure", sep="")
result <- paste(result, header, sep="")
hline <- "------- | -------"
result <- paste(result, hline, sep="\n")

for (file in files) {
  data <- read.csv(file=file, na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")
  cm <- confusion(factor(data$pred, levels=c(1,0)), factor(data$bug, levels=c(1,0)))
  tp <- cm[1]
  fp <- cm[3]
  tn <- cm[4]
  fn <- cm[2]
  
  pd <- tp/(tp+fn)
  pf <- fp/(fp+tn)
  gmeasure <- (2*pd*(100-pf))/(pd+(100-pf))
  #print(gmeasure)
  g <- unlist(strsplit(file, "/"))
  filename <- g[2]
  line <- ""
  line <- paste(filename, " | ", sep="")
  line <- paste(line, gmeasure, sep="")
  result <- paste(result, "\n",sep="")
  result <- paste(result, line, sep="")
}
#print(result)
write(result, file="../g-measure.md")
