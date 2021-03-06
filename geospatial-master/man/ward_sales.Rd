% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chapter-1.R
\docType{data}
\name{ward_sales}
\alias{ward_sales}
\title{Corvallis sales summarized at the ward level}
\format{Data frame with 4189 rows and 8 variables:
\describe{
 \item{ward}{Ward number.}
 \item{lon, lat}{Longitude and latitude of a single point on a ward boundary.}
 \item{group, order}{The polygon group and order in which it should be drawn.}
 \item{num_sales}{The number of sales in this ward in 2015.}
 \item{avg_price}{The average sales price of properties in this ward in 2015.}
 \item{avg_finished_squarefeet}{The average finished square feet of sales in
   this ward in  2015}
}}
\source{
\url{ftp://ftp.ci.corvallis.or.us/pw/gis/Published/Dynamic/Shapefile/Boundary.zip}

\url{https://www.co.benton.or.us/assessment/page/property-sales-data}
}
\usage{
ward_sales
}
\description{
House sales in Corvallis summarized to the ward level.
}
\details{
Wards describe roughly equal population subdivisions of the city that are each
represented by a councilor on the Corvallis City Council.  Sales are assigned
to each ward and then summarized. The sales included are those that satisfy:
\itemize{
  \item{had a sales price greater than $0,}
  \item{had a reported city of Corvallis, and}
  \item{had a reported address.}
}
(This is slightly more properties than in \code{sales} because there is
no bounding box restriction.)

This dataset provides points on the boundaries of the wards and the relevant
summary statistics of the sales in each ward (i.e. enough to create a
choropleth plot of the wards).
}
\seealso{
\code{\link{sales}}, \code{\link{preds}}
}
\keyword{datasets}

