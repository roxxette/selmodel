

build_model <- function() {
  library(rpart)

  df1 <- query_oracle("SELECT SAD_ID, B22_TOTAL_AMOUNT, B25_BORDER_TRANS, B6_TOTAL_PACKAGES, COMPLIANT FROM TRADER_HISTORY")
  df2 <- query_hive("SELECT SAD_ID, B22_TOTAL_AMOUNT, B25_BORDER_TRANS, B6_TOTAL_PACKAGES, COMPLIANT FROM TRADER_HISTORY")

  df <- df2
  names(df) <- toupper(names(df))
  # df$y <- ifelse(data[,'COMPLIANT'] == 'OK', 1, 0)

  # model <- rpart(y ~ B22_TOTAL_AMOUNT + B25_BORDER_TRANS + B6_TOTAL_PACKAGES, data = df, method = "class", control=rpart.control(minsplit=1, minbucket=1, cp=0.001))
  df$NEW_COLUMN <- df$B22_TOTAL_AMOUNT * df$B6_TOTAL_PACKAGES
  model <- rpart(COMPLIANT ~ B22_TOTAL_AMOUNT + B25_BORDER_TRANS + B6_TOTAL_PACKAGES + NEW_COLUMN, data = df, method = "class", control=rpart.control(minsplit=1, minbucket=1, cp=0.001))

  # save(model, file="sysdata.rda")
  save(model, file="model")
  # saveRDS(model,file="model")

  #save column names
  column_names <- colnames(data)
  column_names$COMPLIANT <- NULL
  write.csv2(colnames(column_names),file="colnames.csv",row.names = FALSE)
  print("model saved")
}

