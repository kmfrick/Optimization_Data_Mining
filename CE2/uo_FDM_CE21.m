function uo_FDM_CE21
fprintf('[uo_FDM_CE21]\n'); clear;
% Problem
f = @(x) x(1)^2 + x(2)^3 + 3*x(1)*x(2);
g = @(x) [ 2*x(1)+3*x(2) ; 3*x(2)^2 + 3*x(1)];
h = @(x) [];
% Input parameters.
x1 = [-3;-1]; % starting solution.
epsG= 10^-6; kmax= 1500;
almax= 2; almin= 10^-3; rho=0.5;c1=0.01;c2=0.45; iW= 2;
isd= 1; icg= 1; irc= 1 ; nu = 0.1;
delta = 0; % this parameter is only useful with SDM

[xk,dk,alk,iWk,betak,Hk,tauk] = uo_solve(x1,f,g,h,epsG,kmax,almax,almin,rho,c1,c2,iW,isd,icg,irc,nu,delta);

% Optimization: tauk is only useful with SDM.
% Optimization's log
xo=[-2.25;1.5]; xylim = []; logfreq = 1;
[la1k,kappak,rk,Mk] = uo_solve_log(x1,f,g,h,epsG,kmax,almax,almin,rho,c1,c2,iW,isd,icg,irc,nu,delta,xk,dk,alk,iWk,betak,Hk, tauk,xo,xylim,logfreq);
fprintf('[uo_FDM_CE21]\n');
end
