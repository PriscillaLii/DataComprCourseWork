%a
% init a, b and c
R = zeros(rows,cols);
a=1;b=0;c=0;

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

%c
%RLE
[j,k] = size(Ereshape);
e = [];
i=1;
while i < k
    begin = Ereshape(i);
    this = [begin,1];
    i = i + 1;
    while i<=k & Ereshape(i) == begin
        this(2) = this(2) + 1;
        i = i + 1;
    end
    e = [e , this];
end

%d
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
