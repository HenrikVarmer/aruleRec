
#' Easy and fast recommendations with association rule learning in R
#'
#' The aruleRec function generates recommendations from an input dataframe.
#' @param data A dataframe containing dataframe as input in tidy format with one customer-item pair per row. This df must contain two columns: a customer ID and a product ID.
#' @param customerkey The column containing customer ID's
#' @param productkey The column containing item ID's
#' @param support Minimum support of the mined association rules
#' @param confidence Minimum confidence of the mined association rules
#' @param minlen Minimum length of the mined association rules
#' @param maxlen Maximum length of the mined association rules
#' @export
#' @examples
#' aruleRec(data = dat, productkey = ProductKey, customerkey = CustomerKey, keep_all = FALSE, minlen = 2, maxlen = 20, support = 0.01, confidence = 0.7)

aruleRec <- function(data, 
                     productkey, 
                     customerkey, 
                     keep_all   = FALSE,
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
  mutate(lhs = as.character(lhs)) %>% 
  filter(lift >= 1)

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

if (is.na(keep_all) | keep_all == FALSE) {
  recommendations <- complete_fun(merge(x = lhs_dat, y = all_rules, by = "lhs"), "rhs") %>% 
    arrange(desc(lift)) %>% 
    as.data.frame()
} else if (keep_all == TRUE) {
  recommendations <- merge(x = lhs_dat, y = all_rules, by = "lhs", all.x = TRUE) %>% 
    arrange(desc(lift)) %>% 
    as.data.frame()
}

recommendations <- recommendations %>% 
  rename(item_history   = lhs,
         recommendation = rhs)

export_function(all_rules)

return(recommendations)
}


