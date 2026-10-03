function [M, points] = generate_matrix(N, Cn, varargin)
%GENERATE_MATRIX Build the distance matrix and the coordinates of the instance.
%
%   N : number of customers.
%   Cn: number of vehicles. When Cn > 1 the depot coordinate is replicated Cn-1
%       times so that every route can start at its own copy of the depot.
%   varargin : optional arguments
%       ()                  use the default coordinate file 'data_c1.txt'
%       (coordFile)         use the given coordinate file (char)
%       (x, y)              window sizes of the random coordinate generator
%       (x, y, coordFile)   both
%
%   M      : (N+1)-by-(N+1) symmetric Euclidean distance matrix.
%   points : (N+1)-by-2 coordinates of the depot and the customers.
%
% IMPORTANT - reproducibility note
%   The coordinates are finally read from the coordinate file (by default
%   data_c1.txt), so the random coordinates generated above are overwritten and
%   have no effect on the result. The random draws are kept in place because they
%   advance the global random stream; removing them would change the stochastic
%   trajectory of the algorithm.

if length(varargin) == 1 && ischar(varargin{1})
    x = 1;  y = 1;  coordFile = varargin{1};
elseif length(varargin) == 2 && isnumeric(varargin{1})
    x = varargin{1};  y = varargin{2};  coordFile = 'data_c1.txt';
elseif length(varargin) == 3
    x = varargin{1};  y = varargin{2};  coordFile = varargin{3};
elseif isempty(varargin)
    x = 1;  y = 1;  coordFile = 'data_c1.txt';
else
    error('generate_matrix:badInput', 'Bad input arguments number.');
end

% random instance (overwritten by the file data below, see the note above)
points = [x*rand(N+1,1), y*rand(N+1,1)];

Nc = N + 1;                                 % size of the cost matrix

M = zeros(Nc);                              % fixed typo: "zeros * eye(Nc)"

if Cn > 1
    % replicate the depot coordinate for the extra vehicles
    Mpt = [ones(Cn-1,1)*points(1,1), ones(Cn-1,1)*points(1,2)];
    points = [Mpt; points];
end

points = importdata(coordFile);             % instance coordinates
points = points(:,2:3);                     % drop the node id column

for i = 1:Nc-1                              % Euclidean distance matrix
    for j = i+1:Nc
        t1 = points(i,:);
        t2 = points(j,:);
        M(i,j) = sqrt((t1(1)-t2(1))^2 + (t1(2)-t2(2))^2);
        M(j,i) = M(i,j);
    end
end

end
