function [Xc, X1, cost] = forward_insert2(X)
%FORWARD_INSERT2 Forward insertion move within one sub-route.
%
%   X    : route vector containing depot nodes.
%   Xc   : the resulting route (with depot nodes).
%   X1   : the same route without depot nodes.
%   cost : 3-by-1 interval centroid of the resulting route.
%
% Two customers of a randomly chosen sub-route are selected and the first one is
% moved forward to the position of the second one, so every customer in between
% is shifted one position towards the depot.

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
    nodeB = t1;
    nStep = index2 - index1;            % number of shifts
    k1    = index1;
    id_max = index2;
else
    nodeB = t2;
    nStep = index1 - index2;
    k1    = index2;
    id_max = index1;
end

for i = 1:nStep
    X_old(k1) = X_old(k1+1);
    k1 = k1 + 1;
end
X_old(id_max) = nodeB;

Xnew(index11(index)+1:index11(index+1)-1) = X_old;

[Xc, X1] = TransAngA(Xnew);
cost = quality2(Xc);

end
