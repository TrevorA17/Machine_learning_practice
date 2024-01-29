# Install and load the "mlbench" package
install.packages("mlbench")
library(mlbench)
library(caret)
library(e1071)
# Load the Pima Indians Diabetes dataset
data("PimaIndiansDiabetes")

# Check the structure of the dataset
str(PimaIndiansDiabetes)

# Split the dataset into training and testing sets
set.seed(123)  # Set a random seed for reproducibility


# Assuming "diabetes" is the target variable
inTrain <- createDataPartition(y = PimaIndiansDiabetes$diabetes, p = 0.6, list = FALSE)
training_data <- PimaIndiansDiabetes[inTrain, ]
testing_data <- PimaIndiansDiabetes[-inTrain, ]



# Create a Naive Bayes classifier using the Pima Indians Diabetes dataset
pima_nb_model <- e1071::naiveBayes(diabetes ~ pregnant + glucose + pressure + triceps + insulin + mass + pedigree + age, data = PimaIndiansDiabetes)

# Check the summary of the Naive Bayes model
summary(pima_nb_model)

# Assuming you have already trained the Naive Bayes model (pima_nb_model) and have a testing dataset (testing_data)
predictions_nb_caret <- predict(pima_nb_model, newdata = testing_data[, c("pregnant", "glucose", "pressure", "triceps", "insulin", "mass", "pedigree", "age")])


# Calculate the confusion matrix
confusion_matrix <- confusionMatrix(predictions_nb_caret, testing_data$diabetes)
print(confusion_matrix)

# Create a plot based on the confusion matrix
plot(confusion_matrix$table)

## Train a linear regression model (for regression) ----

### Bootstrapping train control
train_control <- trainControl(method = "boot", number = 500)

pima_lm_model <- caret::train(diabetes ~
                                              pregnant + glucose + pressure + triceps + insulin +
                                              mass + pedigree + age,
                                            data = training_data,
                                            trControl = train_control,
                                            na.action = na.omit, method = "glm", metric = "Accuracy")
# Test the trained linear regression model using the testing dataset
predictions_lm <- predict(pima_lm_model, newdata = testing_data[, c("pregnant", "glucose", "pressure", "triceps", "insulin", "mass", "pedigree", "age")])


#View the predicted values for the observations
print(predictions_lm)


# Binary Classification: Logistic Regression with 10-fold cross-validation
train_control <- trainControl(method = "cv", number = 10, classProbs = TRUE, summaryFunction = twoClassSummary)

pima_lr_model <- caret::train(diabetes ~ .,
                              data = training_data,
                              trControl = train_control,
                              na.action = na.omit,
                              method = "glm", 
                              family = "binomial", 
                              metric = "ROC")

# Test the trained logistic regression model using the testing dataset
predictions_lr <- predict(pima_lr_model, newdata = testing_data[, c("pregnant", "glucose", "pressure", "triceps", "insulin", "mass", "pedigree", "age")])

# Print the model and predicted values
print(pima_lr_model)
print(predictions_lr)


# LDA classifier based on a 5-fold cross-validation
train_control <- trainControl(method = "cv", number = 5)

pima_lda_model <- caret::train(diabetes ~ ., data = training_data,
                               trControl = train_control, na.action = na.omit,
                               method = "lda", metric = "Accuracy")

# Test the trained LDA model using the testing dataset
predictions_lda <- predict(pima_lda_model, newdata = testing_data[, c("pregnant", "glucose", "pressure", "triceps", "insulin", "mass", "pedigree", "age")])

# View the summary of the model
print(pima_lda_model)

# View the confusion matrix
confusion_matrix <- confusionMatrix(predictions_lda, testing_data$diabetes)
print(confusion_matrix)

# Train an e1071::naive Bayes classifier based on the diabetes variable
pima_nb_model <-
  e1071::naiveBayes(diabetes ~ ., data = training_data)

# Test the trained naive Bayes classifier using the testing dataset
predictions_nb_e1071 <-
  predict(pima_nb_model, newdata = testing_data[, c("pregnant", "glucose", "pressure", "triceps", "insulin", "mass", "pedigree", "age")])

# View a summary of the naive Bayes model
print(pima_nb_model)

# View the confusion matrix
confusion_matrix <- confusionMatrix(predictions_nb_e1071, testing_data$diabetes)
print(confusion_matrix)

# SVM Classifier using 5-fold cross-validation with 3 reps
train_control <- trainControl(method = "repeatedcv", number = 5, repeats = 3)

pima_svm_model <-
  caret::train(diabetes ~ ., data = training_data,
               trControl = train_control, na.action = na.omit,
               method = "svmLinear", metric = "Accuracy")

# Test the trained SVM model using the testing dataset
predictions_svm <- predict(pima_svm_model, newdata = testing_data[, c("pregnant", "glucose", "pressure", "triceps", "insulin", "mass", "pedigree", "age")])

# View a summary of the model
print(pima_svm_model)

# View the confusion matrix
confusion_matrix <- confusionMatrix(predictions_svm, testing_data$diabetes)
print(confusion_matrix)

# Train a Naive Bayes classifier based on LOOCV
train_control <- trainControl(method = "LOOCV")

pima_nb_loocv_model <- caret::train(diabetes ~ ., data = training_data,
                                    trControl = train_control, na.action = na.omit,
                                    method = "naive_bayes", metric = "Accuracy")

# Test the trained model using the testing dataset
predictions_nb_loocv <- predict(pima_nb_loocv_model, newdata = testing_data[, c("pregnant", "glucose", "pressure", "triceps", "insulin", "mass", "pedigree", "age")])

# View the confusion matrix
confusion_matrix <- confusionMatrix(predictions_nb_loocv, testing_data$diabetes)
print(confusion_matrix)

