function [wo, e] = uo_sgm(wo, la, f, g, Xtr, ytr, Xte, yte, alpha, beta, gamma, esg_max, esg_best)
p = size(Xtr, 2);
m = gamma * p;
ke = p / m;
kmax = esg_max * ke;
e = 0;
s = 0; 
L_best = 99999;
k = 0;
wk = wo;
while e < esg_max && e < esg_best
    P =  randperm(p);
    for i = 1:(int32(ceil(p/m-1)))
        S = P(:, (i*m+1):min((i+1)*m, p));
        Xtrs = Xtr(:, S);
        ytrs = ytr(S);
        dk = -g(wk, Xtrs, ytrs);
        if k < kmax
            ak = (1 - k / kmax)*alpha + k / kmax * alpha * 0.01;
        else
            ak = 0.01 * alpha;
        end
        wk = wk + ak * dk; 
        k = k + 1;
    end
    e = e + 1;
    Lte = f(wk, Xte, yte);
    if Lte < L_best
        L_best = Lte;
        wo = wk;
        s = 0;
    else
        s = s + 1;
    end
end
end

