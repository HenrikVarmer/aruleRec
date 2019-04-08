library(dplyr)
library(arules)
library(tidyr)
source("complete_fun.R")
source("rule_flow.R")

aruleRec <- function(data, 
                     productkey, 
                     customerkey, 
                     support    = 0.01, 
                     confidence = 0.7, 
                     minlen     = 2, 
                     maxlen     = as.integer(length(unique(data$productkey)) + 1)) {

rules <- rule_flow(data,
                   support,
                   confidence, 
                   minlen,
                   maxlen)

all_rules <- rules$rules %>% 
  mutate(lhs = as.character(lhs))

customerkey <- enquo(customerkey)
productkey  <- enquo(productkey)

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

return(recommendations)
}

