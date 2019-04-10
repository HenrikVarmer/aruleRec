#' A data matrix function
#'
#' This function creates a data matrix
#' @param items_by_contact A dataframe containing items by contact
#' @param productkey The column containing item ID's
#' @param customerkey The column containing customer ID's
#' @export
#' @examples
#' ccreate_transactions(items_by_contact, productkey, customerkey)


create_data_matrix <- function(items_by_contact, productkey, value, customerkey){
  return(
    items_by_contact %>%
      spread(!! colcol,!! value, fill = 0)  %>%
      select(!! -colrow)
  )
}