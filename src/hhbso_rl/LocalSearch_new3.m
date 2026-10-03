function [pcost, pop, popc] = LocalSearch_new3(cost, p, pc, n)
%LOCALSEARCH_NEW3 Local search over the better half of the population.
%
%   cost : 3-by-N matrix of interval centroids of the population.
%   p    : N-by-sizex depot-free permutations.
%   pc   : N-by-(sizex+n+1) depot-split routes.
%   n    : population size (NIND).
%
%   n/4 individuals are drawn from the range [1, n/2] - that is from the better
%   half of the already sorted population - and improved by the Local_3
%   neighbourhood operator. This is the local search used by IDBSO_new4.

% popcost, population, PopulationCar
random_int = randi([1, n/2], 1, n/4);
for i = 1:1/5*n
    [rc, r, rcost] = Local_3(pc(random_int(i),:));
    if ~isempty(rcost)
        [a, b] = sort(rcost);
        rc    = rc(b,:);
        r     = r(b,:);
        rcost = a;
        if rcost(1) < cost(random_int(i))
            p(random_int(i),:)  = r(1,:);
            pc(random_int(i),:) = rc(1,:);
            cost(random_int(i))= rcost(1);
        end
    end
end

pcost = cost;
pop   = p;
popc  = pc;

end
