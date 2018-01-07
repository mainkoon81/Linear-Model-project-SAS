#lm_hw01


x1 = matrix(c(-4,-3,-2,-1,0,1,2,3,4), byrow = T); x1
x2 = matrix(c(-1,1,-1,1,0,1,-1,1,-1), byrow=T); x2
Y = matrix(c(-10.9, -5.2, -11.8, -3.4, -6.3, -2.6, -4.9, -1.6, -3.9), byrow=T); Y
a1 <- matrix(c(1,1,1,1,1,1,1,1,1), byrow=T)

X = cbind(a1,x1,x2); X

k=t(X)%*%X; k
betahat=solve(k)%*%t(X)%*%Y; betahat

Yhat=X%*%betahat; Yhat 

sse = sum((Y-Yhat)^2); sse
mse = sse/(length(Y)-length(betahat)); mse

Hatmatrix <- X%*%solve(k)%*%t(X); Hatmatrix

Xstar = matrix(c(1,2.1,0.5), ncol = 3); Xstar

Hatmatrixstar = Xstar%*%solve(k)%*%t(Xstar); Hatmatrixstar


#-----------------------------------------------------------------------------------------------------------------------------------

#Q.02
library("readxl")
pgadata <- read_excel('C:/Users/Minkun/Dropbox/Minkun/Semester 2/30250_Linear Models ii/LAB/data/PGA2004.xlsx')

class(pgadata)

#slicing the delicious parts
pganew <- pgadata[, 5:8]; pganew
pganew <- as.data.frame(pganew); class(pganew)

T_winning <- pgadata[, 4]; T_winning
pganew <- cbind(pganew, T_winning); pganew


#Q(a)
pairs(pganew)
cor(pganew)

#Q(b) Fit a model and interpret its coefficients...conclude...
fitfull <- lm(T_winning~AvPutts+GreensReg+AvgDrive+Age, data=pganew); summary(fitfull)


#Q(c) Refit a model 
pganew2 <- pganew[, -1:-2]; pganew2

fitreduced <- lm(T_winning~AvPutts+GreensReg, data=pganew2); summary(fitreduced)



22548470+(-3396*36)+(158765*65)+(-20478699*1.77)+(16784*290) 












