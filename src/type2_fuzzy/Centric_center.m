function Cen = Centric_center(X)
%CENTRIC_CENTER Centroid of a trapezoidal interval type-2 fuzzy number.
%
%   X : 6-by-2 matrix describing a trapezoidal interval type-2 fuzzy number.
%           X(:,1) : parameters of the upper membership function
%                    [p1 ; p2 ; p3 ; p4 ; height_upper ; height_lower]
%           X(:,2) : parameters of the lower membership function, same layout.
%
%   Cen : 3-by-1 vector [y_l ; y_r ; (y_l + y_r)/2], i.e. the interval centroid
%         obtained by type reduction together with its midpoint.
%
% The upper and lower membership functions are first sampled as m alpha-cut
% intervals (YH and YL) and handed to Centric, which performs the actual
% discretisation and EKM type reduction.

A = X;

% Flatten the 6-by-2 trapezoid into a 10-element parameter vector:
%   v(1:5)  = upper membership parameters
%   v(6:10) = lower membership parameters
% The original implementation produced the same vector with the two statements
%   X(1:5)  = A(1:5,1);
%   X(6:10) = A(1:5,2);
% which relies on column-major linear indexing of the 6-by-2 matrix.
v = [A(1:5,1); A(1:5,2)];

m  = 20;                            % number of alpha-cuts
Y1 = linspace(0.02, v(5), m);       % alpha levels of the upper membership fn
YH = zeros(m,2);
for i = 1:m
    YH(i,1) = (1 - Y1(i))*(v(1) - v(2)) + v(2);
    YH(i,2) = Y1(i)*(v(3) - v(4)) + v(4);
end
Xa = Y1;                            % alpha levels handed over to Centric

Y1 = linspace(0.02, v(10), m);      % alpha levels of the lower membership fn
YL = zeros(m,2);
for i = 1:m
    YL(i,1) = v(7) + (v(10) - Y1(i))*(v(6) - v(7))/v(10);
    YL(i,2) = Y1(i)*(v(8) - v(9))/v(10) + v(9);
end

Cen = Centric(YH, YL, Xa);

end
