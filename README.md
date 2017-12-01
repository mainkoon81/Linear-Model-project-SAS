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
  - Multiple Linear Model  
   
__Lab-04.__ Finding the source of the variation in a textile factory
  - language: R 
  - Multiple Linear Model    

__Lab-05.__ Predicting diamond prices
  - language: Alteryx 
  - Multiple Linear Model   
  
__Lab-06.__ Mailing catalog helps increase revenue?
  - language: Alteryx
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

__Story:__ There is a study of Vietnam War veterans who were exposed to Agent-Orange(TCDD) herbicide during the confict. One goal of us is to determine the deg












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
   
