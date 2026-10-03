function [pcost, pop, popc] = LocalSearch_new2(cost, p, pc, n)
%LOCALSEARCH_NEW2 Local search over the complete population.
%
%   cost : 3-by-N matrix of interval centroids of the population.
%   p    : N-by-sizex depot-free permutations.
%   pc   : N-by-(sizex+n+1) depot-split routes.
%   n    : population size (NIND).
%
%   Every individual is improved by the Local_3 neighbourhood operator. A
%   candidate replaces its parent only if it achieves a smaller cost. This is the
%   local search used by the brain-storm variants IDBSO_new2 and IDBSO_new3.

% popcost, population, PopulationCar
for i = 1:n
    [rc, r, rcost] = Local_3(pc(i,:));
    if ~isempty(rcost)
        [a, b] = sort(rcost);
        rc    = rc(b,:);
        r     = r(b,:);
        rcost = a;
        if rcost(1) < cost(i)
            p(i,:)  = r(1,:);
            pc(i,:) = rc(1,:);
            cost(i) = rcost(1);
        end
    end
end

pcost = cost;
pop   = p;
popc  = pc;

end
