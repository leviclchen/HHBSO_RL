# HHBSO-RL + interval type-2 fuzzy objective

Minimal, self-contained MATLAB implementation of

* **HHBSO-RL** – hybrid brain-storm optimisation with reinforcement learning, and
* the **interval type-2 (IT2) fuzzy** evaluation layer it optimises.

Only the code that is required to run the algorithm is contained in this folder.

## Run

```matlab
% in MATLAB, with this folder as the current folder
run_demo
```

`run_demo.m` adds the paths, prepares the sample instance, runs HHBSO-RL, checks
the solution and plots the convergence curve and the best route. The run takes a
few tens of seconds and finishes with, for example,

```
  best fuzzy cost     : 269911.6117
  capacity violations : 0 (0 = feasible)
  encoding check      : 0 (0 = consistent)
```

## Contents

```
run_demo.m                 entry point
startup.m                  adds src/ and data/ to the MATLAB path
src/
  hhbso_rl/                algorithm core
    hhbso_rl.m             RL outer loop: 5 states x 4 BSO variants, Q-learning
    IDBSO_new.m            BSO variant 1 - random fusion operator
    IDBSO_new2.m           BSO variant 2 - heuristic crossover
    IDBSO_new3.m           BSO variant 3 - no operator for a single cluster
    IDBSO_new4.m           BSO variant 4 - swap + PMX
    normalization_new.m    population quality -> discrete RL state
    TLBO_initxr.m          population initialisation
    InitalAlizeNew3.m      interval weights of the objective
    LocalSearch_new.m      local search (random sub-population)
    LocalSearch_new2.m     local search (whole population)
    LocalSearch_new3.m     local search (better half)
    LocalSearch_rl.m       optional RL-driven local-search operator selection
    Fitness.m              evaluates one operator on one individual
  type2_fuzzy/             interval type-2 fuzzy layer
    quality2.m             fuzzy objective function (returns the interval centroid)
    TypeCal1.m             interval type-2 arithmetic (+, ., scalar, negation)
    Centric_center.m       centroid of a trapezoidal IT2 fuzzy number
    Centric.m              IT2 centroid from alpha-cuts
    EKM.m                  enhanced Karnik-Mendel type reduction
    Rank.m, Rvalue1.m      alternative ranking indices
    probility.m            possibility measure of the fuzzy capacity constraint
  operators/               search operators used by the algorithm
    car_insert3.m          fuzzy-capacity depot insertion
    Local_3.m              neighbourhood generator (exchange/2-opt/insertions)
    improved_2_opt.m       improved 2-opt
    heuristic_crossover.m  greedy-edge crossover
    OX_new.m               order crossover
    PMX_new.m              partially matched crossover
    RIX.m                  route-exchange crossover
    Swap.m                 swap mutation
    Random_variation.m     adaptive mutation (interchange / shift / inverse)
    Interchange.m, Shift.m, Inverse.m
    two_optnew.m           2-opt move
    forward_insert2.m      forward insertion
    backward_insert2.m     backward insertion
    TransAngA.m            depot-split route -> depot-free permutation
    NumberCarx.m           customers per truck
  utils/
    setup_instance.m       globals, instance data and parameters
    generate_matrix.m      distance matrix and node coordinates
    CalculDis.m            neighbourhood table
    ChackRoute.m           encoding consistency check
    ConstrStaA.m           crisp capacity check
    show_path.m            route visualisation
data/
  it2_trapezoid_c1.txt     IT2 trapezoid parameters for c1  (k+1 rows)
  it2_trapezoid_g1.txt     IT2 trapezoid parameters for g1  (k+1 rows)
  it2_trapezoid_l1.txt     IT2 trapezoid parameters for l1  (k+1 rows)
  r.txt                    candidate routes (100 rows), kept with the data set
  instances/               benchmark instances
    data_*.txt             node coordinates  (id, x, y)
    comp_*.txt             crisp demands     (id, demand)
    number.txt             instance table: name, trucks, customers, capacity
```

### Dataset

79 files covering the instance families `c` (c1–c5, c11, c12), `g` (g1–g20) and
`l` (l1–l12), plus `number.txt`, the instance table:

```
name        trucks  customers  capacity
c1               5         50       160
c2              10         75       140
...
g1               9        240       550
l1              10        560      1200
```

Each instance needs three matching files: coordinates, demands and the IT2
trapezoid parameters. **IT2 trapezoid parameters are available for `c1`, `g1` and
`l1` only** – the parameter sets of the other instances are not part of the
original data. Those three instances can be selected as follows:

```matlab
% c1 (default)
setup_instance('sizex', 50, 'n', 5, 'capacity', 160, 'seed', 1);
% g1
setup_instance('sizex', 240, 'n', 9, 'capacity', 550, 'seed', 1, ...
               'coordFile', 'data_g1.txt', 'demandFile', 'comp_g1.txt', ...
               'trapezoidFile', 'it2_trapezoid_g1.txt');
% l1
setup_instance('sizex', 560, 'n', 10, 'capacity', 1200, 'seed', 1, ...
               'coordFile', 'data_l1.txt', 'demandFile', 'comp_l1.txt', ...
               'trapezoidFile', 'it2_trapezoid_l1.txt');
global Kfl; Kfl = 1;
best = hhbso_rl();
```

For any other instance you only have to supply the three matching files and the
values from `number.txt`; `setup_instance` reads the customers, trucks and
capacity values from its arguments.

## Parameters

All parameters are passed to `setup_instance` as name/value pairs:

| Option | Meaning | Default |
|--------|---------|---------|
| `sizex` | number of customers | 50 |
| `n` | number of trucks | 5 |
| `capacity` | crisp truck capacity | 160 |
| `sizey` | population size | 100 |
| `max_iter` | number of generations | 100 |
| `LOP` | number of independent repetitions | 1 |
| `demandFile` | crisp demand file (in `data/`) | `comp_c1.txt` |
| `trapezoidFile` | IT2 trapezoid parameter file (in `data/`) | `it2_trapezoid_c1.txt` |
| `useRL` | use `LocalSearch_rl` instead of the fixed local search | `false` |
| `seed` | seed of the random generator (`[]` = unseeded) | `[]` |

Example:

```matlab
setup_instance('max_iter', 200, 'sizey', 60, 'useRL', true, 'seed', 7);
global Kfl; Kfl = 1;
best = hhbso_rl();
```

## Interval type-2 fuzzy representation

A trapezoidal IT2 fuzzy number is a **6-by-2** matrix:

```
rows 1 .. 4 : trapezoid breakpoints
row  5      : height of the upper membership function
row  6      : height of the lower membership function
column 1    : upper membership function
column 2    : lower membership function
```

`quality2` aggregates the distance, fuel, energy and fixed-cost terms as IT2
fuzzy numbers with the interval weights from `InitalAlizeNew3`, reduces the
result with `Centric_center` (i.e. `EKM`) and returns the interval centroid
`[y_l ; y_r ; (y_l + y_r)/2]`. The search ranks solutions by `y_r`.

To inspect a fuzzy number:

```matlab
W = InitalAlizeNew3(5);      % interval weights of the objective
A = W(:,:,3);
X = A(1:4,1); Y = [0 A(5,1) A(6,1) 0];   % upper membership function
plot(X, Y, '-b', 'LineWidth', 2), hold on
X = A(1:4,2); Y = [0 A(5,2) A(6,2) 0];   % lower membership function
plot(X, Y, '-b', 'LineWidth', 2)
```
