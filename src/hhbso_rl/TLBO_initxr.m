function TLBO_initxr(Matrix, NP, numGenerations) %#ok<INUSD>
%TLBO_INITXR Randomised population initialisation for the HHBSO-RL algorithm.
%
%   Matrix          : cost matrix of the instance (unused, kept for signature
%                     compatibility with the original implementation).
%   NP              : population size.
%   numGenerations  : generation budget (stored in the global num).
%
%   Creates the three population representations used throughout the algorithm
%      population    : NP-by-sizex customer permutations without depot nodes
%      PopulationCar : NP-by-(sizex+n+1) depot-split routes
%      popcost       : 3-by-NP interval centroids, one column per individual
%
% Every individual is generated as a random customer permutation that is split
% into feasible truck routes by car_insert3 and evaluated by quality2.

global populationsize num numVar population popcost sizex n PopulationCar

population    = [];
PopulationCar = [];
popcost       = [];

numVar         = sizex + 1;     % number of customers plus one
populationsize = NP;
num            = numGenerations;

i = 1;
while i <= NP + 2
    index1 = randperm(numVar-1) + 1;        % random customer permutation
    test   = car_insert3(index1);           % insert the depot nodes
    cost1  = quality2(test);

    if ~isnan(test)
        PopulationCar = [PopulationCar; test];
        popcost       = [popcost cost1];
        population    = [population; index1];
        i = i + 1;
    end
end

% trim the (up to three) surplus individuals created by the loop condition
population    = population(1:NP,:);
PopulationCar = PopulationCar(1:NP,:);
popcost       = popcost(:,1:NP);

end
