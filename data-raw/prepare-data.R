#this script is used to read the data from the modeling project and save it as local variables
#in the package for later reuse


column_names <- read.csv2("../../test-pmml/colnames.csv", FALSE)
load("../../test-pmml/model")
devtools::use_data(model,column_names, pkg = ".", internal = TRUE, overwrite = TRUE)

