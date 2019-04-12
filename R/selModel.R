# Calculate the risk score for a group of SAD
#
#  global variable "model" and "column_names" are present in the package (sysdata.rda).
#  they should be imported from the model previously built in R.
#  to load them see scripts in data-raw/prepare-data.R as an example.
#
#' @param sad a json array containing the sad encoded as json.
#' @return a dataframe containing sad_id, risk score, and  for all the passed in sad.
#' @export
#'
sel_predict1 <- function(sad)  {
  c_names = as.vector(t(column_names))
  siz = nrow(column_names)
  nrecords = nrow(sad)

  df = setNames(data.frame(matrix(ncol = siz, nrow = nrecords, data=rep(0, siz * nrecords))), c_names)
  for (row in 1:nrow(df)) {
    b33_code = do.call("c", sad[row,c("_item")])$b33_commodity_code
    for (colName in b33_code) {
      if(colName %in% colnames(df)) {
        df[row,colName] = 1;
      } else {
        df[row,"null"] = 1
      }
    }
  }
  #this shouldn't be generally used in a library package but...
  requireNamespace("randomForest")
  result = predict(model,df)

  resultdf = (data.frame(sad$sad_id,result, result > 0.5))
  colnames(resultdf) <- c("sad_id", "score", "alert")
  return(resultdf)
}

sel_predict <- function(sad) {
  # model <- readRDS(file="model")
  # sad <- json
  # column_names <- read.csv("colnames.csv")
print(sad)
  c_names = as.vector(t(column_names))
  siz = nrow(column_names)
  nrecords = nrow(sad)
print('R0')
  # library(XML)
  # library(RJSONIO)
  # library(jsonlite)
  # df <- fromJSON(sad)
  df <- sad
  names(df) <- toupper(names(df))
print('R1')
  df$B22_TOTAL_AMOUNT <- as.double(df$B22_TOTAL_AMOUNT)
  df$B25_BORDER_TRANS <- as.integer(df$B25_BORDER_TRANS)
  df$B6_TOTAL_PACKAGES <- as.integer(df$B6_TOTAL_PACKAGES)
print('R2')

  result = predict(model, df)
print('R3')

  resultdf = (data.frame(df$SAD_ID, result[2], result[2] > 0.7))
  colnames(resultdf) <- c("sad_id", "score", "alert")
  return(resultdf)
}
