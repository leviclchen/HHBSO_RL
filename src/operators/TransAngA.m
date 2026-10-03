function [Xs, Xa] = TransAngA(Xt)
%TRANSANGA Convert a depot-split route into its depot-free representation.
%
%   Xt : route vector containing depot nodes (value 1).
%   Xs : the same route, zero-padded to the full length sizex+n+1.
%   Xa : the customer sequence with all depot nodes removed.

global sizex n

Tx = find(Xt == 1);
Xa = [];
Xs = Xt;

for i = 1:length(Tx)-1
    temp = Xt(Tx(i)+1:Tx(i+1)-1);
    Xa = [Xa temp];
end

if length(Xs) < sizex+n+1
    Xs = [Xs zeros(1, sizex+n+1-length(Xs))];
end

end
