function Y = EKM(X, W)
%EKM Enhanced Karnik-Mendel (EKM) type reduction of an interval type-2 fuzzy set.
%
%   X : n-by-2 matrix of discretised primary-variable samples.
%       Column 2 is used for the left endpoint and column 2 for the right one.
%   W : n-by-2 matrix of interval membership grades that correspond to the
%       samples in X. Column 1 is the lower and column 2 the upper grade.
%
%   Y : 1-by-2 vector [y_l, y_r] holding the left and right endpoints of the
%       type-reduced interval centroid.
%
% The algorithm estimates an initial switch point, then moves it monotonically
% towards the exact switch point until it no longer changes. The two endpoints
% are computed independently.
%
% NOTE: the original implementation called "format long" here, which changes the
% display format of the whole MATLAB session. Callers that need full precision
% should set the format themselves.

e = 1e-13;                          % small constant guarding division by zero
N = 100;                            % maximum number of switch-point updates
d = size(X);
Y = zeros(1,2);

%% ------------------------- left endpoint y_l -------------------------
xa = X(:,1);
[Xc, sx] = sort(xa);                % sort the primary variable
W1 = W(:,1);
W2 = W(:,2);
wx1 = W1(sx);
wx2 = W2(sx);

K  = round(d(1)/2.4);               % initial switch point
T1 = Xc(1:K);
T2 = Xc(K+1:d(1));
Twl = wx2(1:K);
Twr = wx1(K+1:d(1));
a = sum(T1.*Twl) + sum(T2.*Twr);
b = sum(Twl) + sum(Twr);
yt = a/(b+e);                       % current centroid estimate

Kt = 1;
for i = 1:N
    for j1 = 1:d(1)-1
        if Xc(j1) <= yt && Xc(j1+1) >= yt
            Kt = j1;                % switch point implied by yt
            break;
        end
    end

    if Kt == K
        Y(1) = yt;                  % converged
        break;
    else
        s   = (Kt - K)/abs(Kt - K);
        s1  = min([Kt K]);
        s2  = max([Kt K]);
        Tc  = wx2([s1+1 s2]);
        Tcl = wx1([s1+1 s2]);
        Tcx = Tc - Tcl;
        Xcl = Xc([s1+1 s2]);
        ac  = a + s*sum(Tcx.*Xcl);
        bc  = b + s*sum(Tcx);
        Ytc = ac/(bc+e);
        K   = Kt;
        yt  = Ytc;
        a   = ac;
        b   = bc;
    end
end

%% ------------------------- right endpoint y_r -------------------------
xb = X(:,2);
[Xcb, sxb] = sort(xb);              % sort the primary variable
W1 = W(:,1);
W2 = W(:,2);
wx1 = W1(sxb);
wx2 = W2(sxb);

K  = round(d(1)/1.7);               % initial switch point
T1 = Xcb(1:K);
T2 = Xcb(K+1:d(1));
Twl = wx1(1:K);
Twr = wx2(K+1:d(1));
a = sum(T1.*Twl) + sum(T2.*Twr);
b = sum(Twl) + sum(Twr);
yt = a/b;

Kt = 1;
for i = 1:N
    for j1 = 1:d(1)-1
        if Xcb(j1) <= yt && Xcb(j1+1) >= yt
            Kt = j1;
            break;
        end
    end

    if Kt == K
        Y(2) = yt;                  % converged
        break;
    else
        s   = (Kt - K)/abs(Kt - K);
        s1  = min([Kt K]);
        s2  = max([Kt K]);
        Tc  = wx2([s1+1 s2]);
        Tcl = wx1([s1+1 s2]);
        Tcx = Tc - Tcl;
        Xcl = Xcb([s1+1 s2]);
        ac  = a - s*sum(Tcx.*Xcl);
        bc  = b - s*sum(Tcx);
        Ytc = ac/(bc+e);
        K   = Kt;
        yt  = Ytc;
        a   = ac;
        b   = bc;
    end
end

end
