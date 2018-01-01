# Linear-Model-project (SAS or R or Alteryx)

### [Contents] 

__Lab-01.__ predicting the TCDD level in fat tissue
  - language: SAS 
  - Single Linear Model

__Lab-02.__ predicting Ireland’s health-care spending  
  - language: SAS 
  - Single Linear Model

__Lab-03.__ predicting life expectancy of people  
  - language: R 
  - Multiple Linear Model with interactions 
   
__Lab-04.__ Finding the source of the variation in a textile factory
  - language: R 
  - Multiple Linear Model with Mixed Effect   

__Lab-05.__ Predicting diamond prices
  - language: Alteryx 
  - Multiple Linear Model   
  
__Lab-06.__ Mailing catalog helps increase revenue?
  - language: Alteryx
  - Multiple Linear Model
  
__Lab-07.__ 
  - language: Python
  - Multiple Linear Model  
  
----------------------------------------------------------------------
### >Lab-01. predicting the TCDD level in 'fat tissue'

__Story:__ There is a study of Vietnam War veterans who were exposed to Agent-Orange(TCDD) herbicide during the confict. One goal of us is to determine the degree of linear association between these two variables 'TCDD_plasma' and 'TCDD_fat tissue'. We want to use "plasma" TCDD level to predict the TCDD level in "fat tissue".

__Process:__
 - **>Step 1. - Understand the data:**
   - 'AgOrange.xlsx' contains TCDD levels in both "plasma" and "fat tissue" for 20 veterans. 
   - First, we want to chart TCDD levels in fat tissue (Y-axis) against TCDD levels in blood plasma (X-axis) to detect a linear relationship. 
   - We can see some linear relationship from its scatter plot. 
```
proc import datafile='/folders/myfolders/sasuser.v94/AgOrange.xlsx' out=WORK.TCDD
dbms=xlsx replace;
getnames=yes;
run;

proc plot data=WORK.TCDD;
	plot FatTissue_TCDD*Plasma_TCDD;
run;
```
 - **>Step 2. - Build the model:** 
   - Now we want to find the least squares estimates of the slope and intercept of the best fitting regression line.
```
proc reg data=WORK.TCDD;
	model FatTissue_TCDD = Plasma_TCDD/CLB;
run;
```
<img src="https://user-images.githubusercontent.com/31917400/33491281-9f135202-d6b1-11e7-8967-c28d46dec7f2.jpg" width="300" height="200" />
<img src="https://user-images.githubusercontent.com/31917400/33490745-08e60c26-d6b0-11e7-94c3-5177b7d5fce4.jpg" width="600" height="100" />
If we check the t-statistic value and p-value for testing the hypotheses:[H0: β1 = 0 vs H1: β1 ≠ 0], using a significance level α = 0.01, then we can obtain 99% confidence intervals for β1 and β0. 
 
```
proc reg data=WORK.TCDD;
	model FatTissue_TCDD = Plasma_TCDD/CLB ALPHA=0.01;
	test_slope0: test Plasma_TCDD = 0;
run;
```
<img src="https://user-images.githubusercontent.com/31917400/33491268-9849139e-d6b1-11e7-96f5-cf98ea67d069.jpg" width="600" height="100" />

----------------------------------------------------------------------
### >Lab-02. predicting Ireland’s health-care spending 

__Story:__ Ireland’s GDP per capita in 2010 was $48,260.  Can we predict Ireland’s health care spending in 2010? How to  quantify the uncertainty of the prediction?

__Process:__
 - **>Step 1. - Understand the Data:**
   - 'WDIdata.xlsx' informs that the GDP per capita and Health spending for 186 countries in 2010. 
   - First, we examine the relationship  between the two variables - the log of health care spending (dependent) V.S the log of GDP per capita (independent). 
 - **>Step 2. - Build the model:**  
   - We use simple linear regression to model the log of health care spending as a function of the log of GDP per capita. 
   - With the regression model: Log(y) = β0 +  β1[log(x)], if fitting the model to the data, we can clearly see that there is a positive linear relationship between the two variables.  
```
proc import datafile='/folders/myfolders/sasuser.v94/WDIdata.xlsx' out=WORK.myid0
dbms=xlsx replace;
getnames=yes;
run;

data WORK.myid00;
set WORK.myid0;
	lny_healthspend=log(healthspend);
	lnx_GDP=log(GDP);
run;

proc reg data=WORK.myid00;
	model lny_healthspend=lnx_GDP/cli clb alpha=0.05; 
	output out=WORK.myid00 p=yhat r=res;
run;

proc corr data=WORK.myid00 pearson; 
	var lny_healthspend lnx_gdp;
run;	

proc plot data=WORK.myid00; 
	plot res*yhat / vpos=20 hpos=75;
	title 'plot of residuals against predicted values';
run;

proc univariate data=WORK.myid00;
	var res;
	qqplot res / normal (mu=est sigma=est);
run;
```
<img src="https://user-images.githubusercontent.com/31917400/33493744-f61c0042-d6b8-11e7-8a5e-f926e9db2c8e.jpg" />

 - In the ANOVA table, we can see that the significant F and P value (F=2301.78, P<0.0001) for the model. It is safe to say that the model explains a signiﬁcant amount of the data variation(92.6%) which is stated by the value of Adjusted R-Sq(0.9256). 
 - It is highly unlikely that β0 and β1 is 0 as can be seen through p_value (t-value for ttest is -6.30 and 47.98, given that p-value=0.0001, we reject the null hypothesis). 
 - Instead the analysis shows that the estimate of β0 and β1 is -0.96 and 0.85 respectively. So we can write the regression equation from these parameter estimates: Log(y) = (-0.96) +  (0.85)log(x) 
 - Based on the plot of residuals against fitted values, The model fit well to this dataset because the data are evenly distributed along the line 'res=0.'
 - As stated in the question, we need to predict Ireland’s health care spending when its GDP per capita was $48,260. We plug ‘x=48,260’ into the regression equation as follows.
<img src="https://user-images.githubusercontent.com/31917400/33494133-1fa79588-d6ba-11e7-8ebd-dcdbc78dcf8c.JPG" width="600" height="300" />

----------------------------------------------------------------------
### >Lab-03. predicting life expectancy of people  

__Story:__ Can we predict life expectancy of people by using information of their income, education level, murder rate of their location, the size of their communities, etc ? 

__Process:__
 - **>Step 1. - Understand the Data:**
   - 'USCensusData.csv' We have a dataset that comes from US census of 49 states, and this includes all information we need 
     - Population size
     - Income level
     - Illiteracy rate
     - Murder rate
     - HS.Grad rate
     - number of freezing days
     - Area size
   - What we are aiming at is to build the best regression model by investigating the predictors’ contributions to a response variable, and the **possible interactions** between predictors. 
   - Once we finalize our model,  we would check that the model assumptions are satisﬁed, so that we ensure the reliability of the model and carry out an actual prediction for a given data point.  
   - First, plotting relationships between variables and producing a correlation matrix can give us a hint where to start dealing with collinearity that might reside within the variables.
   - From the matrix below, we can expect that the response variable is somewhat correlated with ‘Murder’, ‘HS.Grad’, and ‘Illiteracy’ variables. 
   - Also, we can consider some significant correlations going on between “Murder & Illiteracy”, “HS.Grad & Illiteracy”, “Frost & Illiteracy”, “Income & HS.Grad”, thus need to start partially mitigating this multicollinearity, centering the predictors as follows.  
   
```
census.data <- read.csv('C:/Users/Minkun/Desktop/classes_1/30250_Linear Models ii/LAB/data/USCensusData.csv', header = T)
pairs(census.data)
cor(census.data[,2:9])

census.data$cMurder = census.data$Murder - mean(census.data$Murder)
census.data$cIlliteracy = census.data$Illiteracy - mean(census.data$Illiteracy)
census.data$cHS.Grad = census.data$HS.Grad - mean(census.data$HS.Grad)
census.data$cFrost = census.data$Frost - mean(census.data$Frost)
census.data$cIncome = census.data$Income - mean(census.data$Income); census.data
```
<img src="https://user-images.githubusercontent.com/31917400/33500882-6458f358-d6d2-11e7-9adc-ec92643d615b.jpg" />
   
 - **>Step 2. - Build the model:**  
   - We fit the model using the centered version of the variables (model_1).
```
fitfull <- lm(Life.Exp~cIlliteracy+cMurder+cHS.Grad+Population+cIncome+cFrost+Area + cIlliteracy*cMurder + 
                cIlliteracy*cHS.Grad + cIlliteracy*cFrost + cIncome*cHS.Grad, data = census.data); summary(fitfull)
```
<img src="https://user-images.githubusercontent.com/31917400/33501202-9c3cb790-d6d3-11e7-9c46-b42411b5df0a.jpg" width="500" height="250" />

   - As can be seen in this table, the relations between “Murder & Illiteracy”, “HS.Grad & Illiteracy”, “Frost & Illiteracy”, “Income & HS.Grad” are not significant; therefore, our model might not need those interaction terms. Next, we need to carry out the global F-test (lack of fit test), using the rest of the terms – Area, Population, centered-illiteracy, centered-Murder, centered- HS.Grad, centered-Income, centered-Frost. We build the new model with using those predictors (model_2).
```
census.data2=census.data[,-c(1,3,4,6,7,8)]
fitfull2 <- lm(Life.Exp~cIlliteracy+cMurder+cHS.Grad+cIncome+cFrost+Population+Area, data=census.data2); summary(fitfull2)
anova(fitfull2)
```
<img src="https://user-images.githubusercontent.com/31917400/33501505-b39019fe-d6d4-11e7-98d3-109bb86b830d.jpg" width="500" height="300" />

   - In this model_2, seemingly, two predictors are obviously significant – “cMurder” and “cFrost.” However, what should be noticed in the global F-test is that the most significant Sum of Squares and F-values come from “cilliteracy” and “cMurder” variables. Bearing this in mind, we might rule out some insignificant terms from the model which are “Population”, “Area” and “cIncome” (model_3). However, we also try the stepwise method with backwards elimination to choose the best subset of variables to include in the ﬁnal model. 
```
fitnull <- lm(Life.Exp~., data=census.data2); summary(fitnull)
fitfull <- lm(Life.Exp~cIlliteracy+cMurder+cHS.Grad+Population+cIncome+cFrost+Area + cIlliteracy*cMurder + 
                cIlliteracy*cHS.Grad + cIlliteracy*cFrost + cIncome*cHS.Grad, data = census.data2); summary(fitfull)
final<- step(fitfull, scope = list(lower=fitnull, upper=fitfull), direction='backward', trace = T)
summary(final)
```
<img src="https://user-images.githubusercontent.com/31917400/33501820-e31d2224-d6d5-11e7-8411-9843e4570bc1.jpg" width="300" height="280" />   

   - The stepwise method suggests that the best model comes with the terms – cIlliteracy, cMurder, cHS.Grad, Population, cIncome, cFrost, Area. AIC value is -22.59 which is the smallest which indicates the model is the best. Now we check the reliability of the final model by referencing the four different plots as follows.      
```
layout(matrix(c(1,2,3,4), 2,2)) 
plot(final)

new = data.frame(cIlliteracy=0.7, cMurder=6.8, cHS.Grad=63.9, Population=2541, cIncome=4884, cFrost=166, Area=103766)
predict.lm(final, newdata = new, interval = 'prediction')
```
<img src="https://user-images.githubusercontent.com/31917400/33500887-6ba0f840-d6d2-11e7-8ac2-c8c8d029d8d3.jpeg" width="300" height="200" /> 

<img src="https://user-images.githubusercontent.com/31917400/33502282-5f7385ec-d6d7-11e7-9f7c-ee473ac9377d.jpg" width="600" height="50" /> 

   - Here we produce a Prediction Interval to quantify the uncertainty in the prediction regarding the given observation. The 95% prediction interval of the life expectancy for Colorado is between 65.85481 and 74.50986 years.
   - The final model we discovered is: 
E[Life.Exp] = Β0+ Β1(cIlliteracy) + Β2(cMurder) + Β3(cHS.Grad) + Β4(Population) + Β5(cIncome) + Β6(cFrost) + Β7(Area)

----------------------------------------------------------------------
### >Lab-04. Finding the source of the variation in a textile factory

__Story:__  A textile factory produces synthetic ﬁbre for use in the manufacture of clothing. A quality control engineer has notice that the strength of this ﬁber has been variable recently and she conducts an experiment to try to ﬁnd the source of the variation. Four machines in the factory produce the ﬁbre and 3 machine operators are selected at random from the factory personnel to take part in the experiment. Each operator produces 2 strings of ﬁbre from each of the 4 machines. The order in which this happens is randomised to eliminate bias. Can we make any recommendations to the engineer about how they might reduce the variability in fibre strength 
based on out findings? 

__Process:__
 - **>Step 1. - Understand the data:**
   - 'FiberStrength.csv' contains two categorical variables - 'Operator','Machine', and one numerical variable - 'Strength'. 
   - This experiment should implement a mixed factor effect model because we are only interested in the outputs from the four machines which should be characterized as a fixed factor while three machine operators are randomly selected ,which should be considered as a random factor. 
```
te.data = read.csv('C:/Users/Minkun/Desktop/classes_1/30250_Linear Models ii/LAB/data/FiberStrength.csv', header = T)
colnames(te.data)[1] = 'Operator'
head(te.data)
summary(te.data)
attach(te.data)
Operater = as.factor(Operator)
Machine = as.factor(Machine)
is.factor(Machine)
aov = aov(Strength ~ Machine + Operator + Machine*Operator); summary(aov)
```
  - Here we cannot rely on F-value and P-value because here R does not differentiate the fixed factor and random factor, but SS-values are still valid; therefore, we can carry on the hypothesis test. 
```
with(te.data, interaction.plot(Machine,Operator,Strength, type = 'b'))

aov.ab = aov(Strength ~ Machine*Operator); summary(aov.ab)
```
<img src="https://user-images.githubusercontent.com/31917400/33503933-72989a6c-d6dd-11e7-8f34-ebff34773802.jpg" />    

**Test H0: Interaction between Machine and Operator is 0?**
 - F = MSAB/MSE = 14.06/5.06 = 2.778656 -> Definitely close to 1.
 - F(0.05), (3, 16) = 3.239 -> therefore, we fail to reject H0, i.e An interaction effect is not significant. 
**This can be seen through the interaction plot as well. The range of strength in this plot is too narrow to say all lines are not parallel.** 

**Test H0: Fixed effect is 0?**
 - F = MSA/MSAB = 27.11/14.06 = 1.928165 -> Definitely close to 1.
 - F(0.05), (3, 3) = 9.277 -> therefore, we fail to reject H0, i.e **there is no significant fixed effect.** 

**Test H0: Random effect is 0?**
 - F = MSB/MSAB = 85.56/14.06 = 6.085349 -> close to 1.
 - F(0.05), (1, 3) = 10.13 -> therefore, we fail to reject H0, i.e **there is no significant random effect.**

> This test does fully convince me because once there is no interaction effect discovered, we can investigate the source of the contribution to the fixed effect of Machine factor as well as the random effect of Operator factor. In other word, the variance of interaction term is not included in MSA of Machine factor and MSB of Operator factor. 

> Not to mention, we can estimate the value of fixed, random effect and the variances of interaction, fixed, random factor. The estimate of the variance of response variable would be equivalent to that of the variance of residual.  

To perform the analysis of variance for this experiment we will use the 'lmer()' which is in the lme4 package..
```
library(lme4)
fs.lmer = lmer(Strength ~ Machine + (1|Operator) + (1|Machine:Operator)); summary(fs.lmer)
anova(fs.lmer)
```
<img src="https://user-images.githubusercontent.com/31917400/33504513-998d6ede-d6df-11e7-89f2-6312ea69497e.jpg" width="600" height="280" />

 - The value of random effect (maximum likelihood) is 97.9
 - The values of fixed effect is 111.8333, 0.3333, 4.6667, 1.6667 respectively.
 - The var of fixed factor is 1.91 and 1.8015. 
 - The var of random factor 6.111
 - The var of interaction term is 3.493
 - Those values seem insignificant.

The estimate of the variance of response variable is only 2.75. Which one is the main source of this variance? We can determine it by comparing their significance of F-values. But as we’ve been through above, there is no significant random effect, fixed effect and interaction. If we need to reduce the variability in the response variable (the fiber strength), we can advise that in the case operator is a source of variation, “train operators,” in the case machine is the source of variance, “calibrate the machine again.” 

----------------------------------------------------------------------
### >Lab-05. predicting diamond prices

__Story:__ A diamond distributor has recently decided to exit the market and has put up a set of 3,000 diamonds up for auction. Seeing this as a great opportunity to expand its inventory, a jewelry company has shown interest in making a bid. To decide how much to bid, we will use a large database(50,000)of diamond prices to build a model to predict the price of a diamond based on its attributes. Then we will use the results of that model to make a recommendation for how much the company should bid.

 - **>Step 1. – Understand the data:** There are two datasets. 
   - 'diamonds.csv' contains the data used to build the regression model. **Only this dataset has prices.**
   - 'new_diamonds.csv' contains the data for the diamonds the company would like to purchase. We'll be predicting prices for the 'new_diamonds.csv' dataset.
   - **Carat** represents the weight of the diamond, and is a numerical variable.
   - **Cut** represents the quality of the cut of the diamond, and falls into 5 categories: fair, good, very good, ideal, and premium. These categories can be represented by an ordinal variable, 1-5 (We can decide to use the ordinal or categorical variable).
   - **Clarity** represents the internal purity of the diamond, and falls into 8 categories: I1, SI2, SI1, VS2, VS1, VVS2, VVS1, and IF (in order from least to most pure). These categories can be represented by an ordinal variable, 1-8. 
   - **Color** represents the color of the diamond, and is rated D through J, with D being the most colorless (and valuable) and J being the most yellow.
   - For the dataset from the database, since the data is in a csv, we’ll need to change the datatypes, so we’ll bring in a select tool and set the numeric data to 'double' and the ordinal data to 'integer'. 
   - Bring it in a scatter plot to take a look at the data and get feel for it. There is only one continuous numeric predictor variable, 'carat', so we chart price and carat. 
   - As expected, that price increases with carat weight, but there’s a lot of variation among diamonds of the same weight. The additional predictor variables will help explain some of this variation.
<img src="https://user-images.githubusercontent.com/31917400/33441774-62ef790c-d5eb-11e7-845b-5d9a2d787624.jpg" />  
   
 - **>Step 2. - Build the model:** 
   - Now we can add a multiple linear regression tool. We start by adding all the predictor variables. When using Alteryx, we do not need to manually create dummy variables before building the model. If we select a categorical variable, like cut or clarity, then Alteryx will automatically create the dummy variables and give the correct regression output. 
   - The first thing we check is the **p-value** on the predictor variables because we don’t want to include any variables that aren’t statistically significant. If the p-value is less than .05, we can be 95% confident that there exists a relationship between the predictor and target variable.
   - For this model, it so happens that all the predictor variables are statistically significant, so we can leave them all in. Let’s take a look at the **adjusted R-squared**. It’s above 0.9, which is good. While a high r-squared is not a guarantee that the model good, in this case we can have a lot of confidence that our model will explain a lot of the variation in prices.
   - Notice that for each of the categorical variables (cut, clarity, and color), there's one value that doesn't have it's own coefficient because one category (fair, I1, D) represents the baseline case that all other categories are compared against. 
   - Normally the process of selecting variables includes additional steps, like checking correlation among predictor variables, ensuring a linear relationship exists, and checking other assumptions. For example, 1)Res vs Fitted_V: cov(Ɛ,Ŷ)=0, equally spread Res! 2)qq-plot: Ɛ~N(0,σ²I) 3)Stu_Res vs Fitted_V: var(Ɛ)=σ²I, each predictors sharing the same variance,homoscedasticity 4)Stu_Res vs Leverage: detecting influential outliers, How results will differ by inclusion/exclusion. The studentized-Res has a purpose to uncorrelate b/w Res and Res.
<img src="https://user-images.githubusercontent.com/31917400/33443681-15d6abf4-d5f0-11e7-9d23-1e7946813eff.jpg" width="600" height="150" />
<img src="https://user-images.githubusercontent.com/31917400/33443182-d9d00322-d5ee-11e7-91f3-d6244ec9394a.jpg" />

 - **>Step 3. - Calculate the predicted price for diamond:** 
   - For each diamond, plug in the values for each of the variables into the equation. Then solve the equation to get the estimated diamond price. Bring in the 'new_diamonds' dataset and setting the datatypes correctly. Bring in the score tool. We attach the linear regression to one side, and the new_diamonds dataset to the other. The score tool does not require any configuration, and it will automatically apply the regression results to the new_diamonds data. The results of the Score tool will create a field called "Score" which represents the predicted diamond price for each of the diamonds in the new_diamonds data.
   - Via a scattor plot, we visualize the data ('Score' as the y-variable, and 'carat' as the x-variable). The data is a bit tighter than the larger dataset of diamonds that had actual prices. This shows that while on average, the model does better, for any particular diamond, the prediction could be way off! The model doesn’t account for all the variable. There must be other factors affecting the prices that haven't been taken into account by the model(of course). Also, we can see that some of the prices are predicted to be negative, which obviously doesn’t make sense. 
   - To correct for this, **we could set a minimum price or any diamond**. However, we can expect some prices to be overestimated and others underestimated. Since we're aggregating all the prices(still useful to set a bid price), We left the prediction as is.
<img src="https://user-images.githubusercontent.com/31917400/33454908-3ffe3a7e-d612-11e7-9932-71bd57c9bc6a.jpg" />

 - **>Step 4. – Make a recommendation:** 
   - If we have the predicted price for each diamond, we can calculate the bid price for the whole set. The diamond price that the model predicts represents the final retail price the consumer will pay. The company generally purchases diamonds from distributors at 70% of the that price, so our recommended bid price should represent that.
   - First, attach the Summarize tool to the Score tool. To sum the Score field, click on Score in the panel, then click add and select the Sum function. This will create a field called Sum_Score. 
   - Next, to multiple the sum_score field by 0.7, attach the formula tool, select sum_score and write the formula: [Sum_Score] * 0.7 which will take the sum of all the predicted diamond prices and multiply it by 0.7.
   - It gives an answer of approximately $8,230,695.69, which would be our recommended bid price for the 3000 diamonds.
<img src="https://user-images.githubusercontent.com/31917400/33455477-1c796464-d614-11e7-960d-40cb482e81d8.jpg" width="600" height="250" />   

----------------------------------------------------------------------
### >Lab-06. Mailing catalog helps increase revenue?

__Story:__ We started working for a company that manufactures and sells high-end home goods. Last year the company sent out its first print catalog, and is preparing to send out this year's catalog in the coming months. The company has 250 new customers from their mailing list that they want to send the catalog to. Our manager has been asked to determine how much profit the company can expect from sending a catalog to these customers. We are assigned to help our manager run the numbers. While fairly knowledgeable about data analysis, our manager is not very familiar with predictive models. We’ve been asked to predict the expected profit from these 250 new customers. Management does not want to send the catalog out to these new customers unless the expected profit contribution exceeds $10,000.
 - The costs of printing and distributing is $6.50 per catalog.
 - The average gross margin (price - cost) on all products sold through the catalog is 50%.
 - When calculating our profit, we need to multiply our revenue by the gross margin first before we subtract out the $6.50 cost. 
 - Here, clean data is provided for this project, so we can skip the data preparation step of the Problem Solving Framework.

 - **>Step 1. – Understand the data:** 
   - 'p1-customers.xlsx'(train-set) includes the following information on about 2,300 customers. **Only this dataset has 'Responded_to_Last_Catalog' and 'Avg_Sale_Amount'.**
   - 'p1-mailinglist.xlsx'(test-set) is the 250 customers that we need to predict sales. This is the list of customers that the company would send a catalog to. Use this dataset to estimate how much revenue the company can expect if they send out the catalog. It includes all of the fields from P1_Customers.xlsx except for 'Responded_to_Last_Catalog.' **It also includes two additional variables.**
     - **Score_No**: The probability that the customer WILL NOT respond to the catalog and not make a purchase.
     - **Score_Yes**: The probability that the customer WILL respond to the catalog and make a purchase.
   - Check the data type.
   - Bring it in a scatter plot. We want to chart 'Avg_Sale_Amount' and '?' but...no idea. 

 - **>Step 2. - Modeling & Validation:** 
   - Now we can add a multiple linear regression tool. We start by adding all the predictor variables. Which one is significant? 
   - Scatter Plot: For Numeric variables we can use a scatterplot between a variable and the response variable to see if the variable might be a good candidate for a predictor variable. Do they have an appropriate linear relationship? 
   - Check P-values (<= 0.05).
   - Check R-Squared. 
<img src="https://user-images.githubusercontent.com/31917400/33460702-4d67d548-d627-11e7-9a0f-360d3aa2506c.jpg" width="600" height="600" />   

For this model, it so happens that 'City', 'Store_Number', 'Years_as_Customer' variables are statistically not significant, so we can rule out them in. 

<img src="https://user-images.githubusercontent.com/31917400/33460802-ca18845c-d627-11e7-9840-ea0de58dea61.jpg" width="600" height="260" />   

For this model, 'Customer_Segment', 'Responded_to_Last_Catalog', 'Avg_Num_Products_Purchased' variables are significant. R-squared value is above 0.8, and we can say with a lot of confidence that this model will explain a lot of the variation in the amount of sales. More importantly, we could confirm that whether responding to catalog or not is somehow associated to the amount of sales. 

 - **>Step 3. - Calculate the predicted profit for sending out catalogs:**
   - Now we can plug in the values of 'p1-mailinglist.xlsx' dataset into the equation. Variables involved here would be 'Customer_Segment', 'Avg_Num_Products_Purchased'. 'Responded_to_Last_Catalog' variable would be ignored here for the sake of model consistency. But we include 'Score_No','Score_Yes' to calculate the expected final profit later on.  
   - We want to calculate the expected revenue from these 250 people. This means we need to multiply the probability that a person will buy our catalog as well. For example, if a customer were to buy from us, we predict this customer will buy $450 worth of products. At a 30% chance that this person will actually buy from us, we can expect revenue to be $450 x 30% = $135.
<img src="https://user-images.githubusercontent.com/31917400/33462413-53b2791e-d62f-11e7-9356-1bc8e653506c.jpg" width="600" height="200" /> 

It gives an answer of approximately $47,224.87, which would be our estimated total payment that the 250 new customers would make. 
 
 - **>Step 4. – Make a recommendation:** to whether the company should send the catalogs or not.
   - We need to factor in the gross margin and cost of sending the catalog to each person.
     - The costs of printing and distributing of catalogs for 250 customers: 250 x 6.5 = 1,625
     - The average gross margin through catalogs: 47,225 x 0.5 =  23,612.5
     - Total profit: 23,612.5 - 1,625 = 21,987.5
   - It seems the expected profit contribution exceeds $10,000, thus we can conclude that the company should send out the catalogs. 


----------------------------------------------------------------------
### >Lab-07. M

__Story:__ We started working for a company that manufactures and sells high-end home goods. Last year the company sent out its first print catalog, and is preparing to















