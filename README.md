# Linear-Model-project (R or SAS or Alteryx)

### [Contents] 

__Lab-01.__ predicting the TCDD level in fat tissue
  - language: SAS 
  - func:

__Lab-02.__ predicting Ireland’s health-care spending  
  - language: SAS 
  - func:  

__Lab-03.__ predicting life expectancy of people  
  - language: R 
  - func:  
   
__Lab-04.__ predicting Y 
  - language: R 
  - func:    

__Lab-05.__ Finding the source of the variation in a textile factory
  - language: R 
  - func:    

__Lab-06.__ Predicting diamond prices
  - language: Alteryx 
  - func:   
----------------------------------------------------------------------
### >Lab-01. predicting the TCDD level

__Data:__ The data set 'AgOrange.xlsx' is related to a study of Vietnam War veterans who were exposed to Agent-Orange(TCDD) herbicide during the confict. The data set contians TCDD levels in both "plasma" and "fat tissue" for 20 veterans. One goal of us is to determine the degree of linear association between these two variables. We want to use "plasma" TCDD level to predict the TCDD level in "fat tissue".





### >Lab-06. predicting diamond prices

__Story:__ A diamond distributor has recently decided to exit the market and has put up a set of 3,000 diamonds up for auction. Seeing this as a great opportunity to expand its inventory, a jewelry company has shown interest in making a bid. To decide how much to bid, we will use a large database(50,000)of diamond prices to build a model to predict the price of a diamond based on its attributes. Then we will use the results of that model to make a recommendation for how much the company should bid.

 - **>Step 1. – Understand the data:** There are two datasets. 
   - 'diamonds.csv' contains the data used to build the regression model. **Only this dataset has prices.**
   - 'new_diamonds.csv' contains the data for the diamonds the company would like to purchase. We'll be predicting prices for the 'new_diamonds.csv' dataset.
   - **Carat** represents the weight of the diamond, and is a numerical variable.
   - **Cut** represents the quality of the cut of the diamond, and falls into 5 categories: fair, good, very good, ideal, and premium. These categories can be represented by an ordinal variable, 1-5 (We can decide to use the ordinal or categorical variable).
   - **Clarity** represents the internal purity of the diamond, and falls into 8 categories: I1, SI2, SI1, VS2, VS1, VVS2, VVS1, and IF (in order from least to most pure). These categories can be represented by an ordinal variable, 1-8. 
   - **Color** represents the color of the diamond, and is rated D through J, with D being the most colorless (and valuable) and J being the most yellow.
   - For the dataset from the database, since the data is in a csv, we’ll need to change the datatypes, so we’ll bring in a select tool and set the numeric data to 'double' and the ordinal data to 'integer'. 
   - Bring it in a scatter plot to take a look at the data and get feel for it. There is only one continuous numeric predictor variable, 'carat', so we chart carat and price. 
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
   - Via a scattor plot, we visualize the data ('Score' as the y-variable, and 'carat' as the x-variable). The data is a bit tighter than the larger dataset of diamonds that had actual prices. This shows that while the model does better, it doesn’t account for all the variable. Also, we can see that some of the prices are predicted to be negative, which obviously doesn’t make sense. 
   - To correct for this, **we could set a minimum price or any diamond**. However, we can expect some prices to be overestimated and others underestimated. Since we're aggregating all the prices, We left the prediction as is.
<img src="https://user-images.githubusercontent.com/31917400/33454908-3ffe3a7e-d612-11e7-9932-71bd57c9bc6a.jpg" />

 - **>Step 4. – Make a recommendation:** 
   - If we have the predicted price for each diamond, we can calculate the bid price for the whole set. The diamond price that the model predicts represents the final retail price the consumer will pay. The company generally purchases diamonds from distributors at 70% of the that price, so our recommended bid price should represent that.
   - First, attach the Summarize tool to the Score tool. To sum the Score field, click on Score in the panel, then click add and select the Sum function. This will create a field called Sum_Score. 
   - Next, to multiple the sum_score field by 0.7, attach the formula tool, select sum_score and write the formula: [Sum_Score] * 0.7 which will take the sum of all the predicted diamond prices and multiply it by 0.7.
   - It gives an answer of approximately $8,230,695.69, which would be our recommended bid price for the 3000 diamonds.
<img src="https://user-images.githubusercontent.com/31917400/33455477-1c796464-d614-11e7-960d-40cb482e81d8.jpg" width="600" height="250" />   



































