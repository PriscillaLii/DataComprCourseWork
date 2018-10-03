X=[0, 0.7, 0.7, 0.7, 0.8, 0.8, 0.8, 1, 1, 1, 1, 1.2, 1.2, 1.2, 1.7, 1.74, 1.75, 1.8, 1.83, 1.84, 2.2, 2.2, 2.3, 2.36, 2.37, 2.4, 2.9];

% init ds by assuming X is uniform distribution
% xmax and xmin determine the start point and end point
% in this question d(1) and d(3) is required to be 0 and 3, 
% but in consider of generalization, I still calculate xmax and xmin in the code.

xmax = ceil(max(X));	
xmin = floor(min(X));
d = [xmin, (xmin + xmax)/4, 2*(xmin + xmax)/4, 3*(xmin + xmax)/4 xmax];

% dpre is used to store the ds in previous iteration
dpre = [0,0,0,0,0];

while dpre(2) ~= d(2) | dpre(3) ~= d(3) | dpre(4) ~= d(4)
    dpre = d;
    r=[];
    % find the the mean of nums which are located in d(j) and d(j+1) and assign it to r(j)
    for j = 1:4
        temp = 0;
        count = 0;
        for i = 1:27
            if X(i)>=d(j) & X(i)<d(j+1)
                temp = temp + X(i);
                count = count + 1;
            end
        end
        r = [r, temp/count];
    end
    % use i to calculate d
    for i = 2:4
        d(i) = (r(i-1) + r(i)) / 2;
    end
end


Xcode = [];
for i = 1:27
    j = 1;
    while ~(X(i) >= d(j) & X(i) < d(j+1))
        j = j + 1;
    end
    Xcode = [Xcode, j];
end

Xdecode = [];
for i = 1:27
    Xdecode = [Xdecode, r(Xcode(i))];
end

MSEX = 0;
for i = 1:27
    MSEX = MSEX + (X(i)-Xdecode(i))^2;
end
MSEX = MSEX / 27;



xmax = ceil(max(X));	
xmin = floor(min(X));
d2 = [xmin, (xmin + xmax)/3, 2*(xmin + xmax)/3, xmax];
r2 = [];
for i = 1:3
    r2 = [r2, (d2(i) + d2(i+1))/2];
end

Xcode = [];
for i = 1:27
    j = 1;
    while ~(X(i) >= d2(j) & X(i) < d2(j+1))
        j = j + 1;
    end
    Xcode = [Xcode, j];
end

Xdecode = [];
for i = 1:27
    Xdecode = [Xdecode, r2(Xcode(i))];
end

d3 = [0, 0.75, 1.5, 2.25, 3];
r3 = [0.3753, 1.125, 1.8752, 2.6251];
Xcode = [];
for i = 1:27
    j = 1;
    while ~(X(i) >= d3(j) & X(i) < d3(j+1))
        j = j + 1;
    end
    Xcode = [Xcode, j];
end
Xdecode = [];
for i = 1:27
    Xdecode = [Xdecode, r3(Xcode(i))];
end