% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_data_matrix.R
\name{create_data_matrix}
\alias{create_data_matrix}
\title{A data matrix function}
\usage{
create_data_matrix(items_by_contact, productkey, value, customerkey)
}
\arguments{
\item{items_by_contact}{A dataframe containing items by contact}

\item{productkey}{The column containing item ID's}

\item{customerkey}{The column containing customer ID's}
}
\description{
This function creates a data matrix
}
\examples{
ccreate_transactions(items_by_contact, productkey, customerkey)
}
