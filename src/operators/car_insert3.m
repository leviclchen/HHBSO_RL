function x = car_insert3(r)
%CAR_INSERT3 Insert depot nodes into a customer permutation.
%
%   r : 1-by-sizex permutation of the customer indices (2 .. sizex+1) that
%       contains no depot node.
%   x : route vector in which depot nodes (value 1) have been inserted whenever
%       the fuzzy capacity constraint is violated. The result starts and ends
%       with a depot node.
%
% The load of the current truck is accumulated as an interval type-2 fuzzy
% number (getSum) and compared with the crisp capacity through the possibility
% measure probility(). As soon as the possibility of a capacity violation
% exceeds the confidence level alpha, a new truck is opened. At most n-1
% depots are inserted, so the final route contains exactly n+1 depot nodes.

global n
global sizex capacity Comp

alpha  = 0.5;                   % confidence level

% FIX: the fuzzy accumulator and the fuzzy capacity must follow the canonical
% 6-by-2 interval type-2 layout of TypeCal1 and probility, i.e. four breakpoints
% (rows 1..4) plus the upper (row 5) and the lower (row 6) membership height.
% The original code used only five rows, which made TypeCal1 fail with
% "operands have incompatible sizes" on the very first insertion.
getSum = [0,0; 0,0; 0,0; 0,0; 1,1; 1,1];      % fuzzy zero load
cap    = [capacity,capacity; capacity,capacity; capacity,capacity; ...
          capacity,capacity; 1,1; 1,1];        % fuzzy available capacity
count1 = 0;
len    = length(r);

for i = 1:sizex+n-1
    getSum = TypeCal1(getSum, Comp(:,:,r(i)), 1, 1);    % accumulated demand
    p = probility(cap, getSum);                         % possibility of overload

    if p > alpha                                        % constraint violated
        for k = len:-1:i
            r(k+1) = r(k);                              % shift to free a slot
        end
        r(i) = 1;                                       % insert a depot node
        count1 = count1 + 1;
        len = len + 1;
        getSum = [0,0; 0,0; 0,0; 0,0; 1,1; 1,1];        % reset the truck load
        if count1 == n - 1
            break;
        end
    end
end

result = [1 r 1];
x = result;

end
