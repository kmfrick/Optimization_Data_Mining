param m; # Number of data points
param n; # Number of features
param k; # Number of clusters
param d {i in 1..m, j in 1..m};
var x {i in 1..m, j in 1..m} binary;

minimize cluster: sum{i in 1..m}(sum{j in 1..m} d[i,j] * x[i,j]);

subject to onecluster {i in 1..m}:
sum{j in 1..m} x[i,j] = 1;

subject to kclusters:
sum{j in 1..m} x[j,j] = k;

subject to clusterexists {i in 1..m, j in 1..m}:
x[j,j] >= x[i,j];