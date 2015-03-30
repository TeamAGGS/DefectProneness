printUtility <- function(repetition, fold, data, model, out) {
  out <- paste(repetition, fold, sep=",")
  out <- paste(out, datasetName, sep=",")
  out <- paste(out, model, sep=",")
  return(out)
}