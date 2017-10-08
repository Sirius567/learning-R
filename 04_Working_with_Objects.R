# IN THIS SESSION WE'LL PUT IN PRACTICE ALL WE HAVE 
# LEARN UNTIL NOW, WORKING WITH DIFFERENT DATA TYPES

# Coercing methods
# Combining vectors and data.frames
# Subseting in data.frames
# Working with Lists

data(state)
ls()

help(state)

head(state.abb)
head(state.area)
head(state.center)
head(state.division)
head(state.name)
head(state.region)
head(state.x77)

# create a list named state_data containing all datasets loaded with data(state), 
# naming its element with the individual names

state_data<-list(state.abb=state.abb,
     state.area=state.area,
     state.center=state.center,
     state.division=state.division,
     state.name=state.name,
     state.region=state.region,
     state.x77=state.x77)

# summarize the structure of the list to check the previous step

str(state_data)


# transform all elemnts of the list to data.frames, with 
# and variable names as colnames, and create a new element of the 
# list creating a complete dataset with all variables except for state.center data.frame

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

# create a separate dataset from complete_data keeping only the states with at least 4500$ of income

b<-state_data$complete_data[state_data$complete_data$Income>=4500,c('name','Income','region')]
b

