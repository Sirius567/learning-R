# practical session introducing the data.table package
# and working with a large data.set


library(data.table)
help(data.table)


# data table basics
# data.table is a wrapper for data.frame, with enhanced features
# a data.table is always a data.frame, with all its capabilities

data(mtcars)

data_mtcars<-data.table(mtcars)

data_mtcars  # better display, but lost rownames!

data_mtcars<-cbind(model=rownames(mtcars),data_mtcars) # still a data.table

data_mtcars[mpg>=20,list(model,mpg,hp)]   # no need to preceed with $ the variable names
data_mtcars[mpg>=20,c('model','mpg','hp'),with=F]
data_mtcars[mpg>=20,c(1,2,3)]

# add a new column
data_mtcars[,new_variable:=seq(1,nrow(mtcars))]
data_mtcars[mpg>=20,new_variable2:='mpg >= 20']

# delete a column
data_mtcars[,new_variable:=NULL]

# we can make groupped opperation on the fly
data_mtcars[,carb:=as.factor(carb)]
data_2<-data_mtcars[mpg>=20,list(n=.N,mean_mpg=mean(mpg),mean_hp=mean(hp)),by='carb']
data_2




# merges with data.table

data_3<-data.table(x=runif(6),model=data_mtcars$model[sample(nrow(data_mtcars),6)])

setkey(data_mtcars,model)
setkey(data_3,model)

# inner join
data_3[data_mtcars, nomatch=0]
data_mtcars[data_3, nomatch=0]
data_3[data_mtcars, nomatch=NA]

# left join
data_mtcars[data_3]
data_3[data_mtcars]

# duplicated treatment
data_mtcars[!duplicated(carb)]
data_mtcars[!duplicated(model)]





# https://www.kaggle.com/c/house-prices-advanced-regression-techniques
# 
# 
# https://ww2.amstat.org/publications/jse/v19n3/decock/DataDocumentation.txt



library(readxl)

setwd("C:/Users/sirio/Documents/learning-R")

raw_data<-data.table(read_excel('AmesHousing.xlsx'))
# raw_data<-fread('AmesHousing.csv',stringsAsFactors = T)

str(raw_data)
summary(raw_data$SalePrice)

# change all column names eliminating spaces
names(raw_data)<-gsub(pattern=" ",replacement = "_", x=names(raw_data), fixed = TRUE)

# set all character columns to factor variables
char_to_factor<-function(var){
  if(is.character(var)){
    return(var<-as.factor(as.character(var)))
  } else {
    return(var)
  }
}

# the traditional way
for (i in 1:ncol(raw_data)){
  if(is.character(raw_data[[i]])){
    raw_data[[i]]<-as.factor(raw_data[[i]])
  }
}

str(raw_data)

# the data.table way
# rerun from line 73 to 80
raw_data[, names(raw_data)[sapply(raw_data,is.character)]:= lapply(.SD, as.factor), .SDcols=names(raw_data)[sapply(raw_data,is.character)]]
str(raw_data)

raw_data[, names(raw_data)[sapply(raw_data,is.integer)]:= lapply(.SD, as.numeric), .SDcols=sapply(raw_data,is.integer)]

names(raw_data)<-gsub(" ", "_", names(raw_data), fixed = TRUE)

# we save for further use

saveRDS(raw_data,'AmesHousing_pro.RData')



length(unique(raw_data$PID))

library(ggplot2)
ggplot(raw_data,aes(x=Lot_Area,y=SalePrice,colour=Neighborhood)) + geom_point()

raw_data[,.(mean_price=mean(SalePrice),n=.N),by=Neighborhood][order(-mean_price)]


summary(raw_data$Yr_Sold)



raw_data[,.(mean_price=mean(SalePrice),n=.N),by=Yr_Sold][order(Yr_Sold)]

raw_data[,.(mean_price=mean(SalePrice),n=.N),by=Year_Built][order(Year_Built)]

# create a new variable indicating the decade of Year_Built

raw_data[,decade:=ifelse(Year_Built/100<19,paste0('19th C.',substr(Year_Built,3,3),'0th Decade'),
                         ifelse(Year_Built/100<20,paste0('20th C.',substr(Year_Built,3,3),'0th Decade'),
                         paste0('21th C.',substr(Year_Built,3,3),'0th Decade')))]


ggplot(raw_data,aes(x=Year_Built,y=SalePrice,colour=-Year_Built)) + geom_point()

ggplot(raw_data,aes(x=Lot_Area,y=SalePrice,colour=factor(decade))) + geom_point()


raw_data[,.(mean_price=mean(SalePrice),n=.N),by=Exter_Qual][order(mean_price)]

raw_data[,.(mean_price=mean(SalePrice),n=.N),by=Heating_QC][order(mean_price)]

raw_data[,.(mean_price=mean(SalePrice),n=.N),by=c('Exter_Qual','Heating_QC')][order(mean_price)]



with(raw_data,table(Heating_QC,Exter_Qual))

saveRDS(raw_data,'housing_data.RData')
