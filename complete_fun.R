# gets complete dataframes without NA in the desired columns
complete_fun <- function(data, desiredCols) {
  completeVec <- complete.cases(data[, desiredCols])
  return(data[completeVec, ])
}