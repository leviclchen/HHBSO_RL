function [r1, rx, cost] = two_optnew(r)
%TWO_OPTNEW Intra-route 2-opt move.
%
%   r    : route vector containing depot nodes.
%   r1   : the candidate route (with depot nodes).
%   rx   : the same candidate without depot nodes.
%   cost : 3-by-1 interval centroid of the candidate, returned by quality2.
%
% A sub-route with at least two customers is selected and its order between two
% randomly chosen customers is reversed.

% The original implementation opened with an unreachable branch guarded by
% "if rand < 0" (an alternative 2-opt with a capacity-repair step). The branch
% is removed, but its random draw is preserved so that the global random stream
% - and therefore the reproducibility of previously published runs - is
% unchanged.
rand(); %#ok<NASGU>

Xc = NumberCarx(r);
a  = find(r == 1);
b  = length(a) - 1;

c  = randperm(b, 1);            % select a sub-route
d1 = Xc(c);
while d1 < 2                    % ... that serves at least two customers
    c  = randperm(b, 1);
    d1 = Xc(c);
end

t_list = randperm(d1, 2);       % two distinct customers on that sub-route
t1 = min(t_list);
t2 = max(t_list);
k1 = a(c) + t1;
k2 = a(c) + t2;

ts1 = r(1:k1-1);
ts2 = r(k1:k2);
ts3 = r(k2+1:length(r));
tx  = [ts1 flip(ts2) ts3];      % reverse the selected segment

[r1, rx] = TransAngA(tx);
cost = quality2(r1);

end
