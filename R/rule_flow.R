
#' The main rule flow function
#'
#' This function mines the association rules and preprocesses data by calling other functions in the library.
#' @param data A dataframe containing dataframe as input in tidy format with one customer-item pair per row. This data.frame must contain two columns: a customer ID and a product ID.
#' @param customerkey The column containing customer ID's
#' @param productkey The column containing item ID's
#' @param support Minimum support of the mined association rules
#' @param confidence Minimum confidence of the mined association rules
#' @param minlen Minimum length of the mined association rules
#' @param maxlen Maximum length of the mined association rules
#' @export
#' @examples
#' rule_flow(data, customerkey, productkey, support, confidence, minlen, maxlen)

rule_flow <- function(data, customerkey, productkey, support, confidence, minlen, maxlen) {
  
  items_by_contact    <- create_items_by_contact(data, customerkey, productkey)
  
  transactions        <- create_transactions(items_by_contact, 
                                             productkey,
                                             "rownumber", 
                                             customerkey)
  
  rules               <- create_rules(transactions, 
                                      support, 
                                      confidence, 
                                      minlen, 
                                      maxlen)
  
  rules$rhs           <- as.integer(rules$rhs)
  
  return(list(rules = rules, transactions = transactions))
}
