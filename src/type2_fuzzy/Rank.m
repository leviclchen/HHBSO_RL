function R = Rank(A)
%RANK Ranking index of a trapezoidal interval type-2 fuzzy number.
%
%   A : 6-by-2 interval type-2 fuzzy number (see TypeCal1 for the layout).
%   R : scalar ranking value
%           R = 0.1*c + 0.9*(y_r - y_l)
%       where [y_l, y_r] is the interval centroid and c its midpoint.
%
% The index favours fuzzy numbers whose centroid interval is narrow and whose
% midpoint is large. It is provided as an optional comparison measure and is
% not required by the main optimisation loop.

Cen = Centric_center(A);
R   = 0.1*Cen(3) + 0.9*(Cen(2) - Cen(1));

end
