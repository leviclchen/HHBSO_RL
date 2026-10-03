function [child1, child2, min_index, start_c] = heuristic_crossover(parent1, parent2)
%HEURISTIC_CROSSOVER Heuristic (greedy edge) crossover for permutation problems.
%
%   parent1, parent2 : parent tours, plain customer permutations without
%                      depot nodes.
%   child1, child2   : offspring tours, also free of depot nodes.
%   min_index        : index (1 or 2) of the offspring with the smaller fuzzy
%                      objective value, so that the caller can pick the better one.
%   start_c          : the randomly chosen starting city.
%
% child1 is built by repeatedly appending the successor of the current city that
% is closer to it in either parent; child2 is built in the same way but walking
% to the left, which gives the second offspring a different structure.

global cost_matrix sizex

n = sizex;                      % number of customers
child1 = zeros(1,n);
child2 = zeros(1,n);
start  = randperm(n,1) + 1;     % random starting city
start_c = start;
child1(1) = start;
child2(1) = start;

%% ---------------- child1: follow the nearest right neighbour ------------
parent1_c1 = parent1;
parent2_c1 = parent2;
pos = 2;
while numel(parent1_c1) ~= 1
    start1 = find(parent1_c1 == start, 1, 'first');     % position in parent1
    start2 = find(parent2_c1 == start, 1, 'first');     % position in parent2

    if start1 == numel(parent1_c1)
        right1 = parent1_c1(1);                         % wrap around
    else
        right1 = parent1_c1(start1+1);
    end

    if start2 == numel(parent2_c1)
        right2 = parent2_c1(1);                         % wrap around
    else
        right2 = parent2_c1(start2+1);
    end

    if cost_matrix(start,right1) <= cost_matrix(start,right2)
        child1(pos) = right1;
    else
        child1(pos) = right2;
    end

    parent1_c1(parent1_c1 == start) = [];
    parent2_c1(parent2_c1 == start) = [];
    start = child1(pos);
    pos   = pos + 1;
end

%% ---------------- child2: follow the nearest left neighbour -------------
parent1_c2 = parent1;
parent2_c2 = parent2;
start = start_c;
pos   = 2;
while numel(parent1_c2) ~= 1
    start1 = find(parent1_c2 == start, 1, 'first');
    start2 = find(parent2_c2 == start, 1, 'first');

    if start1 == 1
        left1 = parent1_c2(end);                        % wrap around
    else
        left1 = parent1_c2(start1-1);
    end

    if start2 == 1
        left2 = parent2_c2(end);                        % wrap around
    else
        left2 = parent2_c2(start2-1);
    end

    if cost_matrix(left1,start) <= cost_matrix(left2,start)
        child2(pos) = left1;
    else
        child2(pos) = left2;
    end

    parent1_c2(parent1_c2 == start) = [];
    parent2_c2(parent2_c2 == start) = [];
    start = child2(pos);
    pos   = pos + 1;
end

%% ---------------- pick the better offspring ------------------------------
len1 = quality2(car_insert3(child1));
len2 = quality2(car_insert3(child2));
[~, min_index] = min([len1, len2]);

end
