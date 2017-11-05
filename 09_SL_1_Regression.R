# we introduce the linear regression and its principal issues:


# Simple Vs Multiple Linear Regression
# Goodness of Fit Metrics
# Residual Analysis
# Forecasting


# let's simmulate a variable relationship

set.seed(648315)

u<-1*rnorm(100)
hist(u)

x<-5+100*runif(100)
hist(x)

alpha<-2
beta<-0.5

y<-alpha+beta*x+u

hist(y)
summary(y)

plot(x,y);grid()
abline(a=alpha,b=beta,col='blue')

lm_simulated<-lm(y~x)
summary(lm_simulated)


### we create a function that varies the size of the sample and
# computes the regression

f_sample_sim<-function(n=100,sd_resid=1){
  
  set.seed(64815)
  u<-sd_resid*rnorm(n)
  
  x<-5+100*runif(n)

  alpha<-2
  beta<-0.5
  
  y<-alpha+beta*x+u
  
  lm_sim<-lm(y~x)
  
  return(lm_sim)
}

dev.off()
beta_vector<-c()
alpha_vector<-c()
levels_size<-1:1000
plot(levels_size,rep(0.5,length(levels_size)),type='l',xlab='size of sample',ylab='Coefficient Estimate',lwd=2); grid()
for(i in seq_along(levels_size)){
  # Sys.sleep(0.05)
  alpha_vector<-c(alpha_vector,f_sample_sim(levels_size[i],sd_resid = 1)$coef[1])
  beta_vector<-c(beta_vector,f_sample_sim(levels_size[i],sd_resid = 1)$coef[2])
  # points(i,beta_vector[i],col='red',pch=19,size=20,alpha=0.75)
}

par(mfrow=c(2,1))
plot(alpha_vector,type='l',xlab='size of sample',ylab='Alpha Coefficient Estimate',lwd=2); grid()
abline(a=2,b=0,col='green')
plot(beta_vector,type='l',xlab='size of sample',ylab='Beta Coefficient Estimate',lwd=2); grid()
abline(a=0.5,b=0,col='green')


# we'll make use of the mtcars dataset
library(data.table)
library(ggplot2)

data("mtcars")
raw_data<-data.table(model=rownames(mtcars),mtcars)

head(raw_data)
str(raw_data)


variables_to_factor<-c('vs','am','gear','carb')
raw_data[,eval(variables_to_factor):=lapply(.SD,as.factor),.SDcols=variables_to_factor]

str(raw_data)

summary(raw_data$disp)
summary(raw_data$carb)


pairs(raw_data[,.(mpg,cyl,disp,hp,qsec)])

# Lets try to explain mpg trough a single variable: hp

p<-ggplot(raw_data,aes(x=hp,y=mpg))+geom_point(size=2.5,alpha=0.5)
print(p)
p<-p+ylim(0,50)+xlim(0,400)
p+geom_smooth(method='lm')

# we build our first simple model
simple_model_1<-lm(mpg~hp, data=raw_data)

summary(simple_model_1)


objects(simple_model_1)

simple_model_1$coeff[1]  # the intercept of the model
simple_model_1$coeff[2]  # the slope of the model

# better call it by its variable name
simple_model_1$coeff['hp']

print(paste0('the variation in mpg per incremental hp is ', round(simple_model_1$coeff['hp'],2)))

# the slope represents exactly the blue line of fit

# mathemtically the intercept of the regression captures the level of y
# when x is zero. In this case though, it makes no sense thinking about an engine 
# with 0 horse power.

summary(simple_model_1)

# for every explanatory variable in the model we have the estimate value of the coefficient, 
# the estimated standard deviation of the coefficient, the t-value (coef/Std.Error) and the 
# P-value from the contrast of individual significance.

# The null hipothesis is coef(hp) = 0, with the alternative hipothesis being coef(hp)!=0
# If we set a level the significance to 5%, we reject the null hipothesis (so hp is "significant")
# In this case we can reject the hipothesis of insignificance for hp even al a 1% (99% of confidence)

# create a 95% interval for the hp coefficient estimate
mean_coef<-coef(summary(simple_model_1))[, "Estimate"]['hp']
std_coef<-coef(summary(simple_model_1))[, "Std. Error"]['hp']
pivot_value<-qt(0.975,df=simple_model_1$df.residual)

CI_95<-c(mean_coef-pivot_value*std_coef,mean_coef+pivot_value*std_coef)
CI_95

# lets check it
confint(simple_model_1,parm = 'hp', level = 0.95)

# create a function that takes this simple model, and a level of significance (alpha)
# and returns the Confidence Interval estimation of hp coefficient.


# the fitness of a model represents the explained or predicted value of y from the x variables

fit_1<-simple_model_1$fitted

par(mar=c(8,3.5,3.5,1),mfrow=c(1,1))
plot(raw_data$mpg, type='o', xlab='',ylab='',xaxt='n',lwd=2,pch=19, main='Simple Model Fit'); grid()
axis(1,at=1:nrow(raw_data),labels = raw_data$model,las=2)
lines(simple_model_1$fitted,col='red',type='o',lwd=2,pch=19)

# The goodness of fit tell us how good our model is in explaining the variations in y 
# a very popular metric of gof is the R Squared, or coefficient of determination
# It represents the percentage of the total variability in y that is actually being explained by the x's in the model
# lies between 0 (no explanation power at all) and 1 (perfect explanation).

str(summary(simple_model_1))

summary(simple_model_1)[['r.squared']]

print(paste0('hp explains about ', 100*round(summary(simple_model_1)[['r.squared']],2),'%',' of total variability in mpg'))

# residual analysis

# good statistical modeling <==> deep residual analysis

# by contrstruction of the linear models, residuals mean is always zero. This means that the model is unbiased.
# a good model is the one with the minimun variability of residuals (minimun variance)

# lets analyze residuals

resids_simple_1<-simple_model_1$residuals

summary(resids_simple_1)

sd(resids_simple_1)

# plot 1
par(mfrow=c(2,2),mar=c(8,3.5,3.5,1))
plot(resids_simple_1, type='o', xlab='',ylab='',xaxt='n',lwd=2,pch=19, main='Simple Model Residuals'); grid()
axis(1,at=1:nrow(raw_data),labels = raw_data$model,las=2)

# plot 2 
hist(resids_simple_1)

# plot 3 
boxplot(resids_simple_1,main='boxplot'); grid()

# plot 4 
qqnorm(resids_simple_1); grid()

# pick another explanatory variable, say "disp", and generate another simple model
# replicate the analysis done: interpretation, CI and significance of the slope
# and residual analysis

# which variables explains better the mpg by itself?


# forecasting 

# to get predictions of y with new x values just have to:
new_values_hp<-data.frame(hp=c(50,100,150,200))
pred_simple_1<-predict(simple_model_1,newdata = new_values_hp)

par(mfrow=c(1,1))
plot(raw_data$hp,raw_data$mpg, pch=19); grid()
points(cbind(new_values_hp,pred_simple_1), pch=19, col='red')


# multiple regression

multi_model_1<-lm(mpg~., data=raw_data[,-'model',with=F])
summary(multi_model_1)

fit_2<-multi_model_1$fitted

par(mar=c(8,3.5,3.5,1),mfrow=c(1,1))
plot(raw_data$mpg, type='o', xlab='',ylab='',xaxt='n',lwd=2,pch=19, main='Multiple Model Fit'); grid()
axis(1,at=1:nrow(raw_data),labels = raw_data$model,las=2)
lines(multi_model_1$fitted,col='red',type='o',lwd=2,pch=19)
lines(simple_model_1$fitted,col='cornflowerblue',type='o',lwd=2,pch=19)

resids_multi_1<-multi_model_1$residuals

summary(resids_multi_1)
summary(resids_simple_1)

sd(resids_multi_1)
sd(resids_simple_1)


# plot 1
par(mfrow=c(2,2),mar=c(8,3.5,3.5,1))
plot(resids_multi_1, type='o', xlab='',ylab='',xaxt='n',lwd=2,pch=19, main='Simple Model Residuals'); grid()
axis(1,at=1:nrow(raw_data),labels = raw_data$model,las=2)

# plot 2 
hist(resids_multi_1)

# plot 3 
boxplot(resids_multi_1); grid()

# plot 4 
qqnorm(resids_multi_1)


shapiro.test(resids_multi_1)


