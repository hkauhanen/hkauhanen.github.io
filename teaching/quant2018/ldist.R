# ldist.R / Henri Kauhanen 2018
#
# Computes a Levenshtein distance matrix for a set of languages. Input is
# in the form of a matrix (or dataframe) of language vector, each row
# corresponding to a language, each column to a word/cognate. Distances
# are normalized (divided by the number of words) and length-corrected
# (divided by the longer of two words in each comparison) if requested.

ldist <- function(df,
                  normalize = FALSE,
                  correct = FALSE) {
  distmtx <- matrix(NA, nrow=nrow(df), ncol=nrow(df))
  languages <- rownames(df)
  for (i in 1:nrow(df)) {
    for (j in 1:nrow(df)) {
      # we only need a lower-diagonal matrix as distances are symmetric
      if (i > j) {
        x <- df[languages[i], ]
        y <- df[languages[j], ]
        if (length(x) != length(y)) {
          stop("x and y not of same length!")
        }
        if (normalize) {
          N <- length(x)
        } else {
          N <- 1
        }
        leven <- 0
        for (k in 1:length(x)) {
          a <- x[k]
          b <- y[k]
          if (correct) {
            C <- max(nchar(a), nchar(b))
          } else {
            C <- 1
          }
          leven <- leven + adist(a, b)/C
        }
        distmtx[i,j] <- (1/N)*leven
      }
    }
  }
  colnames(distmtx) <- languages
  rownames(distmtx) <- languages
  distmtx
}
