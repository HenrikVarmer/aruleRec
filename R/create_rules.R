#' Mines the association rules for the subsequent recommendations
#'
#' This function creates transactions object required for association rule mining
#' @param transactions A transaction object
#' @param support Minimum support of the mined association rules
#' @param confidence Minimum confidence of the mined association rules
#' @param minlen Minimum length of the mined association rules
#' @param maxlen Maximum length of the mined association rules
#' @export
#' @examples
#' create_rules(transactions, support, confidence, minlen, maxlen)

create_rules <- function(transactions, support, confidence, minlen, maxlen){
  rules                <- apriori(data = transactions, 
                                  parameter = list(supp   = support,
                                                   conf   = confidence, 
                                                   minlen = minlen,
                                                   maxlen = maxlen))
  topicrules           <- arules::DATAFRAME(rules)
  colnames(topicrules) <- tolower(colnames(topicrules))
  
  # Output rules arranged by lift descending
  # Regex removes curly brackets from rules prior to later joins
  topicrules <- topicrules %>%
    arrange(desc(lift)) %>% 
    tidyr::extract(rhs, 
                   into   = c("rhs"), 
                   regex  = "\\{(.*)\\}", 
                   remove = TRUE) %>% 
    tidyr::extract(lhs, 
                   into   = c("lhs"), 
                   regex  = "\\{(.*)\\}", 
                   remove = TRUE)
  
  return(topicrules)
}