#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
filename <- args[1]
num_features <- as.numeric(args[2])
gamma <- as.numeric(args[3])
w <- as.vector(args[4:length(args)], mode="numeric")

X <- as.matrix(read.table(filename))
num_data <- nrow(X)
num_features_orig <- ncol(X) -1
nts <- 0
ncor <- 0

for (i in 1:nrow(X)) {
	x <- X[i,1:num_features_orig]
	t <- X[,ncol(X)]
	y <- t(w) %*% x + gamma > 0
	nts <- nts + 1
	if ((y == TRUE &&  t[i] == 1) || (y == FALSE &&  t[i] != 1)) {
		ncor <- ncor + 1
	}
}
acc <- c(ncor, nts)
cat(acc[1], ",", acc[2], sep="")
