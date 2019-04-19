

# Esitmates the input data type

guess_data <- function(data, estimate_bool) {
  
  if (class(data) == transaction) {
    data_guess <- "transactions"
  } else if (ncol(data)    == 2 && 
             class(data)   != transaction) {
    data_guess <- "tidy"
  } else if (ncol(data > 2)) {
    data_guess <- "binary incidence matrix"
  }
}

