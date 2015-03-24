#Program to get the %LOC Vs %Bugs for a dataset
#Reading the data csv file
file = file.choose()
data = read.csv(file, header = TRUE)
file_name = basename(file)

number_modules = nrow(data)
number_bugs = length(which(data$bug == 1))
number_predicted_bugs = length(which(data$pred == 1))

#function to get %bugs 
get_perc_bugs <- function(data, prediction){
  i = 10
  locvsbug = {0}
  while(i<=100)
  {
    loc_percent = round(i/100*number_modules)
    #get number of bugs for this percent of modules
    if(prediction == 'False'){
      bugs = length(which(data[1:loc_percent,"bug"] == 1))
    }    
    else
    {
      bugs = length(which(data[1:loc_percent,"pred"] == 1))
    }
    perc_bugs = bugs/number_bugs*100
    locvsbug[i/10] = perc_bugs
    i=i+10
  }
  return(locvsbug)
}

#For ManualDown- Descending ordering#For ManualUP- Ascending ordering
asc_loc_data = data[with(data, order(loc)),]
lvb_asc = get_perc_bugs(asc_loc_data, 'False')
plot(lvb_asc, xlab="%Loc Inspected", ylab="%Bugs Detected", main=paste("Loc Vs Bugs Detected for:",file_name), pch=21, type="o", col=2, xaxt="n")
axis(1, at=1:10, lab=c("10","20","30","40","50","60","70","80","90","100"))

des_loc_data = data[with(data, order(-loc)),]
lvb_des = get_perc_bugs(des_loc_data, 'False')
lines(lvb_des, col=1, pch=21, type="o")

#For GodCurve
data_godcurve = data[with(data, order(-bug)),]
lvb = get_perc_bugs(data_godcurve, 'False')
lines(lvb, col=4, pch=21, type="o")

#Prediction Line
asc_loc_data = data[with(data, order(loc)),]
pred_asc = get_perc_bugs(asc_loc_data, 'True')
lines(pred_asc, col=3, pch=21, type="o")
