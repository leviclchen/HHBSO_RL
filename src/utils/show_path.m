function show_path(fig, X, points, n, clear, name)
%SHOW_PATH Plot a vehicle route in 3-D (position against move number).
%
%   fig    : figure handle / number to draw into.
%   X      : route vector as a column; depot nodes are equal to 1.
%   points : (number of nodes)-by-2 coordinate matrix.
%   n      : number of trucks; depot visits are marked with a circle.
%   clear  : 0 performs 'hold off' before drawing, otherwise the current axes
%            are kept.
%   name   : figure title.
%
%   The z axis is the position of a node inside the route, which makes the
%   visiting sequence of the customers visible.
%
%   NOTE: the axis limits are fixed to the coordinate range [0, 70] of the
%   bundled sample instance; adjust the axis command for other instances.
%
%   NOTE: this function relies on the built-in PLOT3. An outdated copy of plot3.m
%   used to shadow the built-in and made this function fail; that file is now
%   archived in legacy/ and is no longer on the path.

b     = find(X > 0);
route = ones(length(b),3);
car   = 0;
for i = 1:length(b)
    route(i,1:2) = points(X(i),1:2);
    if X(i) <= 1
        car = car + 1;
    end
    route(i,3) = car;
end

colors = 'mcrgbkymcrg';
figure(fig);
if clear == 0
    hold off;
end
plot3(route(:,1), route(:,2), 1:length(b), '.b');
grid on;
title(name);
xlabel('x');
ylabel('y');
zlabel('Move number');

h = 1;
t = 1;
for i = 1:length(b)-1
    if X(i) <= n                         % depot visit
        hold on;
        plot3(route(t,1), route(t,2), h, 'or');
    end
    if route(i,3) == route(i+1,3)
        h = h + 1;
    else
        hold on;
        h = h + 1;
        plot3(route(t:h,1), route(t:h,2), t:h, colors(route(i,3)));
        t = h;
    end
end
plot3(route(h,1), route(h,2), h, 'or');
plot3(route(t:h,1), route(t:h,2), t:h, colors(route(i,3)));
axis([0 70 0 70 1 length(X)]);
view(2);

end
