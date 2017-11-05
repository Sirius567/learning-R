# R BASE CHARTS AND GGPLOT INTRODUCTION

# base charts
  # bar charts & pie charts
  # histogram & boxplots
  # scatterplots
  # line charts & time series


# http://www.r-graph-gallery.com for nice examples

data(state)

state_data<-data.frame(state.x77)


# R BASE CHARTS ####

# managing the plotting space layout

plot(1:10)  # this is a single plot

# lets create a multiplot

par(...) # controls all of the base graphical features
par(mar=c(5,5,5,1)) # this controls the margins of the plotting space
par(mfrow=c(2,1)) # here we specify a matrix layout, with two rows and one column
plot(1:10)
plot(10:1)

par(mfrow=c(2,2)) # here we specify a matrix layout, with two rows and one column
plot(runif(10),col='black',main='chart 1')
plot(runif(10),col='red',main='chart 2')
plot(runif(10),col='green',main='chart 3')
plot(runif(10),col='blue',main='chart 4')

# see help(layout) for a more flexible design
layout(matrix(c(1,1,0,2), 2, 2, byrow = TRUE))
layout.show(2)
plot(1:10)
plot(2:34)

nf <- layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE), respect = TRUE)
layout.show(1:3)

dev.off() # this clears all graphics and sets default layout 

# barplots
help(barplot)
barplot(state_data$Life.Exp)

# you can customize it as much as you want
par(mar=c(7.25,4,4,1))
barplot(state_data[order(-state_data$Life.Exp),]$Life.Exp, ylim=c(65,75),xpd=FALSE, 
        names.arg=rownames(state_data[order(-state_data$Life.Exp),]),
        las=2, col='cornflowerblue',
        main='Life Expectancy (1977)'); grid()
legend(45,75,fill=c('cornflowerblue','red'),legend=c('L.E','Mean'))
abline(h=mean(state_data$Life.Exp),col='red')
text(50,mean(state_data$Life.Exp)+0.25,'Mean',col='red')

# histograms & boxplots

hist(state_data$Life)
hist(state_data$Life,probability=T,xlim=c(65,75),
     xlab='years',col='forestgreen',border = 'forestgreen') 


boxplot(state_data$Life)

# lets make a boxplot de Life Expectancy segmented by a categorical variable

# we first bring on the Region
data(state)
state_data$Region<-state.region

boxplot(state_data$Life)
boxplot(state_data$Life~state_data$Region,
        col=c('red','orange','forestgreen','royalblue2'), 
        main='Life Expectancy by Region'); grid()

summary(state_data[state_data$Region=='South',]$Life.Exp)

# example from http://www.r-graph-gallery.com/

# Add data points
mylevels<-levels(state_data$Region)
levelProportions<-summary(state_data$Region)/nrow(state_data)

for(i in 1:length(mylevels)){
  
  thislevel<-mylevels[i]
  thisvalues<-state_data[state_data$Region==thislevel, "Life.Exp"]
  
  points(rep(i, length(thisvalues)), thisvalues, pch=20, col=rgb(0,0,0,.5)) 
  
}


# scatterplots

plot(state_data$HS.Grad,state_data$Income)

plot(state_data$HS.Grad,state_data$Income, col=state_data$Region, pch=19 , cex=1.3,
     main='HS.Grad Vs Income',xlab='Income',ylab='HS.Grad'); grid()
abline(mC <- lm(Income ~ HS.Grad, data = state_data))
legend(40, 6000, pch=19, col=1:4, levels(state_data$Region),
       bty='o',  box.col='gray', cex=.8)


# line plots and time series

plot(state_data$Income,type='l')

par(mar=c(5,5,5,5))
plot(state_data$Income,type='o',col='black', main='Income (1977)',
     xlab='',ylab='Income',xaxt='n'); grid()
axis(1,at=1:nrow(state_data),labels = rownames(state_data),las=2)
par(new = T)
plot(state_data$Area/1000,type='o',col='blue',
     axes = FALSE, bty = "n", xlab = "", ylab = "")
axis(side=4, at = pretty(range(state_data$Area/1000)))
axis(1,at=1:nrow(state_data),labels = rownames(state_data),las=2)
mtext(side = 4, line=3, 'Area',col='blue')
legend('topright',
       legend=c('Income','Area'),
       lwd=1, col=c("black", "blue"))


# a usualy simpler option for visualizing multiple series in 
# one chart is to do it in just one axis, and probably you first
# need to scale the series (to equal mean and variance)
dev.off()
plot(state_data$Income,type='o',col='black', main='Income (1977)',
     xlab='',ylab='Income',xaxt='n'); grid()
axis(1,at=1:nrow(state_data),labels = rownames(state_data),las=2)

lines(state_data$Area,col='blue')  # lines() adds a new line to an existing plot

# now scaling the variables
plot(scale(state_data$Income),type='o',col='black', main='Income (1977)',
     xlab='',ylab='Income',xaxt='n'); grid()
axis(1,at=1:nrow(state_data),labels = rownames(state_data),las=2)

lines(scale(state_data$Area),col='blue')  



# time series charting

data("airmiles")

class(airmiles)

# a ts variable is a numeric/integer variable with a defined frecuency, a 
# start date and an end date

plot(airmiles,type='o'); grid()

# if a time series is not previously defined as a ts, we need to add the 
# dates correctly to the x axis


# GGPLOT INTRODUCTION

library(ggplot2)

barplot(state_data$Life.Exp)

theme_set(theme_gray(base_size = 18))

ggplot(data=state_data,aes(x=rownames(state_data),y=Life.Exp))+
  geom_bar(stat='Identity')+theme(axis.text.x = element_text(angle = 45, hjust = 1))

plot(state_data$Income,type='p')

ggplot(data=state_data,aes(x=rownames(state_data),y=Income))+
  geom_point(size=1)+theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(data=state_data,aes("Income",Income))+
  geom_boxplot()
ggplot(data=state_data,aes(Region,Income,colour=Region))+
  geom_boxplot()

ggplot(data=state_data,aes(x=Income))+
  geom_histogram(bins = 20)

data_airmiles<-data.frame(year=1937:1960,airmiles=as.integer(airmiles))
ggplot(data_airmiles,aes(x=year,y=airmiles))+geom_line(lwd=2)+geom_point(size=3)

ggplot(data=state_data,aes(x=HS.Grad,y=Income))+geom_point()+geom_smooth()
ggplot(data=state_data,aes(x=HS.Grad,y=Income,colour=Region))+geom_point()+geom_smooth()+facet_wrap(~Region)
ggplot(data=state_data,aes(x=HS.Grad,y=Income))+geom_point()+geom_smooth()+facet_wrap(~Region,ncol=2)


# ggplot = data + aesthetics + geometry
state_data$abb<-as.character(state.abb)

install.packages('gridExtra')
library(gridExtra)

pl <- lapply(1:4, function(.x) qplot(1:10, rnorm(10), main=paste("plot", .x)))
ml <- arrangeGrob(pl, nrow=2, ncol=2)
ml







