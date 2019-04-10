#' Create transactions object required for association rule mining
#'
#' This function creates transactions object required for association rule mining
#' @param items_by_contact A dataframe containing items by contact
#' @param productkey The column containing item ID's
#' @param customerkey The column containing customer ID's
#' @export
#' @examples
#' ccreate_transactions(items_by_contact, productkey, customerkey)

create_transactions <- function(items_by_contact, productkey, value, customerkey){
  return(
    create_data_matrix(items_by_contact, productkey, value, customerkey)%>% 
      as.matrix() %>% 
      as("transactions")
  )
}