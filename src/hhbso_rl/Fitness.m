function [fitness, pc, p] = Fitness(i, state)
%FITNESS Apply one local-search operator to one individual.
%
%   i     : individual index in the population.
%   state : operator index, i.e. the RL action
%             1 -> TransAngA        (identity / re-encoding move)
%             2 -> two_optnew       (2-opt)
%             3 -> forward_insert2  (forward insertion)
%             4 -> backward_insert2 (backward insertion)
%
%   fitness : 3-by-1 interval centroid of the resulting route.
%   pc      : resulting depot-split route.
%   p       : resulting depot-free permutation.
%
%   Helper of the optional RL-based local search (see LocalSearch_rl): it lets
%   the agent evaluate one candidate operator before committing to it.

global population popcost PopulationCar

if state == 1
    [pc, p] = TransAngA(PopulationCar(i,:));
    fitness = quality2(pc);
end

if state == 2
    [pc, p, fitness] = two_optnew(PopulationCar(i,:));
end

if state == 3
    [pc, p, fitness] = forward_insert2(PopulationCar(i,:));
end

if state == 4
    [pc, p, fitness] = backward_insert2(PopulationCar(i,:));
end

end
