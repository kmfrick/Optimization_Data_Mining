
fprintf('[uo_FDM_CE23]\n'); clear;
% Problem
f = @(x) 100 * (x(2) - x(1)^2)^2 + (1 - x(1))^2;
g = @(x) [ -400 * (x(2) - x(1)^2) * x(1) - 2 * (1 - x(1));  200 * (x(2) - x(1)^2) ];
h = @(x) [ ];
% Input parameters.
x1 = [-1;2]; % starting solution.
epsG= 10^-6; kmax= 1500;
almax= 2; almin= 10^-3; rho=0.5;c1=0.01;c2=0.45; iW= 2;
isd= 3; icg= 1; irc=  0; nu = 0.1;
delta = 0; % this parameter is only useful with SDM

[xk,dk,alk,iWk,betak,Hk,tauk] = uo_solve(x1,f,g,h,epsG,kmax,almax,almin,rho,c1,c2,iW,isd,icg,irc,nu,delta);

% Optimization: tauk is only useful with SDM.
% Optimization's log
xo=[1; 1]; xylim = []; logfreq = 1;
[la1k,kappak,rk,Mk] = uo_solve_log(x1,f,g,h,epsG,kmax,almax,almin,rho,c1,c2,iW,isd,icg,irc,nu,delta,xk,dk,alk,iWk,betak,Hk, tauk,xo,xylim,logfreq);
fprintf('[uo_FDM_CE23]\n');



