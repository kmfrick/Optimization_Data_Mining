format compact;
almax = 1.0;
almin = 0.01;
rho = 0.5;
c1 = 0.1;
c2 = 0.5;
eps = 1e-6;
Q=[4 0;0 1];
f =@(x)(1/2)*x'*Q*x;
g =@(x)Q*x;

% ELS
x = [1; 1];
x_old = [0; 0];
it = 0;
d = -g(x);

while norm(x - x_old) > eps
    al = -(Q * x)' * d / (d' * Q * d);
    x = x + al * d;
    d = - g(x);
    it = it + 1;
end

x
it

% BLS, W = WC
x = [1; 1];
x_old = [0; 0];
it = 0;
d = -g(x);
iW = 1; % W = WC
while norm(x - x_old) > eps
    [al, iW] = uo_BLS(x, d, f, g, almax, almin, rho, c1, c2, iW);
    x = x + al * d;
    d = - g(x);
    it = it + 1;
end

x
it
iW

% BLS, W = SWC
x = [1; 1];
x_old = [0; 0];
it = 0;
d = -g(x);
iW = 2; % W = SWC
while norm(x - x_old) > eps
    [al, iW] = uo_BLS(x, d, f, g, almax, almin, rho, c1, c2, iW);
    x = x + al * d;
    d = - g(x);
    it = it + 1;
end

x
it
iW

