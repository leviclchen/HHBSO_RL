function setup_instance(varargin)
%SETUP_INSTANCE Prepare global problem data and algorithm parameters.
%
%   SETUP_INSTANCE() prepares the default 50-customer instance.
%   SETUP_INSTANCE('Name', Value, ...) overrides individual parameters.
%
%   Options                                              default
%     'sizex'         number of customers                     50
%     'n'             number of trucks                         5
%     'capacity'      crisp truck capacity                   160
%     'sizey'         population size                        100
%     'max_iter'      number of generations                  100
%     'LOP'           number of independent repetitions        1
%     'coordFile'     node coordinates  (data/instances/)     'data_c1.txt'
%     'demandFile'    crisp demands     (data/instances/)     'comp_c1.txt'
%     'trapezoidFile' IT2 trapezoid parameters (data/)        'it2_trapezoid_c1.txt'
%     'useRL'         use the RL local search LocalSearch_rl  false
%     'seed'          seed for the random generator           [] (unseeded)
%
%   All data are exchanged through global variables. The data files are resolved
%   on the MATLAB path, which run_demo.m (or startup.m) extends with the src/ and
%   data/ folders.
%
%   Example - the bundled instances (see data/instances/number.txt for the
%   instance table) are:
%     setup_instance('sizex', 50,  'n', 5,  'capacity', 160,  'seed', 1);   % c1
%     setup_instance('sizex', 240, 'n', 9,  'capacity', 550,  'seed', 1, ...
%                    'coordFile','data_g1.txt','demandFile','comp_g1.txt', ...
%                    'trapezoidFile','it2_trapezoid_g1.txt');              % g1
%     setup_instance('sizex', 560, 'n', 10, 'capacity', 1200, 'seed', 1, ...
%                    'coordFile','data_l1.txt','demandFile','comp_l1.txt', ...
%                    'trapezoidFile','it2_trapezoid_l1.txt');              % l1

%% ------------------------------------------------------------- parameters
opt = struct('sizex', 50, 'n', 5, 'capacity', 160, 'sizey', 100, ...
             'max_iter', 100, 'LOP', 1, ...
             'coordFile', 'data_c1.txt', ...
             'demandFile', 'comp_c1.txt', ...
             'trapezoidFile', 'it2_trapezoid_c1.txt', ...
             'useRL', false, 'seed', []);
for k = 1:2:numel(varargin)
    name = varargin{k};
    if ~ischar(name) || ~isfield(opt, name)
        error('setup_instance:unknownOption', 'Unknown option "%s".', num2str(name));
    end
    opt.(name) = varargin{k+1};
end

if ~isempty(opt.seed)
    rng(opt.seed);              % reproducible runs
end

%% ---------------------------------------------------------------- globals
global n sizex capacity comp Comp W_VAL cost_matrix points DSor
global sizey max_iter LOP func_count res
global best_route Solutionx TLBO_qx
global USE_RL_LOCAL_SEARCH population popcost PopulationCar

n        = opt.n;
sizex    = opt.sizex;
capacity = opt.capacity;
sizey    = opt.sizey;
max_iter = opt.max_iter;
LOP      = opt.LOP;

USE_RL_LOCAL_SEARCH = opt.useRL;

%% --------------------------------------------------------- crisp demands
% One row per node - "node id, demand". The transposed matrix therefore holds the
% node ids in its first row and the demands in its second row; the demands are
% indexed by the route entries (1 = depot, 2 .. sizex+1 = customers).
comp = importdata(opt.demandFile);
comp = comp';
comp = comp(2,:);

%% --------------------------- interval type-2 trapezoid membership parameters
% One row per node: six parameters of the upper membership function followed by
% six parameters of the lower membership function (see TypeCal1 for the layout).
func_count = 0;
res        = [];
W_VAL      = InitalAlizeNew3(5);        % interval weights of the objective

temp = importdata(opt.trapezoidFile);
Comp = zeros(6,2,sizex+1);
for i = 1:sizex+1
    Comp(:,1,i) = temp(i,1:6);
    Comp(:,2,i) = temp(i,7:12);
end

%% -------------------------------------------------------------- instance
% NOTE: generate_matrix also advances the random stream (see the note in that
% file), so the order of the calls below matters for reproducibility.
[cost_matrix, points] = generate_matrix(sizex, n, opt.coordFile);
DSor = CalculDis();                     % precomputed neighbourhood table

%% ------------------------------------------------------ result containers
best_route = zeros(LOP, sizex+n+1);
Solutionx  = zeros(LOP, sizex);
TLBO_qx    = zeros(LOP, max_iter);

% reset the population containers so that a repeated call starts from scratch
population    = [];
popcost       = [];
PopulationCar = [];

end
