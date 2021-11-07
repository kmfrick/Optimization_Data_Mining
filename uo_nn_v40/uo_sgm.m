function [w, e] = uo_sgm(wo, la, f, g, Xtr, ytr, Xte, yte, alpha, beta, gamma, esg_max, esg_best)
p = size(Xtr, 2);
m = floor(gamma * p);
ksge = p / m;
ksgmax = esg_max * ksge;
e = 0;
s = 0; 
L_best = +inf;
k = 0;
wk = wo;
w = wo;
while e < esg_max && s < esg_best
    P = randperm(p);
    for i = 0:p/m-1
        S = P(:, (i*m+1):min((i+1)*m, p));
        Xtrs = Xtr(:, S);
        ytrs = ytr(S);
        dk = -g(wk, Xtrs, ytrs);
        ksg = floor(beta * ksgmax);
        alphasg = 0.01 * alpha;
        if k <= ksg
            ak = (1 - k / ksg) * alpha + alphasg * k / ksg;
        else
            ak = alphasg;
        end
        wk = wk + ak * dk; 
        k = k + 1;
    end
    e = e + 1;
    Lte = f(wk, Xte, yte);
    if Lte < L_best
        L_best = Lte;
        w = wk;
        s = 0;
    else
        s = s + 1;
    end
end
end

