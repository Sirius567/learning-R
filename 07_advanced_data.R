# practical session introducing the data.table package
# and working with a large data.set


# data.table package ####
library(data.table)  


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
data_mtcars$new_variable<-NULL

# we can make groupped opperation on the fly
data_mtcars[,carb:=as.factor(carb)]
data_2<-data_mtcars[mpg>=20,list(n=.N,mean_mpg=mean(mpg),mean_hp=mean(hp)),by='carb'][order(carb)]
data_2




# merges with data.table

data_3<-data.table(x=runif(6),model=data_mtcars$model[sample(nrow(data_mtcars),6)])

setkey(data_mtcars,model)
setkey(data_3,model)

# inner join
data_3[data_mtcars, nomatch=0]
data_mtcars[data_3, nomatch=0]

data_3[data_mtcars, nomatch=NA]  # outer join

# left join
data_mtcars[data_3]
data_3[data_mtcars]

# duplicated treatment
data_mtcars[!duplicated(carb)]
data_mtcars[duplicated(model)]





# https://www.kaggle.com/c/house-prices-advanced-regression-techniques
# 
# 
# https://ww2.amstat.org/publications/jse/v19n3/decock/DataDocumentation.txt



library(readxl)  # nice for excel reading

setwd("C:/Users/sirio/Documents/learning-R")

raw_data<-data.table(readxl::read_excel('AmesHousing.xlsx'))
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

  raw_data[[i]]<-char_to_factor(raw_data[[i]])
}

str(raw_data)

# the data.table way
# rerun from line 73 to 80
raw_data[, names(raw_data)[sapply(raw_data,is.character)]:= lapply(.SD, as.factor), .SDcols=names(raw_data)[sapply(raw_data,is.character)]]
str(raw_data)

raw_data[, names(raw_data)[sapply(raw_data,is.integer)]:= lapply(.SD, as.numeric), .SDcols=sapply(raw_data,is.integer)]

raw_data[,lapply(.SD,mean), .SDcols=sapply(raw_data,is.numeric)]
raw_data[,lapply(.SD,mean), .SDcols=sapply(raw_data,is.numeric), by='Yr_Sold']
sapply(raw_data[,lapply(.SD,is.na), .SDcols=sapply(raw_data,is.numeric)], sum)


names(raw_data)<-gsub(" ", "_", names(raw_data), fixed = TRUE)

# we save for further use

saveRDS(raw_data,'AmesHousing_pro.RData')


# cheking length of PID... any duplicates?
length(unique(raw_data$PID))



library(ggplot2)

# analizing relationships with price
ggplot(raw_data,aes(x=Lot_Area,y=SalePrice,colour=Neighborhood)) + geom_point()

# count and mean price by neighborhood
raw_data[,.(mean_price=mean(SalePrice),n=.N),by=Neighborhood][order(-mean_price)]


summary(raw_data$Yr_Sold)

# inflation?
raw_data[,.(mean_price=mean(SalePrice),n=.N),by=Yr_Sold][order(Yr_Sold)]

raw_data[,.(mean_price=mean(SalePrice),n=.N),by=Year_Built][order(Year_Built)]

# create a new variable indicating the decade of Year_Built

raw_data[,decade:=ifelse(Year_Built/100<19,paste0('19th C. Decade ',substr(Year_Built,3,3)),
                         ifelse(Year_Built/100<20,paste0('20th C. Decade ',substr(Year_Built,3,3)),
                         paste0('21th C. Decade ',substr(Year_Built,3,3))))]

raw_data[,.(Year_Built,decade)]

# adding continous additional dimensions to scatterplot
ggplot(raw_data,aes(x=TotRms_AbvGrd,y=SalePrice,colour=-Year_Built,size=Lot_Area)) + geom_point(alpha=0.5)

# and with discrete (factor) variables
ggplot(raw_data,aes(x=Lot_Area,y=SalePrice,colour=factor(decade))) + geom_point()


raw_data[,.(mean_price=mean(SalePrice),n=.N),by=Exter_Qual][order(mean_price)]

raw_data[,.(mean_price=mean(SalePrice),n=.N),by=Heating_QC][order(mean_price)]

raw_data[,.(mean_price=mean(SalePrice),n=.N),by=c('Exter_Qual','Heating_QC')][order(mean_price)]


# 2 - way tables
with(raw_data,table(Heating_QC,Exter_Qual))

# n - way tables
with(raw_data,table(TotRms_AbvGrd,Heating_QC,Exter_Qual))


saveRDS(raw_data,'housing_data.RData')

data.table::fwrite(raw_data,'housing_data.csv')  # fast writing
data.table::fread('housing_data.csv')  # fast reading



# melt and dcast  [ https://cran.r-project.org/web/packages/data.table/vignettes/datatable-reshape.html ]

df<-fread('melt_default.csv')

# long to wide format

df_long<-melt(df, id.vars = c("family_id", "age_mother"),
     measure.vars = c("dob_child1", "dob_child2", "dob_child3"))

df_wide<-dcast(df_long, family_id + age_mother ~ variable, value.var = 'value')

# this is widely used to maked grouped plots with ggplot

ggplot(df,aes(x=family_id,y=dob_child1))+geom_point(size=2)+
  geom_point(aes(y=dob_child2),size=2,col='red')+
  geom_point(aes(y=dob_child3),size=2,col='green')
ggplot(df_long,aes(x=family_id,y=value, colour=variable))+geom_point(size=2)
ggplot(df_long[!is.na(value)],aes(x=family_id,y=value, colour=variable))+geom_point(size=2)






# BASIC REGULAR EXPRESSIONS ####

nchar('ikvcnqkejbkjq')

grep('A','A')

vars<-names(raw_data)

print(vars)

# getting any var with the string "room"

vars[grep('room',vars)]
vars[grep('room|Rms',vars)]

# only those who start with "Bsmt"

vars_Bsmt<-vars[grep('^Bsmt',vars)]
raw_data[,vars_Bsmt,with=F]

vars[grep('SF',vars)]
grep('SF',vars,value = T)  # with value=T don't need to subset the vector

# only those who start with "Bsmt"
vars[grep('SF$',vars)]


regexpr('d',c('a','b','c','d','ad','aad'))

substr('hello world!!',1,5)

strsplit('y,r,t,x,u',',')

