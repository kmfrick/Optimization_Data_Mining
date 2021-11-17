#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
filename <- args[1]
sigmasq <- as.numeric(args[2])
num_features <- as.numeric(args[3])
gamma <- as.numeric(args[4])
lambda <- as.vector(args[5:length(args)], mode="numeric")

X <- as.matrix(read.table(filename))
num_data <- nrow(X)
num_features_orig <- ncol(X) -1
nts <- 0
ncor <- 0
K <- 0
rbf <- function(x, y) exp(-norm(x - y, type='2')^2/sigmasq)
K <- outer(
					 1:num_data, 1:num_data,
					 Vectorize(function(i, j) rbf(X[i,1:num_features_orig], X[j,1:num_features_orig])))

for (i in 1:nrow(X)) {
	t <- X[,ncol(X)]
	y <- (sum(lambda * t * K[i,]) + gamma) > 0
	nts <- nts + 1
	if ((y == TRUE &&  t[i] == 1) || (y == FALSE &&  t[i] != 1)) {
		ncor <- ncor + 1
	}
}
acc <- c(ncor, nts)
cat(acc[1], ",", acc[2], sep="")
warnings()
