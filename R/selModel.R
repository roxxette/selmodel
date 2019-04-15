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
sel_predict <- function(sad, debug = FALSE) {
  if (debug) {
    library(jsonlite)
    print(toJSON(sad))
  }

  model <- sel_model
  sel_columns <- sel_model_column_names

    c_names = as.vector(t(sel_columns))
  siz = length(sel_columns)
  nrecords = nrow(sad)
  names(sad) <- toupper(names(sad))

  df = setNames(data.frame(matrix(ncol = siz, nrow = nrecords, data=rep(0, siz * nrecords))), c_names)
  # df <- sad[,c_names]

  df$SAD_ID <- sad$SAD_ID
  df$B22_TOTAL_AMOUNT <- as.double(sad$B22_TOTAL_AMOUNT)
  df$B25_BORDER_TRANS <- as.integer(sad$B25_BORDER_TRANS)
  df$B6_TOTAL_PACKAGES <- as.integer(sad$B6_TOTAL_PACKAGES)

  if (debug) {
    print(df)
  }

  result <- predict(model, df)

  resultdf <- (data.frame(df$SAD_ID, result[2], result[2] > 0.7))
  colnames(resultdf) <- c("sad_id", "score", "alert")
  return(resultdf)
}
