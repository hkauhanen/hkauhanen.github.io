# hdist.R / Henri Kauhanen 2018
#
# Computes a Hamming distance matrix for a set of languages. Input is
# in the form of a matrix (or dataframe) of language vector, each row
# corresponding to a language, each column to a feature. Distances
# are normalized (divided by the number of features) if requested.

hdist <- function(df,
                  normalize = TRUE) {
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
        hamm <- sum(x != y)
        distmtx[i,j] <- (1/N)*hamm
      }
    }
  }
  colnames(distmtx) <- languages
  rownames(distmtx) <- languages
  distmtx
}
