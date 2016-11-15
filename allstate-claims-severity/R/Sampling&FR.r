###### Libraries

library(C50)
library(neuralnet)
library(varhandle)
library(rpart)
library(caret)
library(doMC)

###### Read data

original_data <- read.csv("datasets/train.csv", row.names=1)
# original_data <- as.data.frame(original_data)

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
clean_train <- rand_data[1:178731, ]
clean_test <- rand_data[178732:188138, ]
max_val <- max(rand_data$loss)
min_val <- min(rand_data$loss)

# pre-process
unprocessed_dt = rand_data
unprocessed_dt$loss <- round(unprocessed_dt$loss, -2)
unprocessed_dt$loss <- factor(unprocessed_dt$loss)
dt_train <- unprocessed_dt[1:178731, ]
dt_test <- unprocessed_dt[178732:188138, ]

# feature reduction

dt_model <- C5.0(dt_train[-131], dt_train$loss)
# use the final table in the model summary to select features
summary(dt_model)
# Original MAE Obtained for the practical test: 1696.467

columns <- c("cat57","cat116", "cat80", "cat112", "cat12", "cat81", "cat103", 
             "cat111", "cat101", "cat53", "cat100", "cat79", "cat114", "cat26", "cat77",
             "cat110", "cat83", "cat4", "cat82","loss")

unprocessed_dt = rand_data
unprocessed_dt <- subset(unprocessed_dt, select = columns)
unprocessed_dt$loss <- normalize(unprocessed_dt$loss)
unprocessed_dt[1:19] <- apply(unprocessed_dt[1:19], 2, convertFactorToNormalized)
dt_train <- unprocessed_dt[1:178731, ]
dt_test <- unprocessed_dt[178732:188138, ]

#sampling

train_noreplace <- dt_train[sample(1:nrow(dt_train), 20000,replace=FALSE),]
train_replace <- dt_train[sample(1:nrow(dt_train), 20000,replace=TRUE),]

#final model

model1 <- train(loss ~ ., data = train_noreplace,
                   method = "parRF",
                   trControl = trainControl(method = "cv"))
dt_pred1 <- predict(model1, dt_test)
inflated_loss <- inflate(min_val, max_val, dt_pred1)
MAE(inflated_loss, clean_test$loss)
## MAE Obtained: 1375.433

model2 <- train(loss ~ ., data = train_replace,
                method = "parRF",
                trControl = trainControl(method = "cv"))
dt_pred2 <- predict(model2, dt_test)
inflated_loss2 <- inflate(min_val, max_val, dt_pred2)
MAE(inflated_loss2, clean_test$loss)
## MAE Obtained: 1392.616
