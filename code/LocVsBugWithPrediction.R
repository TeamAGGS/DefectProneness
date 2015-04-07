#Program to get the %LOC Vs %Bugs for a dataset
#For all the datasets with the predicted values- all learners
training_files <- list.files(path = "result/dataset_with_learners", pattern = ".csv", full.names = TRUE)

#For each of the files, generate graphs
for(file in training_files){
  file = "result/dataset_with_learners/velocity_with_learners.csv"
  data = read.csv(file, header = TRUE)
  file_name = basename(file)
  
  number_modules = nrow(data)
  number_bugs = length(which(data$bug == 1))
  #number_predicted_bugs = length(which(data$pred == 1))
  
  #plot = paste(file_name,".jpg")
  #jpeg(file = paste("Plots/",plot, sep=""))
  
  #For ManualUP- Ascending ordering
  data = data[with(data, order(loc)),]
  lvb_asc = get_perc_bugs(data, 'None')
  
  #For ManualDown- Descending ordering
  data = data[with(data, order(-loc)),]
  lvb_des = get_perc_bugs(data, 'None')
  
  #For GodCurve
  data = data[with(data, order(-bug)),]
  lvb = get_perc_bugs(data, 'None')
  
  # RF prediction curve
  data = data[with(data, order(loc)),]
  pred_rf = get_perc_bugs(data, 'RF')

  # DT prediction curve
  pred_dt = get_perc_bugs(data, 'DT')
  
  # SVM prediction curve
  pred_svm = get_perc_bugs(data, 'SVM')
  
  # NB prediction curve
  pred_nb = get_perc_bugs(data, 'NB')
  
  # WHICH prediction curve
  pred_which = get_perc_bugs(data, 'WHICH')
  
  matplot(cbind(lvb_asc, lvb_des, lvb, pred_rf, pred_dt, pred_svm, pred_nb, pred_which), 
          col=c("red", "blue", "green", "brown", "black", "yellow", "orange", "pink"), 
          pch=21, type="o", xaxt="n", xlab="%LOC inspected", ylab="% Bugs found")
  axis(1, at=1:10, lab=c("10","20","30","40","50","60","70","80","90","100"))
  #axis(2, at=c("10","20","30","40","50","60","70","80","90","100"))
  legend(1,140, c("Manual Up", "Manual Down", "God curve", "RF", "DT", "SVM", "NB", "WHICH"), col=c("red", "blue", "green", "brown", "black", "yellow", "orange", "pink"), bty="o", 
         box.lty=1, box.lwd=0.005, box.col=1,lty=c(1,1,1),x.intersp=0.01, y.intersp=0.75, text.width=3.15,
         xjust=0, seg.len=0.80, pt.cex = 1, cex=0.75)

#   Prediction Line
#   asc_loc_data = data[with(data, order(loc)),]
#   pred_asc = get_perc_bugs(asc_loc_data, 'True')
#   lines(pred_asc, col=3, pch=21, type="o")
  
  #dev.off()
  
}

#function to get %bugs 
get_perc_bugs <- function(data, prediction){
  prediction
  i = 10
  locvsbug = {0}
  number_bugs = length(which(data$bug == 1))
  while(i<=100)
  {
    loc_percent = round(i/100*number_modules)
    #get number of bugs for this percent of modules
    if(prediction == 'None'){
      bugs = length(which(data[1:loc_percent,"bug"] == 1))
    }    
    else if(prediction == 'RF'){
      bugs = length(which(data[1:loc_percent,"RF"] == 1))
    }
    else if(prediction == 'DT'){
      bugs = length(which(data[1:loc_percent,"DT"] == 1))
    }
    else if(prediction == 'SVM'){
      bugs = length(which(data[1:loc_percent,"SVM"] == 1))
    }
    else if(prediction == 'NB'){
      bugs = length(which(data[1:loc_percent,"NB"] == 1))
    }
    else if(prediction == 'WHICH') {
      bugs = length(which(data[1:loc_percent,"WHICH"] == 1))
    }
    
    perc_bugs = bugs/number_bugs*100
    locvsbug[i/10] = perc_bugs
    i=i+10
  }
  return(locvsbug)
}

