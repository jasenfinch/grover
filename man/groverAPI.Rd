% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{groverAPI}
\alias{groverAPI}
\title{Grover API}
\usage{
groverAPI(
  grover_host,
  background = FALSE,
  log_dir = "~/.grover/logs",
  temp_dir = tempdir()
)
}
\arguments{
\item{grover_host}{S4 object of class Grover}

\item{background}{Run as a background process.}

\item{log_dir}{directory path for API logs}

\item{temp_dir}{temporary directory for converted files}
}
\description{
Run the grover REST API for file conversion.
}
\examples{
\dontrun{
grover_host <- grover(host = "127.0.0.1",
                     port = 8000,
                     auth = "1234",
                     repository = system.file('repository',
                                               package = 'grover'))
groverAPI(grover_host) 
}
}
