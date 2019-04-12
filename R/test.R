test <- function() {
  library(XML)
  library(RJSONIO)
  library(jsonlite)

  lis <- xmlToList(xmlParse("R/sad0.xml"))

  # library(plyr)
  # library(dplyr)
  # xml <- ldply(lis, data.frame)

  json <- toJSON(lis)

  # df <- fromJSON(paste('[', toString(json), ']'))
  df <- fromJSON(json)
  names(df) <- toupper(names(df))

  df$B22_TOTAL_AMOUNT <- as.double(df$B22_TOTAL_AMOUNT)
  df$B25_BORDER_TRANS <- as.integer(df$B25_BORDER_TRANS)
  df$B6_TOTAL_PACKAGES <- as.integer(df$B6_TOTAL_PACKAGES)

  # str(df)

  # sad <- toJSON(df)
  # df <- fromJSON(sad)

  # c_names
  # df[,c_names]


  result = predict(model, df)

  sad1 <- fromJSON('{"SAD_ID": "1", "B6_TOTAL_PACKAGES": 10, "B22_TOTAL_AMOUNT": 20, "B25_BORDER_TRANS": 7}')
  predict(tree_1, sad1)

  sad2 <- fromJSON('{"SAD_ID": "1", "B6_TOTAL_PACKAGES": 1000, "B22_TOTAL_AMOUNT": 20, "B25_BORDER_TRANS": 7}')
  predict(tree_1, sad2)

    return(result[2] > 0.7)
}
