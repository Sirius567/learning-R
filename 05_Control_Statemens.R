# FUNCTIONS ####

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

# CONDITIONAL STATEMENTS ####

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
  
  if(!is.numeric(number)) { stop('Not a number')}
  
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

# we could use a loop to iterate the if condition over a vector, 
# but in this case we would directly use the vectorised ifelse function

x<-c(1:10)

ifelse(test=x%%2==0, yes=paste0(x,' is even'), no=paste0(x, ' is odd'))

# LOOPS

# FOR LOOPS ####

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

# load the state dataset

str(state.x77)

# lets create an algorithm that returns a vector, of length number of
# variables in state.x77, containing the state name with each higher value

winner<-character(ncol(state.x77))
names(winner)<-colnames(state.x77)

for (i in 1:ncol(state.x77)){
  winner[i]<-rownames(state.x77)[which.max(state.x77[,i])]
}

winner

# many times we can achive this task by using much more simple vectorised functions
winner<-character(ncol(state.x77))
names(winner)<-colnames(state.x77)
winner[]<-rownames(state.x77)[apply(state.x77,2,which.max)]

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

distance<-function(a,b){
  
  d <- sqrt((b[1]-a[1])^2 + (b[2]-a[2])^2)
  
  return(d)
}

# and iterate by row and by column, through every 
# pair of states, calculating their center distance, which by the way, is symmetrical

for (i in 1:nrow(distances)){
  for(j in 1:ncol(distances)){
    distances[i,j]<-distance(a=c(data_center[i,'x'],data_center[i,'y']),
                                  b=c(data_center[j,'x'],data_center[j,'y']))
  }
}
View(distances)

# lets ckech ans example

sort(distances['NY',],decreasing=F)


# WHILE LOOPS ####

# in while loops, you iterate a statement until some logical condition is met

k=0
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
is.prime(integer=4183911)


# creating a fibbonaci sequence calculator

fib<-function(integer){
  result<-c(0,1)
  k<-1
  while(length(result)<integer){
    result[k+2]=result[k+1]+result[k]
    k<-k+1
  }
  return(result)
}

fib(15)
plot(fib(15)) 



# LAPPLY FAMILY OF FUNCTIONS ####
class(distances)


# apply: operates a function over a data.frame margins: 1 for row and 2 for columns 
apply(distances,2,mean)
apply(distances,1,mean)

# lapply: operates a function over a list. Returns a list

a<-list(a=letters[10],
        b=runif(50),
        c=data.frame(x=1:3,y=5:7))

lapply(a,class)
lapply(a,summary)

lapply(a,mean)  # will return na whenever the operation  is not allowed over the element class

# we can define our own function and apply it vectorized with lapply

x<-list(a=15,b=34,c=7,d=2)

result_even<-lapply(x,even_number)
str(result_even)
result_even$a

result_prime<-lapply(x,is.prime)

result_fib<-lapply(x,fib)

lapply(lapply(x,fib),plot) # and we can chain vectorised operations


# we can even define the function to apply on the fly, if we are not going to reuse the function

lapply(x,function(x){return(mean(x*3-1))})


# sapply does the same as lapply, but returns output in a simplified object (vector or matrix)

result_prime<-sapply(x,is.prime)
str(result_prime)


str(result_fib<-sapply(x,fib))

x<-list(a=15,b=15,c=15,d=15)
str(result_fib<-sapply(x,fib))


