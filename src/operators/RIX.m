function [y1, y2, min_index] = RIX(x1, x2)
%RIX_NEW Route-exchange crossover for permutation problems.
%
%   x1, x2    : parent tours, plain customer permutations without depot nodes.
%   y1, y2    : offspring tours, also free of depot nodes.
%   min_index : 1 or 2, indicating which offspring has the smaller fuzzy
%               objective value.
%
% A random number b of sub-routes is taken from the depot-split version of one
% parent and prepended to the other parent, from which the corresponding
% customers have been removed beforehand.

global n

b = randi([1,n]);                       % number of exchanged sub-routes

%% ---------------- offspring 1 -------------------------------------------
y1  = x1;
y11 = car_insert3(x2);                  % depot-split version of parent 2
T   = find(y11 == 1);                   % depot positions
Tx  = T(1:size(T,2)-1);
for j = 1:b
    i  = randi([1,size(Tx,2)]);         % pick one sub-route
    y1 = setdiff(y1, y11(T(i)+1:T(i+1)-1), 'stable');   % remove its customers
    y1 = [y11(T(i)+1:T(i+1)-1) y1];                     % and prepend them again
end

%% ---------------- offspring 2 -------------------------------------------
y2  = x2;
y11 = car_insert3(x1);                  % depot-split version of parent 1
T   = find(y11 == 1);
Tx  = T(1:size(T,2)-1);
for j = 1:b
    i  = randi([1,size(Tx,2)]);
    y2 = setdiff(y2, y11(T(i)+1:T(i+1)-1), 'stable');
    y2 = [y11(T(i)+1:T(i+1)-1) y2];
end

len1 = quality2(car_insert3(y1));
len2 = quality2(car_insert3(y2));
[~, min_index] = min([len1, len2]);

end
