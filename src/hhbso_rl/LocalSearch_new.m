function [pcost, pop, popc] = LocalSearch_new(cost, p, pc, n)
%LOCALSEARCH_NEW Local search over a random sub-population.
%
%   cost : 3-by-N matrix of interval centroids of the population.
%   p    : N-by-sizex depot-free permutations.
%   pc   : N-by-(sizex+n+1) depot-split routes.
%   n    : population size (NIND).
%
%   A random sample of n/5 individuals, drawn from the index range
%   [11, n-10], is improved by the Local_3 neighbourhood operator. A candidate
%   replaces its parent only if it achieves a smaller cost.
%
%   NOTE: the index range [11, n-10] requires a population larger than about
%   20 individuals; with the default sizey = 100 it evaluates to [11, 90].

% popcost, population, PopulationCar
random_int = randi([11, n-10], 1, 1/5*n);
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
