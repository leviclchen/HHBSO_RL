function [state, minV] = normalization_new(cost)
%NORMALIZATION_NEW Map the population cost vector to a discrete RL state.
%
%   cost : 3-by-N matrix of interval centroids, one column per individual.
%   state: discrete state index in 1 .. 5 describing how concentrated the
%          population is on its best solution.
%   minV : best objective value of the population.
%
% The state is derived from the fraction of individuals whose objective equals
% the population minimum:
%   fraction < 0.2                -> state 1 (population is very diverse)
%   0.2 <= fraction < 0.4         -> state 2
%   0.4 <= fraction < 0.6         -> state 3
%   0.6 <= fraction < 0.8         -> state 4
%   fraction >= 0.8               -> state 5 (population has converged)

minV  = min(cost);
count = sum(cost == minV);
temp  = count/size(cost,2);

if temp < 0.2
    state = 1;
elseif temp >= 0.2 && temp < 0.4
    state = 2;
elseif temp >= 0.4 && temp < 0.6
    state = 3;
elseif temp >= 0.6 && temp < 0.8
    state = 4;
else
    state = 5;
end

end
