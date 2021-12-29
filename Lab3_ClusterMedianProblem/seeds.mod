param m := 210; # 70 data points per variety
param n := 6; # 6 features
param k := 3; # 3 varieties of wheat
param d {i in 1..m, j in 1..m};
var x {i in 1..m, j in 1..m} binary;

minimize cluster: sum{i in 1..m}(sum{j in 1..m} d[i,j] * x[i,j]);

subject to onecluster {i in 1..m}:
sum{j in 1..m} x[i,j] = 1;

subject to kclusters:
sum{j in 1..m} x[j,j] = k;

subject to clusterexists {i in 1..m, j in 1..m}:
x[j,j] >= x[i,j];
