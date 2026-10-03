function LocalSearch_rl
%LOCALSEARCH_RL Reinforcement-learning driven local-search operator selection.
%
%   Optional HHBSO-RL component. Instead of improving a fixed sub-population with
%   a fixed operator, every individual chooses one of four local-search operators
%   (TransAngA, two_optnew, forward_insert2, backward_insert2) with an
%   epsilon-greedy policy over the shared Q table q.
%
%   The per-individual RL state is stored in the global vector rl_state and is
%   updated to the operator that was applied, so that the agent learns which
%   move pays off in which situation. A move is rewarded with +1 when it
%   improves the individual and with -1 otherwise; the learning rate follows a
%   cosine annealing schedule between lambda_1 and lambda_2.
%
%   Enable this component by setting USE_RL_LOCAL_SEARCH = true in run_demo.m.
%   It then replaces the deterministic local search of the brain-storm variants.
%
%   FIXES with respect to the original implementation
%     * the Q table is two-dimensional (num_states-by-num_actions, see
%       hhbso_rl.m), but it was indexed with three subscripts
%       (q(state(i),:,i) and q(state(i),x1,i)), which is out of range;
%     * the update used q(state(i),x1) instead of the selected action;
%     * the exploration branch called RandomPermutation(size(q,1)) which returns
%       the scalar 5 rather than a permutation, so the action could exceed the
%       number of columns of q;
%     * popcost(i) = fitness assigned a single element of the 3-by-N cost matrix
%       instead of the whole column.
%   All four issues are corrected below. The behaviour of the remaining
%   algorithm is unchanged, because this file is only reached when
%   USE_RL_LOCAL_SEARCH is set to true.

global ite max_iter q gamma lambda_1 lambda_2 sizey rl_state
global population popcost PopulationCar

% lazily initialise the per-individual RL state
if isempty(rl_state) || numel(rl_state) ~= sizey
    rl_state = ones(1, sizey);
end

num_actions = size(q,2);

for i = 1:sizey

    % cost of the individual under its current operator
    fitness_1 = Fitness(i, rl_state(i));

    % epsilon-greedy exploration / exploitation
    if rand(1,1) < 0.2
        x1  = randperm(num_actions);
        act = x1(1);
    else
        qmax = q(rl_state(i),:);
        [~, act] = max(qmax);
    end

    [fitness_2, pc, p] = Fitness(i, act);

    % reward the operator when it improves the individual
    if fitness_2(2) < fitness_1(2)
        r = 1;
        PopulationCar(i,:) = pc;
        population(i,:)    = p;
        popcost(:,i)       = fitness_2;
    else
        r = -1;
    end

    % cosine-annealed learning rate
    lambda = (lambda_1+lambda_2)/2 - (lambda_1-lambda_2)/2*cos((1-ite/max_iter)*pi);

    % Q-learning update on the shared table
    Max = max(q(act,:));
    q(rl_state(i),act) = q(rl_state(i),act) ...
        + lambda*(r + gamma*Max - q(rl_state(i),act));

    % the applied operator becomes the new state of this individual
    rl_state(i) = act;
end

end
