#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
filename <- args[1]
filename_training <- args[2]
sigmasq <- as.numeric(args[3])
num_features <- as.numeric(args[4])
gamma <- as.numeric(args[5])
lambda <- as.vector(args[6:length(args)], mode="numeric")
if (length(lambda) != num_features) {
	write("OHNO\n", stderr())
}

Xtr <- as.matrix(read.table(filename_training))
Xte <- as.matrix(read.table(filename))
num_data <- nrow(Xte)
num_features_orig <- ncol(Xte) -1
K <- 1:nrow(Xte)
rbf <- function(x, y) exp(-norm(x - y, type='2')^2/sigmasq)
for (i in 1:nrow(Xte)) {
	m = 0;
	for (j in 1:nrow(Xtr)) {
		if (lambda[j] > 0) {
			m <- m + lambda[j] * Xtr[j,ncol(Xtr)] * rbf(Xte[i,1:num_features_orig], Xtr[j,1:num_features_orig]);
		}
	}
	K[i] <- m;
}
y <- Xte[1:nrow(Xte), ncol(Xte)]
ncor <- 0
for (i in 1:nrow(Xte)) {
	yhat <- (K[i] + gamma) > 0
	if ((yhat == TRUE &&  y[i] == 1) || (yhat == FALSE &&  y[i] != 1)) {
		ncor <- ncor + 1
	}
}
acc <- c(ncor, num_data)
cat(acc[1], ",", acc[2], sep="")
