# functions

# functions are all over in R. In fact, c(), as.matrix(), rbind(), seq(), rep()...
# are all (pre-defined) functions. 
# A functions is an object that takes one or more inputs and returns an output
# inputs and output can take any form, even other functions

# we can create our own functions in R, in order to re-use and minimise our code


print_hello<-function(){}  # empty funcion, no aurgumets (input), no output

print_hello()   # here we call the function, returning NULL

print_hello<-function(){
  
  return('Hello')
  
}  # this function constantly returns 'Hello'

print_hello() 


sqr_number<-function(number){
  
  return(print(paste0('The square root of ',number, ' is ',number^0.5)))
}

sqr_number(6748439851385693)


# to get the most out of programming we must learn the basic control statements
# in R. This basicaly implement a set of rules and iterative routine that the computer runs
# for us

# CONDITIONAL STATEMENTS

# if a happens then do this else do that

a <- 1
a

if(2>1){
  a <- a + 5
}

a

if(2>1) {
  print('bigger')
} else {
  print('smaller')
}


# if statements are very commonly used inside functions

even_number<-function(number){
  
  if(number%%2==0 & number!=0){
    print(paste0(number, ' is even'))
  } else if (number%%2!=0){
    print(paste0(number, ' is odd'))
  } else { 
    print('cero is not even nor odd')
    
    }
    
  }
  

even_number(number=876231846129849)

even_number()

even_number(0)

even_number(number=seq(1:10))  # if statemets only apply to vectors of length 1

# we could use a loop to iterate the if condition over a vectos, 
# but in this case we would directly use the vectorised ifelse function

x<-c(1:10)

ifelse(test=x%%2==0, yes=paste0(x,' is even'), no=paste0(x, ' is odd'))

# LOOPS

# FOR LOOPS

# applies a statement an arbitrary number of times, until a specified counter ends

for ( i in 1:1000) {
  print(sqrt(i))
  
}


for ( i in 1:10) {
  even_number(i)
}

# we normally will store results in an object
results<-NULL
for ( i in 1:10) {
  results[i]<-even_number(i)
}

# load the state datadet

str(state.x77)

# lets create an algorithm that returns a vector, of length number of
# variables in state.x77, containing the state name with each higher value

winner<-character(ncol(state.x77))
names(winner)<-colnames(state.x77)

for (i in 1:ncol(state.x77)){
  winner[i]<-rownames(state.x77)[which.max(state.x77[,i])]
}

# many times we can achive this task by using much more simple vectorised functions
rownames(state.x77)[apply(state.x77,2,which.max)]

# double for loops are very common; they are needed when you have two posible iterators

# lets create the matrix of euclidean distances between all pairs of states

data(state)

data_center<-as.matrix(cbind(state.center$x,state.center$y))
colnames(data_center)<-c('x','y')
rownames(data_center)<-state.abb

# we first create and emply matrix called distances to store the results
distances<-matrix(NA, nrow=nrow(data_center),
                  ncol=nrow(data_center))
rownames(distances)<-rownames(data_center)
colnames(distances)<-rownames(data_center)
View(distances)

# lets define the euclidean distance function

distance<-function(C1,C2){
  
  d <- sqrt((C2[1]-C1[1])^2 + (C2[2]-C1[2])^2)
  
  return(d)
}

# and iterate by row and by column, through every 
# pair of states, calculating their center distance, which by the way, is symmetrical

for (i in 1:nrow(distances)){
  for(j in 1:ncol(distances)){
    distances[i,j]<-distance(C1=c(data_center[i,'x'],data_center[i,'y']),
                                  C2=c(data_center[j,'x'],data_center[j,'y']))
  }
}
View(distances)

# lets ckech ans example

sort(distances['NY',],decreasing=F)


# WHILE LOOPS

# in while loops, you iterate a statement until some logical condition is met

k=-10
while( k <= 10 ){
  even_number(k)
  k<-k+1
}


# create a function to confirm weather an integer number is prime or not

is.prime<-function(integer){
  
  N_seq<-seq(2,integer-1)
  
  print(sum(integer%%N_seq==0)==0)
  
}

is.prime(integer=10)
is.prime(integer=31)


# creating a fibbonaci sequence calculator

fib<-function(integer){
  result<-c(0,1)
  k<-1
  while(length(result)<integer){
    result[k+2]=result[k+1]+result[k]
    k<-k+1
    print(length(result))
  }
  return(result)
}

plot(fib(5)) 

recurse_fibonacci <- function(n) {
  if(n <= 1) {
    return(n)
  } else {
    return(recurse_fibonacci(n-1) + recurse_fibonacci(n-2))
  }
}

recurse_fibonacci(130)


# LAPPLY FAMILY OF FUNCTIONS




