function Cen = Centric(Ah, Al, Y)
%CENTRIC Interval centroid of an interval type-2 fuzzy set.
%
%   Ah : m-by-2 matrix with the left/right endpoints of the upper membership
%        function alpha-cuts.
%   Al : m-by-2 matrix with the left/right endpoints of the lower membership
%        function alpha-cuts.
%   Y  : m-by-1 vector of the alpha levels that generated Ah and Al.
%
%   Cen : 3-by-1 vector [y_l ; y_r ; (y_l + y_r)/2], i.e. the interval
%         centroid together with its midpoint.
%
% The primary variable is discretised into N samples. For each sample the
% interval membership grade is obtained by locating the enclosing alpha-cut
% segments of the upper and the lower membership function. The resulting
% interval type-2 fuzzy set is then reduced with the EKM algorithm.

d  = size(Ah);
Bh = Al;
N  = 100;

a = min(Ah(1,1), Bh(1,1));
b = max(Ah(1,2), Bh(1,2));
X = linspace(a, b, N);              % discretised primary variable

St = zeros(N,2);                    % interval membership grades
Xt = zeros(N,2);                    % primary variable (both columns)
Xt(:,1) = X';
Xt(:,2) = X';

for i = 1:N-1
    %% locate the alpha-cut segment of the upper membership function
    if X(i) <= Ah(d(1),1)
        for j = 1:d(1)
            if X(i) < Ah(j,1)
                break;
            end
        end
    else
        for j = 1:d(1)
            if X(i) <= Ah(d(1)-j+1,2)
                break;
            end
        end
    end

    %% locate the alpha-cut segment of the lower membership function
    if X(i) <= Bh(d(1),1)
        for k = 1:d(1)
            if X(i) < Bh(k,1)
                break;
            end
        end
    else
        for k = 1:d(1)
            % FIX: the original code compared against Ah with the stale loop
            % index j, i.e. "X(i) <= Ah(d(1)-j+1,2)". It must use the lower
            % membership function Bh and its own index k.
            if X(i) <= Bh(d(1)-k+1,2)
                break;
            end
        end
    end

    St(i,1) = Y(k);                 % lower membership grade
    St(i,2) = Y(j);                 % upper membership grade
end

Cen1    = EKM(Xt, St);
Cen     = zeros(3,1);
Cen(1:2)= Cen1;
Cen(3)  = (Cen1(1) + Cen1(2))/2.0;

end
