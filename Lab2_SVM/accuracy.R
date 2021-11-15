#!/usr/bin/Rscript
f <- file("stdin")
info = read.csv(text=readLines(f,n=1), header=FALSE)
filename = info[,1]
model = info[,4]

df = read.table(filename)
nts <- 0
ncor <- 0
num_param <- 7
gamma <- 0
w <- 0
if (model == "./SVM.run") {
	gamma <- info[, 6]
	w = unlist(info[, 7:ncol(info[1,])])
} else {
	w = unlist(info[, 6:ncol(info[1,])])
}

for (i in 1:nrow(df)) {
	y <- t(w) %*% as.numeric(df[i, 1:num_param]) + gamma > 0
	nts <- nts + 1
	if ((y == TRUE &&  df[i, num_param+1] == 1) || (y == FALSE &&  df[i, num_param+1] != 1)) {
		ncor <- ncor + 1
	}
	acc <- c(ncor, nts)
}

write(acc, stdout())
