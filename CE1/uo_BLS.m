
function [al, iWout] = uo_BLS(x, d, f, g, almax, almin, rho, c1, c2, iW)
% BLS algorithm
% iW =1 -> WC
% iW = 2 -> SWC
% iWout = 1 -> WC1
% iWout = 2 -> WC2
% iWout = 3 -> SWC
wc = false;
alk = almax;
while wc == false  && alk >= almin
    wc1 = f(x + alk * d) <= f(x) + c1 * g(x)' * d * alk;
    wc2 = g(x + alk * d)' * d >= c2 * g(x)' * d;
    swc = all(wc1) && norm(g(x + alk * d)'*d) <= c2 * norm(g(x)'*d);
    if iW == 1
        wc = all(wc1) && all(wc2);
    else
        wc = swc;
    end
    if wc == false
        alk = alk * rho;
    end
end
iWout = -1;
if all(wc1)
    iWout = 1;
end
if all(wc2)
    iWout = 2;
end
if swc && iW == 2
    iWout = 3;
end
al = alk;
if al < almin
    al = almin;
end
end