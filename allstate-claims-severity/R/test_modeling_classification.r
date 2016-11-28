###### Libraries

#install.packages(c("varhandle", "caret", "doMC", "devtools", "e1071", "plyr", "xgboost", "fastAdaboost", "adabag", "neuralnet", "randomForest", "rpart", "C50"))
library(C50)
library(neuralnet)
library(varhandle)
library(rpart)
library(caret)
library(doMC)
library(devtools)  ## To download "stratified"
source_gist(6424112, filename = "stratified.R")

###### Read data

original_data <- read.csv("datasets/train.csv", row.names=1)
# kaggle_test_clean <- read.csv("datasets/test.csv", row.names=1)
# kaggle_test_clean$loss <- sample(0, size = nrow(kaggle_test_clean), replace = TRUE)

################ Functions

registerDoMC(cores = 7)

normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

inflate <- function(min, max, x){
  return(x*(max-min) + min)
}

# Convert an array of data into normalized data (min 0 max 1) taking into account the
# Factor levels
convertFactorToNormalized <- function(f){
  return(normalize(as.numeric(factor(f))))
}

MAE <- function(actual, predicted) {
  mean(abs(actual - predicted))
}

# set.seed(1809)

# feature reduction

columns <- c("cat4", "cat12", "cat26", "cat53", "cat57", "cat77", "cat79",
              "cat80", "cat81", "cat82", "cat83","cat100", "cat101", "cat103",
              "cat110", "cat111", "cat112", "cat114","cat116", "loss")

unprocessed <- subset(original_data, select = columns)
unprocessed$loss <- round(unprocessed$loss, -3)
unprocessed$loss <- factor(unprocessed$loss)
train_indexes <- createDataPartition(unprocessed$loss, p = .11,
                                  list = FALSE,
                                  times = 1)

train_classification <- unprocessed[train_indexes,]
test_data <- unprocessed[-train_indexes,]
# Modeling - Classification

# createDataPartition actumatically gets a random sample of the dataset
# and at the same time, tries to preserve the distribution of the data

prediction_model_rf_c <- train(loss ~ ., data = train_classification,
                   method = "parRF",
                   trControl = trainControl(method = "cv"))
pred <- predict(prediction_model_rf_c, test_data[-20])
MAE(pred, test_data$loss)

prediction_model_aboost <- train(loss ~ ., data = train_classification,
                   method = "adaboost",
                   trControl = trainControl(method = "cv"))
pred <- predict(prediction_model_aboost, test_data[-20])
MAE(pred, test_data$loss)

prediction_model_C5 <- train(loss ~ ., data = train_classification,
                   method = "C5.0Tree",
                   trControl = trainControl(method = "cv"))
pred <- predict(prediction_model_C5, test_data[-20])
MAE(pred, clean_test$loss)

# The previous models cannot succeed in its creation, some error about
# accessing the same region of the data by different threads (Multicore issues)

prediction_model_xgb_c <- train(loss ~ ., data = train_classification,
                   method = "xgbTree",
                   trControl = trainControl(method = "cv"))
pred <- predict(prediction_model_xgb_c, test_data[-20])
MAE(pred, test_data$loss)

# This one keeps running for 48 hrs and doesn't converge...
