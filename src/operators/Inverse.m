function r = Inverse(d, r)
%INVERSE Block-reversal move: reverse a block of d consecutive elements.
%
%   d : block length (d >= 1).
%   r : permutation to be modified (returned mutated).
%
% A random end position a2 in [d, numel(r)] is drawn and the block
% [a2-d+1, a2] is reversed in place.

nr = size(r,2);
a2 = randi([d nr]);
a1 = a2 - d + 1;

for i = a1:fix((2*a1 + d - 1)/2)
    temp            = r(i);
    r(i)            = r(2*a1 + d - 1 - i);
    r(2*a1 + d - 1 - i) = temp;
end

end
