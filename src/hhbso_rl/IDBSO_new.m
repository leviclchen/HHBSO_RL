function [bestSolution, FEVAL, Solution] = IDBSO_new
%IDBSO_NEW Brain-storm variant 1: random fusion operator, random local search.
%
%   One generation of an improved brain-storm optimisation (BSO) variant.
%   Individuals are clustered by their position in the cost ranking; new
%   individuals are created either from a single cluster (an improved 2-opt move
%   is applied to the selected individual) or from two clusters (one of four
%   crossover operators is drawn uniformly). Every offspring is mutated by
%   Random_variation and replaces its parent only if it improves the fuzzy
%   objective. Finally a local search over a random sub-population is applied.
%
%   Outputs
%     bestSolution : depot-split route of the best individual
%     FEVAL        : right endpoint of its interval centroid
%     Solution     : the same individual as a depot-free permutation

global populationsize capacity population popcost PopulationCar
global sizey cluster_num p_replace p_one p_one_center p_two_center
global numVar NIND USE_RL_LOCAL_SEARCH

%% ---------------------------------------- sort the population by objective
% NOTE: popcost is 3-by-N (one interval centroid per individual), therefore the
% multi-output SORT returns a 3-by-N index matrix and population(index',:) is
% larger than the population itself. This behaviour is inherited from the
% original implementation and is kept unchanged so that published runs remain
% reproducible; see README.md ("Known issues") for a suggested cleaner variant.
[popcost, index] = sort(popcost);
population    = population(index',:);
PopulationCar = PopulationCar(index',:);

%% ------------------------------------------------------------- clustering
for i = 1:sizey
    Idx(i) = mod(i, cluster_num) + 1;    % round-robin cluster assignment
end

cluster       = cell(cluster_num,2);
order_cluster = cell(cluster_num,2);
for i = 1:cluster_num
    cluster{i,1}  = population(Idx == i,:);
    cluster_row(i)= size(cluster{i,1},1);
    for j = 1:cluster_row(i)
        Individual     = cluster{i,1}(j,:);
        Individual_car = car_insert3(Individual);
        cluster{i,2}(j,:) = quality2(Individual_car);
    end
    [order_cluster{i,2}, order_index] = sort(cluster{i,2});
    order_cluster{i,1} = cluster{i,1}(order_index,:);
end

%% --------- replace a randomly chosen cluster centre by a random solution ---
R1 = rand(1,1);
if R1 <= p_replace
    repalce_cluster_num = randi([1,cluster_num],1,1);
    replace_solution    = randperm(numVar-1) + 1;
    order_cluster{repalce_cluster_num,1}(1,:) = replace_solution;
    replace_solution_car     = car_insert3(replace_solution);
    replace_solution_fitness = quality2(replace_solution_car);
    order_cluster{repalce_cluster_num,2}(1,:) = replace_solution_fitness;
end

%% --------------------------------------------------- update NIND individuals
for i = 1:NIND

    if rand() < p_one
        %% ---------- one cluster is selected -----------------------------
        select_one_cluster = randi([1,cluster_num],1,1);
        if rand() < p_one_center || cluster_row(select_one_cluster) == 1
            select_ind = order_cluster{select_one_cluster,1}(1,:);
        else
            r_1 = randi([2,cluster_row(select_one_cluster)],1,1);
            select_ind = order_cluster{select_one_cluster,1}(r_1,:);
        end
        % improved 2-opt move on the selected individual
        indi_temp = improved_2_opt(car_insert3(select_ind));

    else
        %% ---------- two clusters are selected ---------------------------
        cluster_two = [0,0];
        while cluster_two(1,1) == cluster_two(1,2)
            cluster_two = randi([1,cluster_num],1,2);
        end

        if (rand() < p_two_center) || ...
           (cluster_row(cluster_two(1,1)) == 1 && cluster_row(cluster_two(1,2)) == 1)
            select_ind1 = order_cluster{cluster_two(1,1),1}(1,:);
            select_ind2 = order_cluster{cluster_two(1,2),1}(1,:);
        else
            if cluster_row(cluster_two(1,1)) == 1
                r_2 = randi([2,cluster_row(cluster_two(1,2))],1,1);
                select_ind1 = order_cluster{cluster_two(1,1),1}(1,:);
                select_ind2 = order_cluster{cluster_two(1,2),1}(r_2,:);
            elseif cluster_row(cluster_two(1,2)) == 1
                r_3 = randi([2,cluster_row(cluster_two(1,1))],1,1);
                select_ind1 = order_cluster{cluster_two(1,1),1}(r_3,:);
                select_ind2 = order_cluster{cluster_two(1,2),1}(1,:);
            else
                r_4 = randi([2,cluster_row(cluster_two(1,1))],1,1);
                r_5 = randi([2,cluster_row(cluster_two(1,2))],1,1);
                select_ind1 = order_cluster{cluster_two(1,1),1}(r_4,:);
                select_ind2 = order_cluster{cluster_two(1,2),1}(r_5,:);
            end
        end

        % uniformly draw one of the four crossover operators
        p_c = randi([1,4]);
        if p_c == 1
            [child1,child2,min_index] = heuristic_crossover(select_ind1,select_ind2);
        elseif p_c == 2
            [child1,child2,min_index] = OX_new(select_ind1,select_ind2);
        elseif p_c == 3
            [child1,child2,min_index] = RIX(select_ind1,select_ind2);
        else
            [child1,child2,min_index] = PMX_new(select_ind1,select_ind2);
        end

        if min_index == 1
            indi_temp = child1;
        else
            indi_temp = child2;
        end
    end

    %% -------------------------------------------------- random mutation
    indi_temp     = Random_variation(indi_temp);
    indi_temp_car = car_insert3(indi_temp);
    nCost         = quality2(indi_temp_car);

    % the offspring replaces the parent only if it is strictly better
    if nCost(2) < popcost(2,i)
        population(i,:)    = indi_temp;
        PopulationCar(i,:) = indi_temp_car;
        popcost(:,i)       = nCost;
    end
end

%% --------------------------------------------------------- local search
[popcost, index] = sort(popcost);
population    = population(index',:);
PopulationCar = PopulationCar(index',:);

if USE_RL_LOCAL_SEARCH
    % optional RL-driven operator selection (see LocalSearch_rl)
    LocalSearch_rl;
else
    [popcost, population, PopulationCar] = ...
        LocalSearch_new(popcost, population, PopulationCar, NIND);
end

%% ------------------------------------------------------------- outputs
tmppopcost = popcost(2,:);
[FEVAL, bestFocus] = min(tmppopcost);
Solution     = population(bestFocus,:);
bestSolution = PopulationCar(bestFocus,:);

end
