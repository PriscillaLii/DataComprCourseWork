result1 = result;
result1 = sortWithTarget(result1);
for i = 2:length(result)
result1 = result+result1;
result1 = sortWithTarget(result1);
end
for i=1:length(result1)
        if (result1(i,1) == "$")
        index = i;
        end
end
result2 = result1(1,:);
% Result1 is the answer of question b.
% Then result2 would be like “$”+original resource. It’s the answer of question c.
