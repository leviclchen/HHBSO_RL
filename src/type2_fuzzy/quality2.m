function Cen = quality2(r)
%QUALITY2 Interval type-2 fuzzy objective function of a vehicle route.
%
%   r   : 1-by-(sizex+n+1) route vector. Depot entries equal 1, all remaining
%         entries are customer indices in 2 .. sizex+1.
%   Cen : 3-by-1 interval centroid [y_l ; y_r ; (y_l + y_r)/2] of the interval
%         type-2 fuzzy total cost. The optimisation loop ranks solutions by the
%         right endpoint Cen(2).
%
% Four cost terms are modelled as trapezoidal interval type-2 fuzzy numbers and
% aggregated with the interval weights W_VAL:
%   C1    : travelled distance plus the fixed cost of all vehicles
%   FFuel : fuel cost of the conventional (diesel) trucks
%   Fuel  : energy cost of the electric trucks
%   fuel  : fuel consumption of the conventional trucks
% The aggregated fuzzy number is reduced to a crisp interval by EKM type
% reduction (Centric_center).
%
% The function also acts as the global function-evaluation counter: every call
% increments func_count and, every 300 evaluations, records the best objective
% value found so far in the global vector res.

global func_count W_VAL
global n cost_matrix capacity res popcost Comp

A = 168;  B = 179;              % fixed cost of one diesel / electric truck
a = round(cost_matrix);         % integer distance matrix
d = 0;                          % accumulated travelled distance
C = find(r == 1);               % depot indices, i.e. the start of each route
Q = capacity;

%% ---------------- electric drive / consumption model parameters -----------
ER = 2.62;
e0 = 0.3;   e1 = 0.01;
p1 = 0.53;  p0 = 6.5;
f1 = 0.0308; f2 = 0.2725; F3 = 6.0479; W = 1.8;

nn = ceil(n/2);                 % number of diesel trucks; the rest are electric

b = find(r > 0);
for i = 1:(length(b)-1)
    d = d + a(r(i), r(i+1));    % total travel distance along the route
end
d = d + A*nn + B*(n-nn);        % add the fixed vehicle costs

%% ---------------- C1: distance + fixed cost ------------------------------
C1(:,1) = [d,d,d,d,1,1];
C1(:,2) = [d,d,d,d,1,1];

%% ---------------- FFuel: fuel cost of the diesel trucks ------------------
FFuel(:,1) = [0,0,0,0,1,1];
FFuel(:,2) = [0,0,0,0,1,1];
for i = 1:nn
    q(:,1) = [0,0,0,0,1,1];
    q(:,2) = [0,0,0,0,1,1];
    for t = C(i):C(i+1)
        q = TypeCal1(q, Comp(:,:,r(t)), 1, 1);      % load carried by the truck
    end
    y = q;
    for j = C(i):C(i+1)-1
        if j == C(i)
            y = q;                                  % left the depot fully loaded
        else
            y = TypeCal1(y, TypeCal1(Comp(:,:,r(j)),1,1,5), 1, 1);  % unload customer j
        end
        dis(:,1) = [a(r(j),r(j+1))^2, a(r(j),r(j+1))^2, a(r(j),r(j+1))^2, a(r(j),r(j+1))^2, 1, 1];
        dis(:,2) = [a(r(j),r(j+1))^2, a(r(j),r(j+1))^2, a(r(j),r(j+1))^2, a(r(j),r(j+1))^2, 1, 1];
        temp = f2*W + F3;
        c(:,1) = [temp,temp,temp,temp,1,1];
        c(:,2) = [temp,temp,temp,temp,1,1];
        FFuel = TypeCal1(TypeCal1(TypeCal1(TypeCal1(y,1,f2,3),c,1,1),dis,1,2),FFuel,1,1);
    end
    di(:,1) = [a(r(C(i+1)-1),r(C(i+1)))^2, a(r(C(i+1)-1),r(C(i+1)))^2, a(r(C(i+1)-1),r(C(i+1)))^2, a(r(C(i+1)-1),r(C(i+1)))^2, 1, 1];
    di(:,2) = [a(r(C(i+1)-1),r(C(i+1)))^2, a(r(C(i+1)-1),r(C(i+1)))^2, a(r(C(i+1)-1),r(C(i+1)))^2, a(r(C(i+1)-1),r(C(i+1)))^2, 1, 1];
    FFuel = TypeCal1(FFuel, TypeCal1(di,1,f2*W,3), 1, 1);   % empty return to the depot
end
FFuel = TypeCal1(FFuel, 1, p0*f1, 3);

%% ---------------- Fuel: energy cost of the electric trucks ---------------
E0(:,1) = [e0,e0,e0,e0,1,1];
E0(:,2) = [e0,e0,e0,e0,1,1];
Fuel(:,1) = [0,0,0,0,1,1];
Fuel(:,2) = [0,0,0,0,1,1];
for i = nn+1:length(C)-1
    q(:,1) = [0,0,0,0,1,1];
    q(:,2) = [0,0,0,0,1,1];
    for t = C(i):C(i+1)
        q = TypeCal1(q, Comp(:,:,r(t)), 1, 1);      % load carried by the truck
    end
    y = q;
    for j = C(i):C(i+1)-1
        if j == C(i)
            y = q;                                  % left the depot fully loaded
        else
            y = TypeCal1(y, TypeCal1(Comp(:,:,r(j)),1,1,5), 1, 1);  % unload customer j
        end
        dis(:,1) = [a(r(j),r(j+1)), a(r(j),r(j+1)), a(r(j),r(j+1)), a(r(j),r(j+1)), 1, 1];
        dis(:,2) = [a(r(j),r(j+1)), a(r(j),r(j+1)), a(r(j),r(j+1)), a(r(j),r(j+1)), 1, 1];
        Fuel = TypeCal1(Fuel, TypeCal1(TypeCal1(TypeCal1(y,1,e1,3),E0,1,1),dis,1,2), 1, 1);
    end
    di(:,1) = [a(r(C(i+1)-1),r(C(i+1))), a(r(C(i+1)-1),r(C(i+1))), a(r(C(i+1)-1),r(C(i+1))), a(r(C(i+1)-1),r(C(i+1))), 1, 1];
    di(:,2) = [a(r(C(i+1)-1),r(C(i+1))), a(r(C(i+1)-1),r(C(i+1))), a(r(C(i+1)-1),r(C(i+1))), a(r(C(i+1)-1),r(C(i+1))), 1, 1];
    Fuel = TypeCal1(Fuel, TypeCal1(di,1,e0,3), 1, 1);        % empty return to the depot
end
Fuel = TypeCal1(Fuel, 1, p1, 3);

%% ---------------- fuel: consumption of the diesel trucks ----------------
k(:,1) = [1,1,1,1,1,1];
k(:,2) = [1,1,1,1,1,1];
fuel(:,1) = [0,0,0,0,1,1];
fuel(:,2) = [0,0,0,0,1,1];
for i = 1:nn
    q(:,1) = [0,0,0,0,1,1];
    q(:,2) = [0,0,0,0,1,1];
    for t = C(i):C(i+1)
        q = TypeCal1(q, Comp(:,:,r(t)), 1, 1);      % load carried by the truck
    end
    y = q;
    for j = C(i):C(i+1)-1
        y = TypeCal1(y, TypeCal1(Comp(:,:,r(j)),1,1,5), 1, 1);   % unload customer j
        dis(:,1) = [a(r(j),r(j+1)), a(r(j),r(j+1)), a(r(j),r(j+1)), a(r(j),r(j+1)), 1, 1];
        dis(:,2) = [a(r(j),r(j+1)), a(r(j),r(j+1)), a(r(j),r(j+1)), a(r(j),r(j+1)), 1, 1];
        fuel = TypeCal1(fuel, TypeCal1(dis, TypeCal1(k,TypeCal1(y,1,1/Q,3),1,1), 1, 2), 1, 1);
    end
    di(:,1) = [a(r(C(i+1)-1),r(C(i+1))), a(r(C(i+1)-1),r(C(i+1))), a(r(C(i+1)-1),r(C(i+1))), a(r(C(i+1)-1),r(C(i+1))), 1, 1];
    di(:,2) = [a(r(C(i+1)-1),r(C(i+1))), a(r(C(i+1)-1),r(C(i+1))), a(r(C(i+1)-1),r(C(i+1))), a(r(C(i+1)-1),r(C(i+1))), 1, 1];
    fuel = TypeCal1(fuel, di, 1, 1);                % empty return to the depot
end

%% ---------------- aggregation of the interval type-2 fuzzy cost ----------
F1 = TypeCal1(TypeCal1(C1,FFuel,1,1), Fuel, 1, 1);
F2 = TypeCal1(fuel, 1, ER, 3);

a = TypeCal1(W_VAL(:,:,3), F1, 1, 2);                       % weighted distance cost
G = TypeCal1(a, TypeCal1(W_VAL(:,:,2), F2, 1, 2), 1, 1);    % aggregated fuzzy cost

% Optional ranking indices (kept for completeness, not used by the main loop).
g     = Rank(G);        %#ok<NASGU>
vaule = Rvalue1(G);     %#ok<NASGU>

Cen = Centric_center(G);        % interval centroid of the fuzzy cost

%% ---------------- function-evaluation bookkeeping ------------------------
func_count = func_count + 1;
if (func_count <= 300000)
    if mod(func_count, 300) == 0
        [cos, Xt] = min(popcost);   %#ok<ASGLU>
        res = [res cos];
    end
end

end
