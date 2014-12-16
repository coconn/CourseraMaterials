#To fit single, double, 3 pool (NHC) models to incubation respiration data
#Appendix for Joey
#112 jars


#file.choose()

rm(list=ls())
#norm test library
library(nortest)
#aic-liklihood library
library(bbmle)


#read in decomp data
inc=read.csv("C:\\Users\\adair\\Desktop\\carol\\BioCon\\Data\\Bulk density\\Chemical fractionation\\Joey\\RespD391_CHNrerun.csv", header=TRUE)
#look at row headings
head(inc)


#vectors for parameterss
single.k=array(0,dim=c(max(inc$Jar),2)) 1=kf, 2=Cf
double.k=array(0,dim=c(max(inc$Jar),3)) 1=kf, 2=Cf, 3=ks
three.k=array(0,dim=c(max(inc$Jar),3))

#arrays to store AICc values
a.aicc=array(0,dim=c(max(inc$Jar),6)) #3aicc; 3weights; single, double, 3NHC


#set jar number,i
i=71

for(i in 1:max(inc$Jar)){
      
      x=subset(inc,inc$Jar==i)
      #Single pool 
      #	model dailyresp=kf*(Cf*exp(-kf*t))
      mleSingle <- mle2(y~dnorm(mean=kf*(Cf*exp(-kf*x$day)),sd=sqrt((sum((kf*(Cf*exp(-kf*x$day)) - y)^2))/length(y))),
                        start=list(kf=0.1, Cf=0.1),
                        data=list(y=x$DailyResp),method="L-BFGS-B",
                        lower=list(kf=0, Cf=0), 
                        control=list(maxit=10e6, parscale = c(kf = 0.01, Cf=0.1)))
      attr(mleSingle,"df") = attr(mleSingle ,"df")+1
      summary(mleSingle)
      single.k[i,1]<-coef(mleSingle)[1]
      single.k[i,2]<-coef(mleSingle)[2]
      plot(x$day,x$DailyResp)
      lines(x$day,single.k[i,1]*(single.k[i,2]*exp(-single.k[i,1]*x$day)))
      
      #Daily resp 2pool constrained (Yuste et al. 2008);
      #	params = kf, ks, Cf
      mleDouble <- mle2(y~dnorm(mean=kf*(Cf*exp(-kf*x$day))+ ks*((x$TotC.mgg-Cf)*exp(-ks*x$day)),sd=sqrt((sum((kf*(Cf*exp(-kf*x$day))+ ks*((x$TotC.mgg-Cf)*exp(-ks*x$day)) - y)^2))/length(y))),
                        start=list(kf=0.1, Cf=0.1, ks=0.001),
                        data=list(y=x$DailyResp),method="L-BFGS-B",
                        lower=list(kf=0, Cf=0, ks=0), 
                        control=list(maxit=10e6, parscale = c(kf = 0.01, Cf=0.1, ks=0.0001)))
      attr(mleDouble ,"df") = attr(mleDouble ,"df")+1
      summary(mleDouble )
      double.k[i,1]<-coef(mleDouble)[1] #kf
      double.k[i,2]<-coef(mleDouble)[2] #Cf
      double.k[i,3]<-coef(mleDouble)[3] #ks
      
      lines(x$day, double.k[i,1]*(double.k[i,2]*exp(-double.k[i,1]*x$day))+ double.k[i,3]*((x$TotC.mgg-double.k[i,2])*exp(-double.k[i,3]*x$day)), col="red" )
      
      #Daily resp 2pool constrained with NHC as third pool (Pendall & King);
      #model dailyresp=kf*(Cf*exp(-kf*t))+ ks*((totalC-Cf-NHC)*exp(-ks*t))+kv*NHC*exp(-kv*t), 
      #	kv=0.0000027 (1000 yr) or 0.0000274 (100 yr)
      #	est params = kf, ks, Cf
      #nonlinear regression
      #nlinNHC = nls(x$DailyResp~kf*(Cf*exp(-kf*x$day))+ ks*((x$TotC.mgg-Cf-x$NHC)*exp(-ks*x$day)) + 0.0000027*x$NHC*exp(-0.0000027*x$day),
      #		start=list(kf = .1,ks= .001, Cf=.01), data=x)
      #summary(nlinNHC)
      #bbmle-mle2
      mle3NHC <- mle2(y~dnorm(mean=kf*(Cf*exp(-kf*x$day))+ ks*((x$TotC.mgg-Cf-x$NHC)*exp(-ks*x$day)) + 0.0000274*x$NHC*exp(-0.0000274*x$day),
                              sd=sqrt((sum((kf*(Cf*exp(-kf*x$day))+ ks*((x$TotC.mgg-Cf-x$NHC)*exp(-ks*x$day)) + 0.0000274*x$NHC*exp(-0.0000274*x$day) - y)^2))/length(y))),
                      start=list(kf=0.1, Cf=0.1, ks=0.001),
                      data=list(y=x$DailyResp),method="L-BFGS-B",
                      lower=list(kf=0, Cf=0, ks=0), 
                      control=list(maxit=10e6, parscale = c(kf = 0.01, Cf=0.1, ks=0.0001)))
      attr(mle3NHC,"df") = attr(mle3NHC,"df")+1
      summary(mle3NHC)
      three.k[i,1]<-coef(mle3NHC)[1] #kf
      three.k[i,2]<-coef(mle3NHC)[2] #Cf
      three.k[i,3]<-coef(mle3NHC)[3] #ks
      
      lines(x$day, three.k[i,1]*(three.k[i,2]*exp(-three.k[i,1]*x$day))+ three.k[i,3]*((x$TotC.mgg-three.k[i,2]-x$NHC)*exp(-three.k[i,3]*x$day)) + 0.0000027*x$NHC*exp(-0.0000027*x$day),col="blue")
      
      #Compare models
      #Extract AICC values
      xx<-AICctab(mleSingle,mleDouble,mle3NHC, nobs=nrow(x), sort=FALSE, delta=TRUE, weights=TRUE)
      xx
      a.aicc[i,1]=xx$dAICc[1]
      a.aicc[i,2]=xx$dAICc[2]
      a.aicc[i,3]=xx$dAICc[3]
      a.aicc[i,4]=xx$weight[1]
      a.aicc[i,5]=xx$weight[2]
      a.aicc[i,6]=xx$weight[3]
      a.aicc[i,]
      i
}

write.table(single.k,"clipboard",sep="\t",row.names=FALSE,col.names=FALSE)
write.table(double.k,"clipboard",sep="\t",row.names=FALSE,col.names=FALSE)
write.table(three.k,"clipboard",sep="\t",row.names=FALSE,col.names=FALSE)
write.table(a.aicc,"clipboard",sep="\t",row.names=FALSE,col.names=FALSE)

#Get preds


## christine
### this part is very different than charlotte's - clarify why with her tomorrow

pred=array(0,dim=c(nrow(inc),3))
i=1
j=1
for(i in 1:max(inc$Jar)){
      for(j in 1:nrow(inc)){
            if(inc[j,1]==i){
                  pred[j,1]=single.k[i,1]*(single.k[i,2]*exp(-single.k[i,1]*inc[j,7]))
                  pred[j,2]=double.k[i,1]*(double.k[i,2]*exp(-double.k[i,1]*inc[j,7]))+ double.k[i,3]*((inc[j,10]-double.k[i,2])*exp(-double.k[i,3]*inc[j,7]))
                  pred[j,3]=three.k[i,1]*(three.k[i,2]*exp(-three.k[i,1]*inc[j,7]))+ three.k[i,3]*((inc[j,10]-three.k[i,2]-inc[j,11])*exp(-three.k[i,3]*inc[j,7])) + 0.0000027*inc[j,11]*exp(-0.0000027*inc[j,7])
            }
      }
}
write.table(pred,"clipboard-768",sep="\t",row.names=FALSE,col.names=FALSE)


