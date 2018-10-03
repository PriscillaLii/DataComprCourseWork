[I,map]=imread('river.gif');
G=ind2gray(I,map);




count=zeros(1,256);
[rows, cols] = size(G);
for i = 1:rows
    for j = 1:cols
        if R1(i,j) == 0
            count(256) = count(256)+1;
        else
            index = R1(i,j);
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

[rowsE, colsE] = size(e);
count=zeros(1,333);
for i = 1:rowsE
    for j = 1:colsE
        index = e(i,j);
        count(index) = count(index)+1;
    end
end
entropyy = 0;
for  i = 1:256
    if (count(i)~=0)
        pofi = count(i) / (rowsE*colsE);
        entropyy = entropyy - ((count(i) / (rowsE*colsE)) * (log2(count(i) / (rowsE*colsE))));
    end
end



entropyy = entropy(G);

% calculate the uniform ds and rs
gmax = ceil(max(max(E))+1);
gmin = floor(min(min(E)));
delta = (gmax-gmin) / 6;
d = [gmin, delta+gmin, 2*delta+gmin,  3*delta+gmin, 4*delta+gmin,  5*delta+gmin, gmax];
r = [];
for i = 1:6
    temp = d(i)/2 + d(i+1)/2;
    r = [r, temp];
end

% encode G
% [DCrow,DCcol] = size(DCterms);
Ecode = zeros(rows, cols);
for i = 1:rows
    for j = 1:cols
        qed = 1;
        while qed<7 & E(i,j) >= d(qed+1) 
            qed = qed + 1;
        end
        Ecode(i,j) = qed;
    end
end


% decode G
Ehat = zeros(rows, cols);
for i = 1:rows
    for j = 1:cols
        Ehat(i,j) = r(Ecode(i,j));
    end
end

imagesc(E);
colormap(gray);

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


% calculate the uniform ds and rs
gmax = ceil(max(max(E))+1);
gmin = floor(min(min(E)));
delta = (gmax-gmin) / 6;
d = [gmin, delta+gmin, 2*delta+gmin,  3*delta+gmin, 4*delta+gmin,  5*delta+gmin, gmax];
dpre = [0,0,0,0,0,0,0];
aaa = 1;
while dpre(2) ~= d(2) | dpre(3) ~= d(3) | dpre(4) ~= d(4) | dpre(5) ~= d(5) | dpre(6) ~= d(6)
    dpre = d;
    r=[];
    % find the the mean of nums which are located in d(j) and d(j+1) 
    % and assign it to r(j)
    for k = 1:6
        temp = double(0);
        count = double(0);
        for i = 1:rows
            for j = 1:cols
                if E(i,j) >= d(k) & E(i,j) < d(k+1)
                    temp = temp + E(i,j);
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
    aaa = aaa+1;
end



gmax = ceil(max(max(E))+1);
gmin = floor(min(min(E)));
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
                if E(i,j) >= d(k) & E(i,j) < d(k+1)
                    temp = temp + int32(E(i,j));
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




% init a, b and c
R = zeros(rows,cols);
a=1;
b=0;
c=0;

for i = 1:rows
    for j = 1:cols
        if i==1 & j==1
            R(i,j) = Gd(i,j);
        elseif i==1 & j~=1
            R(i,j) = Gd(i,j) - Gd(i,j-1);
        elseif i~=1 & j==1
            R(i,j) = Gd(i,j) - Gd(i-1,j);
        else
            R(i,j) = floor( Gd(i,j) - ( a*Gd(i,j-1) + b*Gd(i-1,j-1) + c*Gd(i-1,j)) );
        end
    end
end
imagesc(R);
colormap(gray);

Gdhat = zeros(rows,cols);
a=1;
b=0;
c=0;
for i = 1:rows
    for j = 1:cols
        if i ==1 & j == 1
            Gdhat(i,j) = Ehat(i,j);
        elseif i==1 & j~=1
            Gdhat(i,j) = Ehat(i,j) + Gdhat(i,j-1);
        elseif i~=1 & j==1
            Gdhat(i,j) = Ehat(i,j) + Gdhat(i-1,j);
        else
            Gdhat(i,j) = Ehat(i,j) + a*Gdhat(i,j-1) + b*Gdhat(i-1,j-1) + c*Gdhat(i-1,j);
        end
    end
end
% Because Gdhat is a double array, which is not good for gray scale picture, I transformed it into unit8
GdhatI = uint8(Gdhat);
imagesc(GdhatI);
colormap(gray);



R(1,1) = G(1,1);

for i = 1:cols
    R(1,i) = G(1,i)-G(1,i-1);
end

for i = 1:rows
    R(i,j) = G(i,1)-G(i-1,1);
end


[j,k] = size(Ereshape);
rle = [];
i=1;
while i < k
    begin = Ereshape(i);
    this = [begin,1];
    i = i + 1;
    while i<=k & Ereshape(i) == begin
        this(2) = this(2) + 1;
        i = i + 1;
    end
    rle = [rle ; this];
end

a = [1 2 2 2 2 2 3 4 5 2 2 2 2];
[1,1][2,5][3,1][4,1][5,1][2,4]


% Apply dct2 on every 8*8 block in G
newG = [];
for i = 1:rows/8
    newRow = [];
    for j = 1:cols/8
        temp = G( (i-1)*8+1 : i*8 , (j-1)*8+1 : j*8);
        temp = dct2(temp);
        newRow = [newRow, temp];
    end
    newG = [newG; newRow];
end

newGdqDCT = [];
for i = 1:rows/8
    newRow = [];
    for j = 1:cols/8
        temp = newGdq( (i-1)*8+1 : i*8 , (j-1)*8+1 : j*8);
        temp = idct2(temp);
        newRow = [newRow, temp];
    end
    newGdqDCT = [newGdqDCT; newRow];
end

imagesc(newGdqDCT);
colormap(gray);


% find DCterms
DCterms = [];
for i = 1:rows/8
    for j = 1:cols/8
        DCterms = [DCterms, newG((i-1)*8+1 , (j-1)*8+1)];
    end
end

% find ds and rs to quantize DCterms
DCmax = ceil(max(DCterms)+1);
DCmin = floor(min(DCterms));
DCd = [];
delta = (DCmax+DCmin)/16;
for i = 1:16
    DCd = [DCd, (i-1)*delta+DCmin];
end
DCd = [DCd, DCmax];
DCr = zeros(1,16);
for i = 1:16
    DCr(i) = (DCd(i) + DCd(i+1))/2;
end

cdiag = [];
2nd = [  , ]
for k = 2:10
    % locate
    temp = [];
    for i = 1:rows/8
        for j = 1:cols/8
            temp = [temp, newG((i-1)*8+2 , (j-1)*8+1)];
        end
    end
    cdiag = [cdiag;temp]
end

% Problem 4

% find DCterms
DCterms = [];
for i = 1:rows/8
    for j = 1:cols/8
        DCterms = [DCterms, newG((i-1)*8+1 , (j-1)*8+1)];
    end
end

% find 2nd
item = [];
for i = 1:rows/8
    for j = 1:cols/8
        item = [item, newG((i-1)*8+1 , (j-1)*8+2)];
    end
end

% find ds and rs to quantize DCterms
DCmax = ceil(max(DCterms)+1);
DCmin = floor(min(DCterms));
DCd = [];
delta = (DCmax+DCmin)/16;
for i = 1:16
    DCd = [DCd, (i-1)*delta+DCmin];
end
DCd = [DCd, DCmax];
DCr = zeros(1,16);
for i = 1:16
    DCr(i) = (DCd(i) + DCd(i+1))/2;
end

% find 2nd
item = [];
for i = 1:rows/8
    for j = 1:cols/8
        item = [item, newG((i-1)*8+4 , (j-1)*8+1)];
    end
end

% find ds and rs of item other
Imax = ceil(max(item)+1);
Imin = floor(min(item));
Id = [];
delta = (Imax+abs(Imin))/8;
for i = 1:8
    Id = [Id, (i-1)*delta+Imin];
end
Id = [Id, Imax];
Ir = zeros(1,8);
for i = 1:8
    Ir(i) = (Id(i) + Id(i+1))/2;
end

% encode items
[irow,icol] = size(item);
icode = zeros(irow, icol);
for i = 1:irow
    for j = 1:icol
        qed = 1;
        while qed<8 & item(i,j) >= Id(qed+1) 
            qed = qed + 1;
        end
        icode(i,j) = qed;
    end
end

item10 = item; icode10 = icode; id10=Id; ir10= Ir;

% encode DCterms
[DCrow,DCcol] = size(DCterms);
DCcode = zeros(DCrow, DCcol);
for i = 1:DCrow
    for j = 1:DCcol
        qed = 1;
        while qed<17 & DCterms(i,j) >= DCd(qed+1) 
            qed = qed + 1;
        end
        DCcode(i,j) = qed;
    end
end

% decode DCterms
[DCrow,DCcol] = size(DCterms);
DChat = zeros(DCrow, DCcol);
for i = 1:DCrow
    for j = 1:DCcol
        DChat(i,j) = DCr(DCcode(i,j));
    end
end

icode = icode10;
Ir = ir10;
[irow,icol] = size(item);
ihat = zeros(irow, icol);
for i = 1:irow
    for j = 1:icol
        ihat(i,j) = Ir(icode(i,j));
    end
end
ihat10 = ihat;

newGdq = zeros(rows, cols);


itemCount = 1;
for i = 1:rows/8
    for j = 1:cols/8
        newGdq((i-1)*8+4 , (j-1)*8+1) = ihat10(itemCount);
        itemCount = itemCount+1;
    end
end


G1 = G3;

for i = 1:rows/8
    for j = 1:cols/8
        G1((i-1)*8+2 , (j-1)*8+1) = 0;
    end
end

newGdqDCT = [];
for i = 1:rows/8
    newRow = [];
    for j = 1:cols/8
        temp = G1( (i-1)*8+1 : i*8 , (j-1)*8+1 : j*8);
        temp = idct2(temp);
        newRow = [newRow, temp];
    end
    newGdqDCT = [newGdqDCT; newRow];
end
Ghat1 = newGdqDCT;


imagesc(E);
colormap(gray);
