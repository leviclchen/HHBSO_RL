function Fx = ConstrStaA(Xs)
%CONSTRSTAA Check the crisp capacity constraint of a depot-split route.
%
%   Xs : route vector containing depot nodes (value 1).
%   Fx : number of sub-routes whose summed demand exceeds the capacity,
%        i.e. 0 when the route is feasible.
%
%   The check uses the crisp cumulative demands in the global vector comp and the
%   crisp capacity. The main algorithm uses the fuzzy variant car_insert3 instead;
%   this function is provided for post-optimality validation only.

global comp capacity

Tx = find(Xs == 1);
S  = zeros(length(Tx)-1,1);

for i = 1:length(Tx)-1
    temp = Xs(Tx(i)+1:Tx(i+1)-1);
    S(i) = sum(comp(temp));
end

Fl = find(S > capacity);
Fx = length(Fl);

end
