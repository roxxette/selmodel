prepare_model <- function() {
  library(rpart)
  library(rpart.plot)

  library(ROracle)
  library(dplyr)

  # fancy plot
  library(rattle)
  library(rpart.plot)
  library(RColorBrewer)

  df1 <- query_oracle("SELECT SAD_ID, B22_TOTAL_AMOUNT, B25_BORDER_TRANS, B6_TOTAL_PACKAGES, COMPLIANT FROM TRADER_HISTORY")
  df2 <- query_hive("SELECT SAD_ID, B22_TOTAL_AMOUNT, B25_BORDER_TRANS, B6_TOTAL_PACKAGES, COMPLIANT FROM TRADER_HISTORY")

  df <- df2
  names(df) <- toupper(names(df))
  # df$y <- ifelse(data[,'COMPLIANT'] == 'OK', 1, 0)

  train <- df %>% dplyr::sample_frac(.7)
  test  <- dplyr::anti_join(df, train, by = 'SAD_ID')

  str(df)
  str(train)
  str(test)

  tree_1 <- rpart(COMPLIANT ~ B22_TOTAL_AMOUNT + B25_BORDER_TRANS + B6_TOTAL_PACKAGES, data = df, method = "class", control=rpart.control(minsplit=1, minbucket=1, cp=0.001))

  fancyRpartPlot(tree_1)



  prediction <- predict(tree_1, newdata = test, type = "class")

  my_solution <- data.frame(SAD_ID = test$SAD_ID, Prediction = prediction)

  result <- merge(test, my_solution, by='SAD_ID')
  result$Correct <- result$COMPLIANT == result$Prediction

  str(result)
  table(result$Correct)
  prop.table(table(result$Correct))



  # Calculate the accuracy
  acc <- as.double( prop.table(table(result$Correct))["TRUE"] )
  acc

  #todo, calculate precision, recall, F1 score
}
