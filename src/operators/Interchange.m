function r = Interchange(a, r)
%INTERCHANGE Swap the elements at paired positions given by the index vector a.
%
%   a : index vector, e.g. [3 7 12 15]; positions a(1)<->a(2), a(3)<->a(4), ...
%   r : permutation to be modified (returned mutated).
%
% If the number of indices is odd the last index is left untouched.

na = size(a,2);                 % renamed from "length" to avoid shadowing the
                                % built-in function
if rem(na,2) == 0
    for i = 1:2:na
        temp     = r(a(i));
        r(a(i))  = r(a(i+1));
        r(a(i+1))= temp;
    end
else
    for i = 1:2:na-1
        temp     = r(a(i));
        r(a(i))  = r(a(i+1));
        r(a(i+1))= temp;
    end
end

end
