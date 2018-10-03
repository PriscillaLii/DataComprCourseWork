function result1 = sortWithTarget(result)
    result1 = [];
    temp = [];
    for i=1:length(result)
        if (result(i) == "$")
            result1 = result(i,:);
            index = i;
        end
    end
    if(index~=1)
        temp = [result(1:index-1,:);result(index+1:length(result),:)];
        temp = sortrows(temp,1);
        result1 = [result1; temp];
    else
        temp = result(index:length(result),:);
    end
end
