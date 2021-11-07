param n >= 1, integer;
param m >= 1, integer;
param nu >= 0;

param A {1..m,1..n};
param y {1..m};

var gamma;
var w {1..n};
var s {1..m} >= 0;

minimize Primal:
0.5 * sum {i in 1..n} w[i] * w[i] + nu * sum{i in 1..m} s[i];

subject to PrimalConstraint {i in 1..m}:
y[i] * (sum {j in 1..n} (A[i,j] * w[j]) + gamma) + s[i] >= 1;

