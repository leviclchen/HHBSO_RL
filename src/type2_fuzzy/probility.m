function p = probility(t, s)
%PROBILITY Possibility measure used for the fuzzy capacity constraint.
%
%   t : 6-by-2 interval type-2 fuzzy available capacity.
%   s : 6-by-2 interval type-2 fuzzy accumulated demand.
%   p : possibility degree in [0,1] that the accumulated demand exceeds the
%       available capacity.
%
% The measure is expressed as (a + b)/(c + d) and clipped to the unit interval:
%   a : difference of the "core" breakpoints (rows 3 and 4),
%   b : positive part of the membership-height differences,
%   c : spread of the breakpoints of both fuzzy numbers,
%   d : absolute membership-height differences.
%
% The constraint is considered satisfied when p is larger than the confidence
% level alpha used in car_insert3.

a = s(3,1) + s(3,2) + s(4,1) + s(4,2) - (t(1,1) + t(1,2) + t(2,1) + t(2,2));
b = max(s(5,1)-t(5,1),0) + max(s(5,2)-t(5,2),0) ...
  + max(s(6,1)-t(6,1),0) + max(s(6,2)-t(6,2),0);
c = s(3,1) + s(4,1) - s(2,1) - s(1,1) + s(3,2) + s(4,2) - s(2,2) - s(1,2) ...
  + t(3,1) + t(4,1) - t(2,1) - t(1,1) + t(3,2) + t(4,2) - t(2,2) - t(1,2);
d = abs(s(5,1)-t(5,1)) + abs(s(5,2)-t(5,2)) ...
  + abs(s(6,1)-t(6,1)) + abs(s(6,2)-t(6,2));

y = (a + b)/(c + d);
p = min(max(y,0),1);

end
