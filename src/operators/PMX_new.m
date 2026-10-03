function [y1, y2, min_index] = PMX_new(x1, x2)
%PMX_NEW Partially matched crossover (PMX) for permutation problems.
%
%   x1, x2    : parent tours, plain customer permutations without depot nodes.
%   y1, y2    : offspring tours, also free of depot nodes.
%   min_index : 1 or 2, indicating which offspring has the smaller fuzzy
%               objective value.
%
% Two crossover points are drawn along the string; the two segments are
% exchanged between the parents and the remaining genes are legalised through
% the resulting mapping relation.

Va = x1;
Vb = x2;
nGene = length(Va);

% A route may contain several depot nodes in other encodings. Should that be the
% case, all depot nodes except the first are relabelled with unique values that
% are larger than the number of customers, so that PMX treats them as distinct
% genes.
Tx = find(Va == 1);
for i = 2:length(Tx)
    Va(Tx(i)) = nGene + i - 1;
end
Tx = find(Vb == 1);
for i = 2:length(Tx)
    Vb(Tx(i)) = nGene + i - 1;
end

%% Step 1: draw two crossover positions.
% FIX: the original code drew the positions with "mod(ceil(rand*10), length(Va))"
% and "mod(floor(rand*10), length(Va))", which restricted the crossover segment
% to the first ten genes - a leftover from a ten-city tutorial example. The
% modulus must be the route length.
startXorPoint = mod(ceil(rand(1)*nGene), nGene);
if startXorPoint == 0
    startXorPoint = startXorPoint + 1;
end
xorLength = mod(floor(rand(1)*nGene), nGene);
endXorPoint = startXorPoint + xorLength;
while endXorPoint > nGene
    xorLength = mod(floor(rand(1)*nGene), nGene);
    endXorPoint = startXorPoint + xorLength;
end

%% Step 2: exchange the two segments between the parents.
temp1 = Va(startXorPoint:endXorPoint);
temp2 = Vb(startXorPoint:endXorPoint);
Va(startXorPoint:endXorPoint) = temp2;
Vb(startXorPoint:endXorPoint) = temp1;

%% Step 3: build the mapping relation of the exchanged segment.
rawMapRelation = [temp1; temp2];
newcol = 1;
newRow = [];
rowIndex = 1;
colIndex = 1;
while rowIndex <= size(rawMapRelation,1)
    while colIndex <= size(rawMapRelation,2)
        [i,j] = find(rawMapRelation == rawMapRelation(rowIndex,colIndex));
        if length(i) == 1 && length(j) == 1        % unambiguous mapping
            newRow(1,newcol) = rawMapRelation(rowIndex,colIndex);
            newcol = newcol + 1;
        end
        colIndex = colIndex + 1;
    end
    rowIndex = rowIndex + 1;
    colIndex = 1;
end

%% Step 4: legalise the offspring with the mapping relation.
if size(newRow) > 0
    Map = [newRow; fliplr(newRow)];
    if startXorPoint ~= 1
        for i = 1:startXorPoint-1
            [r,c] = find(Map(1,:) == Va(1,i));
            if ~isempty(r) && ~isempty(c)
                Va(1,i) = Map(r+1,c);
            end
            [r1,c1] = find(Map(1,:) == Vb(1,i));
            if ~isempty(r1) && ~isempty(c1)
                Vb(1,i) = Map(r1+1,c1);
            end
        end
    end

    if endXorPoint ~= length(Va)
        for i = endXorPoint+1:length(Va)
            [r,c] = find(Map(1,:) == Va(1,i));
            if ~isempty(r) && ~isempty(c)
                Va(1,i) = Map(r+1,c);
            end
            [r1,c1] = find(Map(1,:) == Vb(1,i));
            if ~isempty(r1) && ~isempty(c1)
                Vb(1,i) = Map(r1+1,c1);
            end
        end
    end
end

y1 = Va;
y2 = Vb;

% NOTE: the relabelled depot nodes must not be mapped back by a test such as
% "y > length(y)": the legal customer indices are 2 .. sizex+1, so the largest
% customer index is already larger than the route length. The offspring are
% therefore passed to car_insert3 directly.
len1 = quality2(car_insert3(y1));
len2 = quality2(car_insert3(y2));
[~, min_index] = min([len1, len2]);

end
