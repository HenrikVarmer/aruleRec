#' Create Signups By Contact
#'
#' This creates a new dataframe with items by contacts
#' @param data A dataframe containing dataframe as input in tidy format with one customer-item pair per row. This data.frame must contain two columns: a customer ID and a product ID.
#' @param customerkey The column containing customer ID's
#' @param productkey The column containing item ID's
#' @export
#' @examples
#' create_items_by_contact(data, customerkey, productkey)

create_items_by_contact <- function(data, customerkey, productkey){
  
  customerkey <- enquo(customerkey)
  productkey  <- enquo(productkey)
  
  return(
    data %>% 
      select(!! customerkey,!! productkey) %>% 
      group_by(!! customerkey,!! productkey) %>%
      mutate(rownumber = row_number(!! productkey)) %>% 
      filter(rownumber == 1) %>% 
      as.data.frame()
  )
}
