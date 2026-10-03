function [Xc, X1, cost] = backward_insert2(X)
%BACKWARD_INSERT2 Backward insertion move within one sub-route.
%
%   X    : route vector containing depot nodes.
%   Xc   : the resulting route (with depot nodes).
%   X1   : the same route without depot nodes.
%   cost : 3-by-1 interval centroid of the resulting route.
%
% Two customers of a randomly chosen sub-route are selected and the second one is
% moved backward to the position of the first one, so every customer in between
% is shifted one position towards the end of the sub-route.

Xnew = X;

index11 = find(X == 1);                 % depot positions
len  = NumberCarx(X);                   % customers per sub-route
lis  = find(len >= 2);                  % sub-routes with >= 2 customers
path_index = randperm(length(lis), 1);
index = lis(path_index);                % selected sub-route
X_old = X(index11(index)+1:index11(index+1)-1);

r  = X_old(randperm(length(X_old), 2));
t1 = r(1);
t2 = r(2);

index1 = find(X_old == t1);
index2 = find(X_old == t2);

if index1 < index2
    nodeC  = t2;
    nStep  = index2 - index1;           % number of shifts
    k2     = index2;
    id_min = index1;
else
    nodeC  = t1;
    nStep  = index1 - index2;
    k2     = index1;
    id_min = index2;
end

for i = 1:nStep
    X_old(k2) = X_old(k2-1);
    k2 = k2 - 1;
end
X_old(id_min) = nodeC;

Xnew(index11(index)+1:index11(index+1)-1) = X_old;

[Xc, X1] = TransAngA(Xnew);
cost = quality2(Xc);

end
