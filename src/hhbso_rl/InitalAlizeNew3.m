function W = InitalAlizeNew3(n)
%INITALALIZENEW3 Build the interval weights of the objective function.
%
%   n : number of weight sets to build (index 2 is the distance weight and
%       index 3 the cost weight used by quality2; the remaining sets are kept
%       for experimentation).
%   W : 6-by-2-by-n array of trapezoidal interval type-2 fuzzy weights, sorted
%       from the largest (index 1) to the smallest (index n). Each (:,:,k) slice
%       follows the layout documented in TypeCal1, i.e. column 1 is the upper
%       and column 2 the lower membership function.
%
% Example of one weight set:
%   upper: [9.0 ; 10 ; 10 ; 10 ; 1 ; 1]
%   lower: [8.0 ; 10 ; 10 ; 10 ; 1 ; 1]

W = zeros(6,2,n);

X2 = [9.0; 10;  10; 10; 1; 1];
X1 = [8.0; 10;  10; 10; 1; 1];
W(:,1,1) = X1;  W(:,2,1) = X2;

X1 = [5;   6;   7.6; 8.6; 1;   1];
X2 = [5.5; 6.5; 7.5; 8.5; 0.8; 0.8];
W(:,1,2) = X1;  W(:,2,2) = X2;

X1 = [3;   4;   5.6; 6.6; 1;   1];
X2 = [3.5; 4.5; 5.5; 6.5; 0.8; 0.8];
W(:,1,3) = X1;  W(:,2,3) = X2;

X1 = [1;   2;   3.6; 4.6; 1;   1];
X2 = [1.2; 2.2; 3.3; 4.5; 0.8; 0.8];
W(:,1,4) = X1;  W(:,2,4) = X2;

X1 = [0; 0; 0; 2;   1; 1];
X2 = [0; 0; 0; 0.8; 1; 1];
W(:,1,5) = X1;  W(:,2,5) = X2;

% The original implementation contained "W(1:4,:) = W(1:4,:);", a no-op that has
% been removed. The membership-function shapes of a weight set can be inspected
% with scripts/plot_it2_membership.m.

end
