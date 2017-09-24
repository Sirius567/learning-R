# we introduce the linear regression and its principal issues:


# Simple Vs Multiple Linear Regression
# Goodness of Fit Metrics
# Residual Analysis
# Forecasting


# we'll make use of the mtcars dataset
library(data.table)

data("mtcars")
raw_data<-data.table(model=rownames(mtcars),mtcars)

head(raw_data)
str(raw_data)
lapply(raw_data,function(x) summary(as.factor(x)))


raw_data[,c('vs','am','gear','carb'):=list(as.factor(vs),
                                   as.factor(am),
                                   as.factor(gear),
                                   as.factor(carb))]

str(raw_data)

summary(raw_data$disp)


pairs(raw_data[,.(mpg,cyl,disp,hp,qsec)])

# Lets try to explain mpg trough a single variable: hp

p<-ggplot(raw_data,aes(x=hp,y=mpg))+geom_point(size=2.5,alpha=0.5)
print(p)
p<-p+ylim(0,50)+xlim(0,400)
p+geom_smooth(method='lm')

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
# If we set a level the significance to 5%, we reject the null hipothesis (hp is "significant")
# In this case we can reject the hipothesis of insignificance for hp even al a 1% (99% of confidence)

# create a 95% interval for the hp coefficient estimate
mean_coef<-coef(summary(simple_model_1))[, "Estimate"]['hp']
std_coef<-coef(summary(simple_model_1))[, "Std. Error"]['hp']
pivot_value<-qt(0.975,df=simple_model_1$df.residual)

CI_95<-c(mean_coef-pivot_value*std_coef,mean_coef+pivot_value*std_coef)


# create a function that takes this simple model, and a level of significance (alpha)
# and returns the Confidence Interval estiation of hp coefficient.


# the fitness of a model represents the explained or predicted value of y from the x variables

fit_1<-simple_model_1$fitted

par(mar=c(8,3.5,3.5,1))
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
boxplot(resids_simple_1); grid()

# plot 4 
qqnorm(resids_simple_1)

