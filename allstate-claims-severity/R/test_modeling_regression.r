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
kaggle_test_clean <- read.csv("datasets/test.csv", row.names=1)
kaggle_test_clean$loss <- sample(0, size = nrow(kaggle_test_clean), replace = TRUE)

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

# Reorder, Split on train and test for later comparison
set.seed(1809)
rand_data <- original_data[order(runif(188138)), ]
max_val <- max(rand_data$loss)
min_val <- min(rand_data$loss)

# feature reduction

columns <- c("cat4", "cat12", "cat26", "cat53", "cat57", "cat77", "cat79",
              "cat80", "cat81", "cat82", "cat83","cat100", "cat101", "cat103",
              "cat110", "cat111", "cat112", "cat114","cat116", "loss")

unprocessed = rand_data
unprocessed <- subset(unprocessed, select = columns)
unprocessed[1:19]<- apply(unprocessed[1:19], 2, convertFactorToNormalized)

# createDataPartition actumatically gets a random sample of the dataset
# and at the same time, tries to preserve the distribution of the data
train_set_size <- .2
train_indexes <- createDataPartition(unprocessed$loss, p = train_set_size,
                                  list = FALSE,
                                  times = 1)

train_regression_unorm <- unprocessed[train_indexes,]
test_regression_unorm <- unprocessed[-train_indexes,]

# Regresion data (normalized loss)

unprocessed$loss <- normalize(unprocessed$loss)

train_regression_norm <- unprocessed[train_indexes,]
test_regression_norm <- unprocessed[-train_indexes,]

# Modeling

# prediction_model_rf_r <- train(loss ~ ., data = train_regression_unorm,
#                    method = "parRF",
#                    trControl = trainControl(method = "cv"))
# pred <- predict(prediction_model_rf_r, test_regression_unorm[-20])
# MAE(pred, test_regression_unorm$loss)
# Results Achieved: 1381.199
# Kaggle results: 	1364.98654

prediction_model_rf_rn <- train(loss ~ ., data = train_regression_norm,
                   method = "parRF",
                   trControl = trainControl(method = "cv"))
pred <- predict(prediction_model_rf_rn, test_regression_norm[-20])
inflated_loss <- inflate(min_val, max_val, pred)
MAE(pred, test_regression_unorm$loss)
## Previous results: 1345~~
## Kaggle results: 	1339.52230

prediction_model_nn_r <- train(loss ~ ., data = train_regression_unorm,
                   method = "neuralnet",
                   trControl = trainControl(method = "cv"))
pred <- predict(prediction_model_nn_r, test_regression_unorm[-20])
MAE(pred, test_regression_unorm$loss)
### Obtained results in test: 1964.89049
### Kaggle results: 	1339.52230

# prediction_model_nn_rn <- train(loss ~ ., data = train_regression_norm,
#                    method = "neuralnet",
#                    trControl = trainControl(method = "cv"))
# pred <- predict(prediction_model_nn_rn, test_regression_norm[-20])
# inflated_loss <- inflate(min_val, max_val, pred)
# MAE(inflated_loss, test_regression_unorm$loss)

prediction_model_xgb_r <- train(loss ~ ., data = train_regression_unorm,
                   method = "xgbTree",
                   trControl = trainControl(method = "cv"))
pred <- predict(prediction_model_xgb_r, test_regression_unorm[-20])
MAE(pred, test_regression_unorm$loss)
#### Obtained: 1298.576
#### Kaggle:

# prediction_model_xgb_rn <- train(loss ~ ., data = train_regression_norm,
#                    method = "xgbTree",
#                    trControl = trainControl(method = "cv"))
# pred <- predict(prediction_model_xgb_rn, test_regression_norm[-20])
# inflated_loss <- inflate(min_val, max_val, pred)
# MAE(inflated_loss, test_regression_unorm$loss)

## Process Kaggle Testing data
kaggle_test_clean <- read.csv("datasets/test.csv", row.names=1)
kaggle_test_clean$loss <- sample(0, size = nrow(kaggle_test_clean), replace = TRUE)
train_data2 = rand_data
kaggle_test <- subset(kaggle_test_clean, select = columns)
train_data2 <- subset(train_data2, select = columns)
total <- rbind(train_data2, kaggle_test)
total[1:19] <- apply(total[1:19], 2, convertFactorToNormalized)
kaggle_test <- total[nrow(rand_data)+1:nrow(total), ]
# kaggle_pred <- predict(prediction_model_nn_r, kaggle_test)
# write.csv(inflated_kaggle, file="out-nn-un.txt", quote=FALSE)
# kaggle_pred <- predict(prediction_model_nn_rn, kaggle_test)
# inflated_kaggle <- inflate(min_val, max_val, kaggle_pred)
# write.csv(inflated_kaggle, file="out-nn-n.txt", quote=FALSE)
# kaggle_pred <- predict(prediction_model_xgb_r, kaggle_test)
# write.csv(kaggle_pred, file="out-xgb-un.txt", quote=FALSE)
