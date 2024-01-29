# Load necessary libraries
library(caret)
library(e1071)
library(randomForest)
library(kernlab)
library(rpart)

# Load the Iris dataset (this dataset is included in R)
data(iris)

#Train the models
# Define train control
train_control <- trainControl(method = "repeatedcv", number = 10, repeats = 3)

### LDA ----
set.seed(7)
iris_model_lda <- train(Species ~ ., data = iris,
                        method = "lda", trControl = train_control)
### CART ----
set.seed(7)
iris_model_cart <- train(Species ~ ., data = iris,
                         method = "rpart", trControl = train_control)
### KNN ----
set.seed(7)
iris_model_knn <- train(Species ~ ., data = iris,
                        method = "knn", trControl = train_control)
### SVM ----
set.seed(7)
iris_model_svm <- train(Species ~ ., data = iris,
                        method = "svmRadial", trControl = train_control)
### Random Forest ----
set.seed(7)
iris_model_rf <- train(Species ~ ., data = iris,
                       method = "rf", trControl = train_control)
## Call the `resamples` Function ----
results <- resamples(list(LDA = iris_model_lda, CART = iris_model_cart,
                          KNN = iris_model_knn, SVM = iris_model_svm,
                          RF = iris_model_rf))

## 1. Table Summary ----
summary(results)

## 2. Box and Whisker Plot ----
scales <- list(x = list(relation = "free"), y = list(relation = "free"))
bwplot(results, scales = scales)

## 3. Dot Plots ----
dotplot(results, scales = scales)

## 4. Scatter Plot Matrix ----
splom(results)

## 5. Pairwise xyPlots ----
xyplot(results, models = c("LDA", "SVM"))
xyplot(results, models = c("SVM", "CART"))

## 6. Statistical Significance Tests ----
diffs <- diff(results)

summary(diffs)
