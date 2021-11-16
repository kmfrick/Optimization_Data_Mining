#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
filename <- args[1]
model <- args[2]
sigmasq <- as.numeric(args[3])
num_features <- as.numeric(args[4])
gamma <- as.numeric(args[5])
lambda <- as.vector(args[6:length(args)], mode="numeric")

X <- read.table(filename)
nts <- 0
ncor <- 0
for (i in 1:nrow(X)) {
	x <-  X[i, 1:ncol(X)]
	rbfk <- c()
	for (j in 1:nrow(X)) {
		xj <- X[j, 1:ncol(X)]
		rbfk <- unlist(c(rbfk, exp(-sum((x - xj)^2)/sigmasq)))
	}
	t <- X[[ncol(X)]]
	y <- (sum(lambda * t * rbfk) + gamma) > 0
	nts <- nts + 1
	if ((y == TRUE &&  X[i, ncol(X)] == 1) || (y == FALSE &&  X[i, ncol(X)] != 1)) {
		ncor <- ncor + 1
	}
}

acc <- c(ncor, nts)
cat(acc[1], ",", acc[2], sep="")
