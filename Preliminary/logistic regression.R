setwd("D:/datasheet")
data1 = read.csv("ant-1.7.csv")

bugs = rep(0,nrow(data1))
bugs[which(data1$bug==0)] = 0
bugs[which(data1$bug>0)] = 1
data1=cbind(data1,bugs)

##randomly split the data into five folds
k = 5
set.seed(1)
folds = sample(1:k, dim(data1)[1], replace = TRUE)
set1 = data1[folds == 1,]
set2 = data1[folds == 2,]
set3 = data1[folds == 3,]
set4 = data1[folds == 4,]
set5 = data1[folds == 5,]

##choose set 1 to do logistic regression to train the model and test the model to get the error rate
len1 = dim(set1)[1]
train1 = sample(len1,len1 * 0.9)

set1.train = set1[train1,]
set1.test = set1[-train1,]
names(set1.train)
glm.fit1 = glm(bugs ~ wmc + dit + noc + cbo + rfc + lcom + ca + ce + npm + lcom3 + loc + dam + moa + mfa + cam + ic + cbm + amc + max_cc + avg_cc, data = set1.train, family = binomial)
summary(glm.fit1)

glm.prob1 = predict(glm.fit1, data = set1.test, type = "response")
dim(set1.test)
glm.pred1 = rep("0",dim(set1.test)[1])
for(i in 1:dim(set1.test)[1]){
  if(glm.prob1[i] > 0.5)
    glm.pred1[i] = "1"  
}
##get the confusion matrix
table1=table(glm.pred1,set1.test$bugs)
p1=table1[2,2]/(table1[2,2]+table1[2,1])
r1=table1[2,2]/(table1[2,2]+table1[1,2])
F1=2*p1*r1/(r1+p1)

##do the same for the rest four parts and record the error rate
len2 = dim(set2)[1]
train2 = sample(len2,len2 * 0.9)

set2.train = set2[train2,]
set2.test = set2[-train2,]

glm.fit2 = glm(bugs ~ wmc + dit + noc + cbo + rfc + lcom + ca + ce + npm + lcom3 + loc + dam + moa + mfa + cam + ic + cbm + amc + max_cc + avg_cc, data = set2.train, family = binomial)
summary(glm.fit2)

glm.prob2 = predict(glm.fit2, data = set2.test, type = "response")
dim(set2.test)
glm.pred2 = rep("0",dim(set2.test)[1])
for(i in 1:dim(set2.test)[1]){
  if(glm.prob2[i] > 0.5)
    glm.pred2[i] = "1"  
}
table2=table(glm.pred2,set2.test$bugs)
p2=table2[2,2]/(table2[2,2]+table2[2,1])
r2=table2[2,2]/(table2[2,2]+table2[1,2])
F2=2*p2*r2/(r2+p2)

##the third one
len3 = dim(set3)[1]
train3 = sample(len3,len3 * 0.9)

set3.train = set3[train3,]
set3.test = set3[-train3,]

glm.fit3 = glm(bugs ~ wmc + dit + noc + cbo + rfc + lcom + ca + ce + npm + lcom3 + loc + dam + moa + mfa + cam + ic + cbm + amc + max_cc + avg_cc, data = set3.train, family = binomial)
summary(glm.fit3)

glm.prob3 = predict(glm.fit3, data = set3.test, type = "response")
dim(set3.test)
glm.pred3 = rep("0",dim(set3.test)[1])
for(i in 1:dim(set3.test)[1]){
  if(glm.prob3[i] > 0.5)
    glm.pred3[i] = "1"  
}
table3=table(glm.pred3,set3.test$bugs)
p3=table3[2,2]/(table3[2,2]+table3[2,1])
r3=table3[2,2]/(table3[2,2]+table3[1,2])
F3=2*p3*r3/(r3+p3)

##the fourth one
len4 = dim(set4)[1]
train4 = sample(len4,len4 * 0.9)

set4.train = set4[train4,]
set4.test = set4[-train4,]

glm.fit4 = glm(bugs ~ wmc + dit + noc + cbo + rfc + lcom + ca + ce + npm + lcom3 + loc + dam + moa + mfa + cam + ic + cbm + amc + max_cc + avg_cc, data = set4.train, family = binomial)
summary(glm.fit4)

glm.prob4 = predict(glm.fit4, data = set4.test, type = "response")
dim(set4.test)
glm.pred4 = rep("0",dim(set4.test)[1])
for(i in 1:dim(set4.test)[1]){
  if(glm.prob4[i] > 0.5)
    glm.pred4[i] = "1"  
}
table4=table(glm.pred4,set4.test$bugs)
p4=table4[2,2]/(table4[2,2]+table4[2,1])
r4=table4[2,2]/(table4[2,2]+table4[1,2])
F4=2*p4*r4/(r4+p4)

##the fifth one
len5 = dim(set5)[1]
train5 = sample(len5,len5 * 0.9)

set5.train = set5[train5,]
set5.test = set5[-train5,]
names(set5.train)
glm.fit5 = glm(bugs ~ wmc + dit + noc + cbo + rfc + lcom + ca + ce + npm + lcom3 + loc + dam + moa + mfa + cam + ic + cbm + amc + max_cc + avg_cc, data = set5.train, family = binomial)
summary(glm.fit5)

glm.prob5 = predict(glm.fit5, data = set5.test, type = "response")
dim(set5.test)
glm.pred5 = rep("0",dim(set5.test)[1])
for(i in 1:dim(set5.test)[1]){
  if(glm.prob5[i] > 0.5)
    glm.pred5[i] = "1"  
}
table5=table(glm.pred5,set5.test$bugs)
p5=table5[2,2]/(table5[2,2]+table5[2,1])
r5=table5[2,2]/(table5[2,2]+table5[1,2])
F5=2*p5*r5/(r5+p5)

