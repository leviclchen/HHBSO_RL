function [bestSolution, FEVAL, Solution] = IDBSO_new3
%IDBSO_NEW3 Brain-storm variant 3: no operator for one cluster, heuristic
%   crossover for two clusters.
%
%   Differs from the other variants in that the individual taken from a single
%   cluster is passed on unchanged (apart from the random mutation), while two
%   clusters are always combined with the heuristic crossover. The local search
%   LocalSearch_new2 is applied to every individual.
%
%   See IDBSO_new for the description of the outputs.

global populationsize capacity population popcost PopulationCar
global sizey cluster_num p_replace p_one p_one_center p_two_center
global numVar NIND USE_RL_LOCAL_SEARCH

%% ---------------------------------------- sort the population by objective
% See the NOTE in IDBSO_new.m: the multi-output SORT of a 3-by-N cost matrix
% returns a 3-by-N index matrix. The inherited behaviour is kept unchanged.
[popcost, index] = sort(popcost);
population    = population(index',:);
PopulationCar = PopulationCar(index',:);

%% ------------------------------------------------------------- clustering
for i = 1:sizey
    Idx(i) = mod(i, cluster_num) + 1;
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
        % the selected individual is passed on unchanged in this variant
        indi_temp = select_ind;

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

        [child1,child2,min_index] = heuristic_crossover(select_ind1,select_ind2);
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
    LocalSearch_rl;
else
    [popcost, population, PopulationCar] = ...
        LocalSearch_new2(popcost, population, PopulationCar, NIND);
end

%% ------------------------------------------------------------- outputs
tmppopcost = popcost(2,:);
[FEVAL, bestFocus] = min(tmppopcost);
Solution     = population(bestFocus,:);
bestSolution = PopulationCar(bestFocus,:);

end
