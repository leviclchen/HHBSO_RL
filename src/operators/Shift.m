function r = Shift(d, r)
%SHIFT Insertion move: shift one element d positions to the right.
%
%   d : shift distance (d >= 1).
%   r : permutation to be modified (returned mutated).
%
% A random end position a2 in [d, numel(r)] is drawn; the element at a2 is
% removed and re-inserted at position a2-d+1, so all elements in between move
% one position to the right.

nr = size(r,2);                 % renamed from "length" to avoid shadowing the
                                % built-in function
a2 = randi([d nr]);
a1 = a2 - d + 1;

temp = r(a2);
for i = a2-1:-1:a1
    r(i+1) = r(i);
end
r(a1) = temp;

end
