function [Xtr,ytr,wo,fo,tr_acc,Xte,yte,te_acc,niter,tex] = uo_nn_solve(num_target,tr_freq,tr_seed,tr_p,te_seed,te_q,la,epsG,kmax,ils,ialmax,kmaxBLS,epsal,c1,c2,isd,sg_al0,sg_be,sg_ga,sg_emax,sg_ebest,sg_seed,icg,irc,nu);

[Xtr, ytr] = uo_nn_dataset(tr_seed, tr_p, num_target, tr_freq);

sig = @(Xds) 1./(1+exp(-Xds));
y = @(Xds,w) sig(w'*sig(Xds));
L = @(w,Xds,yds) (norm(y(Xds,w)-yds)^2)/size(yds,2)+ (la*norm(w)^2)/2;
gL = @(w,Xds,yds) (2*sig(Xds)*((y(Xds,w)-yds).*y(Xds,w).* (1-y(Xds,w)))')/size(yds,2)+la*w;
L2 = @(w) L(w, Xtr, ytr);
gL2 = @(w) gL(w, Xtr, ytr);


[Xte, yte] = uo_nn_dataset(te_seed, te_q, num_target, tr_freq);

w0 = ones(1, 35)' * 0;
h = [];
t1 = clock;
if isd < 7
[wo, niter] = uo_solve(w0,L2,gL2,epsG,kmax,ialmax,c1,c2,isd,icg,irc,nu);
else % sgd
    [wo, niter] = uo_sgm(w0, la, L, gL, Xtr, ytr, Xte, yte, sg_al0, sg_be, sg_ga, sg_emax,sg_ebest);
end
t2 = clock; 
tex= etime(t2, t1)/niter;
wo = wo(:, end);
fo = L2(wo);
acc = @(Xds,yds,wo) 100*sum(yds==round(y(Xds,wo)))/size(Xds,2);
tr_acc = acc(Xtr, ytr, wo);
te_acc =  acc(Xte, yte, wo);
end