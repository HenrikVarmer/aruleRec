#' Mines association rules from an input data.frame
#'
#' This function mnes association rules from an input data.frame but does nothing more
#' @param data A dataframe containing dataframe as input in tidy format with one customer-item pair per row. This data.frame must contain two columns: a customer ID and a product ID.
#' @param productkey The column containing item ID's
#' @param customerkey The column containing customer ID's
#' @param support Minimum support of the mined association rules
#' @param confidence Minimum confidence of the mined association rules
#' @param minlen Minimum length of the mined association rules
#' @param maxlen Maximum length of the mined association rules
#' @export
#' @examples
#' aruleTrain(data, productkey, customerkey, cupport, confidence, minlen, maxlen)

aruleTrain <- function(data, 
                       productkey, 
                       customerkey, 
                       support    = 0.01, 
                       confidence = 0.7, 
                       minlen     = 2, 
                       maxlen     = as.integer(length(unique(data$productkey)) + 1)) {
    
    customerkey <- enquo(customerkey)
    productkey  <- enquo(productkey)
    
    rules <- rule_flow(data,
                       !! customerkey,
                       !! productkey,
                       support, 
                       confidence, 
                       minlen,
                       maxlen)
    
    aruleTrain <- rules$rules %>% 
      mutate(lhs = as.character(lhs))
    
    export_function(aruleTrain)
    
    return(aruleTrain)
}