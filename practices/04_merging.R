# install.packages('nutshell') no need if its already instaled
library(nutshell) # package calling always needed 

# load the medicare.payments.by.state data set from nutshell library
data(medicare.payments.by.state)

# lets read df_state.csv (in the campus, from previous session)
df_state<-read.csv('df_states.csv',sep=';')


# 1. name medicare.payments.by.state as df_medicare 
#    check both dataframes structure 

df_medicare<-medicare.payments.by.state

str(df_medicare)
str(df_state)


# 2. filter df_medicare de-duplicating the States and assign it to df_medicare_unique;
#    Check the levels of the State factor variable and compare with those of id variable in df_state

df_medicare_unique<-df_medicare[!duplicated(df_medicare$State), ]
str(df_medicare_unique)

levels(df_medicare_unique$State)  # there are weird states like GU, MP, AS ...
levels(df_state$id)

identical(levels(df_medicare_unique$State),levels(df_state$id)) # chech for exact matching

# tip: setdiff(a,b) prints only the elements different in both objects
setdiff(levels(df_medicare_unique$State),levels(df_state$id)) # states in df_medicare_unique not present in df_state


# 3. Drop the variables Diagnosis.Related.Group and Footnote and the rows for States NY and CA from df_medicare_unique, and assign it to df_medicare_unique_truncated

df_medicare_unique_truncated<-df_medicare_unique[!df_medicare_unique$State%in%c('NY','CA') , !names(df_medicare_unique)%in%c('Diagnosis.Related.Group','Footnote')]
str(df_medicare_unique_truncated)



# 4. Create an inner join between df_medicare_unique_truncated and df_state, keeping only states that match, assign it to df_inner_join and analyze the result
df_inner_join<-merge(df_medicare_unique_truncated,df_state,by.x='State',by.y='id')
head(df_inner_join)
str(df_inner_join)  # only 48 rows, the ones that match by state abbreviation



# 5. Create a left join, keeping all states from df_medicare_unique_truncated (but not necessarily from df_states), and assign it to df_left_join_1
df_left_join_1<-merge(df_medicare_unique_truncated,df_state,by.x='State',by.y='id',all.x=T)
head(df_left_join_1)
str(df_left_join_1)



# 6. Create a left join, keeping all states from df_state (but not necessarily from df_medicare_unique_truncated), and assign it to df_left_join_2
df_left_join_2<-merge(df_medicare_unique_truncated,df_state,by.x='State',by.y='id',all.y=T)
head(df_left_join_2)
str(df_left_join_2)



# 7. Create an outer join, keeping all states from df_state and from df_medicare_unique_truncated, and assign it to df_outer_join
df_outer_join<-merge(df_medicare_unique_truncated,df_state,by.x='State',by.y='id',all=T)
head(df_outer_join)
str(df_outer_join)


# 8. Create variable z in df_state filled with random letters A,B,C,U,V,W and variable z in df_medicare_unique with random letters A,B,C,D,E,F.
#    Crate a data set from a merge between df_state and df_medicare_unique where you keep only states that match in both data frames by state abbreviation and with the same value for the z variable
df_state$z<-sample(c(LETTERS[c(1:3,21:23)]),nrow(df_state),replace=TRUE)
head(df_state)

df_medicare_unique$z<-sample(LETTERS[1:6],nrow(df_medicare_unique),replace = TRUE)
head(df_medicare_unique)

df_join_ABC<-merge(df_state,df_medicare_unique,by.x=c('id','z'),by.y=c('State','z'))
head(df_join_ABC)
