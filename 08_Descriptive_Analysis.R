library(data.table)
raw_data<-fread('AmesHousing.csv',stringsAsFactors = T)


# Summarizing a Variable
# Quantiles and Outlier Detection
# Variance, Covariance and Linear Correlation


head(raw_data)

str(raw_data)

length(unique(raw_data$PID))==nrow(raw_data)


# lets describe statisticaly the variable price (SalePrice)

y<-as.numeric(raw_data$SalePrice)

summary(y)

quantile(y, seq(0,1,0.1))

p0<-qplot(x=1:nrow(raw_data),y=y, geom='point')
p1<-qplot(y, geom='histogram')
p2<-qplot(y, geom='density')
p3<-qplot(y, x= 1, geom = "boxplot")
p<-list(p0,p1,p2,p3)


gridExtra::marrangeGrob(p, nrow=2, ncol=2)

y_mean<-mean(y)
y_sd<-sd(y)

# lets simmulate a normal with y_mean and sd_mean
set.seed(34564)
y_normal<-y_mean+rnorm(nrow(raw_data),sd=y_sd)

comparative<-data.table(y,y_normal)

p<-ggplot(comparative, aes(x=y_normal))+geom_density()+xlab('Sale Price($)')
p+geom_density(data=comparative, aes(x=y), col=2)

# The Standard Deviation gives us the average deviation from the mean of a centered distribution

variance_comparative<-data.table(
  y0<-rnorm(10000),
  y1<-0.25*rnorm(10000),
  y2<-0.5*rnorm(10000),
  y3<-0.75*rnorm(10000),
  y4<-2*rnorm(10000),
  y5<-4*rnorm(10000)
)

matplot(variance_comparative,type='l')


ggplot(variance_comparative, aes(x=y0))+geom_density(col='black')+xlab('')+
  geom_density(data=variance_comparative, aes(x=y1), col='blue')+
  geom_density(data=variance_comparative, aes(x=y2), col='green')+
  geom_density(data=variance_comparative, aes(x=y3), col='red')

# the smallest the variance, the more representative becomes the mean from the population


# Bivariate Analysis

# Lets take the price and another continuous variable, and the analize how the relate with each other

x<-raw_data$`Gr Liv Area`

qplot(x,geom='density')

ggplot(data.table(x,y),aes(x=x,y=y))+geom_point()

library(plotly)

ggplotly(ggplot(data.table(x,y),aes(x=x,y=y))+geom_point())


ggplotly(ggplot(data.table(x,y),aes(x=x,y=y))+geom_point()+stat_smooth(method='auto'))

cov(x,y)  

cor(x,y)

lm(y~x)$coef['x']


