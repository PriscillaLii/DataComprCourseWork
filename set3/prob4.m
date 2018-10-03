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

%b
%dequantize & put into new array(take one position for example):
itemCount = 1;
for i = 1:rows/8
    for j = 1:cols/8
        newGdq((i-1)*8+4 , (j-1)*8+1) = ihat10(itemCount);
        itemCount = itemCount+1;
    end
end
%idct2:
newGdqDCT = [];
for i = 1:rows/8
    newRow = [];
    for j = 1:cols/8
        temp = newGdq( (i-1)*8+1 : i*8 , (j-1)*8+1 : j*8);
        temp = idct2(temp);
        newRow = [newRow, temp];
    end
    newG = [newG; newRow];
end
