#lm_hw02

census.data <- read.csv('C:/Users/Minkun/Dropbox/Minkun/Semester 2/30250_Linear Models ii/LAB/data/USCensusData.csv', header = T)
head(census.data)
tail(census.data)
pairs(census.data)
cor(census.data[,2:9])
#The plot seems to indicate that there is some relationship between Life.Exp and Illiteracy, Murder and HS.Grad.
#but there does not appear to be a strong relationship between Life.Exp and others.


#ﬁt a multiple regression model to the census data:
# and we Use backwards elimination to choose the best subset of variables to include in our ﬁnal model.
# Use this ‘best’ model as a starting point to ﬁt similar models, and AIC says what is a better ﬁt.
#it gives global test result such as general F-value,  R squared, ttest, coefficient estimates...etc and we can decide 
#if these variables are useful for predicting life expectancy...

#From the matrix above, we can expect that the response variable is somewhat correlated with 
#‘Murder’, ‘HS.Grad’, and ‘Illiteracy’ variables. 

#Additionally, we can consider some interactions going on between “Murder + Illiteracy”, “HS.Grad + Illiteracy”, 
#“Frost + Illiteracy”, “Income + HS.Grad.” 


#so..find the mean of Murder, Illiteracy, HS.Grad, Frost, Income
#create and add a new variable which is a centred version of Age..
census.data$cMurder = census.data$Murder - mean(census.data$Murder)
census.data$cIlliteracy = census.data$Illiteracy - mean(census.data$Illiteracy)
census.data$cHS.Grad = census.data$HS.Grad - mean(census.data$HS.Grad)
census.data$cFrost = census.data$Frost - mean(census.data$Frost)
census.data$cIncome = census.data$Income - mean(census.data$Income); census.data


#model-01. with interaction terms
fitfull <- lm(Life.Exp~cIlliteracy+cMurder+cHS.Grad+Population+cIncome+cFrost+Area + cIlliteracy*cMurder + 
                cIlliteracy*cHS.Grad + cIlliteracy*cFrost + cIncome*cHS.Grad, data = census.data); summary(fitfull)
#As can be seen in this table, the interactions between “Murder & Illiteracy”, “HS.Grad & Illiteracy”, “Frost & Illiteracy”,
#“Income & HS.Grad” are not significant; therefore, our model does not need interaction terms.  


#but is it an interaction? it happens b/w the response variable(dependent V) and predictors(independent V) not b/w predictors.
#it's a correlation...


################################################################################################################################
################################################################################################################################
################################################################################################################################
#model-02. with polynomial terms ??????????????????????????????????
# If we fit the polynomial model directly, the predictor variables will be highly correlated each other. In this regard, 
#we ensure to centre the relevant predictor variables by subtracting their mean.
#We will use the sequential sums of squares to choose the appropriate degree of the polynomial
#fitting polynomial termssss..
#Is the @cubic@ term required in this model? Would a @quadratic@ polynomial be su???cient?
#In order to choose the appropriate degree of the polynoial we examine the sequential 
#(Type I) sums of squares with associated F and p-values...how???????????????????????????????????????
aov.test <- aov(reg_pol); summary(aov.test) 
aov.test <- aov(Steroid~cen_Age + I(cen_Age^2) + I(cen_Age^3), data=st_data); summary(aov.test)
aov.test <- anova(reg_pol); aov.test 
#################################################################################################################################
################################################################################################################################
################################################################################################################################





#the global F_test...
#It can be seen that the F value of 16.97 is signiﬁcant as the p-value is 2.707e-10.  
#Thus we reject H0 and conclude that not all of the slope parameters are equal to 0.
#The coeﬃcient of multiple determination, R2, and... 
#the adjusted coeﬃcient of multiple determination, adj R2 are reported as 0.7434, 0.6996

#see sequential SS, each F-values corresponding p-values for the local tests...(anova command only works for the fitting model)
census.data2=census.data[,-c(1,3,4,6,7,8)]
plot(census.data2)

fitfull2 <- lm(Life.Exp~cIlliteracy+cMurder+cHS.Grad+cIncome+cFrost+Population+Area, data=census.data2); summary(fitfull2)
#we have to use data2 coz the model has changed...ssr and sse has changed... 
anova(fitfull2)

fitfull3 <- lm(Life.Exp~cIlliteracy+cMurder+cHS.Grad+cFrost, data=census.data2); summary(fitfull3)
anova(fitfull3)

##################################################################??????
library(MASS)
?stepAIC
census.step <- stepAIC(fitfull, trace = T); summary(census.step)
#AIC = -2Ln(L)+ 2k
#AIC and BIC hold the same interpretation in terms of model comparison. 
#That is, the larger difference in either AIC or BIC indicates stronger 
#evidence for one model over the other (the lower the better). IF you 
#want to compare these two models based on their AIC's, then model with 
#lower AIC would be the preferred one..
#It's just the the AIC doesn't penalize the number of parameters as 
#strongly as BIC. There is also a correction to the AIC (the AICc) 
#that is used for smaller sample sizes.
#Ignore the actual value of AIC (or AICc) and whether it is positive
#or negative. Ignore also the ratio of two AIC (or AICc) values. 
#Pay attention only to the difference.
#??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
##################################################################




fitnull <- lm(Life.Exp~., data=census.data2); summary(fitnull) # null model????

fitfull <- lm(Life.Exp~cIlliteracy+cMurder+cHS.Grad+Population+cIncome+cFrost+Area + cIlliteracy*cMurder + 
                cIlliteracy*cHS.Grad + cIlliteracy*cFrost + cIncome*cHS.Grad, data = census.data2); summary(fitfull)

?step
#Using a process of backwards elimination, what ???nal model do you arrive at?
final<- step(fitfull, scope = list(lower=fitnull, upper=fitfull), direction='backward', trace = T)
summary(final)

#WHAT'S THE FINAL MODEL??????????why?????
update(final)


#check if they r reliable...by plotting
layout(matrix(c(1,2,3,4), 2,2)) 
plot(final)

final$coefficients

# prediction###################

#illiterate is 0.7
#the murder rate is 6.8 
#percentage of high school graduates is 63.9 
#a population of 2541 
#income per capita of 4884 
#the number of days with a minimum temperature below 0 is 166 
#the land area of the state is 103,766 

#Use a prediction interval to quantify the uncertainty in your prediction. 
#(You may need all of these measurements or just some depending on your ???nal model)

# Life.Exp ~ cIlliteracy + cMurder + cHS.Grad + Population + cIncome + cFrost + Area
final

?predict
?predict.lm

#how to define a new obv?

new = c(0.7-mean(census.data$Illiteracy), 6.8-mean(census.data$Murder), 63.9-mean(census.data$HS.Grad), 
        2541, 4884-mean(census.data$Income), 166-mean(census.data$Frost), 103766)
new = as.matrix(new, nrow=7, ncol=1)
new = t(new)
new = as.data.frame(new)####fucked up


new = data.frame(cIlliteracy=0.7, cMurder=6.8, cHS.Grad=63.9, Population=2541, cIncome=4884, cFrost=166, Area=103766)
predict.lm(final, newdata = new, interval = 'prediction')




