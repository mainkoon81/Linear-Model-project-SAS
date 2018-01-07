# LM_HW 03

#Please be advised that for the variable x1, there may not be a transformation that removes the non-linearity. 
#This is often true in real data sets. Based off the histograms discuss and try the transformations but don't be alarmed if they do
#not completly remove the non-linearity as they did in the previous assignment. For real data and in the assignment you would pick 
#a transformation that reduced the problem if the AIC stated that it did improve the prediction error and you would state in your 
#results that the non-linearity still remains and that the transformations reduced or didn't help the issue. This would suffice.

#Q_1.-----------------------------------------------------------------------------------------------------------------------------
#Fit an appropriate multiple linear regression model to this data set. Make an analysis. Do you require a transformation of any of
#the variables are there interaction e???ects?
m.data = read.csv('C:/Users/Minkun/Dropbox/Minkun/Semester 2/30250_Linear Models ii/LAB/data/Q1data.csv', header = T)
m.data = m.data[-1]
head(m.data)
summary(m.data)

#A correlation matrix help us detect collinearity between predictors. 
cor(m.data)
pairs(m.data)

#dealing with catagorical variable (binary predictor)
# x3 turns out a binary predictor, thus we split the model into two. The one of which is x3=1, and the other is x3=0

####table(m.data$x3)
####m.data.1 = split(m.data, m.data$x3==1) # just show... 
##m.data.1 = subset(m.data, x3==1); m.data.1
##m.data.0 = subset(m.data, x3==0); m.data.0

m.data$x3 = as.factor(m.data$x3)
is.factor(m.data$x3)

#a single predictor
reg_1 = lm(y ~ x1, data = m.data); summary(reg_1) # Rsq=0.004
reg_2 = lm(y ~ x2, data = m.data); summary(reg_2) # Rsq=0.028
reg_3 = lm(y ~ x3, data = m.data); summary(reg_3) # Rsq=0.897

# double predictors 
reg_4 = lm(y ~ x1+x2, data = m.data); summary(reg_4) # Rsq=0.03
reg_5 = lm(y ~ x1+x3, data = m.data); summary(reg_5) # Rsq=0.93
reg_6 = lm(y ~ x2+x3, data = m.data); summary(reg_6) # Rsq=0.94

# triple predictors
reg_7 = lm(y ~ x1+x2+x3, data = m.data); summary(reg_7) # Rsq=0.97
av = aov(reg_7); summary(av)

layout(matrix(c(1,2,3,4), 2,2))
plot(av)

#histogram
?hist

hist(m.data$x1, breaks = 10)
hist(m.data$x2, breaks = 10)
hist(m.data$y, breaks = 10)


#transformation
m.data$log.x2 = log(m.data$x2)
hist(m.data$log.x2, breaks = 20)

m.data$sq.x2 = sqrt(m.data$x2)
hist(m.data$sq.x2, breaks = 20)

reg_8 = lm(y ~ x1+log.x2+x3, data = m.data); summary(reg_8) # Rsq=0.97
av = aov(reg_8); summary(av)
layout(matrix(c(1,2,3,4), 2,2))
plot(av)

reg_9 = lm(y ~ x1+sq.x2+x3, data = m.data); summary(reg_9) # Rsq=0.97
av = aov(reg_9); summary(av)
layout(matrix(c(1,2,3,4), 2,2))
plot(av)


fitnull <- lm(y~1, data=m.data); summary(fitnull) 
fitfull <- lm(y~x1+x2+x3, data = m.data); summary(fitfull)
final<- step(fitfull, scope = list(lower=fitnull, upper=fitfull), direction='backward', trace = T);summary(final)

fitfull <- lm(y~x1+log.x2+x3, data = m.data); summary(fitfull)
final<- step(fitfull, scope = list(lower=fitnull, upper=fitfull), direction='backward', trace = T);summary(final)
update(final)

layout(matrix(c(1,2,3,4), 2,2)) 
plot(final)

final$coefficients







#Q_2.-----------------------------------------------------------------------------------------------------------------------------
#A textile factory produces synthetic ???bre for use in the manufacture of clothing. 
#A quality control engineer has notice that the "strength" of this ???ber has been variable recently and she conducts an experiment
#to try to ???nd the source of the variation. 
#'Four machines' in the factory produce the ???bre and '3 machine operators' are selected at random from the factory personnel to 
#take part in the experiment. 
#Each operator produces '2 strings of ???bre' from each of the 4 machines. The order in which this happens is randomised to eliminate 
#bias.  Use a mixed model to analyse this data set...

#The report should introduce the problem, detail the methods you use and provide an interpretation of the relationships between the
#variables here. Can you make any recommendations to the engineer about how they might reduce the variability in ???bre strength 
#based on your ???ndings? 

#You need to do an F-test for the variables and estimate the values of the variables that are statistically different from zero 
#similar to example in lec 10 c.

#it states Use a mixed model to analyse this data set... this means you need to:
# Do a hypothesis test to see if the fixed and random effects are significant......
# Estimate the values of the significant (fixed/random effects) and their Variance's......
# See wine example in the lecture notes and the tutorial from week 10 for examples.....

te.data = read.csv('C:/Users/Minkun/Dropbox/Minkun/Semester 2/30250_Linear Models ii/LAB/data/FiberStrength.csv', header = T)
colnames(te.data)[1] = 'Operator'
head(te.data)
summary(te.data)

attach(te.data)
Operater = as.factor(Operator)
Machine = as.factor(Machine)
is.factor(Machine)

aov = aov(Strength ~ Machine + Operator + Machine*Operator); summary(aov)

#Test H0: interation between Machine and Operator is 0?
with(te.data, interaction.plot(Machine,Operator,Strength, type = 'b'))

aov.ab = aov(Strength ~ Machine*Operator); summary(aov.ab)

F = MSAB/MSE = 14.06/5.06  
F = 14.06/5.06; F  

F = MSA/MSAB = 27.11/14.06  
F = 27.11/14.06; F

F = MSB/MSAB
F = 85.56/14.06 



#To perform the analysis of variance for this experiment we will use the lmer function which is in the lme4 package..
library(lme4)
?lmer
#############################################################################################################################
fs.lmer = lmer(Strength ~ Machine  + (1|Operator) + (1|Machine:Operator)); summary(fs.lmer)
anova(fs.lmer) # put some 'random effect' term after 1|....
############################################################################################################################



#The anova function produces an incomplete ANOVA table for the experiment while the summary function details 
#the parameter estimates.
#Using the 'lmer' procedure to test whether there is evidence of ??????? what?? variation ???????
#and estimate the variance components - [sigma_b]^2, [sigma_e]^2......

#Let’s look at these results. 
#First we get some measures of model ﬁt. 
#Then we get an estimate of the variance explained by the random eﬀect (batch). 
#This number is important, because if it’s indistinguishable from zero, then your random eﬀect probably doesn’t matter 
#and you can go ahead and do a regular linear model instead. 





#What is the estimate of the proportion of variation due to batches ? icc estimate???
??ICC #intra class correlation coefficient....
library(ICC)
?ICCest

ICCest(batch, y, CI.type = 'S') #????????????????

#To evaluate the precision of your estimate of the proportion of variation due to batches, ???nd an appropriate CI of 99%..
#This is the CI for correlation coefficient....
ICCest(batch, y, CI.type = 'S', alpha = 0.05) #????????????????

































































