function route2 = Swap(route1)
%SWAP Exchange two randomly chosen positions of a route.
%
%   route1 : route vector (depot nodes included or not - both are accepted).
%   route2 : route1 with two randomly selected positions exchanged.
%
% Example: with a six-city route 1 2 3 1 4 5 6 7 1 and the two positions 2 and
% 5 selected, the result is 1 5 3 1 4 2 6 7 1. No capacity or depot structure is
% changed: the move only swaps two genes.

n = length(route1);
seq = randperm(n);
I  = seq(1:2);
i1 = I(1);
i2 = I(2);

route2 = route1;
route2([i1 i2]) = route1([i2 i1]);

end
