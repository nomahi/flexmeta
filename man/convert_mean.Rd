\name{convert_mean}
\alias{convert_mean}
\title{Converting means and standard deviations to summary statistics}
\usage{
convert_mean(n1, m1, s1, n2, m2, s2, type=c("MD", "SMD"), pooled = FALSE)
}
\arguments{
\item{n1}{A vector of number of observations in experimental group}

\item{m1}{A vector of estimated mean in experimental group}

\item{s1}{A vector of standard deviation in experimental group}

\item{n2}{A vector of number of observations in experimental group}

\item{m2}{A vector of estimated mean in experimental group}

\item{s2}{A vector of standard deviation in experimental group}

\item{type}{the outcome measure for continous outcome data (default = "MD").
\itemize{
\item \code{MD}: Mean difference.
\item \code{SMD}: Standardized mean difference.
}
}

\item{pooled}{logical; if \code{TRUE}, a pooled variance is used.
The default is \code{FALSE}.}
}
\value{
A \code{data.frame} of study data.
\itemize{
\item \code{y}: A numeric vector of the effect size estimates.
\item \code{v}: A numeric vector of the within studies variance estimates.
}
}
\description{
Converting estimated means and standard deviations in
experimental and contorol groups to the effect size
estimates and the within studies variances vector
}
\examples{
data(SMT)
attach(SMT)

dat1 <- convert_mean(n1, m1, s1, n2, m2, s2, type="MD")
print(dat1)

dat2 <- convert_mean(n1, m1, s1, n2, m2, s2, type="SMD")
print(dat2)
}
