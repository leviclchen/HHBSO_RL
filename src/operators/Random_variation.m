function r = Random_variation(r)
%RANDOM_VARIATION Adaptive mutation of a customer permutation.
%
%   r : 1-by-sizex customer permutation without depot nodes.
%   r : the mutated permutation.
%
% The mutation strength d decreases with the generation counter: early in the
% search large perturbations are used, later only local changes are made. Three
% moves are used depending on the normalised generation t = ite/max_iter:
%   t < 1/3      -> Interchange (paired swaps)
%   1/3 <= t <= 2/3 -> Shift (insertion move)
%   t > 2/3      -> Inverse (block reversal)

global max_iter ite sizex

t = ite/max_iter;
D = sizex;

% adaptive perturbation length
scale         = 0.25;
control_value = scale*(D-1)*exp(1 - max_iter/(max_iter-ite+1)) + 1;
d = control_value*abs(randn());
d = ceil(d);
a = randperm(D);
if d > D
    d = D;
end
a = a(1:d);

% FIX: the original code used the chained comparison "1/3<=t<=2/3". MATLAB
% evaluates that as "(1/3<=t)<=2/3", which is false whenever t >= 1/3, so the
% Shift move was never applied and the middle range performed no mutation at
% all. The comparison is replaced by a proper if/elseif chain.
if t < 1/3
    r = Interchange(a, r);
elseif t <= 2/3
    if d >= 1                       % an empty perturbation would be a no-op
        r = Shift(d, r);
    end
else
    if d >= 1
        r = Inverse(d, r);
    end
end

end
