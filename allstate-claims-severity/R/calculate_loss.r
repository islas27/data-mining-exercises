## Process Kaggle Testing data
train_data2 = rand_data
kaggle_test <- subset(kaggle_test, select = columns)
train_data2 <- subset(train_data2, select = columns)
total <- rbind(train_data2, kaggle_test)
total[1:19] <- apply(total[1:19], 2, convertFactorToNormalized)
kaggle_test <- total[nrow(rand_data)+1:nrow(total), ]
kaggle_pred <- predict(prediction_model, kaggle_test)
# inflated_kaggle <- inflate(min_val, max_val, kaggle_pred)
write.csv(inflated_kaggle, file="out.txt", quote=FALSE)
