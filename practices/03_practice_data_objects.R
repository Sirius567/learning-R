# matrices ####
m0<-matrix(c(3,1,4,6,
             5,4,9,3,
             2,2,5,5,
             0,6,1,7,
             4,8,5,1,
             5,2,2,3,
             2,5,5,2),nrow=7,byrow=T) # no need to indicate number of columns, since ncol=4 is the only option 
                                      # to match number of numbers in the matrix if nrow=7
                                      # byrow=T because I'm entering numbers horizontally (left to right)
m0

colnames(m0)<-paste('col',LETTERS[1:4],sep='_')
rownames(m0)<-paste('row',seq(1:7),sep='_')

m0
dim(m0)

# creating new variables out of matrix subsetting
v0<-m0[4,3]
v1<-m0[c(1,4,5),3]
v2<-m0[2, ]

# accesing las element (the wrong way)
v3<-m0[7,4]
# general way to acces last element of the matrix (right-bottom)
v3<-m0[nrow(m0),ncol(m0)]

# multiplying the matrix by a single number
m1<-m0*4
m1

# matrix multiplication (if dimensions are incorrect will give error)
m2<-m0[c(1,4),1:3]%*%m1[c(1,2,4), ] # keeps rownames


# to data.frame

df<-as.data.frame(m2)
df
str(df)

# data.frames ####

# reading the file with read.csv ... see help(read.csv) for details
df_0<-read.csv("df_states.csv", sep=';')  # if the file is not in your wd, write the whole path

# structure of the data.frame
str(df_0)

# summary for each variable in df_0
summary(df_0)

# create a variable out of Murder from df_0
murder<-df_0$Murder
murder
# filtering the missing values
murder[!is.na(murder)]

# create a variable out of Murder from df_0, without NAs, in a single line
murder2<-df_0[!is.na(df_0$Murder),'Murder']
murder2

# mean of murder and murder_2
mean(murder)  # we get NA as a result =(

mean(murder2) # we get the correct mean, since no missing values

mean(murder,na.rm = T) # with na.rm=TRUE we get the correct mean, even if there's NAs

# add new variable state_order
df_0$state_order<-seq(1:nrow(df_0))
head(df_0)

# delete it
df_0$state_order<-NULL

# now appending it to the begining of df_0
df_0<-cbind(state_order=seq(1:nrow(df_0)),df_0)
head(df_0)

# df_0 without any NAs
df_1<-df_0[complete.cases(df_0), ]
df_1
sum(is.na(df_0))
sum(is.na(df_1))

# subsetting
df_2<-df_1[df_1$Income>5000|df_1$Murder<10, ]
dim(df_2)
dim(df_1)

# ordering
df_0[order(df_0$HS.Grad), ]
help(order)
df_0[order(df_0$HS.Grad, na.last = F), ]
