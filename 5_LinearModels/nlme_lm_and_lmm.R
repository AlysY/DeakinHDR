###************************###
####Deakin HDR Coding Club:####
####An introduction to linear####
####and mixed effect models#### 
####in R####

##Description: An introduction to linear and mixed effect models using the nlme
##             package, including model selection via AIC/AICc and model weights (MuMin package)

##Author: Anna Miltiadous

###**********************###
####1. Working directory####
setwd("D:/Users/Catsi/Documents/1 Anna USB/Anna.PhD/R/Coding club")

###**************###
####2. Data sets####
##Datasets included in the nlme package (may not be exhaustive) 
#Alfalfa <- as.data.frame(Alfalfa)
#Assay <- as.data.frame(Assay)
#BodyWeight <- as.data.frame(BodyWeight)
#Cefamandole <- as.data.frame(Cefamandole)
#Dialyzer <- as.data.frame(Dialyzer)
#Earthquake <- as.data.frame(Earthquake)
#Fatigue <- as.data.frame(Fatigue)
#Gasoline <- as.data.frame(Gasoline)
#Glucose <- as.data.frame(Glucose)
#Glucose2 <- as.data.frame(Glucose2)
#Gun <- as.data.frame(Gun)
IGF <- as.data.frame(IGF)
#Machines <- as.data.frame(Machines)
#MathAchieve <- as.data.frame(MathAchieve)
#MathAchSchool <- as.data.frame(MathAchSchool)
#Meat <- as.data.frame(Meat)
#Milk <- as.data.frame(Milk)
#Muscle <- as.data.frame(Muscle)
#Oats <- as.data.frame(Oats)
#Orthodont <- as.data.frame(Orthodont)
#Ovary <- as.data.frame(Ovary)
#Oxboys <- as.data.frame(Oxboys)
#Oxide <- as.data.frame(Oxide)
#PBG <- as.data.frame(PBG)
#Phenobarb <- as.data.frame(Phenobarb)
#Pixel <- as.data.frame(Pixel)
Quinidine <- as.data.frame(Quinidine)
#Rail <- as.data.frame(Rail)
#RatPupWeight <- as.data.frame(RatPupWeight)
#Relaxin <- as.data.frame(Relaxin)
#Remifentanil <- as.data.frame(Remifentanil)
#Soybean <- as.data.frame(Soybean)
#Spruce <- as.data.frame(Spruce)
#Tetracycline1 <- as.data.frame(Tetracycline1)
#Tetracycline2 <- as.data.frame(Tetracycline2)
#Wafer <- as.data.frame(Wafer)
#Wheat <- as.data.frame(Wheat)
#Wheat2 <- as.data.frame(Wheat2)

###********************************************###
####3. Choosing the correct model for the data####

###linear model (lm) requires:
#1 continuous response variable
#at least 1 predictor variable (can be categorical or continuous)
#no repeated measures (i.e. independent sampling)

###linear mixed-effect model (lmm) requires:
#1 continuous response variable
#at least 1 predictor variable (can be categorical or continuous)
#can have repeated measures (i.e. independent sampling) as random factor

#normal distribution of the response variable is advantageous (not as important for predictors); 
#however not required, as long as the residuals meet assumptions of linear distribution

View(IGF)
#Can use as example for lm (ignore that "lot" likely signifies repeated measure)
#1 continuous response variable (conc), 1 categorical predictor variable (Lot; fixed factor), 
#1 continuous predictor variable (age; co-variate)
#237 data points
#use AIC to compare model fit (minimum of 40 sample size per co-variate/fixed factor in most complex model)

View(Quinidine)
length(unique(Quinidine$Subject))
#136 subjects (with repeated measures; random factor), 1471 data points
#5 continuous variables (co-variates): time, dose, age, height, weight
#6 categorical variables (fixed factors): race, smoke, ethanol, heart, creatinine, glyco
#discard conc and interval as too many NAs
#may be good to show multivariate model selection (more complex)

#View(MathAchieve)
#length(unique(MathAchieve$School))
#160 schools (with repeated measures; random factor), 7185 data points
#1 continuous response variable, 3 categorical (fixed factors), 1 continuous (co-variate).
#lmm (as has repeated measures)
#AIC comparison (minimum of 40 sample size per co-variate/fixed factor in most complex model)

#View(Milk)
#length(unique(Milk$Cow))
#length(unique(Milk$Diet))
#79 cows (with repeated measures; random factor), 1337 data points
#1 continuous response variable (protein), 2 categorical (fixed factors)
#good for lmm with AICc comparison

#View(RatPupWeight)
#length(unique(RatPupWeight$Litter))
#27 litters (with repeated measures: offspring; random factor), 322 data points
#1 continuous response variable: weight 
#1 continuous variable (co-variate): litter size
#1 categorical variable (fixed effect): treatment group

###*********************************************************************###
####4. Choosing the appropriate package for mixed effect models####
##https://bbolker.github.io/mixedmodels-misc/glmmFAQ.html

#e.g. nlme vs. lme4

###nlme: 
#allows more complex designs than aov (unbalanced, heteroscedasticity and/or correlation among residual errors)
#more mature than lme4
#well-documented (Pinheiro and Bates 2000)
#implements R-side effects (heteroscedasticity and correlation)
#estimates "denominator degrees of freedom" for F
#statistics, and hence p [these are the output tables most often reported]
#values, for LMMs

###lme4:
#fastest
#best for crossed designs (although they are possible in lme)
#GLMMs
#cutting-edge (for better or worse!)
#likelihood profiles
#use lme4 for GLMMs, or if you have big data (thousands to tens of thousands of records)

###IMPORTANT: lme4 does not allow the production of p-value tables. Reports output as CIs

###**********************###
####5. Required packages####
library(nlme) #to conduct mixed effect models where residuals fit Gaussian distribution only
library(MuMIn) #to calculate models weights, as well as run AICc model selection
library(lattice) #to produce some pairwise plots for continuous variables
library(car) #to draw qqplots for residual examinations

###***************************###
####6. Running a linear model####

###***********************************###
####6.1 Linear model data exploration####

###****************************###
####6.1.1 Histograms/ boxplots####

#Response variable should generally be normally distributed (less important for variables)
#Transformation only necessary if residuals do not fit normality assumptions
#But should know what the data looks like before utilised in models

#Produce histograms of continuous variables
##Response variable (conc):
hist(IGF$conc)
boxplot(IGF$conc)
shapiro.test(IGF$conc)
#non-normal distribution (p<0.05), transformation not possible due to the distribution shape 

#Very small & large outlier values
#Produce subset without the outliers
IGFs <- subset(IGF, conc >= 1)
IGFs <- subset(IGFs, conc <= 8)
hist(IGFs$conc)
#much better distribution

#Co-variate (age)
hist(IGFs$age) #skewed distribution
boxplot(IGFs$age) #no outliers
shapiro.test(IGFs$age)#non-normal distribution (p<0.05)

###********************************###
####6.1.2 Pairwise plots/ boxplots####

#Draw pairwise plots to look at relationships of continuous variables
pairs(IGFs)
#No clear trends
#But always good to use these pairwise plots to check relationships
#This can inform decision-making for model composition

#Set categorical variable (which is in numerical form) as a character string
#(this is important as numbers are treated as continuous, unless otherwise specified)
LotF <- as.factor(as.character(IGFs$Lot))

boxplot(IGFs$conc~LotF)
aggregate(IGFs$conc, by=list(factor(LotF)), FUN=mean)
#Lot      mean
#  1  5.295357
# 10  5.696667
#  2  5.146552
#  3  5.501818
#  4  5.166667
#  5  5.138710
#  6  5.140000
#  7  5.222162
#  8  5.622500
#  9  5.228710

#no clear trends

###*******************###
####6.2 Linear models####

#No packages needed to run linear models, basic function included in base R
#Linear models should have no repeated measures - i.e. only one data point per sample
#Composition of the models should basically follow this formula:
#UniqueModelName <- lm(ResponseVariable ~ co-variate/fixed effect, data = Dataset)

###**********************###
####6.2.1 Compare models####
#First we need to run a null model, to show that our models have a significant difference
#from baseline; i.e., that their residual slopes are significantly different from 0 
#and that there is an improvement in model fit compared to the null model.
##null model: all residual parameters equal 0 (i.e. baseline for response variable)

#Null model:
IGFM0 <- lm(conc ~ 1, data = IGFs)

#Then run any models you would like to compare for model fit:
IGFM1 <- lm(conc ~ age, data = IGFs)
IGFM2 <- lm(conc ~ age + LotF, data = IGFs)
IGFM3 <- lm(conc ~ age * LotF, data = IGFs)

#compare model fit with an ANOVA table
anova(IGFM0, IGFM1, IGFM2, IGFM3)

#Model 1: conc ~ 1
#Model 2: conc ~ age
#Model 3: conc ~ age + Lot
#Model 4: conc ~ age * Lot
#  Res.Df    RSS Df Sum of Sq      F  Pr(>F)
#1    230 62.706                              
#2    229 61.952  1    0.7539 2.8912 0.09054 .
#3    220 56.679  9    5.2732 2.2469 0.02036 *
#4    211 55.023  9    1.6559 0.7055 0.70348  

#Putting the null model first in the list makes this the comparison model.
#Looking at the p-values you can see that model 3 has a significant difference to null model
#This signifies that model may show significant relationships

###***********************###
####6.2.2 Model residuals####
#Always check that the residuals of your model fit a linear distribution, 
#otherwise model selection is moot and you will either need to transform your data,
#and re-check models or, if that is not possible, use a model type that is non-linear.

###Extract residuals into an object
rIGFM2 <- resid(IGFM2) 

#View residuals histogram
par(mfrow = c(1, 1))
hist(rIGFM2)

#View residuals QQplot
qqPlot(rIGFM2) 
#some minor tail-end deviance

#Kolmogorov-Smirnoff test:
ks.test(rIGFM2, "pnorm", mean(rIGFM2), sd(rIGFM2))
#OUTPUT: D = 0.060867, p-value = 0.359
#P-value >0.05, so model is robust

#Model residuals fit a normal distribution
#When residuals are not normal, data should be transformed, particularly the response variable.

#In this case, outliers were removed to achieve this as data transformation was not possible, 
#but outliers should not be dropped unless there is statistical, biological or methodological 
#justification for doing so.
#Additionally, dropping outliers should be disclosed in any resulting manuscript,
#with the justification explained.

###*************************###
####6.2.3 Best model output####

#You would only do this step if your model residuals are robust
#If you have two competing models which have a p-value (<0.05) that are close together,
#you can justify selecting the most parsimonious model (the one with fewest included
#variables), particularly if choosing the most parsimonious model removes only variables
#that are non-significant in the summary table model output (shown below)

#Check the model output (the one with the significant p-value):
summary(IGFM2)
#lm(formula = conc ~ age + Lot, data = IGF)
#Residuals:
#     Min       1Q   Median       3Q      Max 
#-2.03160 -0.25242  0.03373  0.29766  1.38386 

#Coefficients:
#             Estimate Std. Error t value Pr(>|t|)    
#(Intercept)  5.397317   0.066303  81.404   <2e-16 ***
#age         -0.004517   0.002718  -1.662   0.0979 .  
#LotF10       0.320648   0.233440   1.374   0.1710    
#LotF2       -0.160076   0.134651  -1.189   0.2358    
#LotF3        0.222095   0.130754   1.699   0.0908 .  
#LotF4       -0.176227   0.144061  -1.223   0.2225    
#LotF5       -0.159864   0.132346  -1.208   0.2284    
#LotF6       -0.256346   0.278029  -0.922   0.3575    
#LotF7       -0.072611   0.127138  -0.571   0.5685    
#LotF8        0.235189   0.210868   1.115   0.2659    
#LotF9       -0.078606   0.132527  -0.593   0.5537  

#Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

#Residual standard error: 0.5076 on 220 degrees of freedom
#Multiple R-squared:  0.09612,	Adjusted R-squared:  0.05503 
#F-statistic: 2.339 on 10 and 220 DF,  p-value: 0.01219

##No p-values are significant; however the relationship between concentration and age
##and concentration and Lot 3 are borderline significant
##this may indicate a trend 
##t-value shows a negative relationship between concentration and age
##t-value shows a positive relationship between concentration and Lot 3
#Keep in mind this is in comparison to the reference group, in this case Lot 1
#When naming groups, it is easiest to put the control group as the first in the order
#as this will then be the comparison group

#Can also look at sample size to see if that may be contributing to significance
aggregate(IGFs$conc, by=list(factor(IGFs$Lot)), FUN = length)
#Lot      n
#  9     31
#  6      4
#  1     28
# 10      6
#  2     29
#  8      8
#  5     31
#  4     24
#  3     33
#  7     37

##Lots 6, 8 and 10 have a very low sample size which is why, despite lots 8 & 10 
##having a similar mean to Lot 3, they were not deemed different to the mean of Lot 1

#Can produce confidence intervals for the model relationships:
#(confidence intervals at a 95% CI level give a range that the mean should fall into, 
#i.e. if the experiment is repeated 100 times, 95 of these times the mean will fall 
#within this confidence interval. Sometimes preferred to be reported instead of standard error.
#The smaller the CI, the more robust/certain the model is.)
confint(IGFM2)
#                   2.5 %      97.5 %
#(Intercept)  5.177127312 5.6426661960
#age         -0.009872885 0.0008387745
#LotF10      -0.139417770 0.7807134217
#LotF2       -0.425446399 0.1052947888
#LotF3       -0.035595235 0.4797847199
#LotF4       -0.460143387 0.1076891799
#LotF5       -0.420691760 0.1009647097
#LotF6       -0.804286423 0.2915952462
#LotF7       -0.323175784 0.1779543267
#LotF8       -0.180391621 0.6507686641
#LotF9       -0.339791744 0.1825793190

###****************************###
####6.2.3 Reporting best model####
##If the model residuals are robust you can report the best model from your ANOVA table
#noting residuals have been checked and how (e.g. histograms, qqplot & Kolmogorov-Smirnoff test)

#Include the table showing model selection
#Include the table of best model with p-values for each co-variate/fixed effect in the model
#Can report CI if you prefer to se, or complimentary to se in output table

###************************###
####7. Mixed effect models####

#A good paper to read on the topic of mixed effect models and model selection
#using AIC and AICc is:
#A brief guide to model selection, multimodel inference and model averaging in
#behavioural ecology using Akaike's information criterion
#Author(s): Matthew R. E. Symonds and Adnan Moussalli
#Source: Behavioral Ecology and Sociobiology, January 2011, Vol. 65, No. 1, pp. 13-21
#URL: http://www.jstor.com/stable/41413993
#DOI: 10.1007/s00265-010-1037-6

#This resource is the one I refer to when providing information, commentary and recommendations 
#for model selection, etc. below.

#NOTE: For AIC selection, the dataset must have a sample size of at least 40 for each variable 
#that is included in the most complex model. 
#To be clear, sample size is at the unit of replication level, and NOT overall sample size!!
#i.e. repeated measures do not count toward sample size.

###*********************************************###
####7.1 Mixed effect models: data exploration####

###******************************###
####7.1.1 Histograms/ boxplots####
#As with linear models, it is important that the model residuals follow a normal distribution
#Check if response variable and co-variates fit normal distribution

#Response variable:
hist(Quinidine$glyco)
boxplot(Quinidine$glyco)
#from histogram there appears to be some non-normal distribution 
#boxplot shows positive outliers
#will require transformation

#Some tips on how best to transform data depending on current distribution:
#https://www.statisticssolutions.com/wp-content/uploads/2018/12/b2.png

trglyco <- (log10(Quinidine$glyco))
hist(trglyco)
#much better distribution
#import values into new column of data set
Quinidine <- data.frame(Quinidine, trglyco)

#Delete variables with too many NAs
#Produce subset dataset
QuinidineS <- Quinidine
QuinidineS$conc <- NULL
QuinidineS$interval <- NULL

#Delete rows with NA in other variables
QuinidineS2 <- na.omit(QuinidineS)

#continuous variables:
hist(QuinidineS2$dose)
boxplot(QuinidineS2$dose)
#quite skewed, many large outliers

hist(QuinidineS2$Age)
boxplot(QuinidineS2$Age)
#mostly normal, no outliers

hist(QuinidineS2$Height)
boxplot(QuinidineS2$Height)
#some skew, no outliers

###********************************###
####7.1.2 Scatterplots/ boxplots####

#Draw pairwise plots to look at relationships of continuous variables
#First create subset with only continuous variables:
QuinidineS3 <- QuinidineS2
QuinidineS3$Subject <- NULL
QuinidineS3$Race <- NULL
QuinidineS3$Smoke <- NULL
QuinidineS3$Ethanol <- NULL
QuinidineS3$Heart <- NULL
QuinidineS3$Creatinine <- NULL
QuinidineS3$glyco <- NULL
pairs(QuinidineS3)

#No variables clearly related to logglyco
#Height and weight appear correlated, but not enough to have collinearity
#If co-variates show collinearity, they cannot be used within the same model
#This can be quantified by the variance inflation factor (VIF) being larger than 5
#The VIF is calculated by the equation: 1/(1 - R-squared)
#so for above dataset calculate the r-squared for the height~weight relationship:
HW <- lm(Height ~ Weight, data = QuinidineS2)
summary(HW)
#Multiple R-squared = 0.09035
#VIF = 1/(1-0.09035)
#1.099324
#This value is under 5, therefore the variables are not collinear 
#and can be used within the same model

#boxplots for categorical variables

#Race:
boxplot(trglyco ~ Race, varwidth = TRUE, xlab = "Race", 
        main = "log glyco concentrations by subject race", 
        ylab = "log glyco concentration (ng/Ml)", data = QuinidineS2)
aggregate(QuinidineS2$trglyco, by=list(QuinidineS2$Race), FUN=mean)
#     Race       mean
#Caucasian 0.07088691
#Latin     0.07252090
#Black     0.12908026

boxplot(trglyco ~ Smoke, varwidth = TRUE, xlab = "Smoking history", 
        main = "log glyco concentrations by subject smoking history", 
        ylab = "log glyco concentration (ng/Ml)", data = QuinidineS2)
aggregate(QuinidineS2$trglyco, by=list(QuinidineS2$Smoke), FUN=mean)
#Smoker?       mean
#     no 0.08558520
#    yes 0.05412061

boxplot(trglyco ~ Ethanol, varwidth = TRUE, xlab = "Drinking history", 
        main = "log glyco concentrations by drinking history", 
        ylab = "log glyco concentration (ng/Ml)", data = QuinidineS2)
aggregate(QuinidineS2$trglyco, by=list(QuinidineS2$Ethanol), FUN=mean)
#Alcoholism?        mean
#      none  0.096864807
#   current -0.003336329
#    former  0.058960690

boxplot(trglyco ~ Heart, varwidth = TRUE, xlab = "Heart condition", 
        main = "log glyco concentrations by heart condition", 
        ylab = "log glyco concentration (ng/Ml)", data = QuinidineS2)
aggregate(QuinidineS2$trglyco, by=list(QuinidineS2$Heart), FUN=mean)
#Heart condition?       mean
#        No/Mild  0.07780702
#       Moderate  0.03570353
#         Severe  0.10570724

boxplot(trglyco ~ Creatinine, varwidth = TRUE, xlab = "Creatinine concentration (ng/mL range)", 
        main = "log glyco concentrations by creatinine concentration", 
        ylab = "log glyco concentration (ng/Ml)", data = QuinidineS2)
aggregate(QuinidineS2$trglyco, by=list(QuinidineS2$Creatinine), FUN=mean)
#Creatinine concentration         mean
#1                   < 50   0.12577882
#2                  >= 50   0.05773698

###************************************************************###
####7.2 Mixed effect models with AIC model selection: models####

###***************************###
####7.2.1 Model comparisons####

#School has repeated measurements

#mixed effect models have the basic structure of:
#ModelName <- lme(ResponseVariable ~ Co-variate/FixedFactor, random = ~1 | RandomFactor, 
#data = Dataset, method = "ML")

#Co-variates/FixedFactors can be separated by + (or * where an interaction is suspected)

#Note:
#In a multilevel model, random factors must be nested like this: RandomFactor/NestedFactor
#This must be hierarchical, in order of (e.g.): unit of replication -> pseudoreplicate
#e.g. family -> individual 
#where offspring (pseudoreplicates) from a family (unit of replication) 
#have repeated measurements taken from them (e.g blood/ tissue samples)
#There must be at least 2 data points taken from each level to include it as a random factor
#Also, this can be many levels, as long as model df can support the analysis 
#(if df cannot support, there will error warnings returned, e.g. singularity error)

#Dataset QuinidineS2 (where NAs have been removed):
#Our random factor (repeated measure) is the individual patient "Subject"
#Set Subject as a factor, as it is in numerical format:
SubjectF <- as.factor(as.character(QuinidineS2$Subject))

#First compose the null model:
Q0 <- lme(trglyco ~ 1, random = ~1 | SubjectF, data = QuinidineS2, method = "ML")

#Models must be run under the ML method (maximum likelihood) for the AIC comparison.
#ML is necessary because comparisons using REML are not valid when the fixed effects change.
#Default for lme is REML which is better for estimating the model variances (calculating p-values).
#Here is a resource that explains the difference between ML and REML:
#https://towardsdatascience.com/maximum-likelihood-ml-vs-reml-78cf79bef2cf

#This is where it can get contentious about which method to use for model selection
#particularly where there are a lot of co-variates/fixed factors to test
#Unless you can test every possible model combination, you will never know which
#model is truly the best. Sometimes this is achievable (if few variables), but when you have 5+
#this can be hundreds to millions of model possibilities (e.g. 5! = 120 -> 10! = 3628800)
#In this case we have 10 variables we might want to test, so that is too many models

#Unfortunately, there are a lot of papers written on how model selection methods are faulty,
#but none that provide any real, definitive answer on the best way to select models.

#Generally, I use the "drop one" method if I have enough statistical power 
#(i.e. a lot of data points and not many random factors).
#This means starting off with a full model (include all co-variates/ fixed factors)
#and then dropping variables that are least likely to improve the model fit.

#But what is the best way to choose which variable to drop?
#Some recommend thinking of the biological relevance, some argue to look at the graphical trends
#I prefer to drop each variable from the model in groups, and compare the AIC
#e.g. in a full model with 6 variables, I will drop each variable from the full model
#and compare 6 model AICs at that round. The next round I will repeat, and have 5 models to compare.
#This reduces the chance of researcher bias, which may influence model selection
#as I am using the AIC to inform my decision, not personal choice of what I think should stay in

#Run full model:
Q1 <- lme(trglyco ~ time + dose + Age + Height + Weight + Race + Smoke + Ethanol + Heart + Creatinine, 
          random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
##NOTE: you might also want to put an interaction effect between height & weight, 
##for example if this is a measure of obesity, or convert the values to BMI
##and use BMI in the model instead

#Compare null and full models:
anova(Q0, Q1)
#   Model df       AIC       BIC   logLik   Test  L.Ratio p-value
#Q0     1  3 -2320.682 -2305.876 1163.341                        
#Q1     2 16 -2321.362 -2242.396 1176.681 1 vs 2 26.67948  0.0138

#full model has lower AIC than the null model
#(The smaller the AIC, the better the model fit, even when negative. 
#Some misunderstand best AIC being closer to 0, but this is not true.)
#At this stage the full model AIC being higher than null model is not concerning, 
#but if your best model has a higher AIC than null model, that shows it isn't a robust model
#to explain your response variable

###IMPORTANT!!
#However, because this dataset does not meet the assumption of comparing model fit by AIC
#As the sample size, per variable included in the full model (10 variables) is not >40
#as there are only 136 subjects.

#Therefore we need to run the model comparison using AICc (AIC corrected for small sample size)
#(AICc requires MuMIn package)
AICc(Q0, Q1)
#   df      AICc
#Q0  3 -2320.659
#Q1 16 -2320.824
#Slightly different AICc with smaller margins, but same consensus
#Full model is better than null model

#Drop one from the full model:
Q2 <- lme(trglyco ~ time + dose + Age + Height + Weight + Race + Smoke + Ethanol + Heart, 
          random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q3 <- lme(trglyco ~ time + dose + Age + Height + Weight + Race + Smoke + Ethanol + Creatinine, 
          random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q4 <- lme(trglyco ~ time + dose + Age + Height + Weight + Race + Smoke + Heart + Creatinine, 
          random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q5 <- lme(trglyco ~ time + dose + Age + Height + Weight + Race + Ethanol + Heart + Creatinine, 
          random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q6 <- lme(trglyco ~ time + dose + Age + Height + Weight + Smoke + Ethanol + Heart + Creatinine, 
          random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q7 <- lme(trglyco ~ time + dose + Age + Height + Race + Smoke + Ethanol + Heart + Creatinine, 
          random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q8 <- lme(trglyco ~ time + dose + Age + Weight + Race + Smoke + Ethanol + Heart + Creatinine, 
          random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q9 <- lme(trglyco ~ time + dose + Height + Weight + Race + Smoke + Ethanol + Heart + Creatinine, 
          random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q10 <- lme(trglyco ~ time + Age + Height + Weight + Race + Smoke + Ethanol + Heart + Creatinine, 
          random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q11 <- lme(trglyco ~ dose + Age + Height + Weight + Race + Smoke + Ethanol + Heart + Creatinine, 
          random = ~1 | SubjectF, data = QuinidineS2, method = "ML")

#Compare AICc values to the full model
AICc(Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11)
#    df      AICc
#Q0   3 -2320.659
#Q1  16 -2320.824
#Q2  15 -2322.013
#Q3  14 -2322.121
#Q4  14 -2323.893
#Q5  15 -2319.899
#Q6  14 -2324.208
#Q7  15 -2322.033
#Q8  15 -2321.498
#Q9  15 -2320.819
#Q10 15 -2320.963
#Q11 15 -2317.316

#Model Q6 has lowest AICc compared to full model

#Drop 1 variable from model Q6
Q12 <- lme(trglyco ~ time + dose + Age + Height + Weight + Smoke + Ethanol + Heart, 
          random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q13 <- lme(trglyco ~ time + dose + Age + Height + Weight + Smoke + Ethanol + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q14 <- lme(trglyco ~ time + dose + Age + Height + Weight + Smoke + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q15 <- lme(trglyco ~ time + dose + Age + Height + Weight + Ethanol + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q16 <- lme(trglyco ~ time + dose + Age + Height + Smoke + Ethanol + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q17 <- lme(trglyco ~ time + dose + Age + Weight + Smoke + Ethanol + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q18 <- lme(trglyco ~ time + dose + Height + Weight + Smoke + Ethanol + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q19 <- lme(trglyco ~ time + Age + Height + Weight + Smoke + Ethanol + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q20 <- lme(trglyco ~ dose + Age + Height + Weight + Smoke + Ethanol + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")

#Compare model AICc
AICc(Q6, Q12, Q13, Q14, Q15, Q16, Q17, Q18, Q19, Q20)
#    df      AICc
#Q6  14 -2324.208
#Q12 13 -2325.410
#Q13 12 -2325.354
#Q14 12 -2327.082
#Q15 13 -2323.409
#Q16 13 -2325.525
#Q17 13 -2323.739
#Q18 13 -2323.585
#Q19 13 -2324.349
#Q20 13 -2320.730

#Q14 has the lowest AICc 

#Drop 1 variable from Q14:
Q21 <- lme(trglyco ~ time + dose + Age + Height + Weight + Smoke + Heart, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q22 <- lme(trglyco ~ time + dose + Age + Height + Weight + Smoke + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q23 <- lme(trglyco ~ time + dose + Age + Height + Weight + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q24 <- lme(trglyco ~ time + dose + Age + Height + Smoke + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q25 <- lme(trglyco ~ time + dose + Age + Weight + Smoke + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q26 <- lme(trglyco ~ time + dose + Height + Weight + Smoke + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q27 <- lme(trglyco ~ time + Age + Height + Weight + Smoke + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q28 <- lme(trglyco ~ dose + Age + Height + Weight + Smoke + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")

#Compare model AICc
AICc(Q14, Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28)
#    df      AICc
#Q14 12 -2327.082
#Q21 11 -2328.280
#Q22 10 -2328.145
#Q23 11 -2326.238
#Q24 11 -2328.460
#Q25 11 -2326.726
#Q26 11 -2325.696
#Q27 11 -2327.153
#Q28 11 -2323.753

#Q24 has lowest AICc

#Drop one from Q24:
Q29 <- lme(trglyco ~ time + dose + Age + Height + Smoke + Heart, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q30 <- lme(trglyco ~ time + dose + Age + Height + Smoke + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q31 <- lme(trglyco ~ time + dose + Age + Height + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q32 <- lme(trglyco ~ time + dose + Age + Smoke + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q33 <- lme(trglyco ~ time + dose + Height + Smoke + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q34 <- lme(trglyco ~ time + Age + Height + Smoke + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q35 <- lme(trglyco ~ dose + Age + Height + Smoke + Heart + Creatinine, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")

#Compare model AICc
AICc(Q24, Q29, Q30, Q31, Q32, Q33, Q34, Q35)
#    df      AICc
#Q24 11 -2328.460
#Q29 10 -2329.489
#Q30  9 -2329.358
#Q31 10 -2327.941
#Q32 10 -2328.435
#Q33 10 -2326.241
#Q34 10 -2328.650
#Q35 10 -2324.243

#Q29 has the lowest AICc

#Drop one from Q29:
Q36 <- lme(trglyco ~ time + dose + Age + Height + Smoke, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q37 <- lme(trglyco ~ time + dose + Age + Height + Heart, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q38 <- lme(trglyco ~ time + dose + Age + Smoke + Heart, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q39 <- lme(trglyco ~ time + dose + Height + Smoke + Heart, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q40 <- lme(trglyco ~ time + Age + Height + Smoke + Heart, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q41 <- lme(trglyco ~ dose + Age + Height + Smoke + Heart, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")

#Compare model AICc
AICc(Q29, Q36, Q37, Q38, Q39, Q40, Q41)
#    df      AICc
#Q29 10 -2329.489
#Q36  8 -2330.237
#Q37  9 -2328.668
#Q38  9 -2329.623
#Q39  9 -2326.824
#Q40  9 -2329.780
#Q41  9 -2325.911

#Q36 has the lowest AICc

#Drop one from Q36
Q42 <- lme(trglyco ~ time + dose + Age + Height, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q43 <- lme(trglyco ~ time + dose + Age + Smoke, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q44 <- lme(trglyco ~ time + dose + Height + Smoke, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q45 <- lme(trglyco ~ time + Age + Height + Smoke, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q46 <- lme(trglyco ~ dose + Age + Height + Smoke, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")

#Compare model AICc
AICc(Q36, Q42, Q43, Q44, Q45, Q46)
#    df      AICc
#Q36  8 -2330.237
#Q42  7 -2329.693
#Q43  7 -2330.951
#Q44  7 -2328.334
#Q45  7 -2330.513
#Q46  7 -2324.087

#Q43 has the lowest AICc

#Drop one from Q43
Q47 <- lme(trglyco ~ time + dose + Age, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q48 <- lme(trglyco ~ time + dose + Smoke, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q49 <- lme(trglyco ~ time + Age + Smoke, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q50 <- lme(trglyco ~ dose + Age + Smoke, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")

#Compare model AICc
AICc(Q43, Q47, Q48, Q49, Q50)
#    df      AICc
#Q43  7 -616.1806
#Q47  6 -615.7380
#Q48  6 -614.8766
#Q49  6 -616.4703
#Q50  6 -610.0317

#Q49 has the lowest AICc

#Drop one from Q49
Q51 <- lme(trglyco ~ time + Age, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q52 <- lme(trglyco ~ time + Smoke, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")
Q53 <- lme(trglyco ~ Age + Smoke, 
           random = ~1 | SubjectF, data = QuinidineS2, method = "ML")

#Compare model AICc
AICc(Q49, Q51, Q52, Q53)
#    df      AICc
#Q49  6 -2331.241
#Q51  5 -2330.675
#Q52  5 -2330.052
#Q53  5 -2323.865
#No model fit improvement

#Q49 appears to be the best-fitting model

###*************************###
####7.2.2 Model residuals####

##Look at the best fitting model's residuals to ensure model is robust.

#First, run the model under REML method
Q49P <- lme(trglyco ~ time + Age + Smoke,
            random = ~1 | SubjectF, data = QuinidineS2, method = "REML")

###Place residuals into object
rQ49P <- resid(Q49P)

#View residuals histogram
par(mfrow = c(1, 1))
hist(rQ49P)
#residual histogram looks fairly normally distributed

#View residuals QQplot
qqPlot(rQ49P)
#some tail-end deviance

#Kolmogorov-Smirnoff test
ks.test(rQ49P, "pnorm", mean(rQ49P), sd(rQ49P))
#OUTPUT: D = 0.13038, p-value = 1.332e-15
#P-value <0.05, so model is not robust

##Would need to go back and transform variables for normality, etc.
#Or if that has been done, it is likely that the model does not fit linear model type
#and will have to fit a different model

#for the purposes of this exercise, will treat data as though model residuals are normal
#to show how to calculate model weights and present model output

###***************************###
####7.2.3 Best model output####

##NOTE: This is only for example purposes, would not report this if residuals were not robust!!
###Summary of model of best fit run under REML method:
summary(Q49P)
#Fixed effects:  trglyco ~ time + Age + Smoke 
#                  Value  Std.Error  DF   t-value p-value
#(Intercept) -0.11486396 0.10046045 889 -1.143375  0.2532
#time         0.00001016 0.00000331 889  3.067063  0.0022
#Age          0.00264235 0.00147840 889  1.787303  0.0742
#Smokeyes    -0.02926957 0.01808996 889 -1.618001  0.1060

#Produce AICc tables with model weights

#Compare AICcs of all models that were run (place in object)
QAICc <- AICc(Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9,
              Q10, Q11, Q12, Q13, Q14, Q15, Q16, Q17, Q18, Q19,
              Q20, Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28, Q29,
              Q30, Q31, Q32, Q33, Q34, Q35, Q36, Q37, Q38, Q39,
              Q40, Q41, Q42, Q43, Q44, Q45, Q46, Q47, Q48, Q49,
              Q50, Q51, Q52, Q53)

QAICc

#Compute AICc weights
Weights(QAICc)
#Double-check that calculated weights equal 1
sum(Weights(QAICc))

#Transfer both the AICc and weights to a spreadsheet and sort by AICc value (smallest - largest)
#Calculate delta AICc (difference in lowest AICc and all other AICc) in new column

#Any models that have a delta AICc that is lower than 2 (some say 6, but 2 is justifiable)
#can be considered top competing models, and may be expected to be reported.
#Can justify only reporting most parsimonious model (one with fewest included variables) if its
#delta AICc is under 2 (or 6, whichever cut-off is being used/justified)
#particularly if this model excludes only non-significant variables.
#Model weights can be interpreted similarly to r-squared values, whereby converted to a %
#they convey how much variance in the response variable that the model explains.
#Very low model weights are not very meaningful, and the reported model should have a much
#better weight than any other model (or comparable to top model, if parsimonious)

#In this case we can report model Q51, as it is more parsimonious, has a delta AICc less than 2,
#has a comparable model weight, and only excludes a non-significant variable.
#Run under REML method:
Q51P <- lme(trglyco ~ time + Age,
            random = ~1 | SubjectF, data = QuinidineS2, method = "REML")

###Place residuals into object
rQ51P <- resid(Q51P)

#View residuals histogram
par(mfrow = c(1, 1))
hist(rQ51P)
#residual histogram looks fairly normally distributed

#View residuals QQplot
qqPlot(rQ51P)
#Tail-end deviance

#Kolmogorov-Smirnoff test
ks.test(rQ51P, "pnorm", mean(rQ51P), sd(rQ51P))
#OUTPUT: D = 0.13016, p-value = 1.443e-15
#P-value <0.05, so model is NOT robust

##NOTE: This is only for example purposes, would not report this if residuals were not robust!!
###Summary of model of best fit run under REML method:
summary(Q51P)
#Fixed effects:  trglyco ~ time + Age 
#                  Value  Std.Error  DF   t-value p-value
#(Intercept) -0.14128121 0.09854308 890 -1.433700  0.1520
#time         0.00001042 0.00000332 890  3.143896  0.0017
#Age          0.00289817 0.00146133 890  1.983238  0.0476

#Removing the non-significant variable now provides a different model output
#where subject age is also a significant factor alongside time of dose

##NOTE: the model weights calculated for this model set are very low. 
#This is likely because the model residuals are not robust and the data likely should not 
#be investigated using a linear mixed-effect model (Gaussian).
#This is intended as an example exercise, so ignore the issues, and take only the theory.

###*************************###
###Reporting model selection###
#Model selection tables should be reported alongside the manuscript, either in the main manuscript 
#(in addition to to statistical methods section), or within a supplementary document/appendix.
#To report model selection, all tested models can be included in a supplementary document
#But in the main manuscript you can include a truncated table which includes top models
#with delta AIC less than 2 (or 6...), or the top 95% confidence set of models.
#May include the null model in the reported table, particularly to appease reviewer "curiosity"
#See Symonds & Moussali (2011) for examples, and more info using delta AICc and model weights.

