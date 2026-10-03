function Rv = Rvalue1(A)
%RVALUE1 Secondary comparison value of an interval type-2 fuzzy number.
%
%   A  : 6-by-2 interval type-2 fuzzy number (see TypeCal1 for the layout).
%   Rv : scalar value computed as K3*K4 with
%           K1 = mean of the first and fourth upper breakpoints,
%           K2 = mean of the two membership heights (both columns),
%           K3 = K1 + K2,
%           K4 = mean of all eight trapezoid breakpoints.
%
% Provided as an optional ranking measure; the main optimisation loop only uses
% the interval centroid returned by Centric_center.

K1 = (A(1,1) + A(4,1))/2;
K2 = (A(5,1) + A(6,1) + A(5,2) + A(6,2))/4;
K3 = K1 + K2;
K4 = (sum(A(1:4,1)) + sum(A(1:4,2)))/8;
Rv = K3*K4;

end
