function Fl = ChackRoute(Xt, Xb)
%CHACKROUTE Consistency check between a depot-split route and its permutation.
%
%   Xt : route vector containing depot nodes (value 1).
%   Xb : the corresponding depot-free customer permutation.
%   Fl : 0 when the two representations describe the same tour, otherwise the
%        largest absolute difference between the customer sequences.
%
%   Used to validate the population after initialisation.

Tx = find(Xt == 1);
Xa = [];
for i = 1:length(Tx)-1
    temp = Xt(Tx(i)+1:Tx(i+1)-1);
    Xa = [Xa temp];
end

X  = Xa - Xb;
Fl = max(abs(X));       % 0 means the two representations match

end
