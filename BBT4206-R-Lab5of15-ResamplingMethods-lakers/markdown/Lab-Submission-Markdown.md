Business Intelligence Lab Submission Markdown
================
<Specify your group name here>
<Specify the date when you submitted the lab>

- [Student Details](#student-details)
- [Setup Chunk](#setup-chunk)
- [Load dataset](#load-dataset)
  - [Split dataset](#split-dataset)
- [Bootstrapping train control](#bootstrapping-train-control)
  - [Binary Classification: Logistic Regression with 10-fold
    cross-validation](#binary-classification-logistic-regression-with-10-fold-cross-validation)
  - [LDA classifier based on a 5-fold
    cross-validation](#lda-classifier-based-on-a-5-fold-cross-validation)

# Student Details

|                                                                                                                                                                                                                                   |                                                              |     |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|-----|
| **Student ID Numbers and Names of Group Members** \| \| \| 1. 134780 - C - Trevor Okinda \| \| \| \| 2. 132840 - C - Sheila Wangui \| \| \| \| 3. 131749 - C - Teresia Nungari \| \| \| 4. 135203 - C - Tom Arnold \| \| \| \| \| |                                                              |     |
| **GitHub Classroom Group Name**                                                                                                                                                                                                   | Lakers                                                       |     |
| **Course Code**                                                                                                                                                                                                                   | BBT4206                                                      |     |
| **Course Name**                                                                                                                                                                                                                   | Business Intelligence II                                     |     |
| **Program**                                                                                                                                                                                                                       | Bachelor of Business Information Technology                  |     |
| **Semester Duration**                                                                                                                                                                                                             | 21<sup>st</sup> August 2023 to 28<sup>th</sup> November 2023 |     |

# Setup Chunk

We start by installing all the required packages

``` r
## mlbench ----
if (require("mlbench")) {
  require("mlbench")
} else {
  install.packages("mlbench", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## klaR ----
if (require("klaR")) {
  require("klaR")
} else {
  install.packages("klaR", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## e1071 ----
if (require("e1071")) {
  require("e1071")
} else {
  install.packages("e1071", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## readr ----
if (require("readr")) {
  require("readr")
} else {
  install.packages("readr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## LiblineaR ----
if (require("LiblineaR")) {
  require("LiblineaR")
} else {
  install.packages("LiblineaR", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## naivebayes ----
if (require("naivebayes")) {
  require("naivebayes")
} else {
  install.packages("naivebayes", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

------------------------------------------------------------------------

**Note:** the following “*KnitR*” options have been set as the defaults
in this markdown:  
`knitr::opts_chunk$set(echo = TRUE, warning = FALSE, eval = TRUE, collapse = FALSE, tidy.opts = list(width.cutoff = 80), tidy = TRUE)`.

More KnitR options are documented here
<https://bookdown.org/yihui/rmarkdown-cookbook/chunk-options.html> and
here <https://yihui.org/knitr/options/>.

``` r
knitr::opts_chunk$set(
    eval = TRUE,
    echo = TRUE,
    warning = FALSE,
    collapse = FALSE,
    tidy = TRUE
)
```

------------------------------------------------------------------------

**Note:** the following “*R Markdown*” options have been set as the
defaults in this markdown:

> output:  
>   
> github_document:  
> toc: yes  
> toc_depth: 4  
> fig_width: 6  
> fig_height: 4  
> df_print: default  
>   
> editor_options:  
> chunk_output_type: console

# Load dataset

Load the PimaIndiansDiabetes dataset and check its structure

``` r
library(mlbench)
data("PimaIndiansDiabetes")
# Check the structure of the dataset
str(PimaIndiansDiabetes)
```

    ## 'data.frame':    768 obs. of  9 variables:
    ##  $ pregnant: num  6 1 8 1 0 5 3 10 2 8 ...
    ##  $ glucose : num  148 85 183 89 137 116 78 115 197 125 ...
    ##  $ pressure: num  72 66 64 66 40 74 50 0 70 96 ...
    ##  $ triceps : num  35 29 0 23 35 0 32 0 45 0 ...
    ##  $ insulin : num  0 0 0 94 168 0 88 0 543 0 ...
    ##  $ mass    : num  33.6 26.6 23.3 28.1 43.1 25.6 31 35.3 30.5 0 ...
    ##  $ pedigree: num  0.627 0.351 0.672 0.167 2.288 ...
    ##  $ age     : num  50 31 32 21 33 30 26 29 53 54 ...
    ##  $ diabetes: Factor w/ 2 levels "neg","pos": 2 1 2 1 2 1 2 1 2 2 ...

## Split dataset

``` r
# Split the dataset into training and testing sets
set.seed(123)  # Set a random seed for reproducibility


# Assuming 'diabetes' is the target variable
inTrain <- createDataPartition(y = PimaIndiansDiabetes$diabetes, p = 0.6, list = FALSE)
training_data <- PimaIndiansDiabetes[inTrain, ]
testing_data <- PimaIndiansDiabetes[-inTrain, ]
```

Next, we create a Naive Bayes classifier using the Pima Indians Diabetes
dataset

``` r
# Create a Naive Bayes classifier using the Pima Indians Diabetes dataset
pima_nb_model <- e1071::naiveBayes(diabetes ~ pregnant + glucose + pressure + triceps +
    insulin + mass + pedigree + age, data = PimaIndiansDiabetes)

# Check the summary of the Naive Bayes model
summary(pima_nb_model)
```

    ##           Length Class  Mode     
    ## apriori   2      table  numeric  
    ## tables    8      -none- list     
    ## levels    2      -none- character
    ## isnumeric 8      -none- logical  
    ## call      4      -none- call

``` r
# Assuming you have already trained the Naive Bayes model (pima_nb_model) and
# have a testing dataset (testing_data)
predictions_nb_caret <- predict(pima_nb_model, newdata = testing_data[, c("pregnant",
    "glucose", "pressure", "triceps", "insulin", "mass", "pedigree", "age")])


# Calculate the confusion matrix
confusion_matrix <- confusionMatrix(predictions_nb_caret, testing_data$diabetes)
print(confusion_matrix)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction neg pos
    ##        neg 164  39
    ##        pos  36  68
    ##                                           
    ##                Accuracy : 0.7557          
    ##                  95% CI : (0.7037, 0.8027)
    ##     No Information Rate : 0.6515          
    ##     P-Value [Acc > NIR] : 5.348e-05       
    ##                                           
    ##                   Kappa : 0.4585          
    ##                                           
    ##  Mcnemar's Test P-Value : 0.8174          
    ##                                           
    ##             Sensitivity : 0.8200          
    ##             Specificity : 0.6355          
    ##          Pos Pred Value : 0.8079          
    ##          Neg Pred Value : 0.6538          
    ##              Prevalence : 0.6515          
    ##          Detection Rate : 0.5342          
    ##    Detection Prevalence : 0.6612          
    ##       Balanced Accuracy : 0.7278          
    ##                                           
    ##        'Positive' Class : neg             
    ## 

``` r
# Create a plot based on the confusion matrix
plot(confusion_matrix$table)
```

![](Lab-Submission-Markdown_files/figure-gfm/Naive%20Bayes%20classifier-1.png)<!-- -->

# Bootstrapping train control

Training a linear regression model (for regression)

``` r
train_control <- trainControl(method = "boot", number = 500)

pima_lm_model <- caret::train(diabetes ~ pregnant + glucose + pressure + triceps +
    insulin + mass + pedigree + age, data = training_data, trControl = train_control,
    na.action = na.omit, method = "glm", metric = "Accuracy")
# Test the trained linear regression model using the testing dataset
predictions_lm <- predict(pima_lm_model, newdata = testing_data[, c("pregnant", "glucose",
    "pressure", "triceps", "insulin", "mass", "pedigree", "age")])


# View the predicted values for the observations
print(predictions_lm)
```

    ##   [1] pos neg pos neg neg pos pos neg neg neg pos neg neg pos neg neg neg pos
    ##  [19] neg pos neg pos neg pos neg pos neg neg neg neg pos neg neg neg neg neg
    ##  [37] pos neg neg neg pos neg pos neg neg neg neg pos pos neg pos neg neg neg
    ##  [55] neg pos pos neg neg neg neg neg pos neg neg pos pos neg neg pos neg neg
    ##  [73] neg neg pos pos neg neg pos neg neg neg neg pos neg neg neg neg pos neg
    ##  [91] pos neg pos pos pos neg neg pos pos pos neg pos pos neg neg pos neg neg
    ## [109] neg pos pos neg neg pos neg neg neg neg pos neg neg neg pos neg neg neg
    ## [127] neg neg neg pos neg pos neg pos neg neg pos pos neg pos neg pos neg neg
    ## [145] neg pos pos neg neg neg neg pos neg pos neg neg pos pos pos neg neg neg
    ## [163] neg pos pos pos neg pos neg neg neg neg pos neg neg neg neg neg neg neg
    ## [181] neg neg neg pos pos neg neg neg neg neg neg neg neg pos pos neg neg neg
    ## [199] pos neg neg neg neg neg neg pos neg neg neg neg neg neg neg neg pos pos
    ## [217] neg neg neg neg neg neg neg neg neg neg neg neg pos neg neg neg pos neg
    ## [235] pos pos neg neg neg neg pos neg neg neg neg neg neg neg neg neg neg neg
    ## [253] neg neg pos pos neg pos pos pos neg neg neg neg neg neg pos neg pos neg
    ## [271] neg pos neg neg neg neg neg neg neg neg pos neg neg neg neg neg neg neg
    ## [289] neg neg neg pos neg pos neg pos pos neg neg pos pos neg pos neg neg neg
    ## [307] neg
    ## Levels: neg pos

## Binary Classification: Logistic Regression with 10-fold cross-validation

``` r
train_control <- trainControl(method = "cv", number = 10, classProbs = TRUE, summaryFunction = twoClassSummary)

pima_lr_model <- caret::train(diabetes ~ ., data = training_data, trControl = train_control,
    na.action = na.omit, method = "glm", family = "binomial", metric = "ROC")

# Test the trained logistic regression model using the testing dataset
predictions_lr <- predict(pima_lr_model, newdata = testing_data[, c("pregnant", "glucose",
    "pressure", "triceps", "insulin", "mass", "pedigree", "age")])

# Print the model and predicted values
print(pima_lr_model)
```

    ## Generalized Linear Model 
    ## 
    ## 461 samples
    ##   8 predictor
    ##   2 classes: 'neg', 'pos' 
    ## 
    ## No pre-processing
    ## Resampling: Cross-Validated (10 fold) 
    ## Summary of sample sizes: 415, 415, 415, 414, 415, 415, ... 
    ## Resampling results:
    ## 
    ##   ROC        Sens       Spec     
    ##   0.8231863  0.8866667  0.5275735

``` r
print(predictions_lr)
```

    ##   [1] pos neg pos neg neg pos pos neg neg neg pos neg neg pos neg neg neg pos
    ##  [19] neg pos neg pos neg pos neg pos neg neg neg neg pos neg neg neg neg neg
    ##  [37] pos neg neg neg pos neg pos neg neg neg neg pos pos neg pos neg neg neg
    ##  [55] neg pos pos neg neg neg neg neg pos neg neg pos pos neg neg pos neg neg
    ##  [73] neg neg pos pos neg neg pos neg neg neg neg pos neg neg neg neg pos neg
    ##  [91] pos neg pos pos pos neg neg pos pos pos neg pos pos neg neg pos neg neg
    ## [109] neg pos pos neg neg pos neg neg neg neg pos neg neg neg pos neg neg neg
    ## [127] neg neg neg pos neg pos neg pos neg neg pos pos neg pos neg pos neg neg
    ## [145] neg pos pos neg neg neg neg pos neg pos neg neg pos pos pos neg neg neg
    ## [163] neg pos pos pos neg pos neg neg neg neg pos neg neg neg neg neg neg neg
    ## [181] neg neg neg pos pos neg neg neg neg neg neg neg neg pos pos neg neg neg
    ## [199] pos neg neg neg neg neg neg pos neg neg neg neg neg neg neg neg pos pos
    ## [217] neg neg neg neg neg neg neg neg neg neg neg neg pos neg neg neg pos neg
    ## [235] pos pos neg neg neg neg pos neg neg neg neg neg neg neg neg neg neg neg
    ## [253] neg neg pos pos neg pos pos pos neg neg neg neg neg neg pos neg pos neg
    ## [271] neg pos neg neg neg neg neg neg neg neg pos neg neg neg neg neg neg neg
    ## [289] neg neg neg pos neg pos neg pos pos neg neg pos pos neg pos neg neg neg
    ## [307] neg
    ## Levels: neg pos

## LDA classifier based on a 5-fold cross-validation

``` r
train_control <- trainControl(method = "cv", number = 5)

pima_lda_model <- caret::train(diabetes ~ ., data = training_data, trControl = train_control,
    na.action = na.omit, method = "lda", metric = "Accuracy")

# Test the trained LDA model using the testing dataset
predictions_lda <- predict(pima_lda_model, newdata = testing_data[, c("pregnant",
    "glucose", "pressure", "triceps", "insulin", "mass", "pedigree", "age")])

# View the summary of the model
print(pima_lda_model)
```

    ## Linear Discriminant Analysis 
    ## 
    ## 461 samples
    ##   8 predictor
    ##   2 classes: 'neg', 'pos' 
    ## 
    ## No pre-processing
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 369, 369, 368, 369, 369 
    ## Resampling results:
    ## 
    ##   Accuracy   Kappa    
    ##   0.7656381  0.4485062

``` r
# View the confusion matrix
confusion_matrix <- confusionMatrix(predictions_lda, testing_data$diabetes)
print(confusion_matrix)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction neg pos
    ##        neg 178  41
    ##        pos  22  66
    ##                                           
    ##                Accuracy : 0.7948          
    ##                  95% CI : (0.7452, 0.8386)
    ##     No Information Rate : 0.6515          
    ##     P-Value [Acc > NIR] : 2.813e-08       
    ##                                           
    ##                   Kappa : 0.5286          
    ##                                           
    ##  Mcnemar's Test P-Value : 0.02334         
    ##                                           
    ##             Sensitivity : 0.8900          
    ##             Specificity : 0.6168          
    ##          Pos Pred Value : 0.8128          
    ##          Neg Pred Value : 0.7500          
    ##              Prevalence : 0.6515          
    ##          Detection Rate : 0.5798          
    ##    Detection Prevalence : 0.7134          
    ##       Balanced Accuracy : 0.7534          
    ##                                           
    ##        'Positive' Class : neg             
    ## 

**etc.** as per the lab submission requirements. Be neat and communicate
in a clear and logical manner.
