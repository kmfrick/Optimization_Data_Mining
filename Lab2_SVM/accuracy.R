#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
filename <- args[1]
filename_training <- args[2]
num_features <- as.numeric(args[3])
gamma <- as.numeric(args[4])
w <- as.vector(args[5:length(args)], mode="numeric")

Xtr <- as.matrix(read.table(filename_training))
Xte <- as.matrix(read.table(filename))
num_data <- nrow(Xte)
num_features_orig <- ncol(Xte) -1
ncor <- 0
y <- Xte[1:nrow(Xte), ncol(Xte)]
for (i in 1:num_data) {
	x <- Xte[i,1:num_features_orig]
	t <- Xtr[1:nrow(Xtr),ncol(Xtr)]
	yhat <- (t(w) %*% x + gamma) > 0
	if ((yhat == TRUE &&  y[i] == 1) || (yhat == FALSE &&  y[i] != 1)) {
		ncor <- ncor + 1
	}
}
acc <- c(ncor, num_data)
cat(acc[1], ",", acc[2], sep="")
