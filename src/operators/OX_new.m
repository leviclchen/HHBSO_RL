function [y1, y2, min_index] = OX_new(x1, x2)
%OX_NEW Order crossover (OX) for permutation problems.
%
%   x1, x2    : parent tours, plain customer permutations without depot nodes.
%   y1, y2    : offspring tours, also free of depot nodes.
%   min_index : 1 or 2, indicating which offspring has the smaller fuzzy
%               objective value.
%
% A random segment of x1 is copied to y1 while keeping its absolute position;
% the remaining positions are filled, in order, with the customers of x2 that
% are not part of the segment. The second offspring is built symmetrically.

point       = randperm(length(x1), 2);
start_point = min(point);
end_point   = max(point);

if start_point == 1
    start_point = start_point + 1;      % keep position 1 for the wrap-around copy
end

retain1 = x1(start_point:end_point);
retain2 = x2(start_point:end_point);

% remove the retained customers from the other parent
x2t = x2;
for j = 1:length(retain1)
    te = find(x2t == retain1(j));
    x2t(te) = [];
end

x1t = x1;
for j = 1:length(retain2)
    te = find(x1t == retain2(j));
    x1t(te) = [];
end

%% ---------------- offspring 1 -------------------------------------------
for j = 1:start_point-1
    offspring1(j) = x2t(j);
end
x2t(1:start_point-1) = [];

j1 = 1;
for j = start_point:end_point
    offspring1(j) = retain1(j1);
    j1 = j1 + 1;
end

j1 = 1;
for j = end_point+1:length(x1)
    offspring1(j) = x2t(j1);
    j1 = j1 + 1;
end

%% ---------------- offspring 2 -------------------------------------------
for j = 1:start_point-1
    offspring2(j) = x1t(j);
end
x1t(1:start_point-1) = [];

j1 = 1;
for j = start_point:end_point
    offspring2(j) = retain2(j1);
    j1 = j1 + 1;
end

j1 = 1;
for j = end_point+1:length(x1)
    offspring2(j) = x1t(j1);
    j1 = j1 + 1;
end

y1 = offspring1;
y2 = offspring2;

len1 = quality2(car_insert3(y1));
len2 = quality2(car_insert3(y2));
[~, min_index] = min([len1, len2]);

end
