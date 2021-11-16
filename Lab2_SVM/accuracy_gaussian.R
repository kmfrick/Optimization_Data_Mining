#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
num_param <- as.numeric(args[1])
f <- file("stdin")
info = read.csv(text=readLines(f,n=1), header=FALSE)
filename = info[,1]
model = info[,4]

df <- read.table(filename)
nts <- 0
ncor <- 0
gamma <- 0
lambda <- 0
gamma <- info[, 6]
lambda <- unlist(info[, 7:ncol(info[1,])])


for (i in 1:nrow(df)) {
	x <-  df[i, 1:ncol(df)]
	rbfk <- c()
	for (j in 1:nrow(df)) {
		xj <- df[j, 1:ncol(df)]
		rbfk <- unlist(c(exp(-norm(x - xj, type="2"))))
	}
	t <- df[[ncol(df)]]
	y <- sum(lambda * t * rbfk) + gamma > 0
	nts <- nts + 1
	if ((y == TRUE &&  df[i, ncol(df)] == 1) || (y == FALSE &&  df[i, ncol(df)] != 1)) {
		ncor <- ncor + 1
	}
	acc <- c(ncor, nts)
}

write(acc, stdout())
