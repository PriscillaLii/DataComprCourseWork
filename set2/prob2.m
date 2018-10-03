%X & x:
x = [];
for j = 0:31
    x = [x, j*j/3];
end
x = x';
X = fft(x);

%Y & y:
y = [];
for j = 0:31
    y = [y, sin((2*j+1)*pi/32)];
end
y = y';
Y = fft(y);

absX = abs(X);
absY = abs(Y);

%X
absXAndX = [absX, X]; % connect absX with X
sortedAX = sortrows(absXAndX, 1); % sort the matrix by 1st element in each cols
selectedAX = sortedAX(1:17,:); % select 17 smallest-magnitude
selectedX = selectedAX(:,2); % extract the corresponding elements in X
%Y
absYAndY = [absY, Y]; 
sortedAY = sortrows(absYAndY, 1); 
selectedAY = sortedAY(1:17,:);
selectedY = selectedAY(:,2);

%X
Xbar = X;
for j = 1:17
    for k = 1:32
        if(sortedAX(j,2) == Xbar(k,1))
            Xbar(k,1) = 0;
        end
    end
end
xbar = ifft(Xbar);

%Y
Ybar = Y;
for j = 1:17
    for k = 1:32
        if(sortedAY(j,2) == Ybar(k,1))
            Ybar(k,1) = 0;
        end
    end
end
ybar = ifft(Ybar);
