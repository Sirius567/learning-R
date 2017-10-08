### HELLO WORLD!!! 

# ...this is our first R Script!!


# COSOLE STATEMENTS vS SCRIPT MODE

2 + 2


# VARIABLE ASIGNMENT

x <- 1
x


# TYPES OF VARIABLES

# 5 basic type of variables in R: numeric, integer, logical, character and factor

# coertion methods in R allow us to easily swicth the nature of a variable
# as.numeric(), as.integer(), as.logical(), as.character(), as.factor()

# class() tells us the type of a variable/object


# numeric
x<-1.3    
class(x)


# integer
x<-1
class(x)
x<-as.integer(x)
class(x)
x<-1L
class(x)


# logical
x<-TRUE
class(x)
x<-T
class(x)

x<-as.numeric(x)
class(x)

x<-as.logical(x)
class(x)


# character
x<-'hello world!!'
class(x)
x<-'1'
class(x)

x<-as.integer(x)
class(x)

# factor
x<-factor('hello world!!')
class(x)
print(x)
x<-factor(27)
class(x)
x

x<-as.character(x)
x

x<-as.numeric(x)
x



# R BASE MAIN BUILT-IN FUNCTIONS 

# c()  concatenates variables

x<-c(1,2,3,4,5)

# c() forces to the same class of variable

x<-c(1,2,'a',TRUE)

class(x)

# a:b generates a sequence from a to b with unitary step

x<-1:5

# seq(from, to, by) generates a sequence from a to b with step specified with the by argument

x<-seq(from=2,to=10,by=2)  # arguments in functions are always assigned with =

# x[n] returns the nth position in a vector
x[3]
# [n:m] returns positions n to m in a vector
x[2:4]
# [c(n,m)] returns positions n and m in a vector
x[c(1,3,5)]

length(x) # gives the length of a vector

# sort(x, decreasing=FALSE), sorts a vector in decreasing or increasing mode

sort(x)
sort(x, decreasing = T)

# order() returns the indices of the vector in sorted order
# not the ordered positions of a vector!
order(x)
x<-c(1,5,2,4,6)
order(x)
order(-x)

x[order(x)] # equivalent to sort(x)

# rep(x,n) repeats x, n times

rep(3,5)

# which.min/which.max returns the index of the vector with min/max value

which.min(x)
which.max(x)

x[which.min(x)] # equivalent to min(x)

# summary: applied to a numeric vector, returns a basic statistic summary

summary(x<-c(6,4,5,3,6,5,7,3,5,5))  # we can define a vector on the fly

summary(c(2,3,NA))

# is.na returns logic values TRUE/FALSE when missing values found

is.na(c(2,3,NA))



# logic operators

x<-1
y<-2

x==2
x!=2
x>=0 & y<=3
x>=0 | y<=3
x>=0 && y<=3

z<-c(1:10)

z%%2==0 & z==4
z%%2==0 && z==4


# basic functions for characters

# c, rep, sort and order work as well

c('a','b','c')

rep('vcniqvncq',10)

x<-letters[1:10]

sort(x)
sort(x,decreasing = T)

order(x)


# paste(x,y,z,sep=';') concatenates text with a specified separator
# paste0 concatenates text without any separator

paste('a','b','c',sep=' ')
paste0('a','b','c')




