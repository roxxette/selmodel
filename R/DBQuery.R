query_hive <- function(sql) {
  library("RJDBC")
  library("rJava")
  hadoop.class.path = list.files(path=c("./dep"), pattern="jar", full.names=T);
  cp = c(hadoop.class.path)
  .jinit(classpath=cp)
  url.dbc =  paste0("jdbc:hive2://eb-pmp:10000/default");
  drv=JDBC("org.apache.hive.jdbc.HiveDriver")
  conn <- dbConnect(drv, url.dbc, "hive", "hive")
  df <- dbGetQuery(conn, sql)
}

query_oracle <- function(sql) {
  library(ROracle)
  drv <- dbDriver("Oracle")
  con <- dbConnect(drv, "CLR", "INTG_REF_CLR", "209.INTG")
  res <- dbSendQuery(con, sql)
  df <- fetch(res, n=-1)
  # df <- data.frame(data)
}
