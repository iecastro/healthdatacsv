% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers.R
\name{get_keywords}
\alias{get_keywords}
\title{Extract keywords listed in the healthdata.gov API}
\usage{
get_keywords(agency = NULL)
}
\arguments{
\item{agency}{enter full agency name in title case (results from
\code{get_agencies()}) to pull keywords tagged in the listed
agency's products. Defaults to \code{NULL} and pulls all keywords cataloged}
}
\value{
a \code{\link[tibble:tibble]{tibble}} with publisher (agency)
name(s) and respective keywords
}
\description{
This is a helper function that will download either all keywords
listed in the \href{https://healthdata.gov/}{healthdata.gov} data API, or
pairings of agency and keywords listed.
}
\examples{
\dontrun{
get_keywords()

get_keywords("Centers for Disease Control and Prevention")
}
}
