#Program to get the %LOC Vs %Bugs for a dataset
#Reading the data csv file
dataset = read.csv(file=choose.files(), header = TRUE)

#Adding a new column respective to number of bugs
bugs = rep(0,nrow(dataset))
bugs[which(dataset$bug==0)] = 0
bugs[which(dataset$bug>0)] = 1

#adding the bugs column
data=cbind(dataset,bugs)

number_bugs = length(which(data$bugs == 1))
number_modules = nrow(data)

#function to get %bugs 
get_perc_bugs <- function(data){
  i = 10
  locvsbug = {0}
  while(i<=100)
  {
    loc_percent = round(i/100*number_modules)
    #get number of bugs for this percent of modules
    bugs = length(which(data[1:loc_percent,"bugs"] == 1))
    perc_bugs = bugs/number_bugs*100
    locvsbug[i/10] = perc_bugs
    i=i+10
  }
  return(locvsbug)
}
#For ManualUP- Ascending ordering
asc_loc_data = data[with(data, order(loc)),]
lvb_asc = get_perc_bugs(asc_loc_data)
plot(lvb_asc, xlab="%Loc Inspected", ylab="%Bugs Detected", main="Loc Vs Bugs Detected", pch=21, type="o", col=2, xaxt="n")
axis(1, at=1:10, lab=c("10","20","30","40","50","60","70","80","90","100"))

#For ManualDown- Descending ordering
des_loc_data = data[with(data, order(-loc)),]
lvb_des = get_perc_bugs(des_loc_data)
lines(lvb_des, col=1, pch=21, type="o")

#For GodCurve
data_godcurve = data[with(data, order(-bugs)),]
lvb = get_perc_bugs(data_godcurve)
lines(lvb, col=4, pch=21, type="o")

#Prediction Line
