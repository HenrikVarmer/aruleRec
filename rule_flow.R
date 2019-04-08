


create_signups_by_contact <- function(data, customerkey, productkey){
  
  return(
    data %>% 
      select(!! customerkey,!! productkey) %>% 
      group_by(!! customerkey,!! productkey) %>%
      mutate(rownumber = row_number(!! productkey)) %>% 
      filter(rownumber == 1) %>% 
      as.data.frame()
  )
}


create_data_matrix <- function(df_in, colcol, value, colrow){
  return(
    df_in %>%
      spread(!! colcol,!! value, fill = 0)  %>%
      select(!! -colrow)
  )
}

create_transactions <- function(signups_by_contact, colcol, value, colrow){
  return(
    create_data_matrix(signups_by_contact, colcol, value, colrow)%>% 
      as.matrix() %>% 
      as("transactions")
  )
}

create_rules <- function(transactions, supp, conf, minlen, maxlen){
  rules                <- apriori(data = transactions, 
                                  parameter = list(supp   = supp,
                                                   conf   = conf, 
                                                   minlen = minlen,
                                                   maxlen = maxlen))
  topicrules           <- arules::DATAFRAME(rules)
  colnames(topicrules) <- tolower(colnames(topicrules))
  
  # Output rules arranged by lift descending
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

rule_flow <- function(data, customerkey, productkey, supp, conf, minlen, maxlen) {
  
  signups_by_contact  <- create_signups_by_contact(data, customerkey, productkey)
  transactions        <- create_transactions(signups_by_contact, 
                                             productkey, 
                                             "rownumber", 
                                             customerkey)
  rules               <- create_rules(transactions, 
                                      supp, 
                                      conf, 
                                      minlen, 
                                      maxlen)
  rules$rhs           <- as.integer(rules$rhs)
  
  return(list(rules = rules, transactions = transactions))
}
