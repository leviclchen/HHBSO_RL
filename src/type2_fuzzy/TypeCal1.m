function X = TypeCal1(A, B, lan, Index)
%TYPECAL1 Interval type-2 fuzzy arithmetic on 6-by-2 interval matrices.
%
%   A, B  : 6-by-2 matrices describing a trapezoidal interval type-2 fuzzy
%           number. Row layout:
%               rows 1..4 : the four breakpoints of the trapezoid
%               row  5    : height of the upper membership function
%               row  6    : height of the lower membership function
%           Column 1 holds the left elements and column 2 the right elements
%           of the corresponding interval.
%   lan   : scalar coefficient used by operations 3 and 4.
%   Index : operation selector
%               1 -> addition            A + B
%               2 -> multiplication      A .* B
%               3 -> scalar product      lan * A
%               4 -> scalar division     A / lan
%               5 -> negation            -A  (trapezoid mirrored about the
%                                            vertical axis, rows reversed)
%
%   X     : result, same 6-by-2 layout as the inputs.
%
% Notes
%   * Operations 1 and 2 combine the membership heights with the minimum
%     operator, which is the standard intersection rule for type-2 fuzzy sets.
%   * Operations 3 and 4 are scaling operations, so the membership heights are
%     copied unchanged.

X = A;

if Index == 1                       % addition
    X(:,1) = A(:,1) + B(:,1);
    X(:,2) = A(:,2) + B(:,2);
    X(5,1) = min(A(5,1), B(5,1));
    X(5,2) = min(A(5,2), B(5,2));
    X(6,1) = min(A(6,1), B(6,1));
    X(6,2) = min(A(6,2), B(6,2));

elseif Index == 2                   % multiplication
    X(:,1) = A(:,1) .* B(:,1);
    X(:,2) = A(:,2) .* B(:,2);
    X(5,1) = min(A(5,1), B(5,1));
    X(5,2) = min(A(5,2), B(5,2));
    X(6,1) = min(A(6,1), B(6,1));
    X(6,2) = min(A(6,2), B(6,2));

elseif Index == 3                   % multiply by the scalar lan
    X(:,1) = lan * A(:,1);
    X(:,2) = lan * A(:,2);
    X(5,1) = A(5,1);
    X(5,2) = A(5,2);
    X(6,1) = A(6,1);
    X(6,2) = A(6,2);

elseif Index == 4                   % divide by the scalar lan
    X(:,1) = A(:,1) / lan;
    X(:,2) = A(:,2) / lan;
    X(5,1) = A(5,1);
    X(5,2) = A(5,2);
    X(6,1) = A(6,1);
    X(6,2) = A(6,2);

elseif Index == 5                   % negation (mirror the trapezoid)
    X(1,1) = -A(4,1);
    X(2,1) = -A(3,1);
    X(3,1) = -A(2,1);
    X(4,1) = -A(1,1);
    X(1,2) = -A(4,2);
    X(2,2) = -A(3,2);
    X(3,2) = -A(2,2);
    X(4,2) = -A(1,2);
    X(5,1) = A(5,1);
    X(5,2) = A(5,2);
    X(6,1) = A(6,1);
    X(6,2) = A(6,2);
end

end
