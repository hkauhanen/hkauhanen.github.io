# cretest.R / Henri Kauhanen 2018
#
# A likelihood ratio test for constant rate effects (pitting a CRE
# model against a null model with a fixed slope across contexts),
# using Wilks' theorem.

cretest <- function(alt,
                    null) {
  RSS_alt <- 0
  pars_alt <- 0
  n_alt <- 0
  for (a in alt) {
    RSS_alt <- RSS_alt + deviance(a)
    pars_alt <- pars_alt + nrow(summary(a)$parameters)
    n_alt <- n_alt + length(summary(a)$residuals)
  }
  RSS_null <- 0
  pars_null <- 0
  n_null <- 0
  for (a in null) {
    RSS_null <- RSS_null + deviance(a)
    pars_null <- pars_null + nrow(summary(a)$parameters)
    n_null <- n_null + length(summary(a)$residuals)
  }
  if (n_alt != n_null) {
    stop("Error: unequal numbers of data points")
  }
  LR <- 0.5*n_alt*log(RSS_null/RSS_alt)
  chi <- 2*LR
  df <- pars_alt - pars_null
  p <- pchisq(chi, df=df, lower.tail=FALSE)
  cat("Likelihood ratio test\n\n")
  cat(paste("     L-ratio:", round(LR, 3), "\n"))
  cat(paste("  chi-square:", round(chi, 3), "\n"))
  cat(paste("          df:", df, "\n"))
  cat(paste("     p-value:", round(p, 3), "\n"))
  invisible(list(chisquare=chi, LR=LR, df=df, p=p))
}
