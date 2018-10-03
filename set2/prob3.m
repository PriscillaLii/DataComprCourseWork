% x and y are inited in problem 2
X = dct(x); 
Y = dct(y);
Xbar = X;
for j = 16:32
    Xbar(j,1) = 0;
end
Ybar = Y;
for j = 16:32
    Ybar(j,1) = 0;
end
xbar = idct(Xbar);
ybar = idct(Ybar);
