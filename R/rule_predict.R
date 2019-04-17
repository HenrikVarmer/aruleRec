#' Creates recommendations based on input association rules
#'
#' This function returns recommendations based on input association rules and a new unseen dataset
#' @param rule_train Association Rule Mining Training Vector Object
#' @export
#' @examples
#' rule_predict(rules, newdata)

rule_predict <- function(rules, newdata) {
  
  all_rules <- test[1]
  lhs_dat   <- test[2]
  
  recommendations <- complete_fun(merge(x = lhs_dat, y = all_rules, by = "lhs", all.x = TRUE), "rhs") %>% 
    arrange(desc(lift)) %>% 
    filter(lift >= 1) %>% 
    as.data.frame()
  
}