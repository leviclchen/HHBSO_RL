function [r1, rx, cost] = Local_3(r)
%LOCAL_3 Local search neighbourhood around a single route.
%
%   r    : route vector containing depot nodes.
%   r1   : candidate routes, one candidate per row.
%   rx   : the same candidates with the depot nodes removed.
%   cost : 3-by-k matrix of interval centroids, one column per candidate.
%
% Four neighbours are generated: a swap of a customer with its successor,
% a 2-opt move, a forward insertion and a backward insertion.

global sizex ite max_iter

r1 = []; rx = []; cost = [];

%% select two distinct sub-routes (kept from the original implementation; the
%% result is not used downstream, but the draw is kept so that the random
%% stream - and therefore run reproducibility - is unchanged)
a = find(r == 1);
b = length(a) - 1;
c_list = randperm(b, 2); %#ok<NASGU>

%% select a sub-route with at least two customers
a  = find(r == 1);
b  = length(a) - 1;
Xc = NumberCarx(r);
Xf = find(Xc > 1);
c1 = randperm(length(Xf), 1);
c1 = Xf(c1);                    % sub-route index
d1 = Xc(c1);                    % number of customers on that sub-route
t1 = randperm(d1-1, 1);         % pick one customer on the sub-route
k1 = a(c1) + t1;

tx = r;                         % exchange the customer with its successor
tx(k1)   = r(k1+1);
tx(k1+1) = r(k1);

[r7_, Xt7] = TransAngA(tx);
cost1 = quality2(r7_);
r1 = [r1; r7_];  rx = [rx; Xt7];  cost = [cost cost1];

%% 2-opt move
[rt_, Xt, nCost] = two_optnew(r);
r1 = [r1; rt_];  rx = [rx; Xt];  cost = [cost nCost];

%% forward insertion
[rt_, Xt, nCost] = forward_insert2(r);
r1 = [r1; rt_];  rx = [rx; Xt];  cost = [cost nCost];

%% backward insertion
[rt_, Xt, nCost] = backward_insert2(r);
r1 = [r1; rt_];  rx = [rx; Xt];  cost = [cost nCost];

end
