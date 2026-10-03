function r_new = improved_2_opt(rc)
%IMPROVED_2_OPT Improved 2-opt move applied to one sub-route.
%
%   rc    : route vector containing depot nodes.
%   r_new : the modified tour WITHOUT depot nodes, i.e. a plain customer
%           permutation that can be stored in a row of the population matrix.
%
% One sub-route is selected at random. For every pair of edges (i, i+1) and
% (j, j+1) the successors are swapped whenever that shortens the sub-route.
%
% NOTE: the trailing call to quality2(rc_new) does not influence the returned
% value. It is kept because quality2 is the global function-evaluation counter.

global cost_matrix

a = round(cost_matrix);

t = find(rc == 1);
startIndices = t(1:length(t)-1);
endIndices   = t(2:length(t));

randomIndex    = randi(numel(startIndices));            % pick one sub-route
subPathIndices = startIndices(randomIndex):endIndices(randomIndex);
r1  = rc(subPathIndices(1):subPathIndices(end));
len = length(r1);

for i = 1:len-2
    for j = i+2:len
        if j == len
            break;
        end
        if a(r1(i),r1(i+1)) + a(r1(j),r1(j+1)) > a(r1(i),r1(j)) + a(r1(i+1),r1(j+1))
            temp    = r1(j);
            r1(j)   = r1(i+1);
            r1(i+1) = temp;
        end
    end
end

rc_new = rc;
rc_new(startIndices(randomIndex):endIndices(randomIndex)) = r1;
r_new = rc_new;

% remove the depot nodes -> plain customer permutation
r_new(r_new == 1) = [];

quality2(rc_new); %#ok<NASGU>   % keep the function-evaluation counter in sync

end
