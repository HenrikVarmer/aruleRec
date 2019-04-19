#' Gets complete columns
#'
#' @param data A dataframe 
#' @param desiredCols Columns which you want to have no missing values
#' @examples
#' complete_fun(data, desiredCols)

complete_fun <- function(data, desiredCols) {
  completeVec <- complete.cases(data[, desiredCols])
  return(data[completeVec, ])
}