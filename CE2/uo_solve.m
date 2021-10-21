function [xk, dk, alk, iWk, betak, Hk, tauk] = uo_solve(x,f,g,h,epsG,kmax,almax,almin,rho,c1,c2,iW,isd,icg,irc,nu,delta)
k = 0;
n = length(x);
d = -g(x);
H = eye(n);
xk = [x];
dk = [];
alk = [];
iWk = [];
betak = [];
Hk = [];
tauk = [];
epsilon = 1e-3;
maxit = 30;
while k < kmax && norm(g(x)) > epsG
    if isd == 1 % gradient
        d = -g(x);
        dk = [dk, d];
        %[al, iWkk] = uo_BLS(x, d, f, g, almax, almin, rho, c1, c2, iW);
        [al, iWkk] = uo_BLSNW32(f, g, x, d, almax, c1, c2, maxit, epsilon);
        iWk = [iWk, iWkk];
        alk = [alk, al];
        x = x + al * d;
        xk = [xk, x];
        k = k + 1;
    elseif isd == 2 % cgm
        dk = [dk, d];
        dkm1 = d;
        gkm1 = g(x);
        %[al, iWkk] = uo_BLS(x, d, f, g, almax, almin, rho, c1, c2, iW);
        [al, iWkk] = uo_BLSNW32(f, g, x, d, almax, c1, c2, maxit, epsilon);
        iWk = [iWk, iWkk];
        alk = [alk, al];
        x = x + al * d;
        xk = [xk, x];
        k = k + 1;
        if icg == 1 % fr
            beta = max(0, g(x)' * g(x) / (gkm1' * gkm1));
        elseif icg == 2 % pr+
            beta = max(0, g(x)' * (g(x) - gkm1) / (gkm1' * gkm1));
        end
        betak = [betak, beta];
        if irc == 0 && k == 0 % no restart
            d = -g(x);
        elseif irc == 1 &&  mod(k, n) == 0 % rc1
            d = -g(x);
        elseif irc == 2 && (norm(g(x)' * gkm1) / (g(x)' * g(x))) >= nu %rc2
            d = -g(x);
        else
            d = -g(x) + beta * dkm1;
        end
    elseif isd == 3 % bfgs
        xkm1 = x;
        gkm1 = g(x);
        I = eye(n);
        d = - H * g(x);
        dk = [dk, d];
        %[al, iWkk] = uo_BLS(x, d, f, g, almax, almin, rho, c1, c2, iW);
        [al, iWkk] = uo_BLSNW32(f, g, x, d, almax, c1, c2, maxit, epsilon);
        iWk = [iWk, iWkk];
        alk = [alk, al];
        x = x + al * d;
        xk = [xk, x];
        sk = x - xkm1;
        yk = g(x) - gkm1;
        rhok = 1 / (yk' * sk);
        H = (I - rhok * sk * yk') * H * (I - rhok * yk * sk') + (rhok * sk) * sk';
        Hk = cat(3, Hk, H);
        k = k + 1;
    end
    tauk = [tauk, 0];
end
end

