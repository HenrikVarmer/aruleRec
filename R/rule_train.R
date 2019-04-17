#' Mines association rules from an input data.frame
#'
#' This function mnes association rules from an input data.frame but does nothing more
#' @param items_by_contact A dataframe containing items by contact
#' @param productkey The column containing item ID's
#' @param customerkey The column containing customer ID's
#' @export
#' @examples
#' rule_train(data, productkey, customerkey, cupport, confidence, minlen, maxlen)

rule_train <- function(data, 
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
    
    all_rules <- rules$rules %>% 
      mutate(lhs = as.character(lhs))
    
    lhs_dat <- data %>% 
      select(!! customerkey, !! productkey) %>%
      group_by(!! customerkey, !! productkey) %>% 
      mutate(rownumber= row_number(!! customerkey)) %>% 
      filter(rownumber == 1) %>% 
      ungroup %>% 
      group_by(!! customerkey) %>% 
      arrange(!! productkey) %>% 
      mutate(lhs = as.character(paste0(!! productkey, collapse = ","))) %>% 
      arrange(!! customerkey) %>% 
      top_n(1, !! productkey) %>% 
      select(!! customerkey, lhs) %>%
      as.data.frame()
    
    recommendations <- complete_fun(merge(x = lhs_dat, y = all_rules, by = "lhs", all.x = TRUE), "rhs") %>% 
      arrange(desc(lift)) %>% 
      filter(lift >= 1) %>% 
      as.data.frame()
    
    rule_train@all_rules <- all_rules
    rule_train@lhs_dat   <- lhs_dat
    
    export_function(rule_train)
    
    return(rule_train)
}