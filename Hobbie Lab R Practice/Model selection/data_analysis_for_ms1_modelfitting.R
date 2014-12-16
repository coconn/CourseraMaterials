#started code 10/16/14


#### christine
setwd("/Users/oconn568/Documents/GITHUB/CourseraMaterials/Hobbie Lab R Practice/Model selection")


####################################################
#DECOMP MODELS

#STEP 1: model evaluation

#install.packages("nortest")
#install.packages("bbmle")
library(nortest)
library(bbmle)
library(ggplot2)

#read in resp data
#data<-read.csv(file.choose()) #Resp_alldates_101614.csv (in NutNet>SOM_Data>Respiration folder)
## christine
data<-read.csv("Resp_all-dates_101614.csv")

#look at row headings
head(data)
tail(data)
str(data)

#call column names
colnames(data) #note relevant columns are 16 (TotC.mgg), 82 (INCUB_DAYS), and 84 (RESP_C)
data[c(1:3),c(16,82,84)] #confirm you've got the right columns here 

#create vectors for parameters
single.k=array(0,dim=c(max(data$ID_indiv_reps),3)) #kf and cf
double.k=array(0,dim=c(max(data$ID_indiv_reps),4)) #kf, cf, ks
#create arrays to store AICc values
a.aicc=array(0,dim=c(max(data$ID_indiv_reps),4)) #2aicc; 2weights; single, double


#fit models in a loop:
for (i in 1:max(data$ID_indiv_reps)){
      
      s1=subset(data,data$ID_indiv_reps==i)
      x = s1[,c(16,82,84)]  #select the columns with relevant data (e.g. incub days, resp, and total C)
      xNA <-na.exclude(x) #omit lines with missing data (NAs)
      
      #Single pool 
      #  model dailyresp=kf*(Cf*exp(-kf*t))
      mleSingle <- mle2(y~dnorm(mean=(kf*(Cf*exp(-kf*xNA$INCUB_DAYS))),sd=sqrt(((sum((kf*(Cf*exp(-kf*xNA$INCUB_DAYS))) - y)^2))/length(y))),
                        start=list(kf=0.1, Cf=0.1),
                        data=list(y=xNA$RESP_C),method="L-BFGS-B",
                        lower=list(kf=0, Cf=0), 
                        control=list(maxit=10e6, parscale = c(kf = 0.01, Cf=0.1)))
      attr(mleSingle,"df") = attr(mleSingle ,"df")+1
      summary(mleSingle)
      
      
      #extract k value
      single.k[i,1]<-coef(mleSingle)[1]
      single.k[i,2]<-coef(mleSingle)[2]
      single.k[i,3]<-mean(xNA$ID_indiv_reps)
      
      #Daily resp 2pool constrained (Yuste et al. 2008);
      #  params = kf, ks, Cf
      mleDouble <- mle2(y~dnorm(mean=kf*(Cf*exp(-kf*xNA$INCUB_DAYS))+ 
                                      ks*((xNA$TotC.mgg-Cf)*exp(-ks*xNA$INCUB_DAYS)),
                                sd=sqrt((sum((kf*(Cf*exp(-kf*xNA$INCUB_DAYS))+ 
                                                    ks*((xNA$TotC.mgg-Cf)*exp(-ks*xNA$INCUB_DAYS))-
                                                    y)^2))/length(y))),
                        start=list(kf=0.1, Cf=0.1, ks=0.001),
                        data=list(y=xNA$RESP_C),method="L-BFGS-B",
                        lower=list(kf=0, Cf=0, ks=0), 
                        control=list(maxit=10e6, parscale = c(kf = 0.01, Cf=0.1, ks=0.0001)))
      attr(mleDouble ,"df") = attr(mleDouble ,"df")+1
      summary(mleDouble )
      
      #Extract K and C values
      double.k[i,1]<-coef(mleDouble)[1] #kf
      double.k[i,2]<-coef(mleDouble)[2] #Cf
      double.k[i,3]<-coef(mleDouble)[3] #ks
      double.k[i,4]<-mean(xNA$ID_indiv_reps)
      
      xx<-AICctab(mleSingle,mleDouble, nobs=nrow(x), sort=FALSE, delta=TRUE, weights=TRUE)
      xx
      a.aicc[i,1]=xx$dAICc[1]
      a.aicc[i,2]=xx$dAICc[2]
      a.aicc[i,3]=xx$weight[1]
      a.aicc[i,4]=xx$weight[2]
      a.aicc[i,]
      print(i) ## christine added this
      
}


warnings()
###NOTES: warning messages: "NaNs produced".  

write.csv(a.aicc, file = "aic_pergsoil.csv")
write.csv(single.k, file = "singlek_pergsoil.csv")
write.csv(double.k, file = "doublek_pergsoil.csv")


############
#STEP 2: get predicted values from the two-pool fit

double.k=array(0,dim=c(max(data$ID_indiv_reps),4)) #kf, cf, ks

for (i in 1:max(data$ID_indiv_reps)){
      
      s1=subset(data,data$ID_indiv_reps==i)
      x = s1[,c(16,82,84)]  #select the columns with relevant data (e.g. incub days, resp, and total C)
      xNA <-na.exclude(x) #omit lines with missing data (NAs)
      
      
      #Daily resp 2pool constrained (Yuste et al. 2008);
      #  params = kf, ks, Cf
      mleDouble <- mle2(y~dnorm(mean=kf*(Cf*exp(-kf*xNA$INCUB_DAYS))+ 
                                      ks*((xNA$TotC.mgg-Cf)*exp(-ks*xNA$INCUB_DAYS)),
                                sd=sqrt((sum((kf*(Cf*exp(-kf*xNA$INCUB_DAYS))+ 
                                                    ks*((xNA$TotC.mgg-Cf)*exp(-ks*xNA$INCUB_DAYS))-
                                                    y)^2))/length(y))),
                        start=list(kf=0.1, Cf=0.1, ks=0.001),
                        data=list(y=xNA$RESP_C),method="L-BFGS-B",
                        lower=list(kf=0, Cf=0, ks=0), 
                        control=list(maxit=10e6, parscale = c(kf = 0.01, Cf=0.1, ks=0.0001)))
      attr(mleDouble ,"df") = attr(mleDouble ,"df")+1
      summary(mleDouble )
      
      #Extract K and C values
      double.k[i,1]<-coef(mleDouble)[1] #kf
      double.k[i,2]<-coef(mleDouble)[2] #Cf
      double.k[i,3]<-coef(mleDouble)[3] #ks
      
      #preds
      if(i==1){predmle2.a=double.k[i,1]*(double.k[i,2]*exp(-double.k[i,1]*xNA[,2])) + 
                     double.k[i,3]*((xNA[,1]-double.k[i,2])*exp(-double.k[i,3]*xNA[,1]))}
      if(i>1){
            predmle2temp=double.k[i,1]*(double.k[i,2]*exp(-double.k[i,1]*xNA[,2])) + 
                  double.k[i,3]*((xNA[,1]-double.k[i,2])*exp(-double.k[i,3]*xNA[,1]))
            predmle2.a=append(predmle2.a,predmle2temp)
      }
}

#get values all reps are run
write.csv(predmle2.a,"predmle2a.csv")  


## christine doesn't have the necessary file for this
# 
# #############################################
# #calculate R2 for predictions
# 
# #examining 2-pool model fit
# #at this point I have the RESP_C_gsoil predictions (from the 2 pool
# #model in the resp through August data sheet)
# 
# #read in data
# data<-read.csv(file.choose()) #Resp_all-dates_101614_w-pred-resp-c
# 
# #look at row headings and data structure
# head(data)
# colnames(data)
# str(data)
# tail(data)
# 
# data<-subset(data, RESP_C!="NA")
# tail(data)
# 
# #look at all data
# ggplot(data, aes(x=RESP_C, y=RESP_C_PRED)) + 
#   geom_point(size=3) 
# 
# #extract R squared for all model predictions
# rsquared=array(0,dim=c(max(data$ID_indiv_reps),1)) 
# 
# for (i in 1:207){
#   
#   s1=subset(data,data$ID_indiv_reps==i)
#   A=s1$RESP_C
#   P=s1$RESP_C_PRED
#   x <- data.frame(A, P)
#   xNA <-na.exclude(x)
#   
#   fit <- lm(A ~ P, data=xNA)
#   
#   summary(fit)
#   
#   #extract R squared
#   rsquared[i,1]=summary(fit)$r.squared
# }
# 
# #get values all reps 
# write.csv(rsquared,"rsquared.csv") 
# 
# 
# 
# 
