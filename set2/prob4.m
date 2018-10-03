% Code of init x and y are in Problem 2.
haarTM = [1];
NC = 1/sqrt(2);
LP = [1 1]; 
HP = [1 -1];
for i = 1 : log2(length(x))
    haarTM = NC * [kron(haarTM, LP); kron(eye(size(haarTM)), HP)];
end
X = haarTM * x;
Y = haarTM * y;
absX = abs(X);
absY = abs(Y);
absXAndX = [absX, X]; 
absYAndY = [absY, Y]; 
sortedAX = sortrows(absXAndX, 1); 
sortedAY = sortrows(absYAndY, 1); 
selectedAX = sortedAX(1:17,:); 
selectedAY = sortedAY(1:17,:); 
selectedX = selectedAX(:,2); 
selectedY = selectedAY(:,2); 
Xbar = X;
Ybar = Y;
for j = 1:17
    for k = 1:32
        if(sortedAX(j,2) == Xbar(k,1))
            Xbar(k,1) = 0;
        end
    end
end
xbar = inv(haarTM) * Xbar;
ybar = inv(haarTM) * Ybar;

X = hadamard(32)* x;
Y = hadamard(32)* y;
absX = abs(X);
absY = abs(Y);
absXAndX = [absX, X]; 
absYAndY = [absY, Y]; 
sortedAX = sortrows(absXAndX, 1); 
sortedAY = sortrows(absYAndY, 1); 
selectedAX = sortedAX(1:17,:); 
selectedAY = sortedAY(1:17,:); 
selectedX = selectedAX(:,2); 
selectedY = selectedAY(:,2); 
Xbar = X;
Ybar = Y;
for j = 1:17
    for k = 1:32
        if(sortedAX(j,2) == Xbar(k,1))
            Xbar(k,1) = 0;
        end
    end
end
xbar = inv(hadamard(32)) * Xbar;
ybar = inv(hadamard(32)) * Ybar;

