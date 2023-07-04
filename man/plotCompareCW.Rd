% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotCompareCW.R
\name{plotCompareCW}
\alias{plotCompareCW}
\title{Plot of original consensus weights vs. normalized consensus weights grouping by the number of co-appeared percent of clustering(non-missing).}
\usage{
plotCompareCW(title, label, ncw, plot = NULL)
}
\arguments{
\item{title}{A character value for output directory.}

\item{label}{A matrix or data frame of input labels, columns=different clustering results and rows are samples.}

\item{ncw}{A matrix of normalized consensus weights with sample-by-sample as the order of sample(rows) in \code{label}.}

\item{plot}{character value. NULL(default) - print to screen, 'pdf', 'png', 'pngBMP' for bitmap png, helpful for large datasets, or 'pdf'.}
}
\value{
A ggplot point in PDF format with x-axis: original consensus weights; y-axis: normalized consensus weights; color: percent of co-appeared of clustering; size: number of duplicates sample .
}
\description{
Plot of original consensus weights vs. normalized consensus weights grouping by the number of co-appeared percent of clustering(non-missing).
}
\examples{

# load data
data(example_data)
label=example_data

# if plot is not NULL, results will be saved in "result_output" directory
title="result_output"

\donttest{
ncw<-callNCW(title=title,label=label,stability=TRUE)
plotCompareCW(title=title,label=label,ncw=ncw)
}
}