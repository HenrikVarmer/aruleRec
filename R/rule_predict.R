#' Creates recommendations based on input association rules
#'
#' This function returns recommendations based on input association rules and a new unseen dataset
#' @param rules Association Rule Mining Training Vector Object
#' @param newdata New input data.frame with customers and items
#' @param customerkey The name of the Column containing customer ID's
#' @param productkey The name of the Column containing item/product ID's
#' @export
#' @examples
#' rule_predict(rules, newdata, customerkey, productkey)

rule_predict <- function(rules, newdata, customerkey, productkey) {
  
  customerkey <- enquo(customerkey)
  productkey  <- enquo(productkey)
  
  lhs_dat <- newdata %>% 
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
  
  predictions <- complete_fun(merge(x = lhs_dat, y = rules, by = "lhs", all.x = TRUE), "rhs") %>% 
    arrange(desc(lift)) %>% 
    filter(lift >= 1) %>% 
    as.data.frame()
  
  return(predictions)
  
}