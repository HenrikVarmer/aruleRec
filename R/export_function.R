#' Exports obejcts to globalenv
#'
#' 
#' @param ... Stuff that needs to be exported
#' @export
#' @examples export_function(data)

export_function <- function(...) {
  arg.list      <- list(...)
  names         <- all.names(match.call())[-1]
  for (i in seq_along(names)) assign(names[i],arg.list[[i]],.GlobalEnv)
}
