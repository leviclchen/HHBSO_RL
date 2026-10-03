function Xa = NumberCarx(Xt)
%NUMBERCARX Number of customers served by each truck.
%
%   Xt : route vector containing depot nodes (value 1).
%   Xa : 1-by-n vector; Xa(i) is the number of customers between the i-th and
%        the (i+1)-th depot node.

Tx = find(Xt == 1);
Xa = [];

for i = 1:length(Tx)-1
    temp = Tx(i+1) - Tx(i) - 1;
    Xa = [Xa temp];
end

end
