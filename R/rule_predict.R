

rule_predict <- function(rule_train) {
  
  lhs_dat   <- rule_train
  all_rules <- rule_train
  
  recommendations <- complete_fun(merge(x = lhs_dat, y = all_rules, by = "lhs", all.x = TRUE), "rhs") %>% 
    arrange(desc(lift)) %>% 
    filter(lift >= 1) %>% 
    as.data.frame()
  
}