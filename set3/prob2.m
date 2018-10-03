%a
count=zeros(1,256);
[rows, cols] = size(G);
for i = 1:rows
    for j = 1:cols
        if G(i,j) == 0
            count(256) = count(256)+1;
        else
            index = G(i,j);
            count(index) = count(index)+1;
        end
    end
end
entropyy = 0;
for  i = 1:256
    if (count(i)~=0)
        pofi = count(i) / (rows*cols);
        entropyy = entropyy - ((count(i) / (rows*cols)) * (log2(count(i) / (rows*cols))));
    end
end

% or it’s easier to use entropy function given by Matlab
entropyy = entropy(G);

%b
% calculate the uniform ds and rs
gmax = ceil(max(max(G))+1);
gmin = floor(min(min(G)));
delta = (gmax-gmin) / 6;
d = [gmin, delta+gmin, 2*delta+gmin,  3*delta+gmin, 4*delta+gmin,  5*delta+gmin, gmax];
r = [];
for i = 1:6
    temp = d(i)/2 + d(i+1)/2;
    r = [r, temp];
end

% encode G
Gcode = zeros(rows, cols);
for i = 1:rows
    for j = 1:cols
        qed = 1;
        while qed<7 & G(i,j) >= d(qed+1)   
            qed = qed + 1;
        end
        Gcode(i,j) = qed;
    end
end

% decode G
Ghat = zeros(rows, cols);
for i = 1:rows
    for j = 1:cols
        Ghat(i,j) = r(Gcode(i,j));
    end
end
imagesc(Ghat);
colormap(gray);

%c

countI = zeros(1,6);
for i = 1:rows
    for j = 1:cols
        countI(Gcode(i,j)) = countI(Gcode(i,j))+1;
    end
end
pI = zeros(1,6);
for i = 1:6
    pI(i) = countI(i)/(rows*cols);
end

r=zeros(1,6);
rup=zeros(1,6);
rdown=zeros(1,6);
for i = 1:6
    syms x
    y = pI(i) * x;
    rup(i) = int(y,x,d(i),d(i+1));
end
for i = 1:6
    syms x
    y = pI(i);
    rdown(i) = int(y,x,d(i),d(i+1));
end
for i = 1:6
    r(i) = rup(i)/rdown(i);
end

%d
% calculate the uniform ds and rs
gmax = ceil(max(max(G))+1);
gmin = floor(min(min(G)));
delta = (gmax-gmin) / 6;
d = [gmin, delta+gmin, 2*delta+gmin,  3*delta+gmin, 4*delta+gmin,  5*delta+gmin, gmax];
d = int32(d);
dpre = [0,0,0,0,0,0,0];
dpre = int32(dpre);

while dpre(2) ~= d(2) | dpre(3) ~= d(3) | dpre(4) ~= d(4) | dpre(5) ~= d(5) | dpre(6) ~= d(6)
    dpre = d;
    r=[];
    r = int32(r);
    % find the the mean of nums which are located in d(j) and d(j+1) 
    % and assign it to r(j)
    for k = 1:6
        temp = int32(0);
        count = int32(0);
        for i = 1:rows
            for j = 1:cols
                if G(i,j) >= d(k) & G(i,j) < d(k+1)
                    temp = temp + int32(G(i,j));
                    count = count +1;
                end
            end
        end
        r = [r, temp/count];
    end
    % use i to calculate d
    for i = 2:6
        d(i) = (r(i-1) + r(i)) / 2;
    end
end
