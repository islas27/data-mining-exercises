###### Read data

original_data <- read.csv("train.csv", row.names=1)

###### Libraries

library(C50)
library(neuralnet)
library(varhandle)

################ Functions

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

# pre-process for DT
unprocessed_dt = rand_data
unprocessed_dt$loss <- round(unprocessed_dt$loss, -2)
unprocessed_dt$loss <- factor(unprocessed_dt$loss)
dt_train <- unprocessed_dt[1:178731, ]
dt_test <- unprocessed_dt[178732:188138, ]

# pre-process for NN
unprocessed_nn = rand_data
max_val <- max(unprocessed_nn$loss)
min_val <- min(unprocessed_nn$loss)
unprocessed_nn$cat1 <- convertFactorToNormalized(unprocessed_nn$cat1)
unprocessed_nn$cat2 <- convertFactorToNormalized(unprocessed_nn$cat2)
unprocessed_nn$cat3 <- convertFactorToNormalized(unprocessed_nn$cat3)
unprocessed_nn$cat4 <- convertFactorToNormalized(unprocessed_nn$cat4)
unprocessed_nn$cat5 <- convertFactorToNormalized(unprocessed_nn$cat5)
unprocessed_nn$cat6 <- convertFactorToNormalized(unprocessed_nn$cat6)
unprocessed_nn$cat7 <- convertFactorToNormalized(unprocessed_nn$cat7)
unprocessed_nn$cat8 <- convertFactorToNormalized(unprocessed_nn$cat8)
unprocessed_nn$cat9 <- convertFactorToNormalized(unprocessed_nn$cat9)
unprocessed_nn$cat10 <- convertFactorToNormalized(unprocessed_nn$cat10)
unprocessed_nn$cat11 <- convertFactorToNormalized(unprocessed_nn$cat11)
unprocessed_nn$cat12 <- convertFactorToNormalized(unprocessed_nn$cat12)
unprocessed_nn$cat13 <- convertFactorToNormalized(unprocessed_nn$cat13)
unprocessed_nn$cat14 <- convertFactorToNormalized(unprocessed_nn$cat14)
unprocessed_nn$cat15 <- convertFactorToNormalized(unprocessed_nn$cat15)
unprocessed_nn$cat16 <- convertFactorToNormalized(unprocessed_nn$cat16)
unprocessed_nn$cat17 <- convertFactorToNormalized(unprocessed_nn$cat17)
unprocessed_nn$cat18 <- convertFactorToNormalized(unprocessed_nn$cat18)
unprocessed_nn$cat19 <- convertFactorToNormalized(unprocessed_nn$cat19)
unprocessed_nn$cat20 <- convertFactorToNormalized(unprocessed_nn$cat20)
unprocessed_nn$cat21 <- convertFactorToNormalized(unprocessed_nn$cat21)
unprocessed_nn$cat22 <- convertFactorToNormalized(unprocessed_nn$cat22)
unprocessed_nn$cat23 <- convertFactorToNormalized(unprocessed_nn$cat23)
unprocessed_nn$cat24 <- convertFactorToNormalized(unprocessed_nn$cat24)
unprocessed_nn$cat25 <- convertFactorToNormalized(unprocessed_nn$cat25)
unprocessed_nn$cat26 <- convertFactorToNormalized(unprocessed_nn$cat26)
unprocessed_nn$cat27 <- convertFactorToNormalized(unprocessed_nn$cat27)
unprocessed_nn$cat28 <- convertFactorToNormalized(unprocessed_nn$cat28)
unprocessed_nn$cat29 <- convertFactorToNormalized(unprocessed_nn$cat29)
unprocessed_nn$cat30 <- convertFactorToNormalized(unprocessed_nn$cat30)
unprocessed_nn$cat31 <- convertFactorToNormalized(unprocessed_nn$cat31)
unprocessed_nn$cat32 <- convertFactorToNormalized(unprocessed_nn$cat32)
unprocessed_nn$cat33 <- convertFactorToNormalized(unprocessed_nn$cat33)
unprocessed_nn$cat34 <- convertFactorToNormalized(unprocessed_nn$cat34)
unprocessed_nn$cat35 <- convertFactorToNormalized(unprocessed_nn$cat35)
unprocessed_nn$cat36 <- convertFactorToNormalized(unprocessed_nn$cat36)
unprocessed_nn$cat37 <- convertFactorToNormalized(unprocessed_nn$cat37)
unprocessed_nn$cat38 <- convertFactorToNormalized(unprocessed_nn$cat38)
unprocessed_nn$cat39 <- convertFactorToNormalized(unprocessed_nn$cat39)
unprocessed_nn$cat40 <- convertFactorToNormalized(unprocessed_nn$cat40)
unprocessed_nn$cat41 <- convertFactorToNormalized(unprocessed_nn$cat41)
unprocessed_nn$cat42 <- convertFactorToNormalized(unprocessed_nn$cat42)
unprocessed_nn$cat43 <- convertFactorToNormalized(unprocessed_nn$cat43)
unprocessed_nn$cat44 <- convertFactorToNormalized(unprocessed_nn$cat44)
unprocessed_nn$cat45 <- convertFactorToNormalized(unprocessed_nn$cat45)
unprocessed_nn$cat46 <- convertFactorToNormalized(unprocessed_nn$cat46)
unprocessed_nn$cat47 <- convertFactorToNormalized(unprocessed_nn$cat47)
unprocessed_nn$cat48 <- convertFactorToNormalized(unprocessed_nn$cat48)
unprocessed_nn$cat49 <- convertFactorToNormalized(unprocessed_nn$cat49)
unprocessed_nn$cat50 <- convertFactorToNormalized(unprocessed_nn$cat50)
unprocessed_nn$cat51 <- convertFactorToNormalized(unprocessed_nn$cat51)
unprocessed_nn$cat52 <- convertFactorToNormalized(unprocessed_nn$cat52)
unprocessed_nn$cat53 <- convertFactorToNormalized(unprocessed_nn$cat53)
unprocessed_nn$cat54 <- convertFactorToNormalized(unprocessed_nn$cat54)
unprocessed_nn$cat55 <- convertFactorToNormalized(unprocessed_nn$cat55)
unprocessed_nn$cat56 <- convertFactorToNormalized(unprocessed_nn$cat56)
unprocessed_nn$cat57 <- convertFactorToNormalized(unprocessed_nn$cat57)
unprocessed_nn$cat58 <- convertFactorToNormalized(unprocessed_nn$cat58)
unprocessed_nn$cat59 <- convertFactorToNormalized(unprocessed_nn$cat59)
unprocessed_nn$cat60 <- convertFactorToNormalized(unprocessed_nn$cat60)
unprocessed_nn$cat61 <- convertFactorToNormalized(unprocessed_nn$cat61)
unprocessed_nn$cat62 <- convertFactorToNormalized(unprocessed_nn$cat62)
unprocessed_nn$cat63 <- convertFactorToNormalized(unprocessed_nn$cat63)
unprocessed_nn$cat64 <- convertFactorToNormalized(unprocessed_nn$cat64)
unprocessed_nn$cat65 <- convertFactorToNormalized(unprocessed_nn$cat65)
unprocessed_nn$cat66 <- convertFactorToNormalized(unprocessed_nn$cat66)
unprocessed_nn$cat67 <- convertFactorToNormalized(unprocessed_nn$cat67)
unprocessed_nn$cat68 <- convertFactorToNormalized(unprocessed_nn$cat68)
unprocessed_nn$cat69 <- convertFactorToNormalized(unprocessed_nn$cat69)
unprocessed_nn$cat70 <- convertFactorToNormalized(unprocessed_nn$cat70)
unprocessed_nn$cat71 <- convertFactorToNormalized(unprocessed_nn$cat71)
unprocessed_nn$cat72 <- convertFactorToNormalized(unprocessed_nn$cat72)
unprocessed_nn$cat73 <- convertFactorToNormalized(unprocessed_nn$cat73)
unprocessed_nn$cat74 <- convertFactorToNormalized(unprocessed_nn$cat74)
unprocessed_nn$cat75 <- convertFactorToNormalized(unprocessed_nn$cat75)
unprocessed_nn$cat76 <- convertFactorToNormalized(unprocessed_nn$cat76)
unprocessed_nn$cat77 <- convertFactorToNormalized(unprocessed_nn$cat77)
unprocessed_nn$cat78 <- convertFactorToNormalized(unprocessed_nn$cat78)
unprocessed_nn$cat79 <- convertFactorToNormalized(unprocessed_nn$cat79)
unprocessed_nn$cat80 <- convertFactorToNormalized(unprocessed_nn$cat80)
unprocessed_nn$cat81 <- convertFactorToNormalized(unprocessed_nn$cat81)
unprocessed_nn$cat82 <- convertFactorToNormalized(unprocessed_nn$cat82)
unprocessed_nn$cat83 <- convertFactorToNormalized(unprocessed_nn$cat83)
unprocessed_nn$cat84 <- convertFactorToNormalized(unprocessed_nn$cat84)
unprocessed_nn$cat85 <- convertFactorToNormalized(unprocessed_nn$cat85)
unprocessed_nn$cat86 <- convertFactorToNormalized(unprocessed_nn$cat86)
unprocessed_nn$cat87 <- convertFactorToNormalized(unprocessed_nn$cat87)
unprocessed_nn$cat88 <- convertFactorToNormalized(unprocessed_nn$cat88)
unprocessed_nn$cat89 <- convertFactorToNormalized(unprocessed_nn$cat89)
unprocessed_nn$cat90 <- convertFactorToNormalized(unprocessed_nn$cat90)
unprocessed_nn$cat91 <- convertFactorToNormalized(unprocessed_nn$cat91)
unprocessed_nn$cat92 <- convertFactorToNormalized(unprocessed_nn$cat92)
unprocessed_nn$cat93 <- convertFactorToNormalized(unprocessed_nn$cat93)
unprocessed_nn$cat94 <- convertFactorToNormalized(unprocessed_nn$cat94)
unprocessed_nn$cat95 <- convertFactorToNormalized(unprocessed_nn$cat95)
unprocessed_nn$cat96 <- convertFactorToNormalized(unprocessed_nn$cat96)
unprocessed_nn$cat97 <- convertFactorToNormalized(unprocessed_nn$cat97)
unprocessed_nn$cat98 <- convertFactorToNormalized(unprocessed_nn$cat98)
unprocessed_nn$cat99 <- convertFactorToNormalized(unprocessed_nn$cat99)
unprocessed_nn$cat100 <- convertFactorToNormalized(unprocessed_nn$cat100)
unprocessed_nn$cat101 <- convertFactorToNormalized(unprocessed_nn$cat101)
unprocessed_nn$cat102 <- convertFactorToNormalized(unprocessed_nn$cat102)
unprocessed_nn$cat103 <- convertFactorToNormalized(unprocessed_nn$cat103)
unprocessed_nn$cat104 <- convertFactorToNormalized(unprocessed_nn$cat104)
unprocessed_nn$cat105 <- convertFactorToNormalized(unprocessed_nn$cat105)
unprocessed_nn$cat106 <- convertFactorToNormalized(unprocessed_nn$cat106)
unprocessed_nn$cat107 <- convertFactorToNormalized(unprocessed_nn$cat107)
unprocessed_nn$cat108 <- convertFactorToNormalized(unprocessed_nn$cat108)
unprocessed_nn$cat109 <- convertFactorToNormalized(unprocessed_nn$cat109)
unprocessed_nn$cat110 <- convertFactorToNormalized(unprocessed_nn$cat110)
unprocessed_nn$cat111 <- convertFactorToNormalized(unprocessed_nn$cat111)
unprocessed_nn$cat112 <- convertFactorToNormalized(unprocessed_nn$cat112)
unprocessed_nn$cat113 <- convertFactorToNormalized(unprocessed_nn$cat113)
unprocessed_nn$cat114 <- convertFactorToNormalized(unprocessed_nn$cat114)
unprocessed_nn$cat115 <- convertFactorToNormalized(unprocessed_nn$cat115)
unprocessed_nn$cat116 <- convertFactorToNormalized(unprocessed_nn$cat116)
unprocessed_nn$loss <- normalize(unprocessed_nn$loss)

nn_train <- unprocessed_nn[1:178731, ]
nn_test <- unprocessed_nn[178732:188138, ]

############# DT
dt_model <- C5.0(dt_train[-131], dt_train$loss)
dt_pred <- predict(dt_model, dt_test)
#summary(dt_model)

dt_results <- unfactor(dt_pred)
MAE(dt_results, clean_test$loss)

# Boosted DT
dt_model_boost <- C5.0(dt_train[-131], dt_train$loss, trials = 10)
dt_pred_boosted <- predict(dt_model_boost, dt_test)
#summary(dt_model_boost)

dt_results_boosted <- unfactor(dt_pred_boosted)
MAE(dt_results_boosted, clean_test$loss)


############# NN
columns <- c("cat57","cat116","loss")
nn_train <- subset(nn_train, select = columns)
nn_test <- subset(nn_test, select = columns)

nn_model <- neuralnet(loss ~ cat57	+ cat116, data = nn_train, hidden = 10)

nn_prediction <- compute(nn_model, nn_test[1:12])
nn_pred_loss <- nn_prediction$net.result
nn_inflated_loss <- inflate(max_val, min_val, nn_pred_loss)

MAE(nn_pred_loss, clean_test$loss)
