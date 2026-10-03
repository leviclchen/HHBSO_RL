function best_q = hhbso_rl()
%HHBSO_RL Hybrid brain-storm optimisation with reinforcement learning.
%
%   best_q = HHBSO_RL() runs one independent repetition of the HHBSO-RL
%   algorithm on the problem instance prepared by the driver script
%   (run_demo.m). All problem data and algorithm parameters are exchanged
%   through global variables.
%
%   Outline
%     1. initialise the population with TLBO_initxr (fuzzy capacity insertion)
%     2. for every generation
%          a. map the population to an RL state with normalization_new
%          b. pick one of the four brain-storm variants IDBSO_new .. IDBSO_new4
%             with an epsilon-greedy policy over the Q table
%          c. reward the action by the improvement of the best objective value
%          d. update the Q table with the standard Q-learning rule
%
%   Output
%     best_q : right endpoint of the best interval centroid found in the last
%              generation.

%% ------------------------------------------------------------------ globals
global n sizex cost_matrix max_iter population popcost PopulationCar
global best_route ite Kfl Solutionx sizey populationsize
global TLBO_qx NIND cluster_num p_replace p_one p_one_center p_two_center
global q gamma lambda_1 lambda_2 state

% Number of cities and number of customers (kept for compatibility with the
% helper functions, which rely on the globals n and sizex).
Cn = n;             %#ok<NASGU>
N  = sizex;         %#ok<NASGU>

%% ------------------------------------------ population initialisation -----
TLBO_routes = [];
TLBO_q      = [];
TLBO_time   = [];

TLBO_initxr(cost_matrix, sizey, 20);

% Sanity check: the depot-split route (PopulationCar) and the depot-free
% permutation (population) must describe the same tour. ChackRoute returns 0
% when the two representations are consistent.
Fk = zeros(populationsize,1);
for i = 1:size(population,1)
    a = find(PopulationCar(i,:) == 1);
    if length(a)
        Fk(i) = ChackRoute(PopulationCar(i,:), population(i,:));
    end
end

%% ------------------------------------------------- brain-storm parameters
NIND          = sizey;      % population size
cluster_num   = 10;         % number of clusters
p_replace     = 0.1;        % probability of replacing a cluster centre
p_one         = 0.5;        % probability of selecting one cluster
p_one_center  = 0.4;        % probability of taking the centre of that cluster
p_two_center  = 0.5;        % probability of taking the centres of two clusters

%% --------------------------------------------- reinforcement-learning setup
num_states  = 5;            % number of discrete population-quality states
num_actions = 4;            % four brain-storm variants (IDBSO_new .. new4)
alpha       = 0.1;          % learning rate
q           = rand(num_states, num_actions);    % Q table, initialised in [0,1]
state       = 1;            % current state (set by normalization_new)

gamma    = 0.8;             % discount factor
lambda_1 = 0.1;             % initial learning rate (kept for the RL local search)
lambda_2 = 0.9;             % final learning rate   (kept for the RL local search)

%% --------------------------------------------------------------- main loop
for ite = 1:max_iter
    tic;

    % (a) state of the population, obtained from the cost distribution
    [state, best] = normalization_new(popcost);

    % (b) epsilon-greedy action selection with a linearly decaying epsilon
    epsilon = 0.1 - ((0.1-0.05)/max_iter)*ite;
    if rand() < epsilon
        action = randi(num_actions);
    else
        [~, action] = max(q(state, :));
    end

    % execute the selected brain-storm variant
    if action == 1
        [best_route(Kfl,:), best_q, Solutionx(Kfl,:)] = IDBSO_new;
    elseif action == 2
        [best_route(Kfl,:), best_q, Solutionx(Kfl,:)] = IDBSO_new2;
    elseif action == 3
        [best_route(Kfl,:), best_q, Solutionx(Kfl,:)] = IDBSO_new3;
    else
        [best_route(Kfl,:), best_q, Solutionx(Kfl,:)] = IDBSO_new4;
    end

    % (c) reward: the action is rewarded when the best objective improves
    [state_next, best_next] = normalization_new(popcost);
    if ite < max_iter/5
        if best_next < best
            reward = 1;
        else
            reward = 0;
        end
    else
        if best_next < best
            reward = 10;
        else
            reward = 0;
        end
    end

    % (d) Q-learning update
    q(state,action) = q(state,action) ...
        + alpha*(reward + gamma*max(q(state_next,:)) - q(state,action));

    %% ------------------------------------------------------------ logging
    TLBO_time   = [TLBO_time toc];
    TLBO_routes = [TLBO_routes best_route];
    TLBO_q      = [TLBO_q best_q];
    TLBO_qx(Kfl,ite) = best_q;
end

end
