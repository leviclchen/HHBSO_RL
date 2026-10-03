%%RUN_DEMO Run the HHBSO-RL algorithm with the interval type-2 fuzzy objective.
%
%   Open this folder in MATLAB and run the script (F5). It
%     * adds the source and data folders to the MATLAB path,
%     * prepares the global problem data and the algorithm parameters,
%     * runs one or more repetitions of the HHBSO-RL algorithm,
%     * validates the best solution and plots the convergence curve and the
%       best route.
%
%   Algorithm     : hybrid brain-storm optimisation with reinforcement learning
%                   (hhbso_rl.m, IDBSO_new*.m, LocalSearch_*.m)
%   Fuzzy layer   : interval type-2 fuzzy evaluation
%                   (quality2.m, TypeCal1.m, Centric*.m, EKM.m, probility.m)

clear; clc;

%% ------------------------------------------------- keep the code on the path
rootDir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(rootDir, 'src')));
addpath(fullfile(rootDir, 'data'));
addpath(fullfile(rootDir, 'data', 'instances'));

%% -------------------------------------------------- problem and parameters
% 'seed', 1 makes the run reproducible; pass 'seed', [] to randomise it.
% 'useRL', true replaces the deterministic local search by LocalSearch_rl.
setup_instance('sizex', 50, 'n', 5, 'sizey', 100, 'max_iter', 100, ...
               'LOP', 1, 'useRL', false, 'seed', 1);

global LOP Kfl sizex n capacity max_iter points best_route Solutionx TLBO_qx

%% ------------------------------------------------------------------- run
best_q_record = zeros(1, LOP);
for Kfl = 1:LOP
    best_q_record(Kfl) = hhbso_rl();
end

%% -------------------------------------------------------------- validation
violations  = ConstrStaA(best_route(Kfl,:));                    % crisp capacity
consistency = ChackRoute(best_route(Kfl,:), Solutionx(Kfl,:));  % route encoding

%% ---------------------------------------------------------------- report
fprintf('\nHHBSO-RL (interval type-2 fuzzy) finished\n');
fprintf('  instance            : %d customers, %d trucks, capacity %d\n', ...
        sizex, n, capacity);
fprintf('  repetitions         : %d\n', LOP);
fprintf('  best fuzzy cost     : %.4f\n', min(best_q_record));
fprintf('  mean fuzzy cost     : %.4f\n', mean(best_q_record));
fprintf('  capacity violations : %d (0 = feasible)\n', violations);
fprintf('  encoding check      : %g (0 = consistent)\n', consistency);
fprintf('  best route          : %s\n', mat2str(best_route(Kfl,:)));

%% ------------------------------------------------------------- plots
figure('Name', 'Convergence');
plot(1:max_iter, TLBO_qx(Kfl,:), 'LineWidth', 1.5);
xlabel('Generation');
ylabel('Best objective (right endpoint of the interval centroid)');
title('HHBSO-RL convergence');
grid on;

figure('Name', 'Best route');
show_path(gcf, best_route(Kfl,:)', points, n, 0, 'Best route');
