install.packages('nutshell')
library(nutshell)

data(batting.2008)

str(batting.2008)

head(batting.2008)


# 1. check if there's NAs in the dataframe

sum(is.na(batting.2008)) # no NA's



# 2. filter the dataframe, keeping only players born after 1980

batting.2008[batting.2008$birthYear>1980, ]
# or
subset(batting.2008,birthYear>1980)

# tip: to chek if two objects are exactly the same use the identical function:
identical(batting.2008[batting.2008$birthYear>1980, ],subset(batting.2008,birthYear>1980))



# 3. filter the dataframe, keeping only players born after 1980 and who bats with boths arms (B in bats)

batting.2008[batting.2008$birthYear>1980&batting.2008$bats=='B', ]
# or
subset(batting.2008,birthYear>1980&bats=='B')



# 4. filter the dataframe, keeping only players born after 1980 and who bats with boths arms (B in bats) but throws with only left arm (L in trows)

batting.2008[batting.2008$birthYear>1980&batting.2008$bats=='B'&batting.2008$throws=='L', ]
# or
subset(batting.2008,birthYear>1980&bats=='B'&throws=='L')



# 5. filter the dataframe, keeping only players belonging to teams OAK or DET

batting.2008[batting.2008$teamID=='OAK'|batting.2008$teamID=='DET', ]
# or
subset(batting.2008,teamID=='OAK'|teamID=='DET')

# in this case you could make use of the combine c() function and the %in% instruction (can't use == with a vector)
batting.2008[batting.2008$teamID %in% c('OAK','DET'), ]
# or
subset(batting.2008,teamID %in% c('OAK','DET'))



# 6. filter the dataframe, keeping only players born after 1985, but only keeping variables nameLast, nameFirst, birthYear and teamID
batting.2008[batting.2008$birthYear>1985,c('nameLast','nameFirst','birthYear','teamID')]
# or
identical(
subset(batting.2008,birthYear>1985,select=c('nameLast','nameFirst','birthYear','teamID')), 
subset(batting.2008,birthYear>1985,select=c(nameLast,nameFirst,birthYear,teamID))          # in this case you dont need quotes for the select part 
)



# 7. filter the dataframe, keeping only players born after 1985 or with a height not greater than 71, but only keeping variables nameLast, nameFirst, birthYear, height and teamID
batting.2008[batting.2008$birthYear>1985|batting.2008$height<=71,c('nameLast','nameFirst','birthYear','height','teamID')]
# or
subset(batting.2008,birthYear>1985|height<=71,select=c('nameLast','nameFirst','birthYear','height','teamID'))



# 8. filter the dataframe, keeping only players born after 1985 or with a height not greater than 71, but keeping all variables except teamID
batting.2008[batting.2008$birthYear>1985|batting.2008$height<=71,names(batting.2008)!='teamID']  # a bit tricky...in the columns index part we're saying 
                                                                                                 # variables whose names are different from teamID (returns a boolean vector)
# or
subset(batting.2008,birthYear>1985|height<=71,select=-teamID)  # with the - symbol we're excluding that variable


# 9. filter the dataframe, keeping only players born after 1985 or with a height not greater than 71, but keeping all variables except teamID and nameLast
batting.2008[batting.2008$birthYear>1985|batting.2008$height<=71,!names(batting.2008)%in%c('teamID','nameLast')]  # if excluding several variables we use the %in% operator
                                                                                                                  # and ! (different operator) goes in the begining (try running without ! and compare results)
# or
subset(batting.2008,birthYear>1985|height<=71,select=-c(teamID,nameLast))

# 10. filter the dataframe, keeping only players born after 1985 or before 1965 and with a height not greater than 71 or at least 90, keeping only variables nameLast, nameFirst, birthYear and height. Assign it to a new dataframe (batting_2)
batting_2<-batting.2008[(batting.2008$birthYear>1985|batting.2008$birthYear<1965) & (batting.2008$height<=71|batting.2008$height>=90),c('nameLast',"nameFirst", "birthYear","height")] 

# or
batting_2<-subset(batting.2008,(birthYear>1985|birthYear<1965) & (height<=71|height>=90),select=c(nameLast,nameFirst,birthYear,height))  # you need to encapsulate the or conditions in parenthesis


# 11. create a new variable at the begining of the batting_2 being a sequence from one to the number of rows in batting_2, and name it id_row. Then eliminate it

# batting_2$id_row<-seq(1,nrow(batting_2)) would append it to the end so we can't use it

batting_2<-cbind(id_row=seq(1,nrow(batting_2)),batting_2)

batting_2$id_row<-NULL # or we could use: batting_2<-batting_2[ ,names(batting_2)!='id_row']


