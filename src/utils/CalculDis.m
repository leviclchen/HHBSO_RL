function DSor = CalculDis()
%CALCULDIS Rank all customers by their distance to every other customer.
%
%   DSor : (number of points)-by-(number of points) matrix. Row i contains the
%          indices of all other points sorted by increasing distance from point i
%          (nearest neighbour first).
%
%   Used as a precomputed neighbourhood table, e.g. by construction heuristics.

global cost_matrix points

ny   = size(cost_matrix,2);
DSor = [];

for i = 1:size(points,1)
    Tx = cost_matrix(i,2:ny);
    [a, b] = sort(Tx);
    DSor = [DSor; b+1];
end

end
