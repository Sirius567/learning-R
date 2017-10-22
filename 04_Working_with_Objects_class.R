# IN THIS SESSION WE'LL PUT IN PRACTICE ALL WE HAVE 
# LEARN UNTIL NOW, WORKING WITH DIFFERENT DATA TYPES

# Coercing methods
# Combining vectors and data.frames
# Subseting in data.frames
# Working with Lists

data(state)
ls()

help(state)


# lets first create coerce all data sets into data.frames, and create a unique id variable from state.abb
# we will also shuffle rows in each one of them

state.abb
l<-length(state.abb)

state_area<-data.frame(id=state.abb, area=state.area)
head(state_area)

state_area<-state_area[sample(l),]
head(state_area)


state_center<-data.frame(id=state.abb, center=state.center)[sample(l),]
head(state_center)

state_division<-data.frame(id=state.abb, division=state.division)[sample(l),]
head(state_division)

state_name<-data.frame(id=state.abb, name=state.name)[sample(l),]
head(state_name)

state_region<-data.frame(id=state.abb, region=state.region)[sample(l),]
head(state_region)

state_data<-data.frame(id=state.abb,state.x77)[sample(l),]
head(state_data)

# now, we'll merge all datasets into a single data.frame with all information
# since all data sets are randomized rowwise, we cant just concatenate columns with cbind()

whole_data<-merge(state_name, state_data, by='id')
whole_data<-merge(whole_data, state_division, by='id')
whole_data<-merge(whole_data, state_region, by='id')
whole_data<-merge(whole_data, state_center, by='id')
whole_data<-merge(whole_data, state_area, by='id') # area and Area are not identical so we'll keep'em both by now

head(whole_data)
tail(whole_data)

str(whole_data)

# id and name have automatically been coerced to a factor variable. Let's turn it a character variable

whole_data$id<-as.character(whole_data$id)  # to avoid this, have to set stringsAsFactors=F when building the data.frame
whole_data$name<-as.character(whole_data$name)  


str(whole_data)

# we can achive this in a singe step with Reduce()

whole_data2 <- Reduce(merge, list(state_name,state_data,state_division, state_region, state_center,state_area), accumulate=F)

str(whole_data2)

rm(whole_data2)



# summary of each variable in whole data

summary(whole_data)


# working with state_data:

# 1. states with al least 10 million people

most_popul<-whole_data[whole_data$Population>=10000,]

# 2. states with an Income above 5000

richest<-whole_data[whole_data$Income>5000,]

# 3. states with more than 10000 people and Income higher than 5000, but keeping only the variables id, name, Population and Income

popul_and_rich<-whole_data[whole_data$Population>=10000&whole_data$Income>5000,c('id', 'name', 'Population', 'Income')]


# 4. analyze the diffrence of Area and area, and keep only the smallest one
whole_data$Area-whole_data$area

with(whole_data, summary(Area-area))

whole_data<-whole_data[,names(whole_data)!='area']

# 5. create a new variable from the ratio of Murder and HS.Grad, and call it ratio_murder_hsGrad

whole_data$ratio_murder_hsGrad<-whole_data$Murder/whole_data$HS.Grad

# 6. which states names start with letter A

whole_data[which(whole_data$Life.Exp>70),]


##############################################################################

# now let's start over, but working with lists

# to remove all objects in workspace (programmatically) :

rm(list = ls())

data(state)
ls()


head(state.abb)
head(state.area)
head(state.center)
head(state.division)
head(state.name)
head(state.region)
head(state.x77)

# creating a list named state_data containing all datasets loaded with data(state), 
# naming each element with the individual names

state_data<-list(state.abb=state.abb,
                 state.area=state.area,
                 state.center=state.center,
                 state.division=state.division,
                 state.name=state.name,
                 state.region=state.region,
                 state.x77=state.x77)

# summarizing the structure of the list to check the previous step

str(state_data)


# transforming all elemnts of the list to data.frames, with 
# and variable names as colnames, and create a new element of the 
# list creating a complete dataset with all variables except for state.center

state_data<-lapply(state_data,as.data.frame)
str(state_data)


names(state_data$state.abb)<-'abb'
names(state_data$state.area)<-'area'
names(state_data$state.center)<-c('center_x','center_y')
names(state_data$state.division)<-'division'
names(state_data$state.name)<-'name'
names(state_data$state.region)<-'region'

str(state_data)



state_data$complete_data<-cbind(state_data[['state.abb']],
                                state_data$state.division,
                                state_data$state.region,
                                state_data[['state.area']],
                                state_data[['state.x77']])

head(state_data$complete_data)
str(state_data$complete_data)



# merge the complete_data data.frame with a shuffled version of state.center data.frame
state_data$state.center$name<-as.character(state_data$state.name$name)
state_data$state.center<-state_data$state.center[sample(1:nrow(state_data$state.center)),]


state_data$complete_data$name<-as.character(state_data$state.name$name)
state_data$complete_data<-merge(state_data$complete_data,state_data$state.center,by='name')



# check the structure of the dataset created and summarise all variables
str(state_data$complete_data)

summary(state_data$complete_data)


# order the complete_data set in descending order of Income
# print the top 10 state income ranking, from the previous ordered dataset in descending order
# print also the top 10 states with the lowest income

state_data$complete_data<-state_data$complete_data[order(-state_data$complete_data$Income),]

head(state_data$complete_data,n=10)
tail(state_data$complete_data,n=10)

# create a separate dataset from complete_data keeping only the states with at least 4500$ of income or Murder being less than 10
# and droping all variables execpt for name, Income and region

b<-state_data$complete_data[state_data$complete_data$Income>=4500|state_data$complete_data$Murder<10,c('name','Income','region')]
b





