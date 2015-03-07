#Program to discretize a dataset
library("Hmisc")
args <- commandArgs(trailingOnly = TRUE)
file = paste(args[1], "/", args[2], sep="")
data = read.csv(file, header = TRUE)
data <- data[,-c(1,2,3)]
number_attr = 1
while(number_attr <= (ncol(data)-1))
{
  values = data[[number_attr]]
  #Discretize the data into 5 bins
  discrete_values = as.numeric(cut2(values, g = 5))
  data[[number_attr]] = discrete_values
  number_attr=number_attr+1
}
#Dataset with discretized columns except the 'bug' column
write.csv(data, file = paste("../DiscretizedData/", args[2], sep=""), row.names=FALSE)