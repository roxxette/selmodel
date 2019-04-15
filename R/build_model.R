

train_test_selectivity_model <- function() {
  source('R/DBQuery.R')
  df1 <- query_oracle("SELECT SAD_ID, B22_TOTAL_AMOUNT, B25_BORDER_TRANS, B6_TOTAL_PACKAGES, COMPLIANT FROM TRADER_HISTORY")
  # df2 <- query_hive("SELECT SAD_ID, B22_TOTAL_AMOUNT, B25_BORDER_TRANS, B6_TOTAL_PACKAGES, COMPLIANT FROM TRADER_HISTORY")

  df <- df1
  names(df) <- toupper(names(df))

  library(rpart)
  model <- rpart(COMPLIANT ~ B22_TOTAL_AMOUNT + B25_BORDER_TRANS + B6_TOTAL_PACKAGES, data = df, method = "class", control=rpart.control(minsplit=1, minbucket=1, cp=0.001))
  saveRDS(model, "models/sel_model")

  df$COMPLIANT <- NULL
  column_names <- colnames(df)
  saveRDS(column_names, "models/sel_model_columns")

  # save.image("R/sysdata.rda")
  print("model saved")
}
