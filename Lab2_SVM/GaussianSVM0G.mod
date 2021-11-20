param n >= 1, integer;
param m >= 1, integer;
param nu >= 0;

param y {1..m};
param A {1..m, 1..n};
param K {1..m, 1..m};
param sigmasq;

var lambda {1..m} >=0, <=nu;

maximize Dual:
sum {i in 1..m} lambda[i] - 0.5 * sum{i in 1..m, j in 1..m} 
(lambda[i] * y[i] * lambda[j] * y[j] * K[i,j]);

